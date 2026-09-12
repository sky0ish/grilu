/* 구글 캘린더 [GRILU] ↔ 홈페이지 일정 양방향 동기화 (브라우저에서, 관리자용)
   - "구글 캘린더 잇기" 를 누르면 구글 권한 요청 창이 뜹니다 (calendar.events 권한).
   - 이어진 뒤에는 달력을 열 때·일정을 저장/삭제할 때마다 조용히 맞춥니다.
       홈페이지에서 만든 일정   → 구글 [GRILU] 에 추가 (구글 일정 id 를 events.gcal_id 에 기억)
       홈페이지에서 고친 일정   → 구글 [GRILU] 에 반영   (updated_at > synced_at)
       홈페이지에서 지운 일정   → 구글 [GRILU] 에서도 삭제
       구글에서 새로 만든 일정  → 홈페이지 일정표(events)에 추가 (구분 'gcal', 누구나 볼 수 있고 관리자가 고칠 수 있음)
       구글에서 고친 일정       → 홈페이지에 반영            (google.updated > synced_at)
       구글에서 지운 일정       → 홈페이지에서도 삭제
   - 열쇠(access token)는 이 브라우저의 localStorage 에만 두고 만료되면 조용히 새로 받습니다. */
window.GCAL = (function () {
  var cfg = window.GRILU_CONFIG || {};
  var CLIENT = cfg.GCAL_CLIENT_ID || '', CAL = cfg.GCAL_ID || '';
  var SCOPE = 'https://www.googleapis.com/auth/calendar.events';
  var KEY = 'grilu-gcal-token', OKKEY = KEY + '-ok', API = 'https://www.googleapis.com/calendar/v3';
  var SINCE = '2026-09-01', TZ = 'Asia/Seoul';
  function saved() { try { var v = JSON.parse(localStorage.getItem(KEY) || 'null'); return (v && v.exp > Date.now() + 60000) ? v.token : null; } catch (e) { return null; } }
  function keep(t, sec) { try { localStorage.setItem(KEY, JSON.stringify({ token: t, exp: Date.now() + (sec || 3600) * 1000 })); localStorage.setItem(OKKEY, '1'); } catch (e) {} }
  function ready() { return !!(CLIENT && CAL); }
  function linked() { try { return !!localStorage.getItem(OKKEY); } catch (e) { return false; } }
  function loadGis() {
    if (window.google && google.accounts && google.accounts.oauth2) return Promise.resolve();
    return new Promise(function (res, rej) { var s = document.createElement('script'); s.src = 'https://accounts.google.com/gsi/client'; s.onload = res; s.onerror = rej; document.head.appendChild(s); });
  }
  function getToken(prompt) {
    return loadGis().then(function () {
      return new Promise(function (res, rej) {
        var tc = google.accounts.oauth2.initTokenClient({ client_id: CLIENT, scope: SCOPE, callback: function (r) {
          if (r && r.access_token) { keep(r.access_token, r.expires_in); res(r.access_token); } else rej(new Error((r && r.error) || 'no token'));
        }, error_callback: function (e) { rej(new Error(e && e.type || 'popup')); } });
        tc.requestAccessToken({ prompt: prompt });
      });
    });
  }
  function connect() { return getToken('consent'); }
  function silent() { var t = saved(); if (t) return Promise.resolve(t); if (!linked()) return Promise.reject(new Error('not linked')); return getToken(''); }
  function disconnect() { try { localStorage.removeItem(KEY); localStorage.removeItem(OKKEY); } catch (e) {} }
  function api(token, method, path, body, params) {
    var u = API + path + (params ? '?' + Object.keys(params).map(function (k) { return k + '=' + encodeURIComponent(params[k]); }).join('&') : '');
    return fetch(u, { method: method, headers: { Authorization: 'Bearer ' + token, 'Content-Type': 'application/json' }, body: body ? JSON.stringify(body) : undefined })
      .then(function (r) { if (r.status === 401) { try { localStorage.removeItem(KEY); } catch (e) {} throw new Error('401'); } if (r.status === 404 || r.status === 410) return { _gone: true }; if (!r.ok) return r.text().then(function (t) { throw new Error(r.status + ' ' + t.slice(0, 120)); }); return r.status === 204 ? null : r.json(); });
  }
  function pad(n) { return (n < 10 ? '0' : '') + n; }
  function addDays(ds, n) { var d = new Date(ds + 'T00:00:00'); d.setDate(d.getDate() + n); return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }
  var TYPES = { union: '노조', council: '노사협의회', event: '행사', holiday: '휴일', meeting: '회의', gcal: 'GRILU 캘린더' };
  /* 홈페이지 일정 → 구글 일정 본문 */
  function toG(e) {
    var date = e.date, end = e.end_date || e.date, m = /^(\d{1,2}):(\d{2})\s*(?:[~\-]\s*(\d{1,2}):(\d{2}))?/.exec(e.time || '');
    var desc = (e.description || '').replace(/\n*\(grilu\.kr[^)]*\)\s*$/, '');
    var b = { summary: e.title, location: e.place || '', description: desc + '\n\n(grilu.kr 노동조합 일정 · 구분: ' + (TYPES[e.type] || e.type) + ')',
      extendedProperties: { private: { grilu_id: String(e.id), grilu_type: e.type || 'union' } } };
    if (m) { var sh = +m[1], sm = +m[2], eh = m[3] ? +m[3] : (sh + 1) % 24, em = m[3] ? +m[4] : sm;
      b.start = { dateTime: date + 'T' + pad(sh) + ':' + pad(sm) + ':00', timeZone: TZ }; b.end = { dateTime: end + 'T' + pad(eh) + ':' + pad(em) + ':00', timeZone: TZ }; }
    else { b.start = { date: date }; b.end = { date: addDays(end, 1) }; }
    return b;
  }
  /* 구글 일정 → 홈페이지 일정 칸 */
  function fromG(it) {
    var s = it.start || {}, e = it.end || {}, date, end, tm = '';
    if (s.date) { date = s.date; end = addDays(e.date || s.date, -1); }
    else { date = (s.dateTime || '').slice(0, 10); end = (e.dateTime || '').slice(0, 10) || date; tm = (s.dateTime || '').slice(11, 16) + ((e.dateTime || '').slice(11, 16) ? '~' + e.dateTime.slice(11, 16) : ''); }
    if (end < date) end = date;
    var gtype = it.extendedProperties && it.extendedProperties.private && it.extendedProperties.private.grilu_type;
    return { title: it.summary || '(제목 없음)', date: date, end_date: end === date ? null : end, time: tm || null, place: it.location || null,
      description: (it.description || '').replace(/\n*\(grilu\.kr[^)]*\)\s*$/, '').trim() || null, type: gtype && TYPES[gtype] ? gtype : 'gcal' };
  }
  function listAll(token, params) {
    var out = [];
    function page(tok) { var p = Object.assign({ maxResults: 2500, singleEvents: 'true' }, params); if (tok) p.pageToken = tok;
      return api(token, 'GET', '/calendars/' + encodeURIComponent(CAL) + '/events', null, p).then(function (j) { out = out.concat(j.items || []); return j.nextPageToken ? page(j.nextPageToken) : out; }); }
    return page(null);
  }
  function same(a, b) { return JSON.stringify([a.summary, a.location || '', a.start, a.end, (a.description || '').trim()]) === JSON.stringify([b.summary, b.location || '', b.start, b.end, (b.description || '').trim()]); }
  /* 양방향 맞추기. db = supabase client. 돌려주는 값: {add,upd,del,pullAdd,pullUpd,pullDel} */
  function sync(db, interactive) {
    var n = { add: 0, upd: 0, del: 0, pullAdd: 0, pullUpd: 0, pullDel: 0 };
    return (interactive ? connect() : silent()).then(function (token) {
      return Promise.all([
        listAll(token, { timeMin: SINCE + 'T00:00:00+09:00', showDeleted: 'true' }),
        db.from('events').select('*').gte('date', SINCE)
      ]).then(function (res) {
        var G = {}, gl = res[0] || []; gl.forEach(function (it) { G[it.id] = it; });
        var S = (res[1] && res[1].data) || [];
        var now = new Date().toISOString(), jobs = [], byG = {};
        S.forEach(function (s) { if (s.gcal_id) byG[s.gcal_id] = s; });
        S.forEach(function (s) {
          var g = s.gcal_id ? G[s.gcal_id] : null;
          if (s.gcal_id && (!g || g.status === 'cancelled')) {          // 구글에서 지워짐 → 홈페이지에서도
            n.pullDel++; jobs.push(db.from('events').delete().eq('id', s.id)); return;
          }
          var body = toG(s);
          if (!s.gcal_id) {                                             // 홈페이지에서 새로 만든 것 → 구글에
            n.add++; jobs.push(api(token, 'POST', '/calendars/' + encodeURIComponent(CAL) + '/events', body).then(function (r) {
              return db.from('events').update({ gcal_id: r.id, synced_at: now }).eq('id', s.id); })); return;
          }
          var siteChanged = s.updated_at && (!s.synced_at || s.updated_at > s.synced_at);
          var gChanged = g.updated && (!s.synced_at || g.updated > s.synced_at);
          if (siteChanged && !same(g, body)) {                          // 홈페이지에서 고침 → 구글에
            n.upd++; jobs.push(api(token, 'PUT', '/calendars/' + encodeURIComponent(CAL) + '/events/' + s.gcal_id, body).then(function () {
              return db.from('events').update({ synced_at: now }).eq('id', s.id); }));
          } else if (gChanged && !same(g, body)) {                      // 구글에서 고침 → 홈페이지에
            var row = fromG(g); row.synced_at = now; row.updated_at = now; if (s.type !== 'gcal' && row.type === 'gcal') row.type = s.type;
            n.pullUpd++; jobs.push(db.from('events').update(row).eq('id', s.id));
          } else if (!s.synced_at) jobs.push(db.from('events').update({ synced_at: now }).eq('id', s.id));
        });
        gl.forEach(function (g) {                                       // 구글에서 새로 만든 것 → 홈페이지에
          if (g.status === 'cancelled' || byG[g.id]) return;
          var gid = g.extendedProperties && g.extendedProperties.private && g.extendedProperties.private.grilu_id;
          if (gid && S.some(function (s) { return String(s.id) === String(gid); })) {      // 예전 방식으로 올라간 것: id 만 이어 줌
            jobs.push(db.from('events').update({ gcal_id: g.id, synced_at: now }).eq('id', gid)); return;
          }
          var row = fromG(g); row.gcal_id = g.id; row.synced_at = now; row.updated_at = now; row.attachments = [];
          n.pullAdd++; jobs.push(db.from('events').insert(row));
        });
        return Promise.all(jobs).then(function (rs) {
          var err = rs.filter(function (r) { return r && r.error; })[0];
          if (err) throw new Error(err.error.message);
          return n;
        });
      });
    });
  }
  /* 홈페이지에서 지울 때 구글에서도 지우기 */
  function remove(gcalId) {
    if (!gcalId || !linked()) return Promise.resolve();
    return silent().then(function (token) { return api(token, 'DELETE', '/calendars/' + encodeURIComponent(CAL) + '/events/' + gcalId); }).catch(function () {});
  }
  return { ready: ready, linked: linked, connect: connect, silent: silent, sync: sync, remove: remove, disconnect: disconnect };
})();

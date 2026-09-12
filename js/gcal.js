/* 구글 캘린더 [GRILU] 잇기 (브라우저에서 직접, 관리자용)
   - "구글 캘린더 잇기" 를 누르면 구글 권한 요청 창이 뜹니다 (calendar.events 권한).
   - 이어지면: 홈페이지 일정(누가 썼든 전부) → [GRILU] 캘린더에 추가·수정·삭제,
               [GRILU] 캘린더의 다른 일정 → 홈페이지 달력에 표시.
   - 열쇠(access token)는 이 브라우저의 localStorage 에만 두고 1시간마다 조용히 갱신합니다.
   - GitHub Actions 의 tools/sync_gcal.py(서비스 계정)와 같은 표식(grilu_src/grilu_id)을 쓰므로 둘을 같이 써도 중복되지 않습니다. */
window.GCAL = (function () {
  var cfg = window.GRILU_CONFIG || {};
  var CLIENT = cfg.GCAL_CLIENT_ID || '', CAL = cfg.GCAL_ID || '';
  var SCOPE = 'https://www.googleapis.com/auth/calendar.events';
  var KEY = 'grilu-gcal-token', OKKEY = KEY + '-ok', API = 'https://www.googleapis.com/calendar/v3';
  var SINCE = '2026-09-01';
  var tokenClient = null;
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
        tokenClient = google.accounts.oauth2.initTokenClient({ client_id: CLIENT, scope: SCOPE, callback: function (r) {
          if (r && r.access_token) { keep(r.access_token, r.expires_in); res(r.access_token); } else rej(new Error((r && r.error) || 'no token'));
        }, error_callback: function (e) { rej(new Error(e && e.type || 'popup')); } });
        tokenClient.requestAccessToken({ prompt: prompt });
      });
    });
  }
  function connect() { return getToken('consent'); }
  function silent() { var t = saved(); if (t) return Promise.resolve(t); if (!linked()) return Promise.reject(new Error('not linked')); return getToken(''); }
  function disconnect() { try { localStorage.removeItem(KEY); localStorage.removeItem(OKKEY); } catch (e) {} }
  function api(token, method, path, body, params) {
    var u = API + path + (params ? '?' + Object.keys(params).map(function (k) { return k + '=' + encodeURIComponent(params[k]); }).join('&') : '');
    return fetch(u, { method: method, headers: { Authorization: 'Bearer ' + token, 'Content-Type': 'application/json' }, body: body ? JSON.stringify(body) : undefined })
      .then(function (r) { if (r.status === 401) { disconnectToken(); throw new Error('401'); } if (!r.ok) return r.text().then(function (t) { throw new Error(r.status + ' ' + t.slice(0, 120)); }); return r.status === 204 ? null : r.json(); });
  }
  function disconnectToken() { try { localStorage.removeItem(KEY); } catch (e) {} }
  function pad(n) { return (n < 10 ? '0' : '') + n; }
  function addDays(ds, n) { var d = new Date(ds + 'T00:00:00'); d.setDate(d.getDate() + n); return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }
  function toG(e) {
    var date = e.date, end = e.end_date || e.end || e.date, m = /^(\d{1,2}):(\d{2})\s*(?:[~\-]\s*(\d{1,2}):(\d{2}))?/.exec(e.time || '');
    var b = { summary: e.title, location: e.place || '', description: (e.description || '') + ((e.attachments || []).length ? '\n\n첨부: ' + e.attachments.map(function (a) { return a.name; }).join(', ') : '') + '\n\n(grilu.kr 노동조합 일정)',
      extendedProperties: { private: { grilu_src: 'site', grilu_id: String(e.id) } } };
    if (m) { var sh = +m[1], sm = +m[2], eh = m[3] ? +m[3] : (sh + 1) % 24, em = m[3] ? +m[4] : sm;
      b.start = { dateTime: date + 'T' + pad(sh) + ':' + pad(sm) + ':00', timeZone: 'Asia/Seoul' }; b.end = { dateTime: end + 'T' + pad(eh) + ':' + pad(em) + ':00', timeZone: 'Asia/Seoul' }; }
    else { b.start = { date: date }; b.end = { date: addDays(end, 1) }; }
    return b;
  }
  function listAll(token, params) {
    var out = [];
    function page(tok) { var p = Object.assign({ maxResults: 2500, singleEvents: 'true' }, params); if (tok) p.pageToken = tok;
      return api(token, 'GET', '/calendars/' + encodeURIComponent(CAL) + '/events', null, p).then(function (j) { out = out.concat(j.items || []); return j.nextPageToken ? page(j.nextPageToken) : out; }); }
    return page(null);
  }
  /* 홈페이지 일정 전부 → 구글 [GRILU] (있으면 고치고, 없으면 넣고, 홈페이지에서 지워진 것은 지움) */
  function push(token, events) {
    return listAll(token, { privateExtendedProperty: 'grilu_src=site', showDeleted: 'false' }).then(function (items) {
      var have = {}; items.forEach(function (it) { var id = it.extendedProperties && it.extendedProperties.private && it.extendedProperties.private.grilu_id; if (id) have[id] = it; });
      var site = {}; events.forEach(function (e) { if (e.id && (e.end_date || e.end || e.date) >= SINCE) site[String(e.id)] = e; });
      var jobs = [], n = { add: 0, upd: 0, del: 0 };
      Object.keys(site).forEach(function (id) {
        var b = toG(site[id]), cur = have[id];
        if (!cur) { n.add++; jobs.push(api(token, 'POST', '/calendars/' + encodeURIComponent(CAL) + '/events', b)); }
        else if (cur.summary !== b.summary || (cur.location || '') !== b.location || (cur.description || '') !== b.description || JSON.stringify(cur.start) !== JSON.stringify(b.start) || JSON.stringify(cur.end) !== JSON.stringify(b.end)) {
          n.upd++; jobs.push(api(token, 'PUT', '/calendars/' + encodeURIComponent(CAL) + '/events/' + cur.id, b)); }
      });
      Object.keys(have).forEach(function (id) { if (!site[id]) { n.del++; jobs.push(api(token, 'DELETE', '/calendars/' + encodeURIComponent(CAL) + '/events/' + have[id].id)); } });
      return Promise.all(jobs).then(function () { return n; });
    });
  }
  /* 구글 [GRILU] 의 다른 일정 → 홈페이지 달력용 목록 */
  function pull(token) {
    return listAll(token, { timeMin: SINCE + 'T00:00:00+09:00', orderBy: 'startTime' }).then(function (items) {
      return items.filter(function (it) { return it.status !== 'cancelled' && !(it.extendedProperties && it.extendedProperties.private && it.extendedProperties.private.grilu_src === 'site'); })
        .map(function (it) { var s = it.start || {}, e = it.end || {}, date, end, tm = '';
          if (s.date) { date = s.date; end = addDays(e.date || s.date, -1); } else { date = (s.dateTime || '').slice(0, 10); end = (e.dateTime || '').slice(0, 10) || date; tm = (s.dateTime || '').slice(11, 16) + ((e.dateTime || '').slice(11, 16) ? '~' + e.dateTime.slice(11, 16) : ''); }
          return { uid: it.iCalUID || it.id, date: date, end: end < date ? date : end, time: tm, title: it.summary || '(제목 없음)', place: it.location || '', desc: it.description || '' }; });
    });
  }
  function sync(events, interactive) {
    return (interactive ? connect() : silent()).then(function (token) {
      return push(token, events).then(function (n) { return pull(token).then(function (list) { return { n: n, list: list }; }); });
    });
  }
  return { ready: ready, linked: linked, connect: connect, silent: silent, sync: sync, disconnect: disconnect };
})();

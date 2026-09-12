/* 노동조합 일정 달력 (첫 화면 + GRI > 일정 달력)
   - Supabase events 표(관리자 작성) + data/gcal.json(구글 캘린더 [GRILU] 공개 주소에서 자동 수집)을 함께 표시
   - 날짜 칸을 누르면 그날 일정 목록 / 관리자는 바로 일정 추가
   - 일정 추가·수정 창: 파일 선택, 끌어다 놓기, 캡처 이미지·파일 붙여넣기(Ctrl+V) 로 첨부
   - 첨부가 있으면 [자료마당 > 회의자료] 게시판에 같은 제목의 글을 자동으로 올리고 서로 연결 */
(function () {
  var boxes = document.querySelectorAll('.gcal');
  if (!boxes.length) return;
  var cfg = window.GRILU_CONFIG || {};
  var TYPE = { union: ['노조', '#1f398f'], council: ['노사협의회', '#1f7a54'], event: ['행사', '#b86400'], holiday: ['휴일', '#c33'], meeting: ['회의', '#6b3fa0'], gcal: ['GRILU 캘린더', '#4285f4'] };
  var WEEK = ['일', '월', '화', '수', '목', '금', '토'];
  var MEET_BOARD = 'delegate';   // 회의자료 게시판 코드
  function pad(n) { return (n < 10 ? '0' : '') + n; }
  function ymd(d) { return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }
  function esc(s) { return String(s == null ? '' : s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); }
  function linkify(s) { return esc(s).replace(/(https?:\/\/[^\s<]+)/g, '<a href="$1" target="_blank" rel="noopener">$1</a>').replace(/\n/g, '<br>'); }
  function root() { return (window.DB && DB.root) || (document.querySelector('script[src*="js/calendar.js"]') || {}).getAttribute && (document.querySelector('script[src*="js/calendar.js"]').getAttribute('src').replace(/js\/calendar\.js.*$/, '')) || ''; }
  function canEdit() { return !!(window.DB && DB.ready && DB.isAdmin && DB.isAdmin()); }
  function dayLabel(ds) { var d = new Date(ds + 'T00:00:00'); return d.getFullYear() + '. ' + (d.getMonth() + 1) + '. ' + d.getDate() + '. (' + WEEK[d.getDay()] + ')'; }

  var events = [], gcal = [], loaded = false;
  function loadAll() {
    var p1 = (window.DB && DB.ready) ? DB.client.from('events').select('*').order('date').then(function (r) {
      return (r.error || !r.data) ? (window.GRILU_EVENTS || []).map(function (e) { return { date: e.date, end: e.end, title: e.title, type: e.type, description: e.desc }; }) : r.data;
    }) : Promise.resolve((window.GRILU_EVENTS || []).map(function (e) { return { date: e.date, end: e.end, title: e.title, type: e.type, description: e.desc }; }));
    var p2 = fetch(root() + 'data/gcal.json?v=' + Math.floor(Date.now() / 900000)).then(function (r) { return r.ok ? r.json() : []; }).catch(function () { return []; });
    return Promise.all([p1, p2]).then(function (res) {
      events = (res[0] || []).map(function (e) { e.end = e.end || e.end_date || e.date; return e; });
      gcal = (res[1] || []).map(function (e) { return { gcal: true, date: e.date, end: e.end || e.date, title: e.title, type: 'gcal', time: e.time || '', place: e.place || '', description: e.desc || '' }; });
      loaded = true;
    });
  }
  function eventsOn(ds) {
    return events.concat(gcal).filter(function (e) { return e.date <= ds && ds <= (e.end || e.date); })
      .sort(function (a, b) { return (a.time || '') < (b.time || '') ? -1 : 1; });
  }
  function color(e) { return (TYPE[e.type] || TYPE.union)[1]; }
  function tname(e) { return (TYPE[e.type] || TYPE.union)[0]; }

  // ---------- 모달 공통 ----------
  function modal(html, cls) {
    document.querySelectorAll('.gcal-modal').forEach(function (m) { m.remove(); });
    var m = document.createElement('div'); m.className = 'gcal-modal' + (cls ? ' ' + cls : '');
    m.innerHTML = '<div class="gcal-box" role="dialog">' + html + '</div>';
    document.body.appendChild(m);
    function shut() { m.remove(); document.removeEventListener('keydown', onkey, true); }
    function onkey(ev) { if (ev.key === 'Escape') shut(); }
    m.addEventListener('click', function (ev) { if (ev.target === m || ev.target.closest('.gcal-close')) { ev.preventDefault(); shut(); } });
    document.addEventListener('keydown', onkey, true);
    m.shut = shut;
    return m;
  }

  // ---------- 그날 일정 목록 ----------
  function showDay(ds, redraw) {
    var list = eventsOn(ds);
    var m = modal('<b class="gcal-h">' + esc(dayLabel(ds)) + ' <span class="note">· ' + list.length + '건</span></b>' +
      '<div class="gcal-list">' + (list.length ? list.map(function (e, i) {
        return '<a href="#" class="gcal-item" data-i="' + i + '"><i style="background:' + color(e) + '"></i>' + (e.time ? '<em>' + esc(e.time) + '</em>' : '') +
          '<span>' + esc(e.title) + '</span><small>' + esc(tname(e)) + (e.post_id ? ' · 회의자료' : '') + ((e.attachments || []).length ? ' &#128206;' : '') + '</small></a>';
      }).join('') : '<p class="note" style="padding:14px 0">등록된 일정이 없습니다.</p>') + '</div>' +
      '<div class="gcal-btns">' + (canEdit() ? '<a href="#" class="btn sm gcal-new">+ 이날 일정 추가</a>' : '') + '<a href="#" class="btn sm line gcal-close">닫기</a></div>');
    m.querySelectorAll('.gcal-item').forEach(function (a) { a.onclick = function (ev) { ev.preventDefault(); showEvent(list[+a.getAttribute('data-i')], redraw); }; });
    var nb = m.querySelector('.gcal-new'); if (nb) nb.onclick = function (ev) { ev.preventDefault(); editEvent({ date: ds, end: ds }, redraw); };
  }

  // ---------- 일정 상세 ----------
  function showEvent(e, redraw) {
    var atts = e.attachments || [];
    var m = modal('<div class="gcal-detail"><span class="gcal-type" style="background:' + color(e) + '">' + esc(tname(e)) + '</span>' +
      '<h4>' + esc(e.title) + '</h4>' +
      '<div class="note">' + esc(dayLabel(e.date)) + (e.end && e.end !== e.date ? ' ~ ' + esc(dayLabel(e.end)) : '') + (e.time ? ' &nbsp;' + esc(e.time) : '') + (e.place ? ' &nbsp;|&nbsp; ' + esc(e.place) : '') + '</div>' +
      (e.description ? '<div class="gcal-desc">' + linkify(e.description) + '</div>' : '') +
      (atts.length ? '<div class="attach"><b>첨부자료</b><ul>' + atts.map(function (a) {
        return '<li>' + (/\.(png|jpe?g|gif|webp)$/i.test(a.name) ? '<a href="' + esc(a.url) + '" target="_blank"><img src="' + esc(a.url) + '" alt="" style="max-width:100%;max-height:240px;display:block;border:1px solid var(--line);border-radius:6px;margin:6px 0"></a>' : '') +
          '<a href="' + esc(a.url) + '" target="_blank" rel="noopener">&#128206; ' + esc(a.name) + '</a> <span class="note">(' + Math.round((a.size || 0) / 1024) + ' KB)</span></li>';
      }).join('') + '</ul></div>' : '') +
      (e.post_id ? '<p style="margin-top:12px"><a href="' + root() + 'board/view.html?id=' + e.post_id + '" class="btn sm line">&#128196; 회의자료 게시판에서 보기</a></p>' : '') +
      (e.gcal ? '<p class="note" style="margin-top:10px">구글 캘린더 [GRILU]에서 자동으로 가져온 일정입니다.</p>' : '') +
      '</div><div class="gcal-btns">' + (canEdit() && !e.gcal ? '<a href="#" class="btn sm gcal-edit">수정</a> <a href="#" class="btn sm gcal-del" style="background:#c33">삭제</a>' : '') + '<a href="#" class="btn sm line gcal-close">닫기</a></div>');
    var ed = m.querySelector('.gcal-edit'); if (ed) ed.onclick = function (ev) { ev.preventDefault(); editEvent(e, redraw); };
    var dl = m.querySelector('.gcal-del'); if (dl) dl.onclick = function (ev) {
      ev.preventDefault(); if (!confirm('이 일정을 삭제할까요?' + (e.post_id ? '\n(회의자료 게시판의 글은 남습니다)' : ''))) return;
      DB.client.from('events').delete().eq('id', e.id).then(function (r) { if (r.error) return alert('삭제 실패: ' + r.error.message); m.shut(); loadAll().then(redraw); });
    };
  }

  // ---------- 일정 추가·수정 ----------
  function editEvent(e, redraw) {
    e = e || {}; var isNew = !e.id;
    var pending = [], existing = (e.attachments || []).slice();
    var types = Object.keys(TYPE).filter(function (k) { return k !== 'gcal'; });
    var m = modal('<form class="gcal-form"><b class="gcal-h">' + (isNew ? '일정 추가' : '일정 수정') + '</b>' +
      '<table class="tbl form-tbl">' +
      '<tr><th>제목</th><td><input type="text" name="title" required value="' + esc(e.title || '') + '"></td></tr>' +
      '<tr><th>날짜</th><td><input type="date" name="date" required value="' + esc(e.date || '') + '" style="width:auto"> ~ <input type="date" name="end" value="' + esc(e.end && e.end !== e.date ? e.end : '') + '" style="width:auto"> <span class="note">(하루면 비워 두세요)</span></td></tr>' +
      '<tr><th>시간·장소</th><td><input type="text" name="time" placeholder="예: 14:00~15:00" value="' + esc(e.time || '') + '" style="width:160px"> <input type="text" name="place" placeholder="장소 (예: 6층 중회의실)" value="' + esc(e.place || '') + '" style="width:calc(100% - 170px)"></td></tr>' +
      '<tr><th>구분</th><td><select name="type" style="width:auto">' + types.map(function (k) { return '<option value="' + k + '"' + ((e.type || 'union') === k ? ' selected' : '') + '>' + TYPE[k][0] + '</option>'; }).join('') + '</select></td></tr>' +
      '<tr><th>내용</th><td><textarea name="description" style="height:120px" placeholder="회의 안건, 참고 사항 등">' + esc(e.description || '') + '</textarea></td></tr>' +
      '<tr><th>첨부자료</th><td><div class="gcal-drop" tabindex="0">&#128206; 파일을 여기에 <b>끌어다 놓거나</b>, 캡처한 이미지·파일을 <b>붙여넣기(Ctrl+V)</b> 하거나, <label class="btn sm line" style="cursor:pointer">파일 선택<input type="file" multiple style="display:none"></label></div>' +
      '<ul class="gcal-files"></ul><p class="note">첨부가 있으면 <b>자료마당 &gt; 회의자료</b> 게시판에 같은 제목의 글이 자동으로 올라가고 일정과 연결됩니다.</p>' +
      '<label style="display:block;margin-top:6px"><input type="checkbox" name="to_board" style="width:auto"' + (existing.length || e.post_id ? ' checked' : '') + '> 첨부가 없어도 회의자료 게시판에 글 올리기</label></td></tr>' +
      '</table><div class="gcal-btns"><button type="submit" class="btn sm">저장</button> <a href="#" class="btn sm line gcal-close">취소</a> <span class="gcal-msg note"></span></div></form>');
    var form = m.querySelector('form'), drop = m.querySelector('.gcal-drop'), ul = m.querySelector('.gcal-files'), msg = m.querySelector('.gcal-msg');
    function renderFiles() {
      ul.innerHTML = existing.map(function (a, i) { return '<li>&#128206; <a href="' + esc(a.url) + '" target="_blank">' + esc(a.name) + '</a> <a href="#" data-x="' + i + '" style="color:#c33">[삭제]</a></li>'; }).join('') +
        pending.map(function (f, i) { return '<li>' + (f.type.indexOf('image/') === 0 ? '<img src="' + URL.createObjectURL(f) + '" alt="" style="height:44px;vertical-align:middle;border:1px solid var(--line);border-radius:4px;margin-right:6px">' : '&#128196; ') + esc(f.name) + ' <span class="note">(' + Math.round(f.size / 1024) + ' KB)</span> <a href="#" data-p="' + i + '" style="color:#c33">[빼기]</a></li>'; }).join('');
      ul.querySelectorAll('a[data-x]').forEach(function (a) { a.onclick = function (ev) { ev.preventDefault(); existing.splice(+a.getAttribute('data-x'), 1); renderFiles(); }; });
      ul.querySelectorAll('a[data-p]').forEach(function (a) { a.onclick = function (ev) { ev.preventDefault(); pending.splice(+a.getAttribute('data-p'), 1); renderFiles(); }; });
    }
    function addFiles(files) {
      Array.prototype.slice.call(files || []).forEach(function (f) {
        if (!f || !f.size) return;
        if (!f.name || /^(image|blob)\.\w+$/i.test(f.name) || f.name === 'image.png') {
          var d = new Date(), stamp = d.getFullYear() + pad(d.getMonth() + 1) + pad(d.getDate()) + '_' + pad(d.getHours()) + pad(d.getMinutes()) + pad(d.getSeconds());
          var ext = (f.type.split('/')[1] || 'png').replace('jpeg', 'jpg');
          f = new File([f], '캡처_' + stamp + '.' + ext, { type: f.type });
        }
        pending.push(f);
      });
      renderFiles();
    }
    renderFiles();
    m.querySelector('input[type=file]').onchange = function () { addFiles(this.files); this.value = ''; };
    ['dragenter', 'dragover'].forEach(function (t) { drop.addEventListener(t, function (ev) { ev.preventDefault(); drop.classList.add('over'); }); });
    ['dragleave', 'drop'].forEach(function (t) { drop.addEventListener(t, function (ev) { ev.preventDefault(); drop.classList.remove('over'); }); });
    drop.addEventListener('drop', function (ev) { addFiles(ev.dataTransfer.files); });
    m.addEventListener('drop', function (ev) { ev.preventDefault(); addFiles(ev.dataTransfer.files); });
    m.addEventListener('dragover', function (ev) { ev.preventDefault(); });
    var onPaste = function (ev) {
      var cd = ev.clipboardData; if (!cd) return;
      var files = [];
      for (var i = 0; i < cd.items.length; i++) { var it = cd.items[i]; if (it.kind === 'file') { var f = it.getAsFile(); if (f) files.push(f); } }
      if (files.length) { ev.preventDefault(); addFiles(files); }
    };
    document.addEventListener('paste', onPaste);
    var origShut = m.shut; m.shut = function () { document.removeEventListener('paste', onPaste); origShut(); };

    form.onsubmit = function () {
      var btn = form.querySelector('button[type=submit]'); btn.disabled = true; msg.textContent = '저장 중…';
      var row = { title: form.title.value.trim(), date: form.date.value, end_date: form.end.value || null, time: form.time.value.trim() || null, place: form.place.value.trim() || null, type: form.type.value, description: form.description.value.trim() || null };
      if (!row.title || !row.date) { alert('제목과 날짜를 입력하세요.'); btn.disabled = false; msg.textContent = ''; return false; }
      Promise.all(pending.map(function (f) { return DB.upload(f, 'events'); })).then(function (up) {
        row.attachments = existing.concat(up);
        var wantPost = row.attachments.length > 0 || form.to_board.checked || e.post_id;
        if (!wantPost) return Promise.resolve(null);
        // 회의자료 게시판 글 (있으면 갱신, 없으면 새로)
        var post = {
          board: MEET_BOARD, title: row.title + ' (' + row.date + ')',
          content: '<p><b>일시</b> ' + esc(dayLabel(row.date)) + (row.end_date ? ' ~ ' + esc(dayLabel(row.end_date)) : '') + (row.time ? ' ' + esc(row.time) : '') + (row.place ? ' &nbsp;|&nbsp; <b>장소</b> ' + esc(row.place) : '') + ' &nbsp;|&nbsp; <b>구분</b> ' + esc(TYPE[row.type][0]) + '</p>' +
            (row.description ? '<div style="margin-top:10px">' + linkify(row.description) + '</div>' : '') + '<p class="note" style="margin-top:14px">※ 일정 달력에서 등록된 회의자료입니다.</p>',
          attachments: row.attachments, updated_at: new Date().toISOString()
        };
        if (e.post_id) return DB.client.from('posts').update(post).eq('id', e.post_id).select('id').single().then(function (r) { return r.error ? DB.client.from('posts').insert(Object.assign({ author_id: DB.user.id, author_name: '관리자' }, post)).select('id').single() : r; });
        return DB.client.from('posts').insert(Object.assign({ author_id: DB.user.id, author_name: '관리자' }, post)).select('id').single();
      }).then(function (r) {
        if (r && r.error) throw r.error;
        if (r && r.data) row.post_id = r.data.id;
        return isNew ? DB.client.from('events').insert(row).select().single() : DB.client.from('events').update(row).eq('id', e.id).select().single();
      }).then(function (r) {
        if (r.error) throw r.error;
        m.shut(); loadAll().then(redraw);
      }).catch(function (err) {
        var t = err.message || String(err);
        if (/column .* does not exist|schema cache/i.test(t)) t += '\n(supabase/events_v2.sql 을 아직 실행하지 않았습니다)';
        alert('저장 실패: ' + t); btn.disabled = false; msg.textContent = '';
      });
      return false;
    };
  }

  // ---------- 달력 그리기 ----------
  function init(box) {
    var today = new Date(), cur = new Date(today.getFullYear(), today.getMonth(), 1);
    var big = box.classList.contains('gcal-big'), MAX = big ? 4 : 3;
    var upBox = document.querySelector(box.getAttribute('data-upcoming') || '.gcal-upcoming');
    function draw() {
      var y = cur.getFullYear(), m = cur.getMonth();
      var first = new Date(y, m, 1), d = new Date(y, m, 1 - first.getDay()), todayStr = ymd(today);
      var cells = '';
      for (var i = 0; i < 42; i++) {
        var ds = ymd(d), list = eventsOn(ds), out = d.getMonth() !== m;
        cells += '<div class="gc-cell' + (out ? ' out' : '') + (ds === todayStr ? ' today' : '') + (list.length ? ' has' : '') + '" data-d="' + ds + '">' +
          '<b class="gc-d' + (d.getDay() === 0 ? ' sun' : d.getDay() === 6 ? ' sat' : '') + '">' + d.getDate() + '</b>' +
          list.slice(0, MAX).map(function (e, k) { return '<a href="#" class="gc-ev" data-k="' + k + '" style="background:' + color(e) + '" title="' + esc(e.title) + '">' + (e.time ? '<em>' + esc(e.time.split(/[~\-]/)[0]) + '</em> ' : '') + esc(e.title) + '</a>'; }).join('') +
          (list.length > MAX ? '<span class="gc-more">+' + (list.length - MAX) + '</span>' : '') + '</div>';
        d.setDate(d.getDate() + 1);
        if (i >= 34 && d.getMonth() !== m && (i + 1) % 7 === 0) break;
      }
      box.innerHTML = '<div class="gc-head"><div class="gc-nav"><button type="button" class="gc-prev" aria-label="이전 달">&lsaquo;</button><b>' + y + '. ' + pad(m + 1) + '</b><button type="button" class="gc-next" aria-label="다음 달">&rsaquo;</button><button type="button" class="gc-today">오늘</button></div>' +
        '<div class="gc-right">' + (canEdit() ? '<a href="#" class="btn sm gc-add">+ 일정 추가</a>' : '') + (box.getAttribute('data-more') ? '<a href="' + esc(box.getAttribute('data-more')) + '" class="more">전체 일정 →</a>' : '') + '</div></div>' +
        '<div class="gc-wd">' + WEEK.map(function (w, i) { return '<span class="' + (i === 0 ? 'sun' : i === 6 ? 'sat' : '') + '">' + w + '</span>'; }).join('') + '</div>' +
        '<div class="gc-grid">' + cells + '</div>' +
        '<div class="gc-legend">' + Object.keys(TYPE).map(function (k) { return '<span><i style="background:' + TYPE[k][1] + '"></i>' + TYPE[k][0] + '</span>'; }).join('') + (canEdit() ? '<span class="note">· 날짜를 누르면 일정을 추가할 수 있습니다</span>' : '') + '</div>';
      box.querySelector('.gc-prev').onclick = function () { cur.setMonth(cur.getMonth() - 1); draw(); };
      box.querySelector('.gc-next').onclick = function () { cur.setMonth(cur.getMonth() + 1); draw(); };
      box.querySelector('.gc-today').onclick = function () { cur = new Date(today.getFullYear(), today.getMonth(), 1); draw(); };
      var add = box.querySelector('.gc-add'); if (add) add.onclick = function (ev) { ev.preventDefault(); editEvent({ date: ymd(today), end: ymd(today) }, draw); };
      box.querySelector('.gc-grid').onclick = function (ev) {
        var cell = ev.target.closest('.gc-cell'); if (!cell) return;
        ev.preventDefault();
        var ds = cell.getAttribute('data-d'), list = eventsOn(ds);
        var evl = ev.target.closest('.gc-ev');
        if (evl) return showEvent(list[+evl.getAttribute('data-k')], draw);
        if (ev.target.closest('.gc-more') || list.length) return showDay(ds, draw);
        if (canEdit()) return editEvent({ date: ds, end: ds }, draw);
        showDay(ds, draw);
      };
      drawUpcoming();
    }
    function drawUpcoming() {
      if (!upBox) return;
      var todayStr = ymd(today), lim = +(upBox.getAttribute('data-limit') || 6);
      var list = events.concat(gcal).filter(function (e) { return (e.end || e.date) >= todayStr; }).sort(function (a, b) { return a.date < b.date ? -1 : a.date > b.date ? 1 : (a.time || '') < (b.time || '') ? -1 : 1; }).slice(0, lim);
      upBox.innerHTML = '<h4>다가오는 일정</h4>' + (list.length ? '<ul>' + list.map(function (e) {
        var dt = new Date(e.date + 'T00:00:00');
        return '<li><a href="#" class="up-item"><div class="date-box" style="border-left:4px solid ' + color(e) + '"><b>' + dt.getDate() + '</b><span>' + (dt.getMonth() + 1) + '월 (' + WEEK[dt.getDay()] + ')</span></div>' +
          '<div><div class="tit">' + esc(e.title) + '</div><div class="desc">' + esc(tname(e)) + (e.time ? ' · ' + esc(e.time) : '') + (e.place ? ' · ' + esc(e.place) : '') + ((e.attachments || []).length ? ' · &#128206;' : '') + '</div></div></a></li>';
      }).join('') + '</ul>' : '<p class="note" style="padding:16px 0">앞으로 잡힌 일정이 없습니다.</p>');
      upBox.querySelectorAll('.up-item').forEach(function (a, i) { a.onclick = function (ev) { ev.preventDefault(); showEvent(list[i], draw); }; });
    }
    box.innerHTML = '<p class="note" style="padding:30px;text-align:center">달력을 여는 중…</p>';
    loadAll().then(draw);
    document.addEventListener('db:ready', function () { loadAll().then(draw); });
  }
  boxes.forEach(init);
})();

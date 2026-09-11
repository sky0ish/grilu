/* ============================================================
   관리자 페이지: 회원 승인, 일정 관리, 고충상담 열람
   ============================================================ */
(function () {
  var DB = window.DB;
  if (!DB) return;
  var esc = DB.esc, fmt = DB.fmtDate;
  var typeName = { union: '노조', council: '노사협의회', event: '행사', holiday: '휴일' };

  document.addEventListener('db:ready', function () {
    if (!document.getElementById('adminPage')) return;
    if (!DB.requireLogin()) return;
    if (!DB.isAdmin()) { document.getElementById('adminPage').innerHTML = '<p style="color:#c33">관리자만 접근할 수 있습니다.</p>'; return; }
    loadMembers(); loadEvents(); loadCounsel();
    document.getElementById('eventForm').onsubmit = saveEvent;
  });

  // ---------- 회원 ----------
  function loadMembers() {
    DB.client.from('profiles').select('*').order('created_at', { ascending: false }).then(function (r) {
      var tb = document.querySelector('#memberTbl tbody');
      if (r.error) { tb.innerHTML = '<tr><td colspan="6">' + esc(r.error.message) + '</td></tr>'; return; }
      tb.innerHTML = r.data.map(function (p) {
        return '<tr><td>' + esc(p.name || '-') + '</td><td>' + esc(p.email) + '</td><td>' + esc(p.dept || '-') + '</td><td>' + fmt(p.created_at) + '</td>' +
          '<td>' + (p.role === 'admin' ? '<b style="color:var(--gri-orange)">관리자</b>' : (p.approved ? '승인' : '<span style="color:#c33">대기</span>')) + '</td>' +
          '<td>' + (p.role === 'admin' ? '' :
            '<button class="btn" data-act="' + (p.approved ? 'revoke' : 'approve') + '" data-id="' + p.id + '" style="padding:4px 10px;font-size:12px">' + (p.approved ? '승인취소' : '승인') + '</button> ' +
            '<button class="btn line" data-act="admin" data-id="' + p.id + '" style="padding:4px 10px;font-size:12px">관리자 지정</button>') + '</td></tr>';
      }).join('') || '<tr><td colspan="6">회원이 없습니다.</td></tr>';
      tb.querySelectorAll('button').forEach(function (b) {
        b.onclick = function () {
          var act = b.getAttribute('data-act'), id = b.getAttribute('data-id');
          var patch = act === 'approve' ? { approved: true } : act === 'revoke' ? { approved: false } : { role: 'admin', approved: true };
          if (act === 'admin' && !confirm('이 회원을 관리자로 지정할까요?')) return;
          DB.client.from('profiles').update(patch).eq('id', id).then(function (r2) { if (r2.error) alert(r2.error.message); loadMembers(); });
        };
      });
    });
  }

  // ---------- 일정 ----------
  function loadEvents() {
    DB.client.from('events').select('*').order('date', { ascending: false }).limit(100).then(function (r) {
      var tb = document.querySelector('#eventTbl tbody');
      if (r.error) { tb.innerHTML = '<tr><td colspan="5">' + esc(r.error.message) + '</td></tr>'; return; }
      tb.innerHTML = r.data.map(function (e) {
        return '<tr><td>' + e.date + (e.end_date ? ' ~ ' + e.end_date : '') + '</td><td class="tit">' + esc(e.title) + '</td><td>' + typeName[e.type] + '</td><td class="tit">' + esc(e.description || '') + '</td>' +
          '<td><button class="btn line" data-edit="' + e.id + '" style="padding:4px 10px;font-size:12px">수정</button> <button class="btn" data-del="' + e.id + '" style="padding:4px 10px;font-size:12px;background:#c33">삭제</button></td></tr>';
      }).join('') || '<tr><td colspan="5">등록된 일정이 없습니다.</td></tr>';
      tb.querySelectorAll('[data-del]').forEach(function (b) {
        b.onclick = function () { if (!confirm('삭제할까요?')) return; DB.client.from('events').delete().eq('id', b.getAttribute('data-del')).then(loadEvents); };
      });
      tb.querySelectorAll('[data-edit]').forEach(function (b) {
        b.onclick = function () {
          var e = r.data.filter(function (x) { return String(x.id) === b.getAttribute('data-edit'); })[0];
          var f = document.getElementById('eventForm');
          f.id_.value = e.id; f.date.value = e.date; f.end_date.value = e.end_date || ''; f.title.value = e.title; f.type.value = e.type; f.description.value = e.description || '';
          f.scrollIntoView({ behavior: 'smooth' });
        };
      });
    });
  }
  function saveEvent() {
    var f = document.getElementById('eventForm');
    var row = { date: f.date.value, end_date: f.end_date.value || null, title: f.title.value.trim(), type: f.type.value, description: f.description.value.trim() || null };
    if (!row.date || !row.title) { alert('날짜와 제목을 입력하세요.'); return false; }
    var q = f.id_.value ? DB.client.from('events').update(row).eq('id', f.id_.value) : DB.client.from('events').insert(row);
    q.then(function (r) { if (r.error) return alert(r.error.message); f.reset(); f.id_.value = ''; loadEvents(); });
    return false;
  }

  // ---------- 고충상담 ----------
  function loadCounsel() {
    DB.client.from('counsel').select('*').order('created_at', { ascending: false }).then(function (r) {
      var tb = document.querySelector('#counselTbl tbody');
      if (r.error) { tb.innerHTML = '<tr><td colspan="6">' + esc(r.error.message) + '</td></tr>'; return; }
      var stName = { received: '접수', processing: '처리중', done: '완료' };
      tb.innerHTML = r.data.map(function (c) {
        return '<tr><td>' + fmt(c.created_at) + '</td><td>' + esc(c.category || '') + '</td><td class="tit"><a href="#" data-view="' + c.id + '">' + esc(c.title) + '</a></td><td>' + esc(c.name || '익명') + '<br><span class="note">' + esc(c.contact || '') + '</span></td>' +
          '<td><select data-st="' + c.id + '" style="padding:4px"><option value="received"' + (c.status === 'received' ? ' selected' : '') + '>접수</option><option value="processing"' + (c.status === 'processing' ? ' selected' : '') + '>처리중</option><option value="done"' + (c.status === 'done' ? ' selected' : '') + '>완료</option></select></td></tr>' +
          '<tr id="c' + c.id + '" hidden><td colspan="5" style="text-align:left;background:#fafbfd;white-space:pre-wrap">' + esc(c.content) + '</td></tr>';
      }).join('') || '<tr><td colspan="5">접수된 상담이 없습니다.</td></tr>';
      tb.querySelectorAll('[data-view]').forEach(function (a) { a.onclick = function (e) { e.preventDefault(); var row = document.getElementById('c' + a.getAttribute('data-view')); row.hidden = !row.hidden; }; });
      tb.querySelectorAll('[data-st]').forEach(function (s) { s.onchange = function () { DB.client.from('counsel').update({ status: s.value }).eq('id', s.getAttribute('data-st')).then(function (r2) { if (r2.error) alert(r2.error.message); }); }; });
    });
  }
})();

/* ============================================================
   관리자 페이지: 대시보드 / 회원관리 / 일정관리 / 고충상담
   (페이지 구분: #adminPage[data-admin="index|members|events|counsel"])
   ============================================================ */
(function () {
  var DB = window.DB;
  if (!DB) return;
  var esc = DB.esc, fmt = DB.fmtDate;
  var typeName = { union: '노조', council: '노사협의회', event: '행사', holiday: '휴일' };

  document.addEventListener('db:ready', function () {
    var page = document.getElementById('adminPage');
    if (!page) return;
    if (!DB.requireLogin()) return;
    if (!DB.isAdmin()) { page.innerHTML = '<p style="color:#c33;padding:40px 0">관리자만 접근할 수 있습니다.</p>'; return; }
    var kind = page.getAttribute('data-admin');
    if (kind === 'index') loadDashboard();
    if (kind === 'members') initMembers();
    if (kind === 'events') { loadEvents(); document.getElementById('eventForm').onsubmit = saveEvent; }
    if (kind === 'counsel') loadCounsel();
  });

  function statusBadge(p) {
    if (p.role === 'admin') return '<span class="st-badge admin">관리자</span>';
    return p.approved ? '<span class="st-badge ok">승인</span>' : '<span class="st-badge wait">대기</span>';
  }

  // ---------- 대시보드 ----------
  function loadDashboard() {
    var set = function (k, v) { var el = document.querySelector('[data-stat="' + k + '"]'); if (el) el.textContent = v; };
    DB.client.from('profiles').select('*').order('created_at', { ascending: false }).then(function (r) {
      if (r.error) return;
      set('members', r.data.length + '명');
      set('pending', r.data.filter(function (p) { return !p.approved && p.role !== 'admin'; }).length + '명');
      var tb = document.querySelector('#recentMembers tbody');
      tb.innerHTML = r.data.slice(0, 8).map(function (p) {
        return '<tr><td>' + esc(p.name || '-') + '</td><td>' + esc(p.email) + '</td><td>' + esc(p.dept || '-') + '</td><td>' + esc(p.position || '-') + '</td><td>' + fmt(p.created_at) + '</td><td>' + statusBadge(p) + '</td></tr>';
      }).join('') || '<tr><td colspan="6">회원이 없습니다.</td></tr>';
    });
    var now = new Date(), p2 = function (n) { return (n < 10 ? '0' : '') + n; };
    var from = now.getFullYear() + '-' + p2(now.getMonth() + 1) + '-01';
    var to = new Date(now.getFullYear(), now.getMonth() + 1, 0);
    DB.client.from('events').select('id', { count: 'exact', head: true }).gte('date', from).lte('date', fmt(to)).then(function (r) { set('events', (r.count || 0) + '건'); });
    DB.client.from('counsel').select('id', { count: 'exact', head: true }).neq('status', 'done').then(function (r) { set('counsel', (r.count || 0) + '건'); });
  }

  // ---------- 회원관리 ----------
  var members = [];
  var TABS = [['pending', '승인 대기'], ['approved', '승인됨'], ['admin', '관리자'], ['all', '전체']];
  function initMembers() {
    var q = new URLSearchParams(location.search);
    var filter = document.getElementById('memberFilter');
    if (q.get('filter')) filter.value = q.get('filter');
    document.getElementById('memberSearch').addEventListener('input', renderMembers);
    filter.addEventListener('change', renderMembers);
    document.getElementById('memberCsv').addEventListener('click', exportCsv);
    /* 「회원관리 명단을 종류별로 볼 수 있게」 — 고르개 대신 갈래 단추. 수는 명단을 읽은 뒤 채웁니다 */
    var tools = filter.parentNode;
    var nav = document.createElement('div'); nav.id = 'memberTabs'; nav.className = 'mtabs';
    nav.innerHTML = TABS.map(function (t) { return '<button type="button" class="mtab" data-k="' + t[0] + '">' + t[1] + ' <b class="n">0</b></button>'; }).join('');
    tools.parentNode.insertBefore(nav, tools);
    filter.style.display = 'none';
    var st = document.createElement('style');
    st.textContent = '.mtabs{display:flex;flex-wrap:wrap;gap:8px;margin:0 0 12px}.mtab{border:1px solid #d8d3cc;background:#fff;border-radius:999px;padding:7px 14px;font:inherit;font-size:14px;cursor:pointer;color:#333}' +
      '.mtab .n{display:inline-block;min-width:20px;padding:0 6px;margin-left:4px;border-radius:999px;background:#eee;color:#555;font-size:12px;line-height:20px;text-align:center}' +
      '.mtab.on{background:var(--primary,#1f3f8f);border-color:var(--primary,#1f3f8f);color:#fff}.mtab.on .n{background:rgba(255,255,255,.25);color:#fff}' +
      '.mtab[data-k=pending] .n.has{background:#fde8e8;color:#c33}.mtab.on[data-k=pending] .n.has{background:#fff;color:#c33}' +
      '.tbl .btn.line.sm{background:#fff;color:#333;border:1px solid #cfc8c0}.tbl .btn.line.sm:hover{border-color:var(--primary,#1f3f8f);color:var(--primary,#1f3f8f)}';
    document.head.appendChild(st);
    nav.querySelectorAll('.mtab').forEach(function (b) { b.onclick = function () { filter.value = b.getAttribute('data-k'); renderMembers(); }; });
    loadMembers();
  }
  function isPending(p) { return !p.approved && p.role !== 'admin'; }
  function paintTabs() {
    var f = document.getElementById('memberFilter').value;
    var n = { pending: 0, approved: 0, admin: 0, all: members.length };
    members.forEach(function (p) { if (p.role === 'admin') n.admin++; else if (p.approved) n.approved++; else n.pending++; });
    document.querySelectorAll('#memberTabs .mtab').forEach(function (b) {
      var k = b.getAttribute('data-k');
      b.classList.toggle('on', k === f);
      var nb = b.querySelector('.n'); nb.textContent = n[k]; nb.classList.toggle('has', k === 'pending' && n[k] > 0);
    });
  }
  function loadMembers() {
    DB.client.from('profiles').select('*').order('created_at', { ascending: false }).then(function (r) {
      var tb = document.querySelector('#memberTbl tbody');
      if (r.error) { tb.innerHTML = '<tr><td colspan="6">' + esc(r.error.message) + '</td></tr>'; return; }
      members = r.data; renderMembers();
    });
  }
  function filtered() {
    var kw = (document.getElementById('memberSearch').value || '').trim().toLowerCase();
    var f = document.getElementById('memberFilter').value;
    return members.filter(function (p) {
      if (f === 'pending' && (p.approved || p.role === 'admin')) return false;
      if (f === 'approved' && !(p.approved && p.role !== 'admin')) return false;
      if (f === 'admin' && p.role !== 'admin') return false;
      if (kw && ((p.name || '') + ' ' + (p.email || '') + ' ' + (p.dept || '') + ' ' + (p.position || '')).toLowerCase().indexOf(kw) < 0) return false;
      return true;
    }).sort(function (a, b) {
      /* 승인 대기를 맨 위에, 그다음 가입 차례 — 전체 보기에서도 할 일이 먼저 보이게 */
      return (isPending(a) ? 0 : 1) - (isPending(b) ? 0 : 1) || String(b.created_at || '').localeCompare(String(a.created_at || ''));
    });
  }
  function renderMembers() {
    var tb = document.querySelector('#memberTbl tbody');
    var list = filtered();
    paintTabs();
    document.getElementById('memberCount').textContent = list.length + '명 / 전체 ' + members.length + '명';
    if (!list.length) { tb.innerHTML = '<tr><td colspan="7" style="padding:30px;color:#888">해당하는 회원이 없습니다.</td></tr>'; return; }
    var me = DB.user.id;
    tb.innerHTML = list.map(function (p) {
      var self = p.id === me;
      var grade = p.role === 'admin' ? 'admin' : (p.approved ? 'member' : 'pending');
      return '<tr data-id="' + p.id + '">' +
        '<td><input class="inline" data-f="name" value="' + esc(p.name || '') + '"></td>' +
        '<td style="text-align:left">' + esc(p.email) + (self ? ' <span class="note">(나)</span>' : '') + '</td>' +
        '<td><input class="inline" data-f="dept" value="' + esc(p.dept || '') + '"></td>' +
        '<td><select class="inline" data-f="position">' + '<option value="">-</option>' + '<option' + (p.position === '선임연구위원' ? ' selected' : '') + '>선임연구위원</option>' + '<option' + (p.position === '연구위원' ? ' selected' : '') + '>연구위원</option>' + '<option' + (p.position === '선임연구원' ? ' selected' : '') + '>선임연구원</option>' + '<option' + (p.position === '연구원' ? ' selected' : '') + '>연구원</option>' + '<option' + (p.position === '행정직' ? ' selected' : '') + '>행정직</option>' + '</select></td>' +
        '<td>' + fmt(p.created_at) + '</td><td>' + statusBadge(p) + '</td>' +
        '<td>' + (self ? '<span class="note">본인</span> ' :
          '<select class="inline" data-f="grade" style="width:auto" title="구분: 승인 대기 / 회원 / 관리자">' +
            '<option value="pending"' + (grade === 'pending' ? ' selected' : '') + '>대기(미승인)</option>' +
            '<option value="member"' + (grade === 'member' ? ' selected' : '') + '>회원</option>' +
            '<option value="admin"' + (grade === 'admin' ? ' selected' : '') + '>관리자</option></select> ') +
        '<button class="btn sm" data-act="save">' + (grade === 'pending' && !self ? '가입 승인' : '저장') + '</button> ' +
        /* 고르개를 거치지 않고 한 번에 — 「내가 회원에서 관리자로 올릴 수 있게」 */
        (self ? '' : grade === 'member' ? '<button class="btn line sm" data-act="admin">관리자로</button> <button class="btn line sm" data-act="revoke">승인 취소</button> '
              : grade === 'admin' ? '<button class="btn line sm" data-act="unadmin">관리자 해제</button> ' : '') +
        (self ? '' : '<button class="btn sm danger" data-act="delete">탈퇴</button>') +
        '</td></tr>';
    }).join('');
    tb.querySelectorAll('button').forEach(function (b) {
      b.onclick = function () {
        var tr = b.closest('tr'), id = tr.getAttribute('data-id'), act = b.getAttribute('data-act');
        var p = members.filter(function (x) { return x.id === id; })[0];
        var done = function (r) { if (r && r.error) alert('실패: ' + r.error.message); loadMembers(); };
        if (act === 'save') {
          var patch = { name: tr.querySelector('[data-f=name]').value.trim(), dept: tr.querySelector('[data-f=dept]').value.trim(), position: tr.querySelector('[data-f=position]').value || null };
          var gsel = tr.querySelector('[data-f=grade]'), g = gsel ? gsel.value : null, cur = p.role === 'admin' ? 'admin' : (p.approved ? 'member' : 'pending');
          if (g && g !== cur) {
            if (g === 'admin' && !confirm(p.email + ' 회원을 관리자로 지정할까요? (회원 관리·일정·게시판 관리 권한)')) return;
            if (g === 'pending' && !confirm(p.email + ' 회원의 승인을 취소할까요?')) return;
            patch.role = g === 'admin' ? 'admin' : 'member'; patch.approved = g !== 'pending';
          }
          return DB.client.from('profiles').update(patch).eq('id', id).then(function (r) { if (r.error) alert(r.error.message); else if (g && g !== cur) loadMembers(); else { b.textContent = '저장됨'; setTimeout(function () { b.textContent = '저장'; }, 1200); p.name = patch.name; p.dept = patch.dept; p.position = patch.position; } });
        }
        if (act === 'approve') return DB.client.from('profiles').update({ approved: true }).eq('id', id).then(done);
        if (act === 'revoke') { if (!confirm(p.email + ' 회원의 승인을 취소할까요?')) return; return DB.client.from('profiles').update({ approved: false }).eq('id', id).then(done); }
        if (act === 'admin') { if (!confirm(p.email + ' 회원을 관리자로 지정할까요?')) return; return DB.client.from('profiles').update({ role: 'admin', approved: true }).eq('id', id).then(done); }
        if (act === 'unadmin') { if (!confirm('관리자 권한을 해제할까요? (승인 조합원으로 남습니다)')) return; return DB.client.from('profiles').update({ role: 'member' }).eq('id', id).then(done); }
        if (act === 'delete') {
          if (!confirm(p.email + ' 회원을 탈퇴 처리할까요?\n홈페이지 회원 정보가 삭제되고 조합원 권한이 사라집니다.')) return;
          return DB.client.from('profiles').delete().eq('id', id).then(done);
        }
      };
    });
  }
  function exportCsv() {
    var rows = [['성명', '이메일', '소속', '직급', '상태', '가입일']].concat(filtered().map(function (p) {
      return [p.name || '', p.email || '', p.dept || '', p.position || '', p.role === 'admin' ? '관리자' : (p.approved ? '승인' : '대기'), fmt(p.created_at)];
    }));
    var csv = '﻿' + rows.map(function (r) { return r.map(function (v) { return '"' + String(v).replace(/"/g, '""') + '"'; }).join(','); }).join('\r\n');
    var a = document.createElement('a');
    a.href = URL.createObjectURL(new Blob([csv], { type: 'text/csv;charset=utf-8' }));
    a.download = '회원목록_' + fmt(new Date()) + '.csv'; a.click();
  }

  // ---------- 일정 ----------
  function loadEvents() {
    DB.client.from('events').select('*').order('date', { ascending: false }).limit(200).then(function (r) {
      var tb = document.querySelector('#eventTbl tbody');
      if (r.error) { tb.innerHTML = '<tr><td colspan="5">' + esc(r.error.message) + '</td></tr>'; return; }
      tb.innerHTML = r.data.map(function (e) {
        return '<tr><td>' + e.date + (e.end_date ? ' ~ ' + e.end_date : '') + '</td><td class="tit">' + esc(e.title) + '</td><td>' + typeName[e.type] + '</td><td class="tit">' + esc(e.description || '') + '</td>' +
          '<td><button class="btn sm line" data-edit="' + e.id + '">수정</button> <button class="btn sm danger" data-del="' + e.id + '">삭제</button></td></tr>';
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
      if (r.error) { tb.innerHTML = '<tr><td colspan="5">' + esc(r.error.message) + '</td></tr>'; return; }
      tb.innerHTML = r.data.map(function (c) {
        var opt = function (v, n) { return '<option value="' + v + '"' + (c.status === v ? ' selected' : '') + '>' + n + '</option>'; };
        return '<tr><td>' + fmt(c.created_at) + '</td><td>' + esc(c.category || '') + '</td><td class="tit"><a href="#" data-view="' + c.id + '">' + esc(c.title) + '</a></td><td>' + esc(c.name || '익명') + '<br><span class="note">' + esc(c.contact || '') + '</span></td>' +
          '<td><select data-st="' + c.id + '" style="padding:4px">' + opt('received', '접수') + opt('processing', '처리중') + opt('done', '완료') + '</select></td></tr>' +
          '<tr id="c' + c.id + '" hidden><td colspan="5" style="text-align:left;background:#fafbfd;white-space:pre-wrap">' + esc(c.content) + '</td></tr>';
      }).join('') || '<tr><td colspan="5">접수된 상담이 없습니다.</td></tr>';
      tb.querySelectorAll('[data-view]').forEach(function (a) { a.onclick = function (e) { e.preventDefault(); var row = document.getElementById('c' + a.getAttribute('data-view')); row.hidden = !row.hidden; }; });
      tb.querySelectorAll('[data-st]').forEach(function (s) { s.onchange = function () { DB.client.from('counsel').update({ status: s.value }).eq('id', s.getAttribute('data-st')).then(function (r2) { if (r2.error) alert(r2.error.message); }); }; });
    });
  }
})();

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

  function gradeOf(p) { return p.role === 'admin' ? 'admin' : !p.approved ? 'pending' : (p.role === 'associate' ? 'associate' : 'member'); }
  var GRADE_NAME = { pending: '대기', member: '회원', associate: '준회원', admin: '관리자' };
  function statusBadge(p) {
    var g = gradeOf(p);
    var cls = g === 'admin' ? 'admin' : g === 'pending' ? 'wait' : g === 'associate' ? 'assoc' : 'ok';
    return '<span class="st-badge ' + cls + '">' + GRADE_NAME[g] + '</span>';
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
  var TABS = [['pending', '승인 대기'], ['approved', '회원'], ['associate', '준회원'], ['admin', '관리자'], ['all', '전체']];
  /* 직급 구분 — 가입 화면(build.py)과 같게 */
  var POSITIONS = ['선임연구위원', '연구위원', '공무직_연구원', '공무직_행정원', '행정관리직', '계약직_연구직', '계약직_공무직'];
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
      '.tbl .btn.line.sm{background:#fff;color:#333;border:1px solid #cfc8c0}.tbl .btn.line.sm:hover{border-color:var(--primary,#1f3f8f);color:var(--primary,#1f3f8f)}' +
      '.st-badge.assoc{background:#e8eef9;color:#1f3f8f}' +
      '.tbl input.inline{border-color:#e3ded8;background:#fff}.tbl input.inline:hover{border-color:#b9b2aa}' +
      '.roster{margin:0 0 14px;padding:12px 14px;border:1px solid #e3ded8;border-radius:8px;background:#faf8f5;font-size:13px}.roster summary{cursor:pointer;font-weight:700}' +
      '.roster textarea{width:100%;min-height:90px;margin:8px 0;font:inherit;font-size:13px;padding:8px;border:1px solid #cfc8c0;border-radius:6px}.roster .row{display:flex;flex-wrap:wrap;gap:8px;align-items:center}.roster .cnt{color:#666}';
    document.head.appendChild(st);
    nav.querySelectorAll('.mtab').forEach(function (b) { b.onclick = function () { filter.value = b.getAttribute('data-k'); renderMembers(); }; });
    initRoster(nav);
    loadMembers();
  }
  function paintTabs() {
    var f = document.getElementById('memberFilter').value;
    var n = { pending: 0, approved: 0, associate: 0, admin: 0, all: members.length };
    members.forEach(function (p) { var g = gradeOf(p); n[g === 'member' ? 'approved' : g]++; });
    document.querySelectorAll('#memberTabs .mtab').forEach(function (b) {
      var k = b.getAttribute('data-k');
      b.classList.toggle('on', k === f);
      var nb = b.querySelector('.n'); nb.textContent = n[k]; nb.classList.toggle('has', k === 'pending' && n[k] > 0);
    });
  }

  /* ── 노조 회원 명단 대조 ──
     「노조회원 명단을 공유할테니 비교해서 그 안에 있으면 회원으로 아니면 준회원으로」
     명단은 union_roster 표(관리자만)에 두고, 「명단 대조 승인」 을 누르면 대기자 모두를
     명단에 있으면 회원, 없으면 준회원으로 승인합니다. 이름·이메일 어느 쪽이든 맞으면 있는 것으로 봅니다. */
  var roster = [];
  var rkey = function (v) { return String(v || '').trim().toLowerCase().replace(/\s+/g, ''); };
  function initRoster(nav) {
    var box = document.createElement('details'); box.className = 'roster'; box.id = 'rosterBox';
    box.innerHTML = '<summary>노조 회원 명단 대조 <span class="cnt" id="rosterCnt"></span></summary>' +
      '<p class="note" style="margin:6px 0 0">한 줄에 한 사람 — 이름, 이메일, 또는 「이름, 이메일」. 저장하면 명단이 바뀌고(덮어씀), ' +
      '「명단 대조 승인」 은 승인 대기인 분을 명단에 있으면 <b>회원</b>, 없으면 <b>준회원</b>으로 한 번에 승인합니다.</p>' +
      '<textarea id="rosterText" placeholder="홍길동\nkim@gri.re.kr\n이영희, lee@gri.re.kr"></textarea>' +
      '<div class="row"><button type="button" class="btn sm" id="rosterSave">명단 저장</button>' +
      '<button type="button" class="btn line sm" id="rosterApprove">명단 대조 승인 (대기자 전체)</button>' +
      '<span class="cnt" id="rosterMsg"></span></div>';
    nav.parentNode.insertBefore(box, nav);
    document.getElementById('rosterSave').onclick = saveRoster;
    document.getElementById('rosterApprove').onclick = approveByRoster;
    loadRoster();
  }
  function loadRoster() {
    DB.client.from('union_roster').select('key,name,email').then(function (r) {
      var cnt = document.getElementById('rosterCnt'), ta = document.getElementById('rosterText');
      if (r.error) { cnt.textContent = '(명단 표가 아직 없습니다 — supabase/roster.sql 을 실행하세요)'; return; }
      roster = r.data || [];
      cnt.textContent = roster.length ? '· ' + roster.length + '명' : '· 아직 없음';
      if (ta && !ta.value) ta.value = roster.map(function (x) { return [x.name, x.email].filter(Boolean).join(', '); }).join('\n');
    });
  }
  function parseRoster(text) {
    var out = {};
    String(text || '').split(/\r?\n/).forEach(function (line) {
      var parts = line.split(/[,\t;]/).map(function (x) { return x.trim(); }).filter(Boolean);
      if (!parts.length) return;
      var email = parts.filter(function (x) { return /@/.test(x); })[0] || '';
      var name = parts.filter(function (x) { return !/@/.test(x); })[0] || '';
      var key = rkey(email || name);
      if (key) out[key] = { key: key, name: name, email: email.toLowerCase() };
    });
    return Object.keys(out).map(function (k) { return out[k]; });
  }
  function saveRoster() {
    var rows = parseRoster(document.getElementById('rosterText').value);
    var msg = document.getElementById('rosterMsg');
    if (!rows.length && !confirm('명단이 비어 있습니다. 모두 지울까요?')) return;
    DB.client.from('union_roster').delete().neq('key', '').then(function (r) {
      if (r.error) { msg.textContent = '실패: ' + r.error.message; return; }
      if (!rows.length) { msg.textContent = '명단을 비웠습니다.'; loadRoster(); return; }
      DB.client.from('union_roster').insert(rows).then(function (r2) {
        msg.textContent = r2.error ? '실패: ' + r2.error.message : rows.length + '명을 저장했습니다.';
        loadRoster();
      });
    });
  }
  function inRoster(p) {
    var e = rkey(p.email), n = rkey(p.name);
    return roster.some(function (x) { return (x.email && rkey(x.email) === e) || (x.name && n && rkey(x.name) === n); });
  }
  function approveByRoster() {
    var pend = members.filter(isPending);
    var msg = document.getElementById('rosterMsg');
    if (!pend.length) { msg.textContent = '승인 대기인 분이 없습니다.'; return; }
    if (!roster.length && !confirm('명단이 비어 있어 모두 준회원이 됩니다. 계속할까요?')) return;
    var yes = pend.filter(inRoster), no = pend.filter(function (p) { return !inRoster(p); });
    if (!confirm('대기 ' + pend.length + '명을 승인합니다.\n회원(명단에 있음) ' + yes.length + '명: ' + yes.map(function (p) { return p.name || p.email; }).join(', ') +
                 '\n준회원(명단에 없음) ' + no.length + '명: ' + no.map(function (p) { return p.name || p.email; }).join(', '))) return;
    var jobs = pend.map(function (p) {
      return DB.client.from('profiles').update({ role: inRoster(p) ? 'member' : 'associate', approved: true }).eq('id', p.id);
    });
    Promise.all(jobs).then(function (rs) {
      var bad = rs.filter(function (r) { return r.error; });
      msg.textContent = bad.length ? '일부 실패: ' + bad[0].error.message : '회원 ' + yes.length + '명 · 준회원 ' + no.length + '명 승인했습니다.';
      loadMembers();
    });
  }
  function isPending(p) { return !p.approved && p.role !== 'admin'; }
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
      if (f === 'approved' && gradeOf(p) !== 'member') return false;
      if (f === 'associate' && gradeOf(p) !== 'associate') return false;
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
      var grade = gradeOf(p);
      return '<tr data-id="' + p.id + '">' +
        '<td><input class="inline" data-f="name" value="' + esc(p.name || '') + '"></td>' +
        '<td style="text-align:left">' + esc(p.email) + (self ? ' <span class="note">(나)</span>' : '') + '</td>' +
        '<td><input class="inline" data-f="dept" value="' + esc(p.dept || '') + '"></td>' +
        '<td><select class="inline" data-f="position">' + '<option value="">-</option>' + POSITIONS.map(function (x) { return '<option' + (p.position === x ? ' selected' : '') + '>' + x + '</option>'; }).join('') + (p.position && POSITIONS.indexOf(p.position) < 0 ? '<option selected>' + esc(p.position) + '</option>' : '') + '</select></td>' +
        '<td>' + fmt(p.created_at) + '</td><td>' + statusBadge(p) + '</td>' +
        '<td>' + (self ? '<span class="note">본인</span> ' :
          '<select class="inline" data-f="grade" style="width:auto" title="관리구분: 관리자 / 회원 / 준회원 — 대기자는 골라서 「가입 승인」">' +
            '<option value="admin"' + (grade === 'admin' ? ' selected' : '') + '>관리자</option>' +
            '<option value="member"' + (grade === 'member' || grade === 'pending' ? ' selected' : '') + '>회원</option>' +
            '<option value="associate"' + (grade === 'associate' ? ' selected' : '') + '>준회원</option></select> ') +
        '<button class="btn sm" data-act="save">' + (grade === 'pending' && !self ? '가입 승인' : '저장') + '</button> ' +
        /* 고르개를 거치지 않고 한 번에 — 「내가 회원에서 관리자로 올릴 수 있게」 */
        (self ? '' : grade === 'member' ? '<button class="btn line sm" data-act="associate">준회원으로</button> <button class="btn line sm" data-act="admin">관리자로</button> <button class="btn line sm" data-act="revoke">승인 취소</button> '
              : grade === 'associate' ? '<button class="btn line sm" data-act="member">회원으로</button> <button class="btn line sm" data-act="admin">관리자로</button> <button class="btn line sm" data-act="revoke">승인 취소</button> '
              : grade === 'admin' ? '<button class="btn line sm" data-act="unadmin">관리자 해제</button> ' : '') +
        (self ? '' : '<button class="btn sm danger" data-act="delete">탈퇴</button>') +
        '</td></tr>';
    }).join('');
    tb.querySelectorAll('button').forEach(function (b) {
      b.onclick = function () {
        var tr = b.closest('tr'), id = tr.getAttribute('data-id'), act = b.getAttribute('data-act');
        var p = members.filter(function (x) { return x.id === id; })[0];
        var done = function (r) {
          if (r && r.error) alert('실패: ' + r.error.message);
          else if (r && r.data && !r.data.length) alert('바뀌지 않았습니다 — 이 계정에 고칠 권한이 없거나 세션이 끊겼습니다. 다시 로그인한 뒤 눌러 주세요.');
          loadMembers();
        };
        if (act === 'save') {
          var patch = { name: tr.querySelector('[data-f=name]').value.trim(), dept: tr.querySelector('[data-f=dept]').value.trim(), position: tr.querySelector('[data-f=position]').value || null };
          var gsel = tr.querySelector('[data-f=grade]'), g = gsel ? gsel.value : null, cur = gradeOf(p);
          if (g && g !== cur) {
            if (g === 'admin' && !confirm(p.email + ' 회원을 관리자로 지정할까요? (회원 관리·일정·게시판 관리 권한)')) return;
            patch.role = g === 'admin' ? 'admin' : g === 'associate' ? 'associate' : 'member'; patch.approved = true;
          }
          /* .select() 를 붙여 정말 몇 줄이 바뀌었는지 봅니다 — 접근 규칙(RLS)에 걸리면 오류 없이 0줄이라
             전에는 「저장됨」 이라 해 놓고 새로 고치면 옛 이름으로 돌아왔습니다 */
          return DB.client.from('profiles').update(patch).eq('id', id).select('id').then(function (r) {
            if (r.error) return alert('저장 실패: ' + r.error.message);
            if (!r.data || !r.data.length) return alert('저장되지 않았습니다 — 이 계정에 회원 정보를 고칠 권한이 없거나(관리자인지 확인), 세션이 끊겼습니다. 다시 로그인한 뒤 눌러 주세요.');
            if (g && g !== cur) return loadMembers();
            b.textContent = '저장됨'; setTimeout(function () { b.textContent = '저장'; }, 1200);
            p.name = patch.name; p.dept = patch.dept; p.position = patch.position;
            renderMembers();
          });
        }
        if (act === 'approve') return DB.client.from('profiles').update({ approved: true }).eq('id', id).select('id').then(done);
        if (act === 'revoke') { if (!confirm(p.email + ' 회원의 승인을 취소할까요?')) return; return DB.client.from('profiles').update({ approved: false }).eq('id', id).select('id').then(done); }
        if (act === 'admin') { if (!confirm(p.email + ' 회원을 관리자로 지정할까요?')) return; return DB.client.from('profiles').update({ role: 'admin', approved: true }).eq('id', id).select('id').then(done); }
        if (act === 'unadmin') { if (!confirm('관리자 권한을 해제할까요? (승인 조합원으로 남습니다)')) return; return DB.client.from('profiles').update({ role: 'member' }).eq('id', id).select('id').then(done); }
        if (act === 'member') return DB.client.from('profiles').update({ role: 'member', approved: true }).eq('id', id).select('id').then(done);
        if (act === 'associate') return DB.client.from('profiles').update({ role: 'associate', approved: true }).eq('id', id).select('id').then(done);
        if (act === 'delete') {
          if (!confirm(p.email + ' 회원을 탈퇴 처리할까요?\n홈페이지 회원 정보가 삭제되고 조합원 권한이 사라집니다.')) return;
          return DB.client.from('profiles').delete().eq('id', id).select('id').then(done);
        }
      };
    });
  }
  function exportCsv() {
    var rows = [['성명', '이메일', '소속', '직급', '상태', '가입일']].concat(filtered().map(function (p) {
      return [p.name || '', p.email || '', p.dept || '', p.position || '', GRADE_NAME[gradeOf(p)], fmt(p.created_at)];
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

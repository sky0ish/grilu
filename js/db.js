/* ============================================================
   Supabase 클라이언트 + 로그인 상태 공통 처리
   (supabase-js v2 UMD 가 먼저 로드되어야 합니다)
   ============================================================ */
(function () {
  var cfg = window.GRILU_CONFIG || {};
  var ready = !!(cfg.SUPABASE_URL && cfg.SUPABASE_ANON_KEY && window.supabase);
  var client = ready ? window.supabase.createClient(cfg.SUPABASE_URL, cfg.SUPABASE_ANON_KEY) : null;

  var DB = window.DB = {
    ready: ready,
    client: client,
    user: null,
    profile: null,
    root: (document.body.getAttribute('data-root') || ''),

    esc: function (s) {
      return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) {
        return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
      });
    },
    fmtDate: function (iso, withTime) {
      if (!iso) return '';
      var d = new Date(iso);
      var p = function (n) { return (n < 10 ? '0' : '') + n; };
      var s = d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate());
      return withTime ? s + ' ' + p(d.getHours()) + ':' + p(d.getMinutes()) : s;
    },
    qs: function (k) { return new URLSearchParams(location.search).get(k); },
    isAdmin: function () { return !!(DB.profile && DB.profile.role === 'admin'); },
    isMember: function () { return !!(DB.profile && (DB.profile.approved || DB.profile.role === 'admin')); },

    // 현재 로그인 사용자 + 프로필 로드
    loadUser: function () {
      if (!ready) return Promise.resolve(null);
      return client.auth.getUser().then(function (r) {
        DB.user = r.data && r.data.user ? r.data.user : null;
        if (!DB.user) { DB.profile = null; return null; }
        return client.from('profiles').select('*').eq('id', DB.user.id).maybeSingle().then(function (p) {
          DB.profile = p.data || null;
          return DB.user;
        });
      }).catch(function () { return null; });
    },

    // 상단 로그인/회원가입 영역 갱신
    renderUtil: function () {
      var util = document.querySelector('.topbar .util');
      if (!util) return;
      var root = DB.root;
      if (!ready) return; // 정적 모드: 그대로 둠
      if (DB.user) {
        var name = (DB.profile && DB.profile.name) || DB.user.email;
        var status = DB.isAdmin() ? ' <b style="color:var(--gri-orange)">관리자</b>' : (DB.isMember() ? '' : ' <span style="color:#c33">(승인 대기)</span>');
        util.innerHTML = '<span style="padding:0 10px;color:#333">' + DB.esc(name) + '님' + status + '</span>' +
          (DB.isAdmin() ? '<a href="' + root + 'admin/members.html?filter=pending" id="memberMgrLink">회원관리</a>' : '') +
          '<a href="' + root + 'member/mypage.html">내 정보</a>' +
          '<a href="#" id="logoutBtn">로그아웃</a>';
        if (DB.isAdmin()) {
          client.from('profiles').select('id', { count: 'exact', head: true }).eq('approved', false).neq('role', 'admin').then(function (r) {
            var a = document.getElementById('memberMgrLink');
            if (a && r.count) a.innerHTML = '회원관리 <b style="color:#c33">가입대기 ' + r.count + '명</b>';
          });
        }
        document.getElementById('logoutBtn').addEventListener('click', function (e) {
          e.preventDefault();
          client.auth.signOut().then(function () { location.href = root + 'index.html'; });
        });
      } else {
        util.innerHTML = '<a href="' + root + 'member/login.html">로그인</a><a href="' + root + 'member/join.html">회원가입</a>';
      }
    },

    // 로그인 필요 페이지 보호
    requireLogin: function (msg) {
      if (!ready) { alert('Supabase 설정(js/config.js)이 아직 비어 있습니다.'); return false; }
      if (!DB.user) {
        alert(msg || '로그인이 필요합니다.');
        location.href = DB.root + 'member/login.html?next=' + encodeURIComponent(location.pathname + location.search);
        return false;
      }
      return true;
    },

    // 일정 불러오기 (DB 우선, 없으면 events.js)
    loadEvents: function () {
      if (!ready) return Promise.resolve(window.GRILU_EVENTS || []);
      return client.from('events').select('*').order('date').then(function (r) {
        if (r.error || !r.data) return window.GRILU_EVENTS || [];
        return r.data.map(function (e) {
          return { id: e.id, date: e.date, end: e.end_date || undefined, title: e.title, type: e.type, desc: e.description || '' };
        });
      });
    },

    // 첨부파일 업로드
    upload: function (file, folder) {
      var path = (folder || 'misc') + '/' + Date.now() + '_' + Math.random().toString(36).slice(2, 8) + '_' + file.name.replace(/[^\w.\-가-힣]/g, '_');
      return client.storage.from('attachments').upload(path, file).then(function (r) {
        if (r.error) throw r.error;
        var url = client.storage.from('attachments').getPublicUrl(path).data.publicUrl;
        return { name: file.name, path: path, url: url, size: file.size };
      });
    }
  };

  // 초기화: 사용자 로드 후 이벤트 발행
  // 다른 스크립트(main/board/auth/admin)가 리스너를 등록한 뒤에 이벤트를 발생시킴
  function fire() { DB.renderUtil(); document.dispatchEvent(new CustomEvent('db:ready')); }
  DB.init = DB.loadUser().then(function () {
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', fire);
    else setTimeout(fire, 0);
    return DB;
  });
})();

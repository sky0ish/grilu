/* ============================================================
   로그인 / 회원가입 / 내 정보 (Supabase Auth)
   ============================================================ */
(function () {
  var DB = window.DB;
  if (!DB) return;

  function notReady() { alert('Supabase 설정(js/config.js)이 아직 비어 있어 회원 기능을 사용할 수 없습니다.'); return false; }

  document.addEventListener('db:ready', function () {
    var login = document.getElementById('loginForm');
    var join = document.getElementById('joinForm');
    var my = document.getElementById('myForm');
    var reset = document.getElementById('resetForm');

    if (login) login.onsubmit = function () {
      if (!DB.ready) return notReady();
      DB.client.auth.signInWithPassword({ email: login.email.value.trim(), password: login.password.value }).then(function (r) {
        if (r.error) return alert('로그인 실패: ' + (r.error.message === 'Invalid login credentials' ? '이메일 또는 비밀번호가 올바르지 않습니다.' : r.error.message));
        location.href = DB.qs('next') || (DB.root + 'index.html');
      });
      return false;
    };

    /* 가입은 경기연구원 메일로만 — 회원/관리자 구분과 승인은 관리자가 회원관리에서 고릅니다 */
    var COMPANY = /@(gri\.re\.kr|gri\.kr)$/i;
    if (join) join.onsubmit = function () {
      if (!DB.ready) return notReady();
      var email = join.email.value.trim().toLowerCase();
      if (!COMPANY.test(email)) { alert('경기연구원 메일(@gri.re.kr 또는 @gri.kr)로만 가입할 수 있습니다.'); return false; }
      if (join.password.value.length < 6) { alert('비밀번호는 6자 이상이어야 합니다.'); return false; }
      if (join.password.value !== join.password2.value) { alert('비밀번호가 서로 다릅니다.'); return false; }
      /* 단추를 두 번 누르면 Supabase 가 「For security purposes, you can only request this after N seconds」 로 막습니다 */
      var btn = join.querySelector('button[type=submit]');
      if (btn && btn.disabled) return false;
      if (btn) { btn.disabled = true; btn.textContent = '신청 중…'; }
      var restore = function () { if (btn) { btn.disabled = false; btn.textContent = '가입 신청'; } };
      var done = function (msg) { alert(msg); location.href = DB.root + 'index.html'; };
      DB.client.auth.signUp({
        email: email, password: join.password.value,
        options: { data: { name: join.name.value.trim(), dept: join.dept.value.trim(), position: join.position.value } }
      }).then(function (r) {
        if (r.error) {
          var m = r.error.message || '';
          var wait = /after (\d+) seconds/.exec(m);
          if (wait || /rate limit/i.test(m)) {
            /* 같은 메일로 방금 신청이 한 번 들어간 것 — 그 신청은 이미 관리자에게 가 있습니다 */
            return done('가입 신청은 이미 접수되어 있습니다' + (wait ? ' (같은 메일로 다시 보내는 것은 ' + wait[1] + '초 뒤에 가능)' : '') + '.\n관리자가 조합원 확인 후 승인하면 로그인하실 수 있습니다.');
          }
          if (/already registered|already exists|already been registered/i.test(m)) {
            return done('이미 가입 신청된 이메일입니다. 관리자가 승인하면 로그인하실 수 있고, 비밀번호를 잊으셨으면 「비밀번호 찾기」를 이용해 주세요.');
          }
          alert('가입 실패: ' + m); restore(); return;
        }
        /* 이미 있는 메일로 다시 신청하면 Supabase 는 오류 대신 identities 가 빈 사용자를 돌려줍니다 */
        if (r.data && r.data.user && r.data.user.identities && r.data.user.identities.length === 0) {
          return done('이미 가입 신청된 이메일입니다. 관리자가 승인하면 로그인하실 수 있습니다.');
        }
        done('가입 신청이 접수되었습니다.\n조합원 확인 후 관리자가 승인하면 로그인하여 조합원 게시판을 이용할 수 있습니다.');
      }, function (e) { alert('가입 실패: ' + (e && e.message || e)); restore(); });
      return false;
    };

    if (reset) reset.onsubmit = function () {
      if (!DB.ready) return notReady();
      DB.client.auth.resetPasswordForEmail(reset.email.value.trim(), { redirectTo: location.origin + DB.root + 'member/mypage.html' }).then(function (r) {
        alert(r.error ? '실패: ' + r.error.message : '비밀번호 재설정 메일을 보냈습니다.');
      });
      return false;
    };

    if (my) {
      if (!DB.requireLogin()) return;
      my.email.value = DB.user.email;
      if (DB.profile) { my.name.value = DB.profile.name || ''; my.dept.value = DB.profile.dept || ''; if (my.position) my.position.value = DB.profile.position || ''; }
      var st = document.getElementById('myStatus');
      if (st) st.textContent = DB.isAdmin() ? '관리자' : (DB.isMember() ? '승인된 조합원' : '승인 대기 중 (관리자 확인 후 조합원 게시판 이용 가능)');
      my.onsubmit = function () {
        var jobs = [DB.client.from('profiles').update({ name: my.name.value.trim(), dept: my.dept.value.trim(), position: my.position ? my.position.value : null }).eq('id', DB.user.id)];
        if (my.password.value) {
          if (my.password.value.length < 6) { alert('비밀번호는 6자 이상이어야 합니다.'); return false; }
          jobs.push(DB.client.auth.updateUser({ password: my.password.value }));
        }
        Promise.all(jobs).then(function (rs) {
          var err = rs.filter(function (r) { return r.error; })[0];
          alert(err ? '저장 실패: ' + err.error.message : '저장되었습니다.');
          if (!err) location.reload();
        });
        return false;
      };
    }
  });
})();

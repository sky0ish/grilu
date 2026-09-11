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

    if (join) join.onsubmit = function () {
      if (!DB.ready) return notReady();
      if (join.password.value.length < 6) { alert('비밀번호는 6자 이상이어야 합니다.'); return false; }
      if (join.password.value !== join.password2.value) { alert('비밀번호가 서로 다릅니다.'); return false; }
      DB.client.auth.signUp({
        email: join.email.value.trim(), password: join.password.value,
        options: { data: { name: join.name.value.trim(), dept: join.dept.value.trim() } }
      }).then(function (r) {
        if (r.error) return alert('가입 실패: ' + r.error.message);
        var needConfirm = r.data && r.data.user && !r.data.session;
        alert(needConfirm ? '가입 신청이 완료되었습니다. 이메일로 발송된 인증 링크를 확인해 주세요.\n조합원 확인 후 관리자가 승인하면 조합원 게시판을 이용할 수 있습니다.'
                          : '가입이 완료되었습니다. 조합원 확인 후 관리자가 승인하면 조합원 게시판을 이용할 수 있습니다.');
        location.href = DB.root + 'index.html';
      });
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
      if (DB.profile) { my.name.value = DB.profile.name || ''; my.dept.value = DB.profile.dept || ''; }
      var st = document.getElementById('myStatus');
      if (st) st.textContent = DB.isAdmin() ? '관리자' : (DB.isMember() ? '승인된 조합원' : '승인 대기 중 (관리자 확인 후 조합원 게시판 이용 가능)');
      my.onsubmit = function () {
        var jobs = [DB.client.from('profiles').update({ name: my.name.value.trim(), dept: my.dept.value.trim() }).eq('id', DB.user.id)];
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

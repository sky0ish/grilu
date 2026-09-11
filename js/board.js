/* ============================================================
   게시판 (목록 / 보기 / 쓰기 / 수정 / 삭제) + 메인 최신글 + 고충상담 접수
   페이지 요소:
   - 목록  : <table class="tbl" data-board="notice"> ... <tbody id="postList">
   - 보기  : <article id="postView">
   - 쓰기  : <form id="postForm" data-board="...">
   - 메인  : <ul class="list" data-latest="notice" data-limit="6">
   ============================================================ */
(function () {
  var DB = window.DB;
  if (!DB) return;
  var cfg = window.GRILU_CONFIG || {};
  var PAGE = cfg.PAGE_SIZE || 15;
  var esc = DB.esc, fmt = DB.fmtDate;

  function boardName(code) {
    var m = { notice: '공지사항', news: '노조소식', statement: '성명서·보도자료', regulation: '규정 및 지침', council: '노사협의회',
      newsletter: '노보(소식지)', documents: '문서자료', agreement: '단체협약', law: '노동관계법령', rules: '규약·규정',
      board: '조합원 게시판', photo: '사진자료', video: '동영상' };
    return m[code] || code;
  }
  function boardSection(code) {
    if (['notice', 'news', 'statement', 'regulation', 'council', 'newsletter'].indexOf(code) >= 0) return 'news';
    if (['documents', 'agreement', 'law', 'photo', 'video'].indexOf(code) >= 0) return 'archive';
    if (code === 'rules') return 'about';
    return 'community';
  }
  function listUrl(code) { return DB.root + boardSection(code) + '/' + code + '.html'; }
  function viewUrl(id) { return DB.root + 'board/view.html?id=' + id; }
  function writeUrl(code, id) { return DB.root + 'board/write.html?board=' + code + (id ? '&id=' + id : ''); }
  function isNew(iso) { return (Date.now() - new Date(iso).getTime()) < 3 * 86400000; }
  function attachHtml(list) {
    if (!list || !list.length) return '';
    return '<div class="attach"><b>첨부파일</b><ul>' + list.map(function (a) {
      return '<li><a href="' + esc(a.url) + '" target="_blank" rel="noopener">&#128206; ' + esc(a.name) + '</a> <span class="note">(' + Math.round((a.size || 0) / 1024) + ' KB)</span></li>';
    }).join('') + '</ul></div>';
  }

  // ---------- 목록 ----------
  function renderList() {
    var tbl = document.querySelector('.tbl[data-board]');
    if (!tbl) return;
    var code = tbl.getAttribute('data-board');
    var tbody = tbl.querySelector('tbody');
    var page = parseInt(DB.qs('page') || '1', 10);
    var q = DB.qs('q') || '';
    var from = (page - 1) * PAGE, to = from + PAGE - 1;

    var query = DB.client.from('posts').select('id,title,author_name,created_at,views,is_notice,attachments', { count: 'exact' })
      .eq('board', code).order('is_notice', { ascending: false }).order('created_at', { ascending: false }).range(from, to);
    if (q) query = query.ilike('title', '%' + q + '%');

    query.then(function (r) {
      if (r.error) {
        tbody.innerHTML = '<tr><td colspan="5" style="padding:40px;color:#c33">' + (r.error.code === 'PGRST301' || /permission|policy|row-level/i.test(r.error.message) ? '조합원 전용 게시판입니다. 로그인 후 이용해 주세요.' : '목록을 불러오지 못했습니다: ' + esc(r.error.message)) + '</td></tr>';
        return;
      }
      var total = r.count || 0;
      var cnt = document.querySelector('.board-top .total');
      if (cnt) cnt.textContent = total;
      if (!r.data.length) {
        tbody.innerHTML = '<tr><td colspan="5" style="padding:40px;color:#888">등록된 게시글이 없습니다.</td></tr>';
      } else {
        tbody.innerHTML = r.data.map(function (p, i) {
          var num = p.is_notice ? '<span class="badge" style="background:var(--primary);color:#fff;font-size:11px;padding:2px 6px;border-radius:3px">공지</span>' : (total - from - i);
          return '<tr' + (p.is_notice ? ' style="background:#f8f9fd"' : '') + '><td class="num">' + num + '</td>' +
            '<td class="tit"><a href="' + viewUrl(p.id) + '">' + esc(p.title) + '</a>' +
            (p.attachments && p.attachments.length ? ' <span title="첨부">&#128206;</span>' : '') +
            (isNew(p.created_at) ? ' <span class="badge new" style="font-size:11px;color:#fff;background:#e5533c;padding:1px 6px;border-radius:3px">N</span>' : '') +
            '</td><td class="writer">' + esc(p.author_name || '') + '</td><td class="date">' + fmt(p.created_at) + '</td><td class="hit">' + p.views + '</td></tr>';
        }).join('');
      }
      renderPaging(total, page, q);
      renderWriteBtn(code);
    });

    // 검색 폼
    var form = document.querySelector('.board-top form');
    if (form) {
      var inp = form.querySelector('input'); if (inp) inp.value = q;
      form.onsubmit = function () { location.href = listUrl(code) + '?q=' + encodeURIComponent(inp.value.trim()); return false; };
    }
  }
  function renderPaging(total, page, q) {
    var box = document.querySelector('.paging');
    if (!box) return;
    var pages = Math.max(1, Math.ceil(total / PAGE)), s = Math.max(1, page - 4), e = Math.min(pages, s + 9), html = '';
    var base = location.pathname + '?' + (q ? 'q=' + encodeURIComponent(q) + '&' : '') + 'page=';
    if (page > 1) html += '<a href="' + base + (page - 1) + '">&laquo;</a>';
    for (var i = s; i <= e; i++) html += '<a href="' + base + i + '"' + (i === page ? ' class="on"' : '') + '>' + i + '</a>';
    if (page < pages) html += '<a href="' + base + (page + 1) + '">&raquo;</a>';
    box.innerHTML = html;
  }
  function renderWriteBtn(code) {
    var btn = document.querySelector('.board-bottom .btn:not(.line)');
    if (!btn) return;
    DB.client.from('boards').select('admin_only_write,members_only').eq('code', code).maybeSingle().then(function (r) {
      var b = r.data || {};
      var can = DB.isAdmin() || (DB.isMember() && !b.admin_only_write);
      btn.style.display = can ? '' : 'none';
      btn.href = writeUrl(code);
    });
  }

  // ---------- 보기 ----------
  function renderView() {
    var box = document.getElementById('postView');
    if (!box) return;
    var id = DB.qs('id');
    if (!id) { box.innerHTML = '<p>잘못된 접근입니다.</p>'; return; }
    DB.client.from('posts').select('*').eq('id', id).maybeSingle().then(function (r) {
      if (r.error || !r.data) { box.innerHTML = '<p style="color:#c33">게시글을 불러올 수 없습니다. (삭제되었거나 열람 권한이 없습니다)</p>'; return; }
      var p = r.data;
      DB.client.rpc('increment_views', { post_id: p.id }).then(function () {});
      document.title = p.title + ' | ' + boardName(p.board) + ' | ' + (cfg.SITE_NAME || '');
      var t = document.querySelector('.page-title'); if (t) t.textContent = boardName(p.board);
      var mine = DB.user && DB.user.id === p.author_id;
      var content = /<[a-z][\s\S]*>/i.test(p.content || '') ? p.content : esc(p.content || '').replace(/\n/g, '<br>');
      box.innerHTML =
        '<div class="post-head"><h4 style="border:0;padding:0;margin:0 0 8px;color:#222;font-size:24px">' + esc(p.title) + '</h4>' +
        '<div class="post-meta note">' + esc(p.author_name || '') + ' &nbsp;|&nbsp; ' + fmt(p.created_at, true) + ' &nbsp;|&nbsp; 조회 ' + (p.views + 1) + '</div></div>' +
        '<div class="post-body">' + content + '</div>' + attachHtml(p.attachments) +
        '<div class="board-bottom" style="justify-content:space-between"><a href="' + listUrl(p.board) + '" class="btn line">목록</a>' +
        ((mine || DB.isAdmin()) ? '<span><a href="' + writeUrl(p.board, p.id) + '" class="btn">수정</a> <a href="#" id="delBtn" class="btn" style="background:#c33">삭제</a></span>' : '') + '</div>';
      var del = document.getElementById('delBtn');
      if (del) del.addEventListener('click', function (e) {
        e.preventDefault();
        if (!confirm('이 게시글을 삭제할까요?')) return;
        DB.client.from('posts').delete().eq('id', p.id).then(function (r2) {
          if (r2.error) return alert('삭제 실패: ' + r2.error.message);
          location.href = listUrl(p.board);
        });
      });
    });
  }

  // ---------- 쓰기 / 수정 ----------
  function renderWrite() {
    var form = document.getElementById('postForm');
    if (!form) return;
    if (!DB.requireLogin('글을 쓰려면 로그인이 필요합니다.')) return;
    var code = DB.qs('board') || 'board', id = DB.qs('id');
    var t = document.querySelector('.page-title'); if (t) t.textContent = boardName(code) + (id ? ' 수정' : ' 글쓰기');
    form.querySelector('[name=board]').value = code;
    var noticeRow = form.querySelector('.notice-row'); if (noticeRow) noticeRow.style.display = DB.isAdmin() ? '' : 'none';
    var existing = [];

    if (id) {
      DB.client.from('posts').select('*').eq('id', id).maybeSingle().then(function (r) {
        if (!r.data) return alert('게시글을 불러올 수 없습니다.');
        form.title.value = r.data.title; form.content.value = r.data.content || '';
        if (form.is_notice) form.is_notice.checked = r.data.is_notice;
        existing = r.data.attachments || [];
        renderExisting();
      });
    }
    function renderExisting() {
      var box = form.querySelector('.existing');
      if (!box) return;
      box.innerHTML = existing.map(function (a, i) { return '<span style="display:inline-block;margin:2px 8px 2px 0">&#128206; ' + esc(a.name) + ' <a href="#" data-i="' + i + '" style="color:#c33">[삭제]</a></span>'; }).join('');
      box.querySelectorAll('a').forEach(function (a) { a.onclick = function (e) { e.preventDefault(); existing.splice(+a.getAttribute('data-i'), 1); renderExisting(); }; });
    }

    form.onsubmit = function () {
      var btn = form.querySelector('button[type=submit]'); btn.disabled = true; btn.textContent = '저장 중...';
      var files = form.files ? Array.prototype.slice.call(form.files.files) : [];
      Promise.all(files.map(function (f) { return DB.upload(f, code); })).then(function (uploaded) {
        var row = {
          board: code, title: form.title.value.trim(), content: form.content.value,
          is_notice: form.is_notice ? form.is_notice.checked : false,
          attachments: existing.concat(uploaded), updated_at: new Date().toISOString()
        };
        if (!row.title) throw new Error('제목을 입력하세요.');
        if (id) return DB.client.from('posts').update(row).eq('id', id).select().single();
        row.author_id = DB.user.id;
        row.author_name = (DB.profile && DB.profile.name) || DB.user.email;
        return DB.client.from('posts').insert(row).select().single();
      }).then(function (r) {
        if (r.error) throw r.error;
        location.href = viewUrl(r.data.id);
      }).catch(function (e) {
        alert('저장 실패: ' + (e.message || e) + (/policy|permission|row-level/i.test(e.message || '') ? '\n(이 게시판에 글쓰기 권한이 없거나 조합원 승인이 아직 안 되었습니다)' : ''));
        btn.disabled = false; btn.textContent = '저장';
      });
      return false;
    };
  }

  // ---------- 메인 최신글 ----------
  function renderLatest() {
    var lists = document.querySelectorAll('[data-latest]');
    if (!lists.length) return;
    lists.forEach(function (ul) {
      var code = ul.getAttribute('data-latest'), limit = parseInt(ul.getAttribute('data-limit') || '6', 10);
      var badge = ul.getAttribute('data-badge'); // "규정|reg"
      DB.client.from('posts').select('id,title,created_at').eq('board', code).order('created_at', { ascending: false }).limit(limit).then(function (r) {
        if (r.error) return;
        if (!r.data.length) { ul.innerHTML = '<li><span style="color:#999">등록된 글이 없습니다.</span></li>'; return; }
        ul.innerHTML = r.data.map(function (p) {
          var b = badge ? '<span class="badge ' + badge.split('|')[1] + '">' + badge.split('|')[0] + '</span>' : (isNew(p.created_at) ? '<span class="badge new">N</span>' : '');
          var d = fmt(p.created_at); if (badge) d = d.slice(5);
          return '<li>' + b + '<a href="' + viewUrl(p.id) + '">' + esc(p.title) + '</a><span class="date">' + d + '</span></li>';
        }).join('');
      });
    });
    // 메인 사진자료
    var gal = document.querySelector('.gallery[data-gallery]');
    if (gal) {
      DB.client.from('posts').select('id,title,created_at,attachments').eq('board', 'photo').order('created_at', { ascending: false }).limit(parseInt(gal.getAttribute('data-limit') || '4', 10)).then(function (r) {
        if (r.error || !r.data.length) return;
        gal.innerHTML = r.data.map(function (p) {
          var img = (p.attachments || []).filter(function (a) { return /\.(jpe?g|png|gif|webp)$/i.test(a.name); })[0];
          return '<a href="' + viewUrl(p.id) + '"><div class="thumb">' + (img ? '<img src="' + esc(img.url) + '" alt="">' : '&#128247;') + '</div><div class="cap">' + esc(p.title) + '<span>' + fmt(p.created_at) + '</span></div></a>';
        }).join('');
      });
    }
  }

  // ---------- 사진/동영상 갤러리형 목록 ----------
  function renderGallery() {
    var gal = document.querySelector('.gallery[data-board]');
    if (!gal) return;
    var code = gal.getAttribute('data-board');
    DB.client.from('posts').select('id,title,created_at,attachments,content').eq('board', code).order('created_at', { ascending: false }).limit(30).then(function (r) {
      if (r.error) return;
      if (!r.data.length) { gal.innerHTML = '<p style="grid-column:1/-1;color:#888;padding:30px;text-align:center">등록된 자료가 없습니다.</p>'; return; }
      gal.innerHTML = r.data.map(function (p) {
        var img = (p.attachments || []).filter(function (a) { return /\.(jpe?g|png|gif|webp)$/i.test(a.name); })[0];
        var yt = code === 'video' && (p.content || '').match(/(?:youtu\.be\/|v=)([\w-]{11})/);
        var thumb = img ? '<img src="' + esc(img.url) + '" alt="">' : (yt ? '<img src="https://img.youtube.com/vi/' + yt[1] + '/hqdefault.jpg" alt="">' : (code === 'video' ? '&#9654;' : '&#128247;'));
        return '<a href="' + viewUrl(p.id) + '"><div class="thumb">' + thumb + '</div><div class="cap">' + esc(p.title) + '<span>' + fmt(p.created_at) + '</span></div></a>';
      }).join('');
      var btn = document.querySelector('.board-bottom .btn'); if (btn) { btn.href = writeUrl(code); btn.style.display = DB.isAdmin() ? '' : 'none'; }
    });
  }

  // ---------- 고충상담 접수 ----------
  function bindCounsel() {
    var form = document.getElementById('counselForm');
    if (!form) return;
    form.onsubmit = function () {
      var row = { name: form.name.value.trim(), contact: form.contact.value.trim(), category: form.category.value, title: form.title.value.trim(), content: form.content.value.trim() };
      if (!row.title || !row.content) { alert('제목과 내용을 입력해 주세요.'); return false; }
      DB.client.from('counsel').insert(row).then(function (r) {
        if (r.error) return alert('접수 실패: ' + r.error.message);
        alert('상담이 접수되었습니다. 담당자가 3일 이내 연락드리겠습니다.');
        form.reset();
      });
      return false;
    };
  }

  document.addEventListener('db:ready', function () {
    if (!DB.ready) return;   // 정적 모드
    renderList(); renderView(); renderWrite(); renderLatest(); renderGallery(); bindCounsel();
  });
})();

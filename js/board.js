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
      documents: '문서자료', agreement: '단체협약', law: '노동관계법령', rules: '규약·규정',
      board: '조합원 자유게시판', staff: '운영진 게시판', audit: '행정사무감사', photo: '사진자료', video: '동영상' };
    return m[code] || code;
  }
  function boardSection(code) {
    if (['notice', 'news', 'statement', 'newsletter'].indexOf(code) >= 0) return 'news';
    if (['documents', 'agreement', 'law', 'photo', 'video', 'council'].indexOf(code) >= 0) return 'archive';
    if (code === 'rules' || code === 'welfare' || code === 'join') return 'about';
    if (['audit', 'regulation'].indexOf(code) >= 0) return 'gri';
    return 'community';
  }
  function listUrl(code) { return DB.root + boardSection(code) + '/' + code + '.html'; }
  function viewUrl(id) { return DB.root + 'board/view.html?id=' + id; }
  function writeUrl(code, id) { return DB.root + 'board/write.html?board=' + code + (id ? '&id=' + id : ''); }
  function isNew(iso) { return (Date.now() - new Date(iso).getTime()) < 3 * 86400000; }
  function attachCount(a) { return a ? (a.length || (a.files && a.files.length) || 0) : 0; }
  function attachHtml(list) {
    if (list && !list.length && list.files && list.files.length) {
      // 그룹웨어 이관 글: 파일명만 보관 (원문은 그룹웨어)
      return '<div class="attach box"><b>첨부파일</b><ul class="bul">' + list.files.map(function (n) {
        return '<li>&#128206; ' + esc(n) + ' <span class="note">— 원문은 그룹웨어(gw.gri.re.kr)에서 내려받을 수 있습니다</span></li>';
      }).join('') + '</ul></div>';
    }
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
        if (r.error.code === 'PGRST301' || /permission|policy|row-level/i.test(r.error.message)) {
          tbody.innerHTML = '<tr><td colspan="5" style="padding:40px;color:#c33">조합원 전용 게시판입니다. 로그인 후 이용해 주세요.</td></tr>';
        } else {
          // DB 준비 전(테이블 없음 등)에는 예시 목록 유지
          console.warn('posts list error:', r.error.message);
        }
        return;
      }
      var total = r.count || 0;
      var cnt = document.querySelector('.board-top .total');
      if (cnt) cnt.textContent = total;
      if (!r.data.length && !q && page === 1) {
        DB.client.from('boards').select('members_only').eq('code', code).maybeSingle().then(function (b) {
          if (b.data && b.data.members_only && !DB.isMember()) {
            tbody.innerHTML = '<tr><td colspan="5" style="padding:40px;color:#c33">조합원 전용 게시판입니다. 로그인(조합원 승인) 후 이용해 주세요.</td></tr>';
            if (cnt) cnt.textContent = '-';
            var pg = document.querySelector('.paging'); if (pg) pg.innerHTML = '';
            var n2 = document.querySelector('.static-note'); if (n2) n2.remove();
            return;
          }
          // 아직 등록된 글이 없으면 예시 목록(정적 HTML)을 그대로 둔다
          var note = document.querySelector('.static-note'); if (note) note.textContent = '※ 아직 등록된 게시글이 없어 예시 목록이 표시됩니다. 관리자 로그인 후 글쓰기로 등록하세요.';
          if (cnt) cnt.textContent = tbody.querySelectorAll('tr').length;
          renderWriteBtn(code);
        });
        return;
      }
      if (!r.data.length) {
        tbody.innerHTML = '<tr><td colspan="5" style="padding:40px;color:#888">등록된 게시글이 없습니다.</td></tr>';
      } else {
        tbody.innerHTML = r.data.map(function (p, i) {
          var num = p.is_notice ? '<span class="badge" style="background:var(--primary);color:#fff;font-size:11px;padding:2px 6px;border-radius:3px">공지</span>' : (total - from - i);
          return '<tr' + (p.is_notice ? ' style="background:#f8f9fd"' : '') + '><td class="num">' + num + '</td>' +
            '<td class="tit"><a href="' + viewUrl(p.id) + '">' + esc(p.title) + '</a>' +
            (attachCount(p.attachments) ? ' <span title="첨부">&#128206;</span>' : '') +
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
      loadFullText(p);
      if (!(p.attachments && p.attachments.legacy_id && p.attachments.legacy_id.indexOf('audit-') === 0)) { var pb = box.querySelector('.post-body'); if (pb) renderKeywords(pb, pb); }
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


  // 이관 자료(행정사무감사 등)는 본문 전문이 사이트 정적 페이지에 있으므로 불러와 합친다
  function loadFullText(p) {
    var a = p.attachments || {};
    var legacy = a.legacy_id || '';
    if (legacy.indexOf('audit-') !== 0) return;
    var url = DB.root + 'gri/audit/' + legacy.slice(6) + '.html';
    var body = document.querySelector('#postView .post-body');
    if (!body) return;
    var note = document.createElement('p'); note.className = 'note'; note.textContent = '회의록 전문을 불러오는 중...'; body.appendChild(note);
    fetch(url).then(function (r) { if (!r.ok) throw new Error(r.status); return r.text(); }).then(function (html) {
      var doc = new DOMParser().parseFromString(html, 'text/html');
      var full = doc.querySelector('.post-body.minutes');
      if (!full) throw new Error('no body');
      var head = body.querySelector('.box');
      body.innerHTML = '';
      if (head) body.appendChild(head);
      var wrap = document.createElement('div'); wrap.className = 'minutes'; wrap.style.cssText = 'line-height:1.85;font-size:15px';
      wrap.innerHTML = full.innerHTML;
      body.appendChild(wrap);
      renderKeywords(body, wrap);
    }).catch(function () { note.textContent = '전문을 불러오지 못했습니다. 위 링크에서 확인하세요.'; });
  }


  // ---------- 키워드 통계 (본문에서 많이 나온 낱말) ----------
  var KW_STOP = ('그리고 그런데 그래서 그러면 그러니까 그렇게 이렇게 그렇고 저희 우리 위원 위원장 위원님 의원 의원님 여러분 지금 이제 정도 부분 경우 사항 내용 관련 대해 대해서 대한 통해 통해서 위해 위해서 위한 때문 말씀 질의 답변 감사 ' +
    '그것 이것 저것 여기 거기 어디 무엇 이거 그거 저거 하나 아니 아니라 그냥 같은 같이 있는 없는 하는 되는 해서 하고 해야 그런 이런 저런 어떤 모든 다른 여러 계속 다시 먼저 다음 이상 이하 현재 오늘 어제 내년 올해 작년 지난 ' +
    '물론 사실 실제 실제로 결국 특히 바로 아직 이미 항상 많이 조금 굉장히 상당히 매우 정말 진짜 제가 저는 저도 제일 전체 자체 시간 문제 방법 생각 얘기 이야기 소관 발언 개의 산회 정회 속개 회의 회의록 의석 정돈 의사 일정 진행 ' +
    '원장 원장님 실장 실장님 국장 국장님 과장 과장님 담당 담당관 답변자 관계 공무원 직원 기관 사무처 행정사무감사 행정사무 경기도의회 의회 도의회 기획재정위원회 기획위원회 기획조정실 경기도 경기연구원 경기개발연구원 연구원 피감사기관 피감기관 ' +
    '수고 부탁 질문 확인 정리 설명 검토 보고 자료 부분 관련해서 그래도 그러나 하지만 그러면서 이러한 그러한 어떻게 어떤 얼마나 무슨 이번 저번 한번 두번 사실상 대부분 일부 각각 모두 전부 거의 정도로 하나도 그다음 마지막 처음 ' +
    '있지 거는 혹시 가지 년도 기조실장 기조실장님 이게 그게 저게 이건 그건 저건 있고 없고 것들 부분들 주시기 주세요 가지고 걸로 근데 되어 관련된 경기 하면 하니까 있어서 있어 없어 뭐가 되게 하게 있게 그리 이렇게 저렇게 그러고 그럼 이제는 그때 이때 저기 여기서 거기서 하나씩 하는데 되는데 있는데 없는데 그거는 이거는 우리가 저희가 제가요 그러니 그러다 한테 대한 대비 ' +
    '알겠습니다 감사합니다 됩니다 합니다 입니다 있습니다 없습니다 했습니다 됐습니다 겠습니다 습니다 그렇습니다 맞습니다 아닙니다 드립니다 바랍니다 하겠습니다 되겠습니다').split(' ');
  var KW_SUFFIX = ['에서는', '으로는', '에게는', '으로써', '으로서', '이라고', '에서', '에게', '한테', '께서', '부터', '까지', '으로', '라고', '이며', '이고', '에는', '에도', '과는', '와는', '이나', '이란', '만큼', '보다', '처럼', '은', '는', '이', '가', '을', '를', '의', '에', '로', '과', '와', '도', '만', '들', '께', '요'];
  function kwNormalize(w) {
    for (var i = 0; i < KW_SUFFIX.length; i++) {
      var sf = KW_SUFFIX[i];
      if (w.length - sf.length >= 2 && w.slice(-sf.length) === sf) { w = w.slice(0, -sf.length); break; }
    }
    if (w.length > 2 && w.slice(-1) === '님') w = w.slice(0, -1);
    {
    }
    return w;
  }
  function kwStats(box, text, limit) {
    var stop = {}; KW_STOP.forEach(function (w) { stop[w] = 1; });
    // 발언자 표기(<b>○ 위원장 홍길동</b>)의 이름은 제외
    box.querySelectorAll('b').forEach(function (b) { (b.textContent.match(/[가-힣]{2,20}/g) || []).forEach(function (n) { stop[n] = 1; }); });
    var cnt = {};
    (text.match(/[가-힣]{2,}|[A-Za-z][A-Za-z0-9]{2,}/g) || []).forEach(function (w) {
      w = kwNormalize(w);
      if (w.length < 2 || stop[w] || /(다|요|까|죠|네|는데|니까|지만|으며|하면|해서|되어|하고|되고|있고|없고|하는|되는|있는|없는|면서|해도|해야|하지|되지|이죠|거든|이든)$/.test(w) || /^[0-9]/.test(w)) return;
      cnt[w] = (cnt[w] || 0) + 1;
    });
    return Object.keys(cnt).map(function (k) { return [k, cnt[k]]; }).filter(function (x) { return x[1] >= 2; })
      .map(function (x) { return [x[0], text.split(x[0]).length - 1]; })   // 본문 실제 등장 횟수
      .sort(function (a, b) { return b[1] - a[1] || a[0].localeCompare(b[0]); }).slice(0, limit || 20);
  }
  function renderKeywords(body, textWrap) {
    var text = textWrap.textContent;
    if (text.length < 1500) return;
    var top = kwStats(textWrap, text, 20);
    if (!top.length) return;
    var old = document.querySelector('.kw-stats'); if (old) old.remove();
    var bar = document.createElement('div'); bar.className = 'kw-stats';
    bar.innerHTML = '<div class="kw-title">&#128202; 많이 나온 키워드 <span class="note">(누르면 본문에서 해당 위치로 이동)</span></div>' +
      top.map(function (x) { return '<a href="#" class="kw" data-kw="' + esc(x[0]) + '">' + esc(x[0]) + ' <b>' + x[1] + '</b></a>'; }).join('');
    body.parentNode.insertBefore(bar, body);
    var orig = textWrap.innerHTML, cur = { kw: '', i: -1 };
    bar.addEventListener('click', function (e) {
      var a = e.target.closest('a.kw'); if (!a) return;
      e.preventDefault();
      var kw = a.getAttribute('data-kw');
      if (cur.kw !== kw) {
        textWrap.innerHTML = orig; highlight(textWrap, kw); cur.kw = kw; cur.i = -1;
        bar.querySelectorAll('a.kw').forEach(function (x) { x.classList.toggle('on', x === a); });
      }
      var marks = textWrap.querySelectorAll('mark.kw-hit');
      if (!marks.length) return;
      cur.i = (cur.i + 1) % marks.length;
      marks.forEach(function (m, k) { m.classList.toggle('cur', k === cur.i); });
      var top = marks[cur.i].getBoundingClientRect().top + window.pageYOffset - 140;
      window.scrollTo({ top: top, behavior: 'smooth' });
      var c = a.querySelector('.pos') || a.appendChild(Object.assign(document.createElement('span'), { className: 'pos' }));
      c.textContent = ' ' + (cur.i + 1) + '/' + marks.length;
    });
  }
  function highlight(root, kw) {
    var walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null, false), nodes = [], n;
    while ((n = walker.nextNode())) if (n.nodeValue.indexOf(kw) >= 0) nodes.push(n);
    nodes.forEach(function (t) {
      var parts = t.nodeValue.split(kw), frag = document.createDocumentFragment();
      parts.forEach(function (ptxt, i) {
        if (i) { var m = document.createElement('mark'); m.className = 'kw-hit'; m.textContent = kw; frag.appendChild(m); }
        if (ptxt) frag.appendChild(document.createTextNode(ptxt));
      });
      t.parentNode.replaceChild(frag, t);
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
        existing = Array.isArray(r.data.attachments) ? r.data.attachments : [];
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
        if (!r.data.length) return; // 글이 없으면 예시 목록 유지
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
      if (!r.data.length) return; // 자료가 없으면 예시 유지
      gal.innerHTML = r.data.map(function (p) {
        var img = (p.attachments || []).filter(function (a) { return /\.(jpe?g|png|gif|webp)$/i.test(a.name); })[0];
        var yt = code === 'video' && (p.content || '').match(/(?:youtu\.be\/|v=)([\w-]{11})/);
        var thumb = img ? '<img src="' + esc(img.url) + '" alt="">' : (yt ? '<img src="https://img.youtube.com/vi/' + yt[1] + '/hqdefault.jpg" alt="">' : (code === 'video' ? '&#9654;' : '&#128247;'));
        return '<a href="' + viewUrl(p.id) + '"><div class="thumb">' + thumb + '</div><div class="cap">' + esc(p.title) + '<span>' + fmt(p.created_at) + '</span></div></a>';
      }).join('');
      var btn = document.querySelector('.board-bottom .btn'); if (btn) { btn.href = writeUrl(code); btn.style.display = DB.isAdmin() ? '' : 'none'; }
    });
  }


  // ---------- 통합 검색 ----------
  function renderSearch() {
    var tbl = document.getElementById('searchTable');
    if (!tbl) return;
    var tbody = tbl.querySelector('tbody');
    var q = (DB.qs('q') || '').trim();
    var kw = document.querySelector('.board-top .kw'); if (kw) kw.textContent = q ? '"' + q + '"' : '';
    var inp = document.querySelector('.board-top form input'); if (inp) inp.value = q;
    document.title = (q ? q + ' - ' : '') + '자료검색 | ' + (cfg.SITE_NAME || '');
    if (!q) { tbody.innerHTML = '<tr><td colspan="4" style="padding:40px;color:#888">검색어를 입력해 주세요.</td></tr>'; return; }
    var like = '%' + q.replace(/[%_]/g, '') + '%';
    DB.client.from('posts').select('id,board,title,author_name,created_at,attachments')
      .or('title.ilike.' + like + ',content.ilike.' + like)
      .order('created_at', { ascending: false }).limit(200)
      .then(function (r) {
        if (r.error) { tbody.innerHTML = '<tr><td colspan="4" style="padding:40px;color:#c33">검색에 실패했습니다: ' + esc(r.error.message) + '</td></tr>'; return; }
        var cnt = document.querySelector('.board-top .total'); if (cnt) cnt.textContent = r.data.length;
        if (!r.data.length) { tbody.innerHTML = '<tr><td colspan="4" style="padding:40px;color:#888">"' + esc(q) + '" 에 해당하는 자료가 없습니다.</td></tr>'; return; }
        var BS = String.fromCharCode(92);
        var safe = q.split('').map(function (c) { return /[A-Za-z0-9가-힣 ]/.test(c) ? c : BS + c; }).join('');
        var re = new RegExp('(' + safe + ')', 'ig');
        tbody.innerHTML = r.data.map(function (p) {
          var title = esc(p.title).replace(re, '<mark style="background:#fff2a8;padding:0 2px">$1</mark>');
          return '<tr><td class="num"><a href="' + listUrl(p.board) + '" style="color:var(--primary);font-weight:600">' + esc(boardName(p.board)) + '</a></td>' +
            '<td class="tit"><a href="' + viewUrl(p.id) + '">' + title + '</a>' + (attachCount(p.attachments) ? ' <span title="첨부">&#128206;</span>' : '') + '</td>' +
            '<td class="writer">' + esc(p.author_name || '') + '</td><td class="date">' + fmt(p.created_at) + '</td></tr>';
        }).join('');
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

  // 예시 게시글 보기 (Supabase 연결 전 / 예시 목록의 글)
  function renderDemo() {
    var box = document.getElementById('postView');
    if (!box || DB.qs('demo') !== '1') return false;
    var t = DB.qs('t') || '예시 게시글', d = DB.qs('d') || '', w = DB.qs('w') || '노동조합', b = DB.qs('b') || '';
    var name = b ? boardName(b) : '게시글';
    document.title = t + ' | ' + name + ' | ' + (cfg.SITE_NAME || '');
    var pt = document.querySelector('.page-title'); if (pt) pt.textContent = name;
    var bodies = {
      notice: ['조합원 여러분께 안내드립니다.', '자세한 내용은 노동조합 사무실(내선 3114) 또는 소통상담을 통해 문의해 주시기 바랍니다.', '조합원 여러분의 많은 관심과 참여를 부탁드립니다.'],
      news: ['경기연구원 노동조합의 활동 소식을 전해드립니다.', '노동조합은 조합원의 권익 향상과 건강한 노사관계를 위해 계속 노력하겠습니다.'],
      statement: ['경기연구원 노동조합은 다음과 같이 입장을 밝힙니다.', '노동조합은 연구원 구성원의 노동권과 연구 자율성을 지키기 위해 모든 노력을 다할 것입니다.', '2026년 ○월 ○일 경기연구원 노동조합'],
      regulation: ['경기연구원 규정 및 지침 원문입니다.', '개정 사항은 시행일 이후 적용되며, 원문 파일은 첨부파일에서 내려받을 수 있습니다.'],
      rules: ['노동조합 규약·규정 원문입니다. 원문 파일은 첨부파일에서 내려받을 수 있습니다.'],
      agreement: ['노사가 체결한 협약 원문입니다. 원문 파일은 첨부파일에서 내려받을 수 있습니다.'],
      law: ['노동관계법령 안내입니다. 원문은 국가법령정보센터(law.go.kr)에서 확인할 수 있습니다.']
    };
    var paras = bodies[b] || ['게시글 본문입니다.'];
    box.innerHTML = '<div class="post-head" style="border-bottom:1px solid var(--line);padding-bottom:14px;margin-bottom:20px"><h4 style="border:0;padding:0;margin:0 0 8px;color:#222;font-size:24px">' + esc(t) + '</h4>' +
      '<div class="note">작성자 ' + esc(w) + ' &nbsp;|&nbsp; 게시일 ' + esc(d) + '</div></div>' +
      '<div class="post-body" style="min-height:160px;line-height:1.9">' + paras.map(function (x) { return '<p>' + esc(x) + '</p>'; }).join('') +
      '<p class="note" style="margin-top:24px;padding:12px;background:#f6f7fa;border-radius:6px">※ 이 글은 홈페이지 구성 확인용 <b>예시 게시글</b>입니다. 관리자가 로그인 후 각 게시판의 글쓰기 버튼으로 실제 게시글을 등록하면 이 자리에 본문과 첨부파일이 표시됩니다.</p></div>' +
      '<div class="board-bottom" style="justify-content:space-between"><a href="' + (b ? listUrl(b) : 'javascript:history.back()') + '" class="btn line">목록</a></div>';
    return true;
  }
  // 예시 글은 DB 연결과 무관하게 즉시 표시
  var demoShown = renderDemo();

  var staticMinutes = document.querySelector('.post-body.minutes');
  if (staticMinutes) renderKeywords(staticMinutes, staticMinutes);

  document.addEventListener('db:ready', function () {
    if (demoShown) return;
    if (!DB.ready) return;   // 정적 모드
    renderList(); renderView(); renderWrite(); renderLatest(); renderGallery(); renderSearch(); bindCounsel();
  });
})();

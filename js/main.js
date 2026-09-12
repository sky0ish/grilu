/* ============================================================
   grilu.kr 공통 스크립트 (메뉴, 슬라이드, 탭, 달력)
   ============================================================ */
(function () {
  // ---------- 모바일 메뉴 ----------
  var toggle = document.querySelector('.menu-toggle');
  var gnb = document.querySelector('.gnb');
  if (toggle && gnb) toggle.addEventListener('click', function () { gnb.classList.toggle('open'); });

  // ---------- 히어로 슬라이드 ----------
  var slides = document.querySelectorAll('.hero .slide');
  var dots = document.querySelector('.hero .dots');
  if (slides.length > 1 && dots) {
    var idx = 0, timer;
    slides.forEach(function (_, i) {
      var b = document.createElement('button');
      b.setAttribute('aria-label', (i + 1) + '번 슬라이드');
      b.addEventListener('click', function () { go(i); restart(); });
      dots.appendChild(b);
    });
    var go = function (i) {
      slides[idx].classList.remove('on'); dots.children[idx].classList.remove('on');
      idx = (i + slides.length) % slides.length;
      slides[idx].classList.add('on'); dots.children[idx].classList.add('on');
    };
    var restart = function () { clearInterval(timer); timer = setInterval(function () { go(idx + 1); }, 6000); };
    go(0); restart();
  }

  // ---------- 탭 ----------
  document.querySelectorAll('[data-tabs]').forEach(function (box) {
    var btns = box.querySelectorAll('.tabs button');
    var panels = box.querySelectorAll('.tab-panel');
    btns.forEach(function (b, i) {
      b.addEventListener('click', function () {
        btns.forEach(function (x) { x.classList.remove('on'); });
        panels.forEach(function (x) { x.classList.remove('on'); });
        b.classList.add('on'); panels[i].classList.add('on');
      });
    });
  });

  // ---------- 맨 위로 ----------
  var top = document.querySelector('.totop');
  if (top) {
    window.addEventListener('scroll', function () { top.classList.toggle('show', window.scrollY > 400); });
    top.addEventListener('click', function () { window.scrollTo({ top: 0, behavior: 'smooth' }); });
  }

  // ---------- 달력 ----------
  var calBox = document.querySelector('.calendar');
  if (calBox) {
    var events = window.GRILU_EVENTS || [];
    var today = new Date();
    // Supabase 연결 시 DB 일정으로 교체
    document.addEventListener('db:ready', function () {
      if (window.DB && window.DB.ready) window.DB.loadEvents().then(function (list) { events = list; render(); });
    });
    var cur = new Date(today.getFullYear(), today.getMonth(), 1);
    var titleEl = calBox.querySelector('.cal-title');
    var tbody = calBox.querySelector('tbody');
    var upList = document.querySelector('.upcoming ul');
    var upTitle = document.querySelector('.upcoming .up-title');
    var typeName = { union: '노조', council: '노사협의회', event: '행사', holiday: '휴일' };
    var dow = ['일', '월', '화', '수', '목', '금', '토'];

    function pad(n) { return (n < 10 ? '0' : '') + n; }
    function ymd(d) { return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }
    function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); }
    function eventsOn(ds) {
      return events.filter(function (e) { return e.date <= ds && ds <= (e.end || e.date); });
    }
    function render() {
      var y = cur.getFullYear(), m = cur.getMonth();
      titleEl.textContent = y + '년 ' + (m + 1) + '월';
      var first = new Date(y, m, 1);
      var d = new Date(y, m, 1 - first.getDay());
      var todayStr = ymd(today), html = '';
      for (var w = 0; w < 6; w++) {
        html += '<tr>';
        for (var i = 0; i < 7; i++) {
          var ds = ymd(d), cls = [];
          if (d.getMonth() !== m) cls.push('other');
          if (ds === todayStr) cls.push('today');
          html += '<td class="' + cls.join(' ') + '"><span class="d">' + d.getDate() + '</span>';
          eventsOn(ds).forEach(function (e) {
            html += '<span class="ev ' + e.type + '" title="' + esc(e.desc || e.title) + '">' + esc(e.title) + '</span>';
          });
          html += '</td>';
          d.setDate(d.getDate() + 1);
        }
        html += '</tr>';
        if (d.getMonth() !== m) break;
      }
      tbody.innerHTML = html;
      renderUpcoming(y, m);
    }
    function renderUpcoming(y, m) {
      if (!upList) return;
      if (upTitle) upTitle.textContent = (m + 1) + '월 일정';
      var prefix = y + '-' + pad(m + 1);
      var list = events.filter(function (e) { return e.date.indexOf(prefix) === 0; })
        .sort(function (a, b) { return a.date < b.date ? -1 : 1; });
      if (!list.length) { upList.innerHTML = '<li><span class="empty">등록된 일정이 없습니다.</span></li>'; return; }
      upList.innerHTML = list.map(function (e) {
        var dt = new Date(e.date + 'T00:00:00');
        return '<li><div class="date-box"><b>' + dt.getDate() + '</b><span>' + (m + 1) + '월 (' + dow[dt.getDay()] + ')</span></div>' +
          '<div><div class="tit">' + esc(e.title) + ' <small>· ' + typeName[e.type] + '</small></div>' +
          (e.desc ? '<div class="desc">' + esc(e.desc) + '</div>' : '') + '</div></li>';
      }).join('');
    }
    calBox.querySelector('.prev').addEventListener('click', function () { cur.setMonth(cur.getMonth() - 1); render(); });
    calBox.querySelector('.next').addEventListener('click', function () { cur.setMonth(cur.getMonth() + 1); render(); });
    calBox.querySelector('.today-btn').addEventListener('click', function () { cur = new Date(today.getFullYear(), today.getMonth(), 1); render(); });
    render();
  }
})();

/* ---------- 표 열 너비 조절: 머리글 오른쪽 가장자리를 끌어서 조절, 두 번 누르면 초기화. 페이지별로 브라우저에 기억 ---------- */
(function () {
  var tables = document.querySelectorAll('table.doc-table');
  if (!tables.length) return;
  tables.forEach(function (tbl, ti) {
    var ths = tbl.querySelectorAll('thead th'); if (!ths.length) return;
    var key = 'grilu-colw:' + location.pathname + ':' + ti;
    var saved = null; try { saved = JSON.parse(localStorage.getItem(key) || 'null'); } catch (e) {}
    if (saved && saved.length === ths.length) { tbl.style.tableLayout = 'fixed'; ths.forEach(function (th, i) { if (saved[i]) th.style.width = saved[i] + 'px'; }); }
    ths.forEach(function (th, i) {
      th.style.position = 'relative';
      var h = document.createElement('span'); h.className = 'col-resize'; h.title = '끌어서 열 너비 조절 · 두 번 누르면 초기화';
      th.appendChild(h);
      h.addEventListener('dblclick', function () { try { localStorage.removeItem(key); } catch (e) {} ths.forEach(function (t) { t.style.width = ''; }); tbl.style.tableLayout = ''; });
      h.addEventListener('mousedown', function (e) {
        e.preventDefault(); var x0 = e.clientX, w0 = th.getBoundingClientRect().width;
        if (tbl.style.tableLayout !== 'fixed') { ths.forEach(function (t) { t.style.width = t.getBoundingClientRect().width + 'px'; }); tbl.style.tableLayout = 'fixed'; }
        document.body.style.cursor = 'col-resize'; document.body.style.userSelect = 'none';
        function mv(ev) { th.style.width = Math.max(60, w0 + ev.clientX - x0) + 'px'; }
        function up() { document.removeEventListener('mousemove', mv); document.removeEventListener('mouseup', up); document.body.style.cursor = ''; document.body.style.userSelect = '';
          try { localStorage.setItem(key, JSON.stringify(Array.prototype.map.call(ths, function (t) { return Math.round(t.getBoundingClientRect().width); }))); } catch (e) {} }
        document.addEventListener('mousemove', mv); document.addEventListener('mouseup', up);
      });
    });
  });
})();

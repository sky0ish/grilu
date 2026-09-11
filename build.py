# -*- coding: utf-8 -*-
"""
grilu.kr 정적 사이트 빌드 스크립트
- 실행:  python build.py
- 공통 헤더/푸터/메뉴를 한 곳(이 파일)에서 관리하고 index.html 과 모든 서브 페이지를 생성합니다.
- 메뉴를 바꾸려면 MENUS 를, 각 페이지 본문을 바꾸려면 PAGES 의 함수를 수정하세요.
"""
import os, html, re

SITE = "경기연구원 노동조합"
SITE_EN = "Gyeonggi Research Institute Labor Union"
DOMAIN = "grilu.kr"
import time
VER = time.strftime("%Y%m%d%H%M")   # CSS/JS 캐시 갱신용
GW_REG_URL = "https://gw.gri.re.kr/servlet/HIServlet?SLET=bbs.BBS.java&boardID=0000002t9"

# ------------------------------------------------------------------ 메뉴
MENUS = [
    ("about", "조합소개", "함께 만드는 건강한 연구원", [
        ("greeting", "인사말"), ("officers", "집행부 소개"), ("history", "연혁"),
        ("declaration", "선언·강령"), ("members", "조합원 현황"),
        ("welfare", "조합원 복지"), ("join", "조합가입 안내"), ("location", "오시는 길"),
    ]),
    ("news", "소식마당", "노동조합의 소식과 알림을 전합니다", [
        ("notice", "공지사항"), ("news", "노조소식"), ("statement", "성명서·보도자료"), ("othernews", "기타 노조 소식"),
    ]),
    ("archive", "자료마당", "노동조합 활동 자료를 모았습니다", [
        ("council", "노사협의회"), ("agreement", "단체협약"), ("rules", "규약·규정"), ("law", "노동관계법령"),
        ("delegate", "대의원 회의자료"), ("documents", "기타참고자료"),
    ]),
    ("community", "소통마당", "조합원과 함께 소통합니다", [
        ("staff", "운영진 게시판"), ("board", "조합원 자유게시판"), ("counsel", "소통상담"), ("wish", "노조에 바란다"),
    ]),
    ("gri", "GRI", "경기연구원 관련 공개 자료", [
        ("audit", "행정사무감사"), ("regulations", "제규정"), ("regulation", "규정 및 지침"), ("calendar", "일정 달력"),
    ]),
]

def href(root, sec, page):
    return f"{root}{sec}/{page}.html"

# ------------------------------------------------------------------ 공통 조각
def head(root, title):
    full = f"{title} | {SITE}" if title else f"{SITE} - {DOMAIN}"
    return f"""<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(full)}</title>
<meta name="description" content="{SITE} 공식 홈페이지. 공지사항, 규정 및 지침, 노사협의회, 일정, 조합원 소통 공간.">
<link rel="icon" href="{root}images/favicon.svg" type="image/svg+xml">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="{root}css/style.css?v={VER}">
</head>
<body data-root="{root}">
"""

def header(root, cur_sec=None):
    items = []
    for sec, name, _, subs in MENUS:
        on = ' class="on"' if sec == cur_sec else ""
        sub = "".join(f'<li><a href="{href(root, sec, p)}">{n}</a></li>' for p, n in subs)
        items.append(f'<li{on}><a href="{href(root, sec, subs[0][0])}">{name}</a><ul class="sub">{sub}</ul></li>')
    return f"""
<div class="topbar">
  <div class="wrap">
    <div class="family">
      <a href="https://www.gri.re.kr" target="_blank" rel="noopener">경기연구원</a>
      <a href="https://gw.gri.re.kr" target="_blank" rel="noopener">그룹웨어</a>
    </div>
    <div class="util">
      <a href="{root}member/login.html">로그인</a>
      <a href="{root}member/join.html">회원가입</a>
    </div>
  </div>
</div>
<header class="header">
  <div class="wrap">
    <h1 class="logo">
      <a href="{root}index.html" style="display:flex;align-items:center;gap:14px">
        <img src="{root}images/gri_logo.png" alt="경기연구원">
        <span class="divider"></span>
        <span class="name"><strong>노동조합</strong><span>{SITE_EN}</span></span>
      </a>
    </h1>
    <form class="search" action="{root}board/search.html" method="get">
      <input type="search" name="q" placeholder="검색어를 입력하세요" aria-label="검색어">
      <button type="submit" aria-label="검색">&#128269;</button>
    </form>
    <button class="menu-toggle" aria-label="메뉴 열기">&#9776;</button>
  </div>
</header>
<nav class="gnb"><div class="wrap"><ul>{''.join(items)}</ul></div></nav>
"""

def footer(root):
    return f"""
<div class="banners"><div class="wrap"><ul>
  <li><a href="https://www.gri.re.kr" target="_blank" rel="noopener">경기연구원</a></li>
  <li><a href="https://www.gg.go.kr" target="_blank" rel="noopener">경기도청</a></li>
  <li><a href="https://www.moel.go.kr" target="_blank" rel="noopener">고용노동부</a></li>
  <li><a href="https://www.nlrc.go.kr" target="_blank" rel="noopener">중앙노동위원회</a></li>
  <li><a href="https://www.law.go.kr" target="_blank" rel="noopener">국가법령정보센터</a></li>
  <li><a href="https://www.comwel.or.kr" target="_blank" rel="noopener">근로복지공단</a></li>
</ul></div></div>
<footer class="footer">
  <div class="wrap">
    <div>
      <div class="flinks">
        <a href="{root}about/greeting.html">조합소개</a>
        <a href="{root}etc/privacy.html" class="em">개인정보처리방침</a>
        <a href="{root}etc/terms.html">이용약관</a>
        <a href="{root}about/location.html">오시는 길</a>
      </div>
      <address>
        {SITE} &nbsp;|&nbsp; (16207) 경기도 수원시 장안구 경수대로 1150 경기연구원<br>
        Tel. 031-250-3114 (경기연구원 대표) &nbsp;|&nbsp; E-mail. union@{DOMAIN}
      </address>
      <p class="copy">Copyright &copy; 2026 {SITE}. All rights reserved.</p>
    </div>
    <div class="fmark">
      <img src="{root}images/gri_logo_footer.png" alt="경기연구원">
      <span>{SITE_EN}</span>
    </div>
  </div>
</footer>
<button class="totop" aria-label="맨 위로">&#8679;</button>
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/dist/umd/supabase.min.js"></script>
<script src="{root}js/config.js?v={VER}"></script>
<script src="{root}js/events.js?v={VER}"></script>
<script src="{root}js/db.js?v={VER}"></script>
<script src="{root}js/main.js?v={VER}"></script>
<script src="{root}js/board.js?v={VER}"></script>
<script src="{root}js/auth.js?v={VER}"></script>
<script src="{root}js/admin.js?v={VER}"></script>
</body>
</html>
"""

# ------------------------------------------------------------------ 서브 페이지 골격
def sub_page(sec, page):
    root = "../"
    name, tagline, subs = next((n, t, s) for s_, n, t, s in MENUS if s_ == sec)
    pname = dict(subs)[page]
    lnb = "".join(f'<li{" class=\"on\"" if p == page else ""}><a href="{href(root, sec, p)}">{n}</a></li>' for p, n in subs)
    body = PAGES.get((sec, page), lambda r: board(r, pname, code=page))(root)
    return head(root, pname) + header(root, sec) + f"""
<section class="sub-visual"><div class="wrap"><h2>{name}</h2><p>{tagline}</p></div></section>
<div class="crumb"><div class="wrap"><a href="{root}index.html">홈</a><span>{name}</span><span>{pname}</span></div></div>
<div class="wrap sub-body">
  <aside class="lnb"><h3>{name}</h3><ul>{lnb}</ul></aside>
  <main class="content">
    <h3 class="page-title">{pname}</h3>
    {body}
  </main>
</div>
""" + footer(root)

# ------------------------------------------------------------------ 게시판 공통
def demo_href(root, title, date, writer="노동조합", code=""):
    from urllib.parse import quote
    return f"{root}board/view.html?demo=1&b={code}&t={quote(title)}&d={date}&w={quote(writer)}"

def rows_html(rows, root="../", code=""):
    out = []
    for i, r in enumerate(rows):
        num, title, writer, date, hit = r[:5]
        link = r[5] if len(r) > 5 else demo_href(root, title, date, writer, code)
        badge = ' <span class="badge new" style="font-size:11px;color:#fff;background:#e5533c;padding:1px 6px;border-radius:3px">N</span>' if (i < 2 and len(r) <= 5) else ""
        out.append(f'<tr><td class="num">{num}</td><td class="tit"><a href="{link}">{title}</a>{badge}</td><td class="writer">{writer}</td><td class="date">{date}</td><td class="hit">{hit}</td></tr>')
    return "".join(out)

def board(root, name, rows=None, intro="", extra_btn="", code=""):
    rows = rows or [(len(SAMPLE) - i, f"[{name}] 예시 게시글 {len(SAMPLE)-i}", "노동조합", d, h) for i, (d, h) in enumerate(SAMPLE)]
    return f"""
{intro}
<div class="board-top">
  <span>전체 <b class="total">{len(rows)}</b>건</span>
  <form onsubmit="return false"><select><option>제목</option><option>내용</option><option>작성자</option></select><input type="search" placeholder="검색어"><button type="submit">검색</button></form>
</div>
<table class="tbl" data-board="{code}">
  <thead><tr><th class="num">번호</th><th>제목</th><th class="writer">작성자</th><th class="date">작성일</th><th class="hit">조회</th></tr></thead>
  <tbody>{rows_html(rows, root, code)}</tbody>
</table>
<div class="paging"><a href="#">&laquo;</a><a href="#" class="on">1</a><a href="#">2</a><a href="#">3</a><a href="#">&raquo;</a></div>
<div class="board-bottom">{extra_btn}<a href="#" class="btn">글쓰기</a></div>
<p class="note static-note" style="margin-top:14px">※ Supabase 연결 전에는 예시 목록이 표시됩니다.</p>
"""

SAMPLE = [("2026-09-10", 128), ("2026-09-05", 96), ("2026-08-28", 210), ("2026-08-20", 74), ("2026-08-11", 153),
          ("2026-07-30", 88), ("2026-07-15", 301), ("2026-07-01", 67), ("2026-06-20", 142), ("2026-06-05", 59)]

# ------------------------------------------------------------------ 각 페이지 본문
def p_greeting(root):
    return """
<p class="lead">존경하는 경기연구원 조합원 여러분, 그리고 홈페이지를 찾아주신 모든 분께 감사드립니다.</p>
<p>경기연구원 노동조합은 연구원 구성원의 노동 권익을 지키고, 자율적이고 창의적인 연구 환경을 만들기 위해 활동하고 있습니다.
연구자와 직원 모두가 존중받는 일터, 공정하고 투명한 인사와 보수 제도, 그리고 일과 삶의 균형을 위해 노사가 함께 고민하고 실천하겠습니다.</p>
<p>노동조합은 조합원 한 분 한 분의 목소리에서 출발합니다. 현장의 어려움과 제안을 언제든 노동조합에 전해 주십시오.
소통상담, 조합원 자유게시판, 그리고 정기적인 간담회를 통해 여러분과 소통하고, 노사협의회와 교섭을 통해 실질적인 변화를 만들어가겠습니다.</p>
<p>경기도민을 위한 정책연구라는 우리의 사명을 자랑스럽게 수행할 수 있도록, 노동조합이 든든한 울타리가 되겠습니다. 감사합니다.</p>
<div class="box" style="text-align:right"><b>경기연구원 노동조합 위원장</b> &nbsp; <span style="font-size:20px;font-weight:800">○ ○ ○</span></div>
<p class="note">※ 인사말 내용과 위원장 성함은 예시입니다. 실제 내용으로 교체해 주세요.</p>
"""

def p_officers(root):
    ppl = [("위원장", "○○○", "연구본부"), ("수석부위원장", "○○○", "○○연구실"), ("사무국장", "○○○", "경영지원실"),
           ("부위원장(정책)", "○○○", "○○연구실"), ("부위원장(복지)", "○○○", "○○센터"), ("회계감사", "○○○", "○○연구실"),
           ("운영위원", "○○○", "○○연구실"), ("운영위원", "○○○", "○○연구실"), ("운영위원", "○○○", "북부연구센터")]
    cards = "".join(f'<div class="person"><div class="avatar">&#128100;</div><div class="role">{r}</div><div class="nm">{n}</div><div class="dept">{d}</div></div>' for r, n, d in ppl)
    return f"""
<h4>제○기 집행부 (임기 2026. 1. 1. ~ 2027. 12. 31.)</h4>
<div class="officers">{cards}</div>
<p class="note" style="margin-top:14px">※ 직책·성함·소속은 예시입니다. 사진은 <code>images/officers/</code> 폴더에 넣고 교체할 수 있습니다.</p>
<h4 style="margin-top:40px">조직도</h4>
""" + p_organization(root)

def p_history(root):
    items = [("2026", [("01월", "제○기 집행부 출범"), ("03월", "2026년 정기 대의원대회")]),
             ("2025", [("11월", "2025년 임금협약 체결"), ("06월", "조합원 복지제도 개선 합의")]),
             ("2024", [("12월", "단체협약 갱신 체결"), ("05월", "노사협의회 운영규정 개정")]),
             ("20○○", [("○월", "경기연구원 노동조합 설립총회 및 설립신고")])]
    li = "".join(f'<li><span class="y">{y}</span>' + "".join(f'<dl><dt>{m}</dt><dd>{t}</dd></dl>' for m, t in ev) + '</li>' for y, ev in items)
    return f'<ul class="history">{li}</ul><p class="note">※ 연혁은 예시입니다. 실제 연혁으로 교체해 주세요.</p>'

def p_declaration(root):
    return """
<h4>선언문</h4>
<div class="box">
<p>우리는 경기도민의 삶의 질 향상과 지역 발전을 위해 정책을 연구하는 경기연구원의 구성원으로서, 자주적이고 민주적인 노동조합을 통해
연구원 구성원의 권익을 지키고 연구의 자율성과 공공성을 수호할 것을 선언한다.</p>
</div>
<h4>강령</h4>
<ul class="bul">
  <li>우리는 조합원의 경제적·사회적 지위 향상과 근로조건의 유지·개선을 위해 단결한다.</li>
  <li>우리는 연구의 자율성과 독립성을 지키고, 공정하고 투명한 조직 운영을 실현한다.</li>
  <li>우리는 차별 없는 일터, 안전하고 건강한 일터를 만들기 위해 노력한다.</li>
  <li>우리는 민주적 절차에 따라 조합을 운영하며 조합원의 참여를 보장한다.</li>
  <li>우리는 경기도민에게 신뢰받는 정책연구기관을 만들기 위해 노사가 상생하는 문화를 만든다.</li>
</ul>
<p class="note">※ 선언문·강령은 예시 문안입니다.</p>
"""

def p_rules(root):
    rows = [(5, "경기연구원 노동조합 규약 (2026. 1. 개정)", "노동조합", "2026-01-15", 342),
            (4, "선거관리규정", "노동조합", "2025-11-02", 188),
            (3, "회계규정", "노동조합", "2025-11-02", 120),
            (2, "대의원회 운영규정", "노동조합", "2024-03-10", 97),
            (1, "노동조합 설립신고증", "노동조합", "2024-03-10", 210)]
    return board(root, "규약·규정", rows, '<p>노동조합의 규약과 내부 규정을 공개합니다. 파일을 내려받아 확인하실 수 있습니다.</p>', code='rules')

def p_organization(root):
    return """
<div class="org">
  <div class="node">대의원대회<small>최고 의결기구</small></div>
  <div class="vline"></div>
  <div class="node">위원장</div>
  <div class="row">
    <div class="node sub">회계감사</div>
    <div class="node sub">운영위원회<small>부위원장·사무국장·운영위원</small></div>
    <div class="node sub">선거관리위원회</div>
  </div>
  <div class="vline"></div>
  <div class="node" style="background:var(--gri-orange)">사무국</div>
  <div class="row">
    <div class="node sub">정책·교섭</div>
    <div class="node sub">조직·홍보</div>
    <div class="node sub">복지·문화</div>
    <div class="node sub">총무·회계</div>
  </div>
</div>
<p class="note" style="margin-top:20px">※ 조직도는 예시입니다. 실제 조직 구성에 맞게 수정해 주세요.</p>
"""

def p_location(root):
    return """
<div class="map-box">
  <iframe title="경기연구원 위치" src="https://maps.google.com/maps?q=%EA%B2%BD%EA%B8%B0%EC%97%B0%EA%B5%AC%EC%9B%90&t=&z=16&ie=UTF8&iwloc=&output=embed" loading="lazy"></iframe>
</div>
<table class="tbl form-tbl">
  <tr><th>주소</th><td>(16207) 경기도 수원시 장안구 경수대로 1150 경기연구원 (노동조합 사무실: 신관 ○층)</td></tr>
  <tr><th>전화</th><td>031-250-3114 (경기연구원 대표)</td></tr>
  <tr><th>이메일</th><td>union@grilu.kr</td></tr>
  <tr><th>대중교통</th><td>지하철 1호선 성균관대역 하차 후 버스 환승 / 수원역에서 버스 이용</td></tr>
  <tr><th>자가용</th><td>경수대로(1번 국도) 경기연구원 방면, 연구원 주차장 이용</td></tr>
</table>
"""

def p_regulation(root):
    rows = [(12, "경기연구원 인사규정 (2026. 7. 개정)", "경영지원실", "2026-07-21", 412),
            (11, "보수규정 및 보수규정 시행지침", "경영지원실", "2026-07-21", 388),
            (10, "복무규정", "경영지원실", "2026-05-02", 265),
            (9, "취업규칙", "경영지원실", "2026-03-14", 501),
            (8, "연구직 직급체계 및 승진 심사지침", "경영지원실", "2026-02-27", 344),
            (7, "출장 및 여비 지급 지침", "경영지원실", "2025-12-09", 190),
            (6, "육아휴직·가족돌봄휴직 운영지침", "경영지원실", "2025-11-18", 158),
            (5, "유연근무제 운영지침", "경영지원실", "2025-10-06", 276),
            (4, "직장 내 괴롭힘 예방 및 처리 지침", "경영지원실", "2025-08-22", 133),
            (3, "연구윤리규정", "연구기획실", "2025-06-11", 121),
            (2, "노사협의회 운영규정", "경영지원실", "2025-03-05", 199),
            (1, "성과평가 및 성과급 지급 지침", "경영지원실", "2025-01-20", 467)]
    intro = f"""
<p>경기연구원의 각종 규정과 지침을 조합원이 쉽게 확인할 수 있도록 모아 놓은 게시판입니다.
원본은 경기연구원 그룹웨어 <a href="{GW_REG_URL}" target="_blank" rel="noopener" style="color:var(--primary);text-decoration:underline">규정 및 지침 게시판</a>(내부망, 로그인 필요)에서 확인할 수 있습니다.</p>
<p class="note">※ 아래 목록은 예시입니다. 그룹웨어 게시판은 외부에서 접근할 수 없어 실제 목록을 가져오지 못했습니다. 게시글 목록을 알려주시면 반영하겠습니다.</p>
"""
    btn = f'<a href="{GW_REG_URL}" target="_blank" rel="noopener" class="btn line">그룹웨어 원문 보기</a>'
    return board(root, "규정 및 지침", rows, intro, btn, code="regulation")

def p_council(root):
    rows = [(10, "2026년 3분기 노사협의회 안건 사전 안내", "노동조합", "2026-09-08", 88),
            (9, "2026년 2분기 노사협의회 회의록", "노동조합", "2026-06-30", 245),
            (8, "2026년 2분기 노사협의회 안건 접수 안내", "노동조합", "2026-06-02", 132),
            (7, "2026년 1분기 노사협의회 회의록", "노동조합", "2026-03-31", 301),
            (6, "노사협의회 근로자위원 명단 (제○기)", "노동조합", "2026-01-10", 177),
            (5, "2025년 4분기 노사협의회 회의록", "노동조합", "2025-12-22", 264),
            (4, "2025년 3분기 노사협의회 회의록", "노동조합", "2025-09-29", 198),
            (3, "2025년 2분기 노사협의회 회의록", "노동조합", "2025-06-30", 220),
            (2, "노사협의회 운영규정", "노동조합", "2025-03-05", 156),
            (1, "노사협의회 소개 및 운영 안내", "노동조합", "2025-01-06", 389)]
    intro = f"""
<div class="info-cards" style="margin-bottom:24px">
  <div class="item"><div class="ico">&#128101;</div><b>구성</b><p>근로자위원과 사용자위원 각 ○명으로 구성, 분기별 1회 정기 개최</p></div>
  <div class="item"><div class="ico">&#128203;</div><b>협의사항</b><p>근로조건, 복지, 인사·노무관리 제도 개선, 고충처리 등</p></div>
  <div class="item"><div class="ico">&#128172;</div><b>안건 제안</b><p>조합원 누구나 노동조합을 통해 협의 안건을 제안할 수 있습니다</p></div>
</div>
<p>노사협의회 회의록, 안건, 결과를 공유하는 게시판입니다. 원본 자료는 그룹웨어 게시판(<a href="{GW_REG_URL}" target="_blank" rel="noopener" style="color:var(--primary);text-decoration:underline">바로가기</a>, 내부망)에서 확인할 수 있습니다.</p>
<p class="note">※ 아래 목록은 예시입니다. 그룹웨어는 외부 접근이 불가하여 실제 게시글을 가져오지 못했습니다.</p>
"""
    btn = f'<a href="{GW_REG_URL}" target="_blank" rel="noopener" class="btn line">그룹웨어 원문 보기</a>'
    return board(root, "노사협의회", rows, intro, btn, code="council")


def p_othernews(root):
    """빅카인즈 자동 수집 뉴스 (data/othernews.json, tools/fetch_news.py 가 매일 갱신)"""
    import json as _json
    try:
        news = _json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "othernews.json"), encoding="utf-8"))
    except Exception:
        news = []
    rows = [(len(news) - i, f'{n["title"]} <span class="note">[{n["provider"]}]</span>', "뉴스", n["date"], "-", f'{root}board/view.html?news={n["id"]}') for i, n in enumerate(news)]
    intro = ('<p>다른 노동조합·연대단체의 소식과 공공기관 노동계 동향입니다. 뉴스는 빅카인즈(한국언론진흥재단)에서 '
             '<b>"경기도 산하기관 노조"</b>, <b>"경기도 공공기관 노조"</b>, <b>"경기연구원 노조"</b> 키워드로 매일 자동 수집되며, 제목을 누르면 요약과 원문 링크가 표시됩니다.</p>')
    return board(root, "기타 노조 소식", rows, intro, code="othernews")

def p_delegate(root):
    intro = '<p>대의원대회·대의원회의 안건과 회의자료를 공유합니다. 승인된 조합원만 열람할 수 있습니다.</p>'
    return board(root, "대의원 회의자료", None, intro, code="delegate")

def p_wish(root):
    intro = '<p>노동조합에 바라는 점, 제안, 건의를 자유롭게 남겨 주세요. 승인된 조합원이면 누구나 글을 쓸 수 있고, 운영진이 확인 후 답변합니다.</p>'
    return board(root, "노조에 바란다", None, intro, code="wish")

def p_members(root):
    return """
<p>홈페이지 회원가입 후 승인된 조합원을 기준으로 집계합니다. 개인 정보 없이 인원수만 표시되며, 관리자가 회원을 승인·수정하면 자동으로 갱신됩니다.</p>
<div class="info-cards" id="memberStats" style="margin:20px 0 28px">
  <div class="item"><div class="ico">&#128101;</div><b>전체 조합원</b><p style="font-size:30px;font-weight:800;color:var(--primary);margin:0" data-ms="total">-</p></div>
  <div class="item"><div class="ico">&#127970;</div><b>소속 부서</b><p style="font-size:30px;font-weight:800;color:var(--primary);margin:0"><span data-ms="depts">-</span><span style="font-size:15px;color:#666;font-weight:500"> 개 부서</span></p></div>
  <div class="item"><div class="ico">&#128200;</div><b>이번 달 신규 가입</b><p style="font-size:30px;font-weight:800;color:var(--gri-orange);margin:0"><span data-ms="recent">-</span><span style="font-size:15px;color:#666;font-weight:500"> 명</span></p></div>
</div>
<div style="display:grid;grid-template-columns:1fr 1fr;gap:24px" class="ms-grid">
  <div><h4>직급별 현황</h4><table class="tbl" id="msPosition"><thead><tr><th>직급</th><th class="num" style="width:110px">인원</th><th style="width:40%">비율</th></tr></thead><tbody><tr><td colspan="3" style="padding:24px;color:#888">불러오는 중...</td></tr></tbody></table></div>
  <div><h4>부서별 현황</h4><table class="tbl" id="msDept"><thead><tr><th>소속(부서)</th><th class="num" style="width:110px">인원</th><th style="width:40%">비율</th></tr></thead><tbody><tr><td colspan="3" style="padding:24px;color:#888">불러오는 중...</td></tr></tbody></table></div>
</div>
<style>@media (max-width:800px){.ms-grid{grid-template-columns:1fr!important}}</style>
<p class="note" style="margin-top:20px">※ 조합비 납부 기준 조합원 수 등 공식 통계와 차이가 있을 수 있습니다. 홈페이지 미가입 조합원은 집계에 포함되지 않습니다.</p>
"""

def _gri_rules():
    import json as _json
    try:
        return _json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "gri_rules.json"), encoding="utf-8"))
    except Exception:
        return []

def p_regulations(root):
    """경기연구원 제규정: 편별 목차 (전문은 gri/regulations/partN.html)"""
    data = _gri_rules()
    cards = ""
    for part in data:
        items = "".join(f'<li><a href="regulations/part{part["no"]}.html#r{it["id"]}">{it["sec"] if not it["sub"] else "&nbsp;&nbsp;└ " + it["sub"]}</a></li>' for it in part["items"])
        cards += f"""
<div class="rule-part">
  <div class="rule-part-head"><a href="regulations/part{part["no"]}.html"><b>{part["part"]}</b> <span class="note">{len(part["items"])}개 규정</span></a>
    <a href="regulations/part{part["no"]}.html" class="btn sm">전문 보기</a></div>
  <ul class="bul">{items}</ul>
</div>"""
    intro = ('<p>경기연구원 홈페이지 <a href="https://www.gri.re.kr/web/contents/managenotice06.do" target="_blank" rel="noopener" style="color:var(--primary);text-decoration:underline">경영공시 &gt; 제규정</a>에 '
             '공개된 규정을 <b>편(編)별로 한 페이지에 묶어</b> 전문을 바로 읽을 수 있게 정리했습니다. 편 제목을 누르면 그 편의 모든 규정이 한 화면에 이어서 나오고, 개별 규정을 누르면 해당 위치로 이동합니다.</p>')
    return intro + '<div class="rule-parts">' + cards + '</div>' + '<p class="note" style="margin-top:20px">※ PDF 원문에서 자동 추출한 텍스트라 띄어쓰기·표 서식이 일부 다를 수 있습니다. 정확한 내용은 각 규정의 원문(PDF)을 확인하세요. 자료 갱신: <code>python tools/import_rules.py</code> 후 <code>python build.py</code></p>'

def regulations_pages():
    data = _gri_rules()
    for i, part in enumerate(data):
        toc = "".join(f'<li><a href="#r{it["id"]}">{it["sec"] if not it["sub"] else "&nbsp;&nbsp;└ " + it["sub"]}</a> <span class="note">{it.get("chars", 0):,}자</span></li>' for it in part["items"])
        body_items = ""
        for it in part["items"]:
            body_items += f"""
<section class="rule-item" id="r{it["id"]}">
  <h4 class="rule-title">{it["title"]}<span class="note" style="font-weight:400;font-size:13px;margin-left:10px">{it["part"]} {"› " + it["sec"] if it["sub"] else ""}</span></h4>
  <div class="rule-links"><a href="{it["view"]}" target="_blank" rel="noopener">경기연구원 원문 페이지</a> · <a href="{it["dl"]}" target="_blank" rel="noopener">PDF 내려받기</a> · <a href="#top">▲ 맨 위로</a></div>
  {it["html"] or '<p class="note">본문 텍스트를 추출하지 못했습니다. 원문 PDF를 확인하세요.</p>'}
</section>"""
        nav = ""
        if i > 0: nav += f'<a href="part{data[i-1]["no"]}.html" class="btn line">◀ {data[i-1]["part"]}</a>'
        nav += '<a href="../regulations.html" class="btn line">목차</a>'
        if i + 1 < len(data): nav += f'<a href="part{data[i+1]["no"]}.html" class="btn line">{data[i+1]["part"]} ▶</a>'
        body = f"""
<a id="top"></a>
<div class="box" style="margin-bottom:20px"><b>{part["part"]}</b> — 이 편에 속한 {len(part["items"])}개 규정의 전문입니다. 아래 목차를 누르면 해당 규정으로 이동합니다.
<ol class="rule-toc">{toc}</ol></div>
<div class="board-bottom" style="justify-content:center;gap:8px;margin:0 0 10px">{nav}</div>
<article class="post-body minutes rules-body">{body_items}</article>
<div class="board-bottom" style="justify-content:center;gap:8px;margin-top:30px">{nav}</div>"""
        write(f"gri/regulations/part{part['no']}.html", simple_page(f'{part["part"]} — 경기연구원 제규정', body, wide=True, root="../../", visual="제규정"))
    return len(data)

def p_staff(root):
    intro = '<p>노동조합 운영진(집행부·대의원)이 운영 사항을 공유하는 게시판입니다. 승인된 조합원만 열람할 수 있으며 글쓰기는 관리자(운영진)만 가능합니다.</p>'
    return board(root, "운영진 게시판", None, intro, code="staff")

def p_audit(root):
    import json as _json
    try:
        data = _json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "audit.json"), encoding="utf-8"))
    except Exception:
        data = []
    rows = [(len(data) - i, f'{r["title"]} — {r["committee"]}', "경기도의회", r["date"], "-", f'audit/{r["id"]}.html') for i, r in enumerate(data)]
    intro = """
<div class="info-cards" style="margin-bottom:24px">
  <div class="item"><div class="ico">&#127963;</div><b>행정사무감사</b><p>경기도의회가 매년 11월 도 산하기관을 대상으로 실시하는 감사. 경기연구원은 주로 <b>기획재정위원회</b> 소관입니다.</p></div>
  <div class="item"><div class="ico">&#128196;</div><b>회의록 원문</b><p>경기도의회 회의록 시스템(kms.ggc.go.kr)에서 경기연구원(구 경기개발연구원) 관련 회의록만 모았습니다.</p></div>
  <div class="item"><div class="ico">&#128269;</div><b>활용</b><p>의원 질의와 연구원 답변을 통해 기관 운영 현안과 지적사항을 확인할 수 있습니다.</p></div>
</div>
<p>제4대(1995년)부터 제11대(2025년)까지 행정사무감사 회의록 중 경기연구원이 피감기관으로 포함된 회의입니다. 제목을 누르면 본문 전문과 원문 링크를 볼 수 있습니다.</p>
"""
    btn = '<a href="https://kms.ggc.go.kr/svc/cms/mnts/MntsTreeAuditList.do" target="_blank" rel="noopener" class="btn line">경기도의회 회의록 원문</a>'
    return board(root, "행정사무감사", rows, intro, btn, code="audit")

def audit_pages():
    import json as _json
    try:
        data = _json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "audit.json"), encoding="utf-8"))
    except Exception:
        return 0
    for i, r in enumerate(data):
        prev_ = data[i + 1] if i + 1 < len(data) else None
        next_ = data[i - 1] if i > 0 else None
        nav = ""
        if next_: nav += f'<tr><th style="text-align:left;width:90px">다음글</th><td style="text-align:left"><a href="{next_["id"]}.html">{next_["title"]} — {next_["committee"]}</a></td></tr>'
        if prev_: nav += f'<tr><th style="text-align:left">이전글</th><td style="text-align:left"><a href="{prev_["id"]}.html">{prev_["title"]} — {prev_["committee"]}</a></td></tr>'
        body = f"""
<article class="post">
  <div class="post-head" style="border-bottom:1px solid var(--line);padding-bottom:14px;margin-bottom:20px">
    <span class="badge" style="font-size:12px;color:#fff;background:var(--primary);padding:2px 8px;border-radius:4px">제{r["daesu"]}대 경기도의회 · {r["committee"]}</span>
    <h4 style="border:0;padding:0;margin:8px 0 6px;color:#222;font-size:24px">{r["title"]}</h4>
    <div class="note">{r["audit"]} &nbsp;|&nbsp; 회의일 {r["date"]} &nbsp;|&nbsp; 출처 경기도의회 회의록시스템</div>
  </div>
  <div class="post-body minutes" style="line-height:1.85;font-size:15px">{r["body"] or "<p class='note'>본문은 원문 링크에서 확인하세요.</p>"}</div>
  <table class="tbl" style="margin-top:24px">{nav}</table>
  <div class="board-bottom" style="justify-content:space-between"><a href="../audit.html" class="btn line">목록</a><a href="{r["url"]}" target="_blank" rel="noopener" class="btn">경기도의회 원문 보기</a></div>
</article>"""
        write(f"gri/audit/{r['id']}.html", simple_page(f'{r["title"]} — 행정사무감사', body, wide=True, root="../../", visual="행정사무감사"))
    return len(data)

def p_photo(root):
    caps = ["2026년 정기 대의원대회", "신규 조합원 환영 간담회", "노사협의회 상견례", "조합원 한마음 체육행사",
            "2025년 임금협약 조인식", "조합 창립기념 행사", "노동조합 간부 교육", "경기도 공공기관 노조 연대회의", "명절 맞이 조합원 나눔행사"]
    items = "".join(f'<a href="#"><div class="thumb">&#128247;</div><div class="cap">{c}<span>2026-0{i%9+1}-1{i%3}</span></div></a>' for i, c in enumerate(caps))
    return f'<div class="gallery sub-gal" data-board="photo">{items}</div><div class="board-bottom"><a href="{root}board/write.html?board=photo" class="btn">사진 등록</a></div><p class="note" style="margin-top:14px">※ Supabase 연결 전에는 예시 썸네일이 표시됩니다. 사진 등록 시 이미지 파일을 첨부하면 썸네일로 표시됩니다.</p>'

def p_video(root):
    items = "".join(f'<a href="#"><div class="thumb">&#9654;</div><div class="cap">{c}<span>2026</span></div></a>' for c in ["노동조합 소개 영상", "2026 대의원대회 하이라이트", "위원장 신년사"])
    return f'<div class="gallery sub-gal" data-board="video">{items}</div><div class="board-bottom"><a href="{root}board/write.html?board=video" class="btn">영상 등록</a></div><p class="note" style="margin-top:14px">※ 내용에 유튜브 주소를 넣으면 썸네일이 자동 표시됩니다.</p>'

def p_calendar(root):
    return """
<div class="cal-grid">
  <div class="card calendar">
    <div class="cal-head">
      <h4 class="cal-title">2026년 9월</h4>
      <div class="nav"><button class="prev" aria-label="이전 달">&lsaquo;</button><button class="today-btn">오늘</button><button class="next" aria-label="다음 달">&rsaquo;</button></div>
    </div>
    <table><thead><tr><th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr></thead><tbody></tbody></table>
    <div class="legend"><span><i style="background:#1f398f"></i>노조</span><span><i style="background:#1f7a54"></i>노사협의회</span><span><i style="background:#b86400"></i>행사</span><span><i style="background:#c33"></i>휴일</span></div>
  </div>
  <div class="card upcoming"><h4 class="up-title">이달의 일정</h4><ul></ul></div>
</div>
<p class="note" style="margin-top:16px">※ 일정은 <code>js/events.js</code> 파일에서 추가·수정합니다. (날짜, 제목, 구분, 설명)</p>
"""

def p_counsel(root):
    return """
<div class="info-cards" style="margin-bottom:28px">
  <div class="item"><div class="ico">&#128274;</div><b>비밀 보장</b><p>상담 내용은 담당자 외 열람할 수 없으며 본인 동의 없이 공개되지 않습니다.</p></div>
  <div class="item"><div class="ico">&#9201;</div><b>신속 처리</b><p>접수 후 3일 이내 담당자가 연락드리고 처리 경과를 안내합니다.</p></div>
  <div class="item"><div class="ico">&#129309;</div><b>함께 해결</b><p>필요 시 고충처리위원회·노사협의회 안건으로 상정하여 해결합니다.</p></div>
</div>
<h4>소통상담 신청</h4>
<form id="counselForm">
<table class="tbl form-tbl">
  <tr><th>성명</th><td><input type="text" name="name" placeholder="비공개 상담을 원하시면 '익명'으로 적어주세요"></td></tr>
  <tr><th>연락처 / 이메일</th><td><input type="text" name="contact" placeholder="회신 받을 연락처"></td></tr>
  <tr><th>상담 분야</th><td><select name="category"><option>근로조건·임금</option><option>인사·평가</option><option>직장 내 괴롭힘·성희롱</option><option>복지·휴가</option><option>안전·건강</option><option>기타</option></select></td></tr>
  <tr><th>제목</th><td><input type="text" name="title" required></td></tr>
  <tr><th>내용</th><td><textarea name="content" required placeholder="상담 내용을 구체적으로 적어주세요."></textarea></td></tr>
</table>
<div class="board-bottom"><button type="submit" class="btn orange">상담 신청</button></div>
</form>
"""

def p_welfare(root):
    return """
<p class="lead">노동조합은 조합원의 생활 안정과 삶의 질 향상을 위해 다양한 복지사업을 운영합니다.</p>
<div class="info-cards">
  <div class="item"><div class="ico">&#127873;</div><b>경조사 지원</b><p>결혼·출산·상례 등 경조사 시 경조금 및 경조용품 지원</p></div>
  <div class="item"><div class="ico">&#127891;</div><b>교육·자기계발</b><p>노동교육, 직무 관련 세미나·워크숍 참가 지원</p></div>
  <div class="item"><div class="ico">&#127939;</div><b>문화·체육</b><p>동호회 활동비 지원, 조합원 한마음 행사 개최</p></div>
  <div class="item"><div class="ico">&#127973;</div><b>건강·안전</b><p>건강검진 추가항목, 심리상담 프로그램 연계</p></div>
  <div class="item"><div class="ico">&#127968;</div><b>생활 지원</b><p>제휴 할인, 명절 선물, 휴양시설 이용 안내</p></div>
  <div class="item"><div class="ico">&#9878;</div><b>법률 지원</b><p>노동 관련 법률상담 및 노무사 연계</p></div>
</div>
<p class="note" style="margin-top:14px">※ 복지사업 항목은 예시입니다. 실제 사업 내용으로 교체해 주세요.</p>
"""

def p_join(root):
    return """
<p class="lead">경기연구원에서 함께 일하는 여러분, 노동조합에 가입하여 더 나은 일터를 함께 만들어 갑시다.</p>
<h4>가입 대상</h4>
<ul class="bul"><li>경기연구원에 재직 중인 연구직·행정직·전문직 등 임직원 (규약에서 정한 사용자 제외)</li><li>고용 형태(정규직·계약직 등)에 관계없이 가입할 수 있습니다.</li></ul>
<h4>가입 절차</h4>
<div class="box">
<ol style="list-style:decimal;padding-left:20px;line-height:2">
  <li>아래 가입신청서를 내려받아 작성합니다.</li>
  <li>노동조합 사무국(union@grilu.kr) 또는 사무국장에게 제출합니다.</li>
  <li>운영위원회 확인 후 조합원으로 등록되며, 조합비는 급여에서 공제(체크오프)됩니다.</li>
</ol>
</div>
<h4>조합비</h4>
<p>통상임금의 ○% (월 ○○,○○○원 상한) — 규약 제○조에 따릅니다.</p>
<div class="board-bottom" style="justify-content:flex-start"><a href="#" class="btn">가입신청서 내려받기</a><a href="../community/counsel.html" class="btn line">가입 문의</a></div>
<p class="note">※ 가입 대상·조합비는 예시입니다. 규약에 맞게 수정해 주세요.</p>
"""

def p_agreement(root):
    rows = [(4, "2024년 단체협약서 (2024. 12. 체결)", "노동조합", "2024-12-20", 512),
            (3, "2025년 임금협약서", "노동조합", "2025-11-25", 431),
            (2, "2022년 단체협약서", "노동조합", "2022-12-15", 288),
            (1, "단체협약 주요 내용 해설", "노동조합", "2025-01-10", 620)]
    return board(root, "단체협약", rows, "<p>노사가 체결한 단체협약과 임금협약 원문을 공개합니다.</p>", code="agreement")

def p_law(root):
    """국가법령정보센터에서 가져온 시행일·개정일 기준 (data/laws.json, tools/import_laws.py 로 갱신)"""
    import json as _json
    from urllib.parse import quote
    try:
        laws = _json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "laws.json"), encoding="utf-8"))
    except Exception:
        laws = []
    def d8(k):  # '2026. 2. 19.' → '2026-02-19'
        n = [int(x) for x in re.findall(r"\d+", k)]
        return f"{n[0]}-{n[1]:02d}-{n[2]:02d}"
    items = []
    for name, src, info in laws:
        if not info: continue
        ef, no, amd, kind = info
        items.append((d8(amd), name, f"{name} <span class='note'>(법률 제{no}호 {amd} {kind} · 시행 {ef})</span>", "https://www.law.go.kr/법령/" + quote(name)))
    items.sort(reverse=True)
    rows = [(len(items) - i, title, "국가법령정보센터", date, "-", link) for i, (date, _, title, link) in enumerate(items)]
    intro = '<p>조합 활동과 관련된 주요 법령입니다. 작성일은 해당 법령의 <b>최근 개정(공포)일</b>이며, 제목을 누르면 <a href="https://www.law.go.kr" target="_blank" rel="noopener" style="color:var(--primary);text-decoration:underline">국가법령정보센터</a>의 현행 법령 원문이 열립니다.</p>'
    return board(root, "노동관계법령", rows, intro, code='law')

PAGES = {
    ("about", "greeting"): p_greeting, ("about", "officers"): p_officers, ("about", "history"): p_history,
    ("about", "declaration"): p_declaration, ("archive", "rules"): p_rules, ("about", "organization"): p_organization,
    ("about", "location"): p_location,
    ("news", "regulation"): p_regulation, ("news", "council"): p_council,
    ("archive", "photo"): p_photo, ("archive", "video"): p_video, ("archive", "agreement"): p_agreement, ("archive", "law"): p_law,
    ("gri", "calendar"): p_calendar, ("community", "counsel"): p_counsel, ("about", "welfare"): p_welfare,
    ("about", "join"): p_join, ("gri", "regulation"): p_regulation, ("archive", "council"): p_council,
    ("community", "staff"): p_staff, ("gri", "regulations"): p_regulations, ("about", "members"): p_members, ("archive", "delegate"): p_delegate, ("community", "wish"): p_wish, ("news", "othernews"): p_othernews, ("gri", "audit"): p_audit,
}

# ------------------------------------------------------------------ 메인 페이지
def index():
    root = ""
    def li(items, badge=None, code=""):
        out = ""
        for i, (t, d) in enumerate(items):
            b = f'<span class="badge {badge[1]}">{badge[0]}</span>' if badge else (f'<span class="badge new">N</span>' if i < 2 else "")
            out += f'<li>{b}<a href="{demo_href(root, t, d, code=code)}">{t}</a><span class="date">{d}</span></li>'
        return out
    notice = [("2026년 3분기 노사협의회 안건 접수 안내", "2026-09-08"), ("추석 명절 조합원 선물 지급 안내", "2026-09-04"),
              ("제○기 집행부 하반기 조합원 간담회 일정", "2026-08-28"), ("2026년 상반기 조합비 사용내역 공개", "2026-08-11"),
              ("조합 사무실 이전 안내", "2026-07-22"), ("노동조합 홈페이지(grilu.kr) 개편 안내", "2026-07-01")]
    news = [("경기도 공공기관 노동조합 연대회의 참석", "2026-09-09"), ("유연근무제 확대 시행 노사 합의", "2026-08-26"),
            ("연구직 직급체계 개편 관련 조합 의견 제출", "2026-08-13"), ("여름철 조합원 건강관리 캠페인 진행", "2026-07-29"),
            ("2026년 상반기 노사협의회 결과 보고", "2026-07-03"), ("신규 조합원 환영 간담회 개최", "2026-06-18")]
    stmt = [("[성명] 연구 자율성 보장과 공정한 평가제도 마련을 촉구한다", "2026-09-02"), ("[보도자료] 경기연구원 노사, 유연근무제 확대 합의", "2026-08-26"),
            ("[성명] 출연기관 예산 삭감 방침에 대한 노동조합의 입장", "2026-07-17"), ("[입장문] 성과급 지급 기준 개편에 대하여", "2026-06-05"),
            ("[성명] 직장 내 괴롭힘 근절을 위한 제도 개선 요구", "2026-05-14"), ("[보도자료] 2025년 임금협약 체결", "2025-11-25")]
    regs = [("경기연구원 인사규정 (2026. 7. 개정)", "07-21"), ("보수규정 및 시행지침", "07-21"), ("복무규정", "05-02"),
            ("취업규칙", "03-14"), ("승진 심사지침", "02-27")]
    council = [("3분기 노사협의회 안건 사전 안내", "09-08"), ("2분기 노사협의회 회의록", "06-30"), ("2분기 안건 접수 안내", "06-02"),
               ("1분기 노사협의회 회의록", "03-31"), ("근로자위원 명단 (제○기)", "01-10")]
    gallery = "".join(f'<a href="archive/photo.html"><div class="thumb">&#128247;</div><div class="cap">{c}<span>{d}</span></div></a>' for c, d in
                      [("2026년 정기 대의원대회", "2026-03-20"), ("신규 조합원 환영 간담회", "2026-06-18"), ("노사협의회 상견례", "2026-01-15"), ("조합원 한마음 체육행사", "2025-10-24")])
    return head(root, "") + header(root) + f"""
<section class="hero">
  <div class="slides">
    <div class="slide on"><div class="wrap">
      <div class="eyebrow">{SITE_EN}</div>
      <h2>연구자와 함께!<br><em>조합원과 함께!</em></h2>
      <p>경기연구원 노동조합은 구성원 모두가 존중받는 일터, 자율적이고 공정한 연구 환경을 만들어 갑니다.</p>
      <div class="cta"><a href="about/join.html" class="primary">조합가입 안내</a><a href="about/greeting.html" class="ghost">노동조합 소개</a></div>
    </div></div>
    <div class="slide"><div class="wrap">
      <div class="eyebrow">Together We Grow</div>
      <h2>함께 지키는 권리,<br><em>함께 만드는 변화</em></h2>
      <p>규정과 지침, 노사협의회 결과를 투명하게 공개하고 조합원의 목소리를 정책에 반영합니다.</p>
      <div class="cta"><a href="gri/regulation.html" class="primary">규정 및 지침</a><a href="archive/council.html" class="ghost">노사협의회</a></div>
    </div></div>
    <div class="slide"><div class="wrap">
      <div class="eyebrow">Your Voice Matters</div>
      <h2>당신의 고충,<br><em>노동조합이 듣겠습니다</em></h2>
      <p>소통상담은 비밀이 보장되며, 접수 후 3일 이내 담당자가 연락드립니다.</p>
      <div class="cta"><a href="community/counsel.html" class="primary">소통상담 신청</a><a href="community/board.html" class="ghost">조합원 자유게시판</a></div>
    </div></div>
  </div>
  <div class="dots"></div>
</section>

<section class="searchband">
  <div class="wrap">
    <form action="board/search.html" method="get" role="search">
      <label for="siteSearch">자료검색</label>
      <input type="search" id="siteSearch" name="q" placeholder="찾으시는 자료의 키워드를 입력하세요 (예: 단체협약, 회의록, 인사규정)" autocomplete="off">
      <button type="submit">&#128269; 검색</button>
    </form>
    <p class="hint">공지사항 · 규정 및 지침 · 노사협의회 · 단체협약 · 문서자료 등 모든 게시판을 한 번에 검색합니다.</p>
  </div>
</section>

<div class="wrap">
  <nav class="quick" aria-label="바로가기"><ul>
    <li><a href="news/notice.html"><span class="ico">&#128226;</span>공지사항</a></li>
    <li><a href="gri/regulation.html"><span class="ico">&#128218;</span>규정 및 지침</a></li>
    <li><a href="archive/council.html"><span class="ico">&#129309;</span>노사협의회</a></li>
    <li><a href="gri/calendar.html"><span class="ico">&#128197;</span>일정 달력</a></li>
    <li><a href="community/counsel.html"><span class="ico">&#128172;</span>소통상담</a></li>
    <li><a href="about/join.html"><span class="ico">&#9997;</span>조합가입</a></li>
  </ul></nav>
</div>

<section class="section">
  <div class="wrap">
    <div class="sec-head"><h3><small>News</small>노조 소식</h3></div>
    <div class="news-grid">
      <div class="card" data-tabs>
        <div class="tabs"><button class="on">공지사항</button><button>노조소식</button><button>성명서·보도자료</button></div>
        <div class="tab-panel on"><ul class="list" data-latest="notice" data-limit="6">{li(notice, code="notice")}</ul><div style="text-align:right;margin-top:8px"><a href="news/notice.html" class="more">더보기</a></div></div>
        <div class="tab-panel"><ul class="list" data-latest="news" data-limit="6">{li(news, code="news")}</ul><div style="text-align:right;margin-top:8px"><a href="news/news.html" class="more">더보기</a></div></div>
        <div class="tab-panel"><ul class="list" data-latest="statement" data-limit="6">{li(stmt, code="statement")}</ul><div style="text-align:right;margin-top:8px"><a href="news/statement.html" class="more">더보기</a></div></div>
      </div>
      <div class="card">
        <h4>규정 및 지침 <a href="gri/regulation.html" class="more">더보기</a></h4>
        <ul class="list compact" data-latest="regulation" data-limit="5" data-badge="규정|reg">{li(regs, code="regulation", badge=("규정", "reg"))}</ul>
        <div class="link-cards">
          <a href="{GW_REG_URL}" target="_blank" rel="noopener" class="c1"><span class="ico">&#128194;</span><span>그룹웨어 규정 및 지침<span>원문 보기 (내부망 로그인)</span></span></a>
        </div>
      </div>
      <div class="card">
        <h4>노사협의회 <a href="archive/council.html" class="more">더보기</a></h4>
        <ul class="list compact" data-latest="council" data-limit="5" data-badge="협의회|council">{li(council, code="council", badge=("협의회", "council"))}</ul>
        <div class="link-cards">
          <a href="community/counsel.html" class="c2"><span class="ico">&#128172;</span><span>소통상담하기<span>비밀 보장 · 3일 이내 회신</span></span></a>
          <a href="community/board.html" class="c3"><span class="ico">&#128221;</span><span>조합원 게시판<span>자유롭게 의견을 나눠주세요</span></span></a>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="section soft">
  <div class="wrap">
    <div class="sec-head"><h3><small>Calendar</small>노동조합 일정</h3><a href="gri/calendar.html" class="more">전체 일정</a></div>
    <div class="cal-grid">
      <div class="card calendar">
        <div class="cal-head">
          <h4 class="cal-title">2026년 9월</h4>
          <div class="nav"><button class="prev" aria-label="이전 달">&lsaquo;</button><button class="today-btn">오늘</button><button class="next" aria-label="다음 달">&rsaquo;</button></div>
        </div>
        <table><thead><tr><th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr></thead><tbody></tbody></table>
        <div class="legend"><span><i style="background:#1f398f"></i>노조</span><span><i style="background:#1f7a54"></i>노사협의회</span><span><i style="background:#b86400"></i>행사</span><span><i style="background:#c33"></i>휴일</span></div>
      </div>
      <div class="card upcoming"><h4 class="up-title">이달의 일정</h4><ul></ul></div>
    </div>
  </div>
</section>

<section class="section">
  <div class="wrap">
    <div class="sec-head"><h3><small>At a Glance</small>한눈에 보는 노동조합</h3></div>
    <div class="glance">
      <div class="item"><small>위원장</small><b>○○○</b><p>제○기 집행부 (2026~2027)</p></div>
      <div class="item"><small>조합원</small><b>○○○명</b><p>연구직·행정직·전문직</p></div>
      <div class="item"><small>노사협의회</small><b>분기 1회</b><p>근로자위원 ○명 참여</p></div>
      <div class="item"><small>설립</small><b>20○○년</b><p>경기연구원 노동조합 설립</p></div>
    </div>
  </div>
</section>

""" + footer(root)

# ------------------------------------------------------------------ 기타 페이지 (로그인 등)
def simple_page(title, body, wide=False, root="../", visual=None):
    return head(root, title) + header(root) + f"""
<section class="sub-visual"><div class="wrap"><h2>{visual or title}</h2></div></section>
<div class="wrap" style="padding:50px 0 80px;{'' if wide else 'max-width:720px'}"><main class="content"><h3 class="page-title">{title}</h3>{body}</main></div>
""" + footer(root)

LOGIN = """
<form id="loginForm">
<table class="tbl form-tbl"><tr><th>이메일</th><td><input type="email" name="email" required autocomplete="username"></td></tr><tr><th>비밀번호</th><td><input type="password" name="password" required autocomplete="current-password"></td></tr></table>
<div class="board-bottom" style="justify-content:center"><button type="submit" class="btn">로그인</button><a href="join.html" class="btn line">회원가입</a><a href="reset.html" class="btn line">비밀번호 찾기</a></div>
</form>
<p class="note" style="text-align:center">조합원 확인 후 관리자가 승인하면 조합원 게시판을 이용할 수 있습니다.</p>
"""
JOIN = """
<p>홈페이지 회원가입은 조합원 확인 후 승인됩니다. 이메일이 로그인 아이디가 됩니다.</p>
<form id="joinForm">
<table class="tbl form-tbl">
<tr><th>성명</th><td><input type="text" name="name" required></td></tr><tr><th>소속(부서명)</th><td><input type="text" name="dept" placeholder="예: 도시주택연구실" required></td></tr>
<tr><th>직급</th><td><select name="position" required><option value="">선택</option><option>선임연구위원</option><option>연구위원</option><option>선임연구원</option><option>연구원</option><option>행정직</option></select></td></tr>
<tr><th>이메일</th><td><input type="email" name="email" required autocomplete="username"></td></tr>
<tr><th>비밀번호</th><td><input type="password" name="password" required minlength="6" autocomplete="new-password"></td></tr>
<tr><th>비밀번호 확인</th><td><input type="password" name="password2" required minlength="6" autocomplete="new-password"></td></tr></table>
<div class="board-bottom" style="justify-content:center"><button type="submit" class="btn">가입 신청</button></div>
</form>
"""
RESET = """
<p>가입한 이메일을 입력하면 비밀번호 재설정 링크를 보내드립니다.</p>
<form id="resetForm"><table class="tbl form-tbl"><tr><th>이메일</th><td><input type="email" name="email" required></td></tr></table>
<div class="board-bottom" style="justify-content:center"><button type="submit" class="btn">재설정 메일 보내기</button></div></form>
"""
MYPAGE = """
<p>회원 상태: <b id="myStatus">-</b></p>
<form id="myForm"><table class="tbl form-tbl">
<tr><th>이메일</th><td><input type="email" name="email" disabled></td></tr>
<tr><th>성명</th><td><input type="text" name="name"></td></tr>
<tr><th>소속(부서명)</th><td><input type="text" name="dept"></td></tr>
<tr><th>직급</th><td><select name="position"><option value="">선택</option><option>선임연구위원</option><option>연구위원</option><option>선임연구원</option><option>연구원</option><option>행정직</option></select></td></tr>
<tr><th>새 비밀번호</th><td><input type="password" name="password" placeholder="변경할 때만 입력" autocomplete="new-password"></td></tr>
</table><div class="board-bottom" style="justify-content:center"><button type="submit" class="btn">저장</button></div></form>
"""
VIEW = """<article id="postView"><p style="color:#888">게시글을 불러오는 중...</p></article>"""
SEARCH = """
<div class="board-top">
  <span>검색어 <b class="kw" style="color:var(--primary)"></b> &nbsp; 결과 <b class="total">0</b>건</span>
  <form action="search.html" method="get"><input type="search" name="q" placeholder="검색어"><button type="submit">검색</button></form>
</div>
<table class="tbl" id="searchTable">
  <thead><tr><th class="num" style="width:130px">게시판</th><th>제목</th><th class="writer">작성자</th><th class="date">작성일</th></tr></thead>
  <tbody><tr><td colspan="4" style="padding:40px;color:#888">검색 중...</td></tr></tbody>
</table>
<p class="note" style="margin-top:14px">※ 제목과 본문에 검색어가 포함된 게시글을 모든 게시판에서 찾습니다. (조합원 전용 게시판은 로그인 후 검색 결과에 포함됩니다)</p>
"""
WRITE = """
<form id="postForm" enctype="multipart/form-data">
<input type="hidden" name="board">
<table class="tbl form-tbl">
  <tr><th>제목</th><td><input type="text" name="title" required></td></tr>
  <tr class="notice-row" style="display:none"><th>공지 여부</th><td><label><input type="checkbox" name="is_notice" style="width:auto"> 상단 공지로 고정</label></td></tr>
  <tr><th>내용</th><td><textarea name="content" style="height:320px" placeholder="내용을 입력하세요. (동영상 게시판은 유튜브 주소를 넣으면 썸네일이 표시됩니다)"></textarea></td></tr>
  <tr><th>첨부파일</th><td><input type="file" name="files" multiple><div class="existing" style="margin-top:6px"></div><p class="note">여러 개 선택 가능. 사진자료 게시판은 이미지 파일이 썸네일로 사용됩니다.</p></td></tr>
</table>
<div class="board-bottom"><a href="javascript:history.back()" class="btn line">취소</a><button type="submit" class="btn">저장</button></div>
</form>
"""
def admin_nav(cur):
    items=[("index","대시보드"),("members","회원관리"),("events","일정관리"),("counsel","고충상담")]
    return '<div class="admin-nav">'+"".join(f'<a href="{p}.html"{" class=\"on\"" if p==cur else ""}>{n}</a>' for p,n in items)+'</div>'

ADMIN = """
<div id="adminPage" data-admin="index">
%s
<div class="glance" id="adminStats">
  <div class="item"><small>전체 회원</small><b data-stat="members">-</b><p>가입 회원 수</p></div>
  <div class="item"><small>승인 대기</small><b data-stat="pending">-</b><p><a href="members.html?filter=pending" style="color:var(--primary)">회원관리에서 승인 →</a></p></div>
  <div class="item"><small>이달의 일정</small><b data-stat="events">-</b><p>등록된 일정</p></div>
  <div class="item"><small>미처리 고충상담</small><b data-stat="counsel">-</b><p>접수 상태</p></div>
</div>
<h4>최근 가입 회원</h4>
<div style="overflow-x:auto"><table class="tbl" id="recentMembers"><thead><tr><th>성명</th><th>이메일</th><th>소속</th><th>직급</th><th>가입일</th><th>상태</th></tr></thead><tbody><tr><td colspan="6">불러오는 중...</td></tr></tbody></table></div>
</div>
""" % admin_nav("index")

ADMIN_MEMBERS = """
<div id="adminPage" data-admin="members">
%s
<p class="note">가입한 회원이 조합원인지 확인한 뒤 <b>승인</b>하면 조합원 게시판 이용과 글쓰기가 가능해집니다. 성명·소속은 칸을 눌러 바로 수정하고 <b>저장</b>을 누르세요.</p>
<div class="admin-tools">
  <input type="search" id="memberSearch" placeholder="성명 · 이메일 · 소속 검색">
  <select id="memberFilter"><option value="all">전체</option><option value="pending">승인 대기</option><option value="approved">승인 조합원</option><option value="admin">관리자</option></select>
  <button class="btn line" id="memberCsv" type="button">CSV 내려받기</button>
  <span class="cnt" id="memberCount"></span>
</div>
<div style="overflow-x:auto"><table class="tbl" id="memberTbl"><thead><tr><th style="width:120px">성명</th><th>이메일</th><th style="width:150px">소속</th><th style="width:120px">직급</th><th style="width:100px">가입일</th><th style="width:90px">상태</th><th style="width:250px">관리</th></tr></thead><tbody><tr><td colspan="7">불러오는 중...</td></tr></tbody></table></div>
<p class="note" style="margin-top:12px">※ "탈퇴"는 홈페이지 회원 정보를 삭제하고 로그인 권한을 없앱니다. 로그인 계정 자체를 완전히 삭제하려면 Supabase 대시보드 &gt; Authentication &gt; Users 에서 삭제하세요.</p>
</div>
""" % admin_nav("members")

ADMIN_EVENTS = """
<div id="adminPage" data-admin="events">
%s
<form id="eventForm" class="box" style="display:grid;grid-template-columns:150px 150px 1fr 130px;gap:8px;align-items:end">
  <input type="hidden" name="id_">
  <label>시작일<input type="date" name="date" required style="width:100%%;padding:8px;border:1px solid var(--line);border-radius:4px"></label>
  <label>종료일(선택)<input type="date" name="end_date" style="width:100%%;padding:8px;border:1px solid var(--line);border-radius:4px"></label>
  <label>제목<input type="text" name="title" required style="width:100%%;padding:8px;border:1px solid var(--line);border-radius:4px"></label>
  <label>구분<select name="type" style="width:100%%;padding:8px;border:1px solid var(--line);border-radius:4px"><option value="union">노조</option><option value="council">노사협의회</option><option value="event">행사</option><option value="holiday">휴일</option></select></label>
  <label style="grid-column:1/4">설명(선택)<input type="text" name="description" style="width:100%%;padding:8px;border:1px solid var(--line);border-radius:4px"></label>
  <button type="submit" class="btn">일정 저장</button>
</form>
<div style="overflow-x:auto"><table class="tbl" id="eventTbl"><thead><tr><th>날짜</th><th>제목</th><th>구분</th><th>설명</th><th>관리</th></tr></thead><tbody><tr><td colspan="5">불러오는 중...</td></tr></tbody></table></div>
</div>
""" % admin_nav("events")

ADMIN_COUNSEL = """
<div id="adminPage" data-admin="counsel">
%s
<p class="note">제목을 누르면 내용이 펼쳐집니다. 상담 내용은 관리자만 볼 수 있습니다.</p>
<div style="overflow-x:auto"><table class="tbl" id="counselTbl"><thead><tr><th>접수일</th><th>분야</th><th>제목</th><th>신청자</th><th>상태</th></tr></thead><tbody><tr><td colspan="5">불러오는 중...</td></tr></tbody></table></div>
</div>
""" % admin_nav("counsel")

PRIVACY = "<p>경기연구원 노동조합(이하 '조합')은 개인정보보호법에 따라 이용자의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 다음과 같이 개인정보처리방침을 수립·공개합니다.</p><h4>1. 개인정보의 처리 목적</h4><p>홈페이지 회원 관리, 고충상담 접수 및 회신, 조합 소식 안내</p><h4>2. 처리하는 개인정보 항목</h4><p>성명, 소속, 이메일, 비밀번호, 연락처</p><h4>3. 보유 및 이용기간</h4><p>회원 탈퇴 시 또는 수집 목적 달성 시까지</p><p class='note'>※ 예시 문안입니다. 실제 방침으로 교체해 주세요.</p>"
TERMS = "<p>본 약관은 경기연구원 노동조합 홈페이지(grilu.kr)의 이용 조건 및 절차에 관한 사항을 규정합니다.</p><p class='note'>※ 예시 문안입니다.</p>"

# ------------------------------------------------------------------ 빌드
def write(path, content):
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def main():
    base = os.path.dirname(os.path.abspath(__file__))
    os.chdir(base)
    write("index.html", index())
    n = 1
    for sec, _, _, subs in MENUS:
        for page, _ in subs:
            write(f"{sec}/{page}.html", sub_page(sec, page)); n += 1
    write("member/login.html", simple_page("로그인", LOGIN))
    write("member/join.html", simple_page("회원가입", JOIN))
    write("member/reset.html", simple_page("비밀번호 찾기", RESET))
    write("member/mypage.html", simple_page("내 정보", MYPAGE))
    write("board/view.html", simple_page("게시글", VIEW, wide=True))
    write("board/write.html", simple_page("글쓰기", WRITE, wide=True))
    write("board/search.html", simple_page("자료검색", SEARCH, wide=True))
    n += audit_pages()
    n += regulations_pages()
    write("admin/index.html", simple_page("관리자", ADMIN, wide=True))
    write("admin/members.html", simple_page("회원관리", ADMIN_MEMBERS, wide=True))
    write("admin/events.html", simple_page("일정관리", ADMIN_EVENTS, wide=True))
    write("admin/counsel.html", simple_page("고충상담 관리", ADMIN_COUNSEL, wide=True))
    write("etc/privacy.html", simple_page("개인정보처리방침", PRIVACY))
    write("etc/terms.html", simple_page("이용약관", TERMS))
    print(f"generated {n + 12} pages")

if __name__ == "__main__":
    main()

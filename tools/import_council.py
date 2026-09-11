# -*- coding: utf-8 -*-
"""
그룹웨어 노사협의회 게시판에서 수집한 데이터(data/council_*.json)를
1) 정적 페이지(news/council/<id>.html)  2) Supabase 시드 SQL(supabase/seed_council.sql) 로 변환합니다.
실행: python tools/import_council.py  (build.py 실행 후에 실행)
"""
import json, glob, os, html, re

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(BASE)
GW_URL = "https://gw.gri.re.kr/servlet/HIServlet?SLET=bbs.BBS.java&boardID=0000001ym"

posts = []
for fn in sorted(glob.glob("data/council_*.json")):
    posts += json.load(open(fn, encoding="utf-8"))
seen = set(); uniq = []
for p in posts:
    if p["id"] in seen: continue
    seen.add(p["id"]); uniq.append(p)
posts = sorted(uniq, key=lambda p: (p["date"], p.get("no", 0)), reverse=True)
json.dump(posts, open("data/council_all.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)

# ---------- build.py 의 공통 조각 재사용 ----------
import importlib.util
spec = importlib.util.spec_from_file_location("build", os.path.join(BASE, "build.py"))
b = importlib.util.module_from_spec(spec); spec.loader.exec_module(b)

BOARD_NAME = {"council_minutes": "공고 및 회의록", "council_rules": "노사협의회 운영규약", "council_agenda": "안건 제안"}
def esc(s): return html.escape(s or "")

def att_html(atts):
    if not atts: return ""
    return '<div class="attach box"><b>첨부파일</b><ul class="bul">' + "".join(
        f'<li>&#128206; {esc(a)} <span class="note">— 원문은 그룹웨어에서 내려받을 수 있습니다</span></li>' for a in atts) + "</ul></div>"

def post_page(p, prev_p, next_p):
    root = "../../"
    body = esc(p["body"]).replace("\n", "<br>") if p["body"] else '<span class="note">본문 없이 첨부파일만 게시된 글입니다.</span>'
    nav = ""
    if prev_p: nav += f'<tr><th style="width:90px;text-align:left">이전글</th><td style="text-align:left"><a href="{prev_p["id"]}.html">{esc(prev_p["title"])}</a></td></tr>'
    if next_p: nav += f'<tr><th style="text-align:left">다음글</th><td style="text-align:left"><a href="{next_p["id"]}.html">{esc(next_p["title"])}</a></td></tr>'
    content = f"""
<article class="post">
  <div class="post-head" style="border-bottom:1px solid var(--line);padding-bottom:14px;margin-bottom:20px">
    <span class="badge council" style="font-size:12px;color:#fff;background:#2a9d6f;padding:2px 8px;border-radius:4px">{BOARD_NAME.get(p['board'], '노사협의회')}</span>
    <h4 style="border:0;padding:0;margin:8px 0 6px;color:#222;font-size:24px">{esc(p['title'])}</h4>
    <div class="note">작성자 {esc(p['writer'])} &nbsp;|&nbsp; 게시일 {p['date']} &nbsp;|&nbsp; 그룹웨어 게시번호 {p.get('no', '')}</div>
  </div>
  <div class="post-body" style="min-height:120px;line-height:1.9">{body}</div>
  {att_html(p['atts'])}
  <table class="tbl" style="margin-top:24px">{nav}</table>
  <div class="board-bottom" style="justify-content:space-between"><a href="../council.html" class="btn line">목록</a><a href="{GW_URL}" target="_blank" rel="noopener" class="btn">그룹웨어 원문 보기</a></div>
</article>
"""
    name, tagline, subs = next((n, t, s) for s_, n, t, s in b.MENUS if s_ == "news")
    lnb = "".join(f'<li{" class=\"on\"" if pg == "council" else ""}><a href="{root}news/{pg}.html">{n}</a></li>' for pg, n in subs)
    return b.head(root, p["title"] + " | 노사협의회") + b.header(root, "news") + f"""
<section class="sub-visual"><div class="wrap"><h2>{name}</h2><p>{tagline}</p></div></section>
<div class="crumb"><div class="wrap"><a href="{root}index.html">홈</a><span>{name}</span><span><a href="../council.html">노사협의회</a></span></div></div>
<div class="wrap sub-body">
  <aside class="lnb"><h3>{name}</h3><ul>{lnb}</ul></aside>
  <main class="content"><h3 class="page-title">노사협의회</h3>{content}</main>
</div>
""" + b.footer(root)

os.makedirs("news/council", exist_ok=True)
for i, p in enumerate(posts):
    prev_p = posts[i - 1] if i > 0 else None
    next_p = posts[i + 1] if i + 1 < len(posts) else None
    open(f"news/council/{p['id']}.html", "w", encoding="utf-8").write(post_page(p, prev_p, next_p))

# ---------- 목록 페이지 (news/council.html) 갱신 ----------
rows = []
for i, p in enumerate(posts):
    badge = ' <span title="첨부">&#128206;</span>' if p["atts"] else ""
    tag = {"council_rules": '<span class="badge reg" style="font-size:11px;color:#fff;background:#6c7a99;padding:1px 6px;border-radius:3px">규약</span> ', "council_agenda": '<span class="badge" style="font-size:11px;color:#fff;background:#3a7bd5;padding:1px 6px;border-radius:3px">안건</span> '}.get(p["board"], "")
    rows.append(f'<tr><td class="num">{len(posts) - i}</td><td class="tit">{tag}<a href="council/{p["id"]}.html">{esc(p["title"])}</a>{badge}</td><td class="writer">{esc(p["writer"])}</td><td class="date">{p["date"]}</td><td class="hit">-</td></tr>')

list_html = open("news/council.html", encoding="utf-8").read()
list_html = re.sub(r'<tbody>.*?</tbody>', '<tbody>' + "".join(rows) + '</tbody>', list_html, count=1, flags=re.S)
list_html = list_html.replace('<b class="total">10</b>', f'<b class="total">{len(posts)}</b>')
list_html = re.sub(r'<div class="paging">.*?</div>', '', list_html, count=1, flags=re.S)
list_html = re.sub(r'<p class="note">※ 아래 목록은 예시입니다.*?</p>', '<p class="note">※ 경기연구원 그룹웨어 노사협의회 게시판(공고 및 회의록·운영규약)에서 가져온 자료입니다. 첨부파일 원문은 그룹웨어에서 내려받을 수 있습니다.</p>', list_html, count=1, flags=re.S)
list_html = list_html.replace('<p class="note static-note" style="margin-top:14px">※ Supabase 연결 전에는 예시 목록이 표시됩니다.</p>', '')
list_html = list_html.replace('data-board="council"', 'data-board="council" data-static="1"')
open("news/council.html", "w", encoding="utf-8").write(list_html)

# ---------- 메인 페이지 노사협의회 최신 5건 ----------
idx = open("index.html", encoding="utf-8").read()
latest = "".join(f'<li><span class="badge council">협의회</span><a href="news/council/{p["id"]}.html">{esc(p["title"])}</a><span class="date">{p["date"][5:]}</span></li>' for p in posts[:5])
idx = re.sub(r'(<ul class="list compact" data-latest="council"[^>]*>).*?(</ul>)', lambda m: m.group(1) + latest + m.group(2), idx, count=1, flags=re.S)
open("index.html", "w", encoding="utf-8").write(idx)

# ---------- Supabase 시드 SQL ----------
def sq(s): return "'" + (s or "").replace("'", "''") + "'"
lines = ["-- 그룹웨어 노사협의회 게시판 이관 데이터 (자동 생성: tools/import_council.py)",
         "-- 게시판 코드 council 에 넣습니다. 여러 번 실행해도 중복되지 않습니다.",
         "create unique index if not exists posts_legacy_idx on public.posts ((attachments->>'legacy_id')) where attachments ? 'legacy_id';", ""]
for p in reversed(posts):
    atts = json.dumps({"legacy_id": p["id"], "files": p["atts"], "source": "gw.gri.re.kr " + BOARD_NAME.get(p["board"], "")}, ensure_ascii=False)
    body = p["body"] + ("\n\n[첨부파일]\n" + "\n".join("- " + a for a in p["atts"]) if p["atts"] else "")
    lines.append(f"insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council',{sq(p['title'])},{sq(body)},{sq(p['writer'])},false,{sq(atts)}::jsonb,{sq(p['date'])}::date,{sq(p['date'])}::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = {sq(p['id'])});")
open("supabase/seed_council.sql", "w", encoding="utf-8").write("\n".join(lines))
print(f"posts: {len(posts)}  pages: news/council/*.html  sql: supabase/seed_council.sql")

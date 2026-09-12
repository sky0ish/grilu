# -*- coding: utf-8 -*-
"""
data/gw_posts.json → supabase/seed_gw.sql  (그룹웨어 이관 글의 DB 목록용 요약 글: 본문 전문은 정적 페이지)
  python tools/make_gw_sql.py
여러 번 실행해도 중복되지 않고, 게시판·페이지 경로가 바뀐 글은 update 됩니다. 분석 글(report-*)은 정적 JSON 이므로 제외.
"""
import os, re, json, html
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GW_DIR = {"committee": "gri/committee", "director": "gri/director", "council": "archive/council", "rules": "archive/rules", "news": "news/news", "budget": "gri/budget", "guide": "gri/guide", "documents": "archive/documents", "statement": "news/statement"}
DB_BOARD = {}
def q(s): return "'" + (s or "").replace("'", "''") + "'"
def main():
    posts = json.load(open(os.path.join(ROOT, "data", "gw_posts.json"), encoding="utf-8"))["posts"]
    out = ["-- 그룹웨어 이관 글 (자동 생성: tools/make_gw_sql.py). 여러 번 실행해도 안전합니다.",
           "create unique index if not exists posts_legacy_idx on public.posts ((attachments->>'legacy_id')) where attachments ? 'legacy_id';"]
    n = 0
    for p in posts:
        if p["id"].startswith("report-") or p["code"] not in GW_DIR: continue
        board = DB_BOARD.get(p["code"], p["code"])
        page_rel = f'{GW_DIR[p["code"]]}/{p["id"]}.html'
        page = "https://grilu.kr/" + page_rel
        text = re.sub(r"\s+", " ", p.get("body_text") or "").strip()
        ex = text[:1200] + ("…" if len(text) > 1200 else "")
        files = [a["name"] for a in p.get("atts", [])]
        content = (f'<div class="box" style="margin-bottom:16px"><b>{html.escape(p["sub"])}</b> · 작성자 {html.escape(p["author"])} · 게시일 {p["date"]}<br>'
                   f'<a href="{page}" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div>'
                   f'<p style="line-height:1.8;color:#444">{html.escape(ex)}</p>' + (f'<p class="note">첨부: {html.escape(", ".join(files))}</p>' if files else ""))
        att = json.dumps({"legacy_id": "gw-" + p["id"], "page": page_rel, "files": files, "source": "gw.gri.re.kr " + p["sub"]}, ensure_ascii=False)
        lid = q("gw-" + p["id"])
        out.append(f"insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select {q(board)},{q(p['title'])},{q(content)},{q(p['author'])},false,{q(att)}::jsonb,{q(p['date'])}::date,{q(p['date'])}::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = {lid});")
        out.append(f"update public.posts set board={q(board)}, title={q(p['title'])}, content={q(content)}, attachments={q(att)}::jsonb where attachments->>'legacy_id' = {lid} and (board <> {q(board)} or attachments->>'page' <> {q(page_rel)});")
        n += 1
    open(os.path.join(ROOT, "supabase", "seed_gw.sql"), "w", encoding="utf-8").write("\n".join(out))
    print("seed_gw.sql:", n, "posts")
if __name__ == "__main__":
    main()

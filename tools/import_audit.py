# -*- coding: utf-8 -*-
"""
경기도의회 회의록 시스템(kms.ggc.go.kr) 행정사무감사 트리를 모두 펼쳐
'경기연구원'(구 '경기개발연구원')이 포함된 회의록을 수집합니다.

  python tools/import_audit.py            → data/audit.json, supabase/seed_audit.sql
  python tools/import_audit.py --no-body  → 본문 없이 목록만 (빠름)

수집 대상: 제3대 ~ 제11대 의회 > 각 위원회 > 연도별 행정사무감사 > 회의(일자) 중
          제목에 경기연구원/경기개발연구원 이 들어간 것 (주로 기획재정위원회 소관)
"""
import re, json, sys, os, time, html
import requests

BASE = "https://kms.ggc.go.kr"
TREE = BASE + "/svc/cms/mnts/MntsTreeAuditList.do"
KEYS = ("경기연구원", "경기개발연구원")
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WITH_BODY = "--no-body" not in sys.argv
SQL_ONLY = "--sql-only" in sys.argv

S = requests.Session()
S.headers["User-Agent"] = "Mozilla/5.0 (grilu.kr archive bot)"

def tree(v1, v2="J", v3="", v7=""):
    for _ in range(3):
        try:
            r = S.post(TREE, data={"schVar01": v1, "schVar02": v2, "schVar03": v3, "schVar07": v7}, timeout=30)
            r.encoding = "utf-8"
            return r.text
        except Exception as e:
            print("  retry", e); time.sleep(2)
    return ""

def links(h):
    """트리 영역의 goMntsTreeAuditPage 노드와 회의록 leaf 를 돌려준다"""
    i = h.find('id="browser"')
    seg = h[i:] if i >= 0 else h
    nodes = [(m.group(1), m.group(2), m.group(3), m.group(4), html.unescape(m.group(5)).strip())
             for m in re.finditer(r"goMntsTreeAuditPage\('([^']*)','([^']*)','([^']*)','([^']*)'\);\"[^>]*>\s*([^<]+)<", seg)]
    leaves = [(m.group(1), html.unescape(m.group(2)).strip())
              for m in re.finditer(r'mntsViewer\.do\?mntsId=(\d+)"[^>]*>\s*([^<]+)<', seg)]
    return nodes, leaves

def clean_body(h):
    """회의록 뷰어에서 본문(mntshtmlviewer)만 추려 단순 HTML 로"""
    m = re.search(r'<div[^>]+(?:id|class)="mntshtmlviewer"[^>]*>', h)
    if not m: return ""
    start = m.end()
    end = h.find('<div class="contentbottom"', start)
    if end < 0: end = h.find('id="contentbottom"', start)
    body = h[start:end if end > 0 else start + 400000]
    body = re.sub(r"<script.*?</script>", "", body, flags=re.S)
    body = re.sub(r"<span class='PV\d+'>(.*?)</span>", r"\1", body, flags=re.S)      # 발언자 이름 span
    body = re.sub(r"<span class='bold'>(.*?)</span>", r"<b>\1</b>", body, flags=re.S)  # 발언자 표기
    body = re.sub(r"<span[^>]*>|</span>", "", body)
    body = re.sub(r"<div[^>]*>|</div>", "", body)
    body = re.sub(r"<a [^>]*>|</a>", "", body)
    body = re.sub(r"<p class='em(\d)'>", lambda m: f'<p style="padding-left:{int(m.group(1))*1.2}em">', body)
    body = re.sub(r"\n\s*\n+", "\n", body)
    return body.strip()

def fetch_body(mid):
    try:
        r = S.get(f"{BASE}/cms/mntsViewer.do?mntsId={mid}", timeout=60); r.encoding = "utf-8"
        return clean_body(r.text)
    except Exception as e:
        print("  body fail", mid, e); return ""

def main():
    if SQL_ONLY:
        found = json.load(open(os.path.join(ROOT, "data", "audit.json"), encoding="utf-8")); return write_sql(found)
    found = []
    seen = set()
    r = S.get(TREE, timeout=30); r.encoding = "utf-8"
    top, _ = links(r.text)
    daesus = sorted({(n[0], n[4]) for n in top if n[1] == "J" and n[0] and not n[2] and not n[3]}, key=lambda x: -int(x[0]))
    print("의회 대수:", [d[0] for d in daesus])
    for daesu, dname in daesus:
        h = tree(daesu)
        nodes, _ = links(h)
        comms = [(n[3], n[4]) for n in nodes if n[0] == daesu and n[3] and not n[2]]
        if not comms:  # 위원회 계층이 없는 경우(연도 바로) 처리
            comms = [("", "")]
        print(f"제{daesu}대: 위원회 {len(comms)}개")
        for ccode, cname in comms:
            h = tree(daesu, "J", "", ccode)
            nodes, leaves0 = links(h)
            years = [(n[2], n[4]) for n in nodes if n[0] == daesu and n[3] == ccode and n[2]]
            year_pages = [(y, yname, tree(daesu, "J", y, ccode)) for y, yname in years] or [("", "", h)]
            for y, yname, hh in year_pages:
                _, leaves = links(hh)
                for mid, title in leaves:
                    if mid in seen: continue
                    if not any(k in title for k in KEYS): continue
                    seen.add(mid)
                    dm = re.search(r"(\d{4})\.(\d{1,2})\.(\d{1,2})", title)
                    date = f"{dm.group(1)}-{int(dm.group(2)):02d}-{int(dm.group(3)):02d}" if dm else (y + "-11-01" if y else "")
                    rec = {"id": mid, "daesu": daesu, "committee": cname, "year": y or dm.group(1) if dm or y else "",
                           "audit": yname, "title": title, "date": date,
                           "url": f"{BASE}/cms/mntsViewer.do?mntsId={mid}", "body": ""}
                    print(f"  + [{daesu}대 {cname} {y}] {title}")
                    found.append(rec)
                time.sleep(0.3)
    found.sort(key=lambda r: r["date"], reverse=True)
    print("총", len(found), "건")
    if WITH_BODY:
        for i, r in enumerate(found):
            r["body"] = fetch_body(r["id"]); print(f"  본문 {i+1}/{len(found)} {r['id']} {len(r['body'])}자")
            time.sleep(0.5)
    os.makedirs(os.path.join(ROOT, "data"), exist_ok=True)
    json.dump(found, open(os.path.join(ROOT, "data", "audit.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)

    write_sql(found)

def write_sql(found):
    def q(s): return "'" + (s or "").replace("'", "''") + "'"
    out = ["-- 경기도의회 행정사무감사 회의록(경기연구원 관련) 이관 데이터 (자동 생성: tools/import_audit.py)",
           "-- 게시판 코드 audit. 여러 번 실행해도 중복되지 않습니다.",
           "insert into public.boards (code,name,members_only,admin_only_write) values ('audit','행정사무감사',false,true) on conflict (code) do nothing;",
           "create unique index if not exists posts_legacy_idx on public.posts ((attachments->>'legacy_id')) where attachments ? 'legacy_id';"]
    def excerpt(body, n=1200):
        t = re.sub(r"<[^>]+>", " ", body or ""); t = re.sub(r"\s+", " ", t).strip()
        k = t.find("경기연구원") if "경기연구원" in t else t.find("경기개발연구원")
        st = max(0, k - 200) if k > 0 else 0
        return ("…" if st else "") + t[st:st + n] + ("…" if len(t) > st + n else "")
    for r in found:
        page = f'https://grilu.kr/gri/audit/{r["id"]}.html'
        content = (f'<div class="box" style="margin-bottom:16px"><b>제{r["daesu"]}대 경기도의회 {r["committee"]}</b> · {r["audit"]}<br>'
                   f'<a href="{page}" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 회의록 전문 보기</a> &nbsp;|&nbsp; '
                   f'<a href="{r["url"]}" target="_blank" rel="noopener" style="color:var(--primary);text-decoration:underline">경기도의회 원문</a></div>'
                   f'<p style="line-height:1.8;color:#444">{html.escape(excerpt(r["body"]))}</p>')
        att = json.dumps({"legacy_id": "audit-" + r["id"], "files": [], "source": "kms.ggc.go.kr 행정사무감사", "url": r["url"], "page": page}, ensure_ascii=False)
        title = f'{r["title"]} — {r["committee"]} {r["audit"].split("(")[0].strip()}'
        out.append(f"insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) "
                   f"select 'audit',{q(title)},{q(content)},'경기도의회',false,{q(att)}::jsonb,{q(r['date'] or '2000-01-01')}::date,{q(r['date'] or '2000-01-01')}::date "
                   f"where not exists (select 1 from public.posts where attachments->>'legacy_id' = {q('audit-' + r['id'])});")
    open(os.path.join(ROOT, "supabase", "seed_audit.sql"), "w", encoding="utf-8").write("\n".join(out))
    print("written: data/audit.json, supabase/seed_audit.sql")

if __name__ == "__main__":
    main()

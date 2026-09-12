# -*- coding: utf-8 -*-
"""행정사무감사 회의록마다 경기연구원 관련 핵심 안건(주제어) 4개를 뽑아 data/audit.json 의 topics 에 저장하고,
   제목에 붙일 수 있게 supabase/audit_titles.sql 을 만듭니다.  실행: python tools/audit_topics.py (make_audit_report.py 의 TOPICS 사용)"""
import os, re, json, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "tools"))
os.environ["AUDIT_TOPICS_ONLY"] = "1"
from make_audit_report import TOPICS, sents, FLAG   # noqa
P = os.path.join(ROOT, "data", "audit.json")
audit = json.load(open(P, encoding="utf-8"))
# 너무 일반적인 주제어는 제외
SKIP = {"자료", "보고서", "효율", "절차", "규정", "협약", "책임", "공개", "객관성", "시스템"}
def title_with(r):
    base = f'{r["title"]} — {r["committee"]} {r["audit"].split("(")[0].strip()}'
    return base + (" · 핵심: " + "·".join(r["topics"]) if r.get("topics") else "")
def q(s): return "'" + s.replace("'", "''") + "'"
out = ["-- 행정사무감사 글 제목에 핵심 안건 붙이기 (자동 생성: tools/audit_topics.py)"]
for r in audit:
    ss = sents(r.get("body", ""))
    flagged = [s for s in ss if FLAG.search(s)]
    score = []
    for content, memo, pat, word in TOPICS:
        if word in SKIP: continue
        p = re.compile(pat)
        n = sum(1 for s in flagged if p.search(s))
        if n >= 2: score.append((n, word))
    score.sort(key=lambda x: -x[0])
    r["topics"] = [w for n, w in score[:4]]
    out.append(f"update public.posts set title={q(title_with(r))} where attachments->>'legacy_id' = {q('audit-' + r['id'])};")
    print(r["date"], r["topics"])
json.dump(audit, open(P, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
open(os.path.join(ROOT, "supabase", "audit_titles.sql"), "w", encoding="utf-8").write("\n".join(out))
print("ok")

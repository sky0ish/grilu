# -*- coding: utf-8 -*-
"""국가법령정보센터(law.go.kr)에서 노동관계법령의 시행일·개정일을 가져와 data/laws.json 에 저장. 실행: python tools/import_laws.py"""
import requests, re, html, json, os
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LAWS = ["노동조합 및 노동관계조정법", "근로기준법", "근로자참여 및 협력증진에 관한 법률", "남녀고용평등과 일·가정 양립 지원에 관한 법률",
        "산업안전보건법", "지방자치단체 출자·출연 기관의 운영에 관한 법률", "공공기관의 운영에 관한 법률", "근로자퇴직급여 보장법", "최저임금법", "고용보험법"]
S = requests.Session(); S.headers["User-Agent"] = "Mozilla/5.0 (grilu.kr)"
out = []
for name in LAWS:
    r = S.get("https://www.law.go.kr/법령/" + name, timeout=30)
    m = re.search(r'src="([^"]*lsInfoP\.do[^"]*)"', r.text)
    if not m: print("skip", name); continue
    src = html.unescape(m.group(1))
    t = re.sub(r"\s+", " ", re.sub(r"<[^>]+>", " ", S.get("https://www.law.go.kr" + src, timeout=30).text))
    sh = re.search(r"\[시행\s*(\d{4}\.\s*\d{1,2}\.\s*\d{1,2}\.)\]\s*\[법률\s*제(\d+)호,\s*(\d{4}\.\s*\d{1,2}\.\s*\d{1,2}\.),\s*([가-힣]+)\]", t)
    print(name, sh.groups() if sh else "?")
    out.append((name, src, list(sh.groups()) if sh else None))
json.dump(out, open(os.path.join(ROOT, "data", "laws.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)

# -*- coding: utf-8 -*-
# 일정캘린더·회의자료 게시판에 올린 첨부(Supabase Storage)를 21.회의자료_Data 폴더에 내려받아 보관합니다.
# 실행: python tools/pull_event_files.py
import os, json, requests, re
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
URL = "https://ryyvwpkhlqbcsjbttxca.supabase.co"; KEY = "sb_publishable_-gj-jLFfB9L5yqlboJAD5A_Y-shrQI0"
OUT = os.path.join(ROOT, "21.회의자료_Data"); os.makedirs(OUT, exist_ok=True)
H = {"apikey": KEY, "Authorization": "Bearer " + KEY}
def safe(n): return re.sub(r'[\/:*?"<>|]', "_", n)
n = 0
for src, q in [("events", f"{URL}/rest/v1/events?select=id,date,title,attachments"), ("delegate", f"{URL}/rest/v1/posts?board=eq.delegate&select=id,created_at,title,attachments")]:
    for row in requests.get(q, headers=H, timeout=30).json():
        atts = row.get("attachments") or []
        if not isinstance(atts, list): continue
        d = (row.get("date") or row.get("created_at") or "")[:10]
        for a in atts:
            if not a.get("url"): continue
            fn = f"{d}_{safe(row.get('title') or '')[:40]}_{safe(a['name'])}"
            p = os.path.join(OUT, fn)
            if os.path.exists(p): continue
            r = requests.get(a["url"], timeout=120)
            if r.ok: open(p, "wb").write(r.content); n += 1; print("+", fn)
print(f"새로 받은 파일 {n}개 → 21.회의자료_Data")

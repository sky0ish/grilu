# -*- coding: utf-8 -*-
"""
경기도의회 회의록(kms.ggc.go.kr) 색인어검색으로 '경기연구원'/'경기개발연구원' 이 본문에 한 번이라도
언급된 모든 회의록(제3대~제12대, 본회의·상임위·특위·예결위·행정사무감사·인사청문회 등)을 수집합니다.

  python tools/import_assembly.py            → 검색 + 본문 수집(캐시) + data/assembly.json, data/assembly/<id>.json
  python tools/import_assembly.py --no-fetch → 캐시된 본문만으로 재생성

회의록 1건이 평균 280KB(2,600여 건 = 700MB)라 사이트에는 경기연구원이 언급된 발언 부분(앞뒤 2문단)만
발췌해 싣고, 경기연구원이 30회 이상 언급되거나 경기연구원장 인사청문회처럼 경기연구원이 주제인
회의는 전문을 싣습니다. 행정사무감사 게시판(audit)에 이미 있는 회의록은 제외합니다.
"""
import re, json, sys, os, time, html
import requests

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "tools"))
from import_audit import clean_body
BASE = "https://kms.ggc.go.kr"
LIST = BASE + "/svc/cms/mnts/MntsKeywordList.do"
KEYS = ("경기연구원", "경기개발연구원")
CACHE = os.environ.get("ASSEMBLY_CACHE") or os.path.join(os.environ.get("LOCALAPPDATA") or os.path.expanduser("~"), "grilu", "assembly_cache")   # 본문 원문 캐시 (700MB, 저장소/드라이브 밖)
FETCH = "--no-fetch" not in sys.argv
FULL_MIN = 30      # 이 횟수 이상 언급되면 전문 수록
CTX = 2            # 발췌 시 앞뒤 문단 수

S = requests.Session(); S.headers["User-Agent"] = "Mozilla/5.0 (grilu.kr archive bot)"

def parse_list(h):
    hid = dict(re.findall(r'<input type="hidden" name="(\w+)"\s+value="([^"]*)"', h))
    items = re.findall(r'<span class="subject">(.*?)</span>.*?goMntsViewerPage\(\'(\d+)\'\);[^>]*>(.*?)</a>', h, re.S)
    return hid, [(i, re.sub(r"\s+", " ", sub).strip(), re.sub(r"<[^>]+>", "", re.sub(r"\s+", " ", snip)).strip()) for sub, i, snip in items]

def search_all():
    S.get(BASE + "/svc/cms/mnts/MntsKeyword.do", timeout=30)
    out = {}
    for key in KEYS:
        for gn in range(12, 2, -1):
            r = S.post(LIST, data={"schVar01": str(gn), "schVar07": key}, timeout=60)
            hid, items = parse_list(r.text); tot = int(hid.get("schTotalPage") or 0)
            pages = [items]
            for pn in range(2, tot + 1):
                g = dict(hid); g["schPageNo"] = str(pn)
                for _ in range(3):
                    try: r = S.get(LIST, params=g, timeout=60); break
                    except Exception: time.sleep(2)
                pages.append(parse_list(r.text)[1])
            n = 0
            for its in pages:
                for mid, sub, snip in its:
                    out.setdefault(mid, {"id": mid, "subject": sub, "gen": gn, "snips": []})["snips"].append(snip); n += 1
            print(f"{key} 제{gn}대: {n}건 (누적 {len(out)})", flush=True)
    return list(out.values())

def fetch_body(mid):
    p = os.path.join(CACHE, mid + ".html")
    if os.path.exists(p): return open(p, encoding="utf-8").read()
    for _ in range(3):
        try:
            r = S.get(f"{BASE}/cms/mntsViewer.do?mntsId={mid}", timeout=90); r.encoding = "utf-8"
            b = clean_body(r.text)
            os.makedirs(CACHE, exist_ok=True); open(p, "w", encoding="utf-8").write(b); return b
        except Exception as e:
            print("  retry", mid, e); time.sleep(3)
    return ""

def strip(h): return re.sub(r"\s+", " ", html.unescape(re.sub(r"<[^>]+>", " ", h or ""))).strip()

def paragraphs(body):
    ps = re.findall(r"<p\b[^>]*>.*?</p>", body, re.S)
    if len(ps) >= 3: return ps
    return [f"<p>{x}</p>" for x in re.split(r"\n+|<br\s*/?>", body) if x.strip()]

def excerpt(body):
    ps = paragraphs(body)
    hit = [i for i, p in enumerate(ps) if any(k in p for k in KEYS)]
    if not hit: return "", 0
    spans = []
    for i in hit:
        a, b = max(0, i - CTX), min(len(ps), i + CTX + 1)
        if spans and a <= spans[-1][1]: spans[-1][1] = max(spans[-1][1], b)
        else: spans.append([a, b])
    out = []
    for n, (a, b) in enumerate(spans):
        if n: out.append('<p class="note" style="text-align:center;color:#999;margin:14px 0">… (중략) …</p>')
        out.extend(ps[a:b])
    return "\n".join(out), len(spans)

def meta_of(rec, body):
    t = strip(body[:3000])
    sub = strip(rec["subject"])
    rec["subject"] = sub
    dm = re.search(r"(\d{4})\.(\d{1,2})\.(\d{1,2})", sub)
    date = f"{dm.group(1)}-{int(dm.group(2)):02d}-{int(dm.group(3)):02d}" if dm else ""
    meeting = re.sub(r"\(\d{4}\.\d{1,2}\.\d{1,2}\.?\s*[가-힣]*\)", "", sub).strip()
    hearing = "인사청문" in sub
    kind = "인사청문회" if hearing else "행정사무감사" if "행정사무감사" in sub else "행정사무조사" if "행정사무조사" in sub \
        else "본회의" if "본회의" in sub else "예결특위" if "예산결산" in sub else "특별위원회" if "특별위원회" in sub else "상임위원회"
    if hearing:
        org = re.search(r"인사청문(?:특별위원회|위원회 회의록|회 회의록)\s*\(([^)]{2,40})\)", t)
        m = re.search(r"의사일정\s*1\.\s*(.{2,70}?(?:인사청문회|인사청문의 건|인사청문))", t)
        if m and "위원장 선임" not in m.group(1):
            name = re.sub(r"에 대한 인사청문(의 건)?$", " 인사청문회", m.group(1).strip())
            name = re.sub(r"[「『」』]", "", name)
        elif org:
            name = org.group(1).strip() + (" 인사청문특별위원회 (위원장 선임)" if m and "위원장 선임" in m.group(1) else " 인사청문회")
        else:
            name = meeting
        title = f"인사청문회 _ {name} _ {date}"
    else:
        title = f"경기도의회 회의록 _ {date} _ {meeting}"
    return date, meeting, kind, title

def main():
    hits_p = os.path.join(CACHE, "kw_hits.json")
    if FETCH or not os.path.exists(hits_p):
        hits = search_all(); os.makedirs(CACHE, exist_ok=True)
        json.dump(hits, open(hits_p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    else:
        hits = json.load(open(hits_p, encoding="utf-8"))
    try: audit_ids = {r["id"] for r in json.load(open(os.path.join(ROOT, "data", "audit.json"), encoding="utf-8"))}
    except Exception: audit_ids = set()
    from keywords import extract, speakers_of
    # 이미 수집된 회의록(data/assembly_body.json)은 캐시가 없어도 재사용 → 매일 새 회의록만 추가 수집
    BODY_DIR = os.path.join(ROOT, "data", "assembly"); os.makedirs(BODY_DIR, exist_ok=True)
    try:
        old_meta = {r["id"]: r for r in json.load(open(os.path.join(ROOT, "data", "assembly.json"), encoding="utf-8"))}
    except Exception:
        old_meta = {}
    old_bodies = {f[:-5] for f in os.listdir(BODY_DIR) if f.endswith(".json")}
    meta, bodies = [], {}
    for n, rec in enumerate(hits):
        if rec["id"] in audit_ids: continue
        cached = os.path.exists(os.path.join(CACHE, rec["id"] + ".html"))
        if rec["id"] in old_meta and rec["id"] in old_bodies and not cached:
            meta.append(old_meta[rec["id"]]); continue
        body = fetch_body(rec["id"]) if (FETCH or cached) else ""
        if not body: print("  본문 없음", rec["id"], rec["subject"]); continue
        text = strip(body)
        cnt = sum(text.count(k) for k in KEYS)
        date, meeting, kind, title = meta_of(rec, body)
        about = cnt >= FULL_MIN or (kind == "인사청문회" and "경기연구원" in title)
        ex, nspan = excerpt(body)
        shown = body if about else ex
        kw = extract(shown, speakers_of(shown), top=20)
        meta.append({"id": rec["id"], "gen": rec["gen"], "subject": rec["subject"], "meeting": meeting, "kind": kind, "date": date,
                     "title": title, "n": cnt, "full": about, "url": f"{BASE}/cms/mntsViewer.do?mntsId={rec['id']}",
                     "k": [w for w, c, s_ in kw.get("top") or []]})
        json.dump({"html": shown, "keywords": kw, "spans": nspan}, open(os.path.join(BODY_DIR, rec["id"] + ".json"), "w", encoding="utf-8"), ensure_ascii=False)
        if n % 100 == 0: print(f"  {n}/{len(hits)} {title} (언급 {cnt}회{', 전문' if about else ''})", flush=True)
    meta.sort(key=lambda r: (r["date"], r["id"]), reverse=True)
    json.dump(meta, open(os.path.join(ROOT, "data", "assembly.json"), "w", encoding="utf-8"), ensure_ascii=False, separators=(",", ":"))
    keep = {r["id"] for r in meta}
    for f in os.listdir(BODY_DIR):
        if f.endswith(".json") and f[:-5] not in keep: os.remove(os.path.join(BODY_DIR, f))
    full = sum(1 for r in meta if r["full"])
    print(f"총 {len(meta)}건 (전문 {full}건, 발췌 {len(meta) - full}건), 행감 게시판 중복 제외 {len(audit_ids & {h['id'] for h in hits})}건")

if __name__ == "__main__":
    main()

# -*- coding: utf-8 -*-
"""
빅카인즈(bigkinds.or.kr) 뉴스 검색 결과를 가져와 data/othernews.json 에 누적 저장합니다.
- 키워드: KEYWORDS (여러 개)
- 저장 항목: 제목 · 언론사 · 날짜 · 원문 링크 · 요약(기사 앞부분 900자) · 검색 키워드
  (저작권상 기사 전문은 저장하지 않고 원문 링크로 연결합니다)
- 실행: python tools/fetch_news.py [--days 30]
- GitHub Actions(.github/workflows/news.yml) 가 매일 실행해 커밋합니다.
"""
import os, sys, json, re, datetime, time, html
import requests

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "data", "othernews.json")
KEYWORDS = ["경기도 산하기관 노조", "경기도 공공기관 노조", "경기연구원 노조"]
DAYS = int(sys.argv[sys.argv.index("--days") + 1]) if "--days" in sys.argv else 30
KEEP = 500          # 최대 보관 건수
SUMMARY_LEN = 900

S = requests.Session()
S.headers.update({
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0 Safari/537.36",
    "Accept": "application/json, text/javascript, */*; q=0.01", "Accept-Language": "ko-KR,ko;q=0.9",
    "X-Requested-With": "XMLHttpRequest", "Referer": "https://www.bigkinds.or.kr/v2/news/search.do", "Origin": "https://www.bigkinds.or.kr",
})

def clean(t):
    t = html.unescape(re.sub(r"<br\s*/?>", " ", t or ""))
    t = re.sub(r"<[^>]+>", " ", t)
    t = re.sub(r"\[[^\]]{0,40}(사진|기자|=)[^\]]{0,40}\]", " ", t)   # [사진=경기도] 같은 캡션 제거
    return re.sub(r"\s+", " ", t).strip()

def search(keyword, start, end, page=1, n=50):
    body = {"indexName": "news", "searchKey": keyword, "searchKeys": [{}], "byLine": "", "searchFilterType": "1", "searchScopeType": "1",
            "searchSortType": "date", "sortMethod": "date", "mainTodayPersonYn": "N", "startDate": str(start), "endDate": str(end),
            "newsIds": [], "categoryCodes": [], "providerCodes": [], "incidentCodes": [], "networkNodeType": "", "topicOrigin": "",
            "dateCodes": [], "editorialIs": False, "startNo": page, "resultNumber": n, "isTmUsable": False, "isNotTmUsable": False}
    for attempt in range(3):
        try:
            r = S.post("https://www.bigkinds.or.kr/api/news/search.do", data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
                       headers={"Content-Type": "application/json;charset=UTF-8"}, timeout=60)
            j = r.json()
            return j.get("totalCount", 0), j.get("resultList") or []
        except Exception as e:
            print("  retry", attempt, e); time.sleep(3)
    return 0, []

def main():
    S.get("https://www.bigkinds.or.kr/v2/news/search.do", timeout=30)   # 세션 쿠키
    old = []
    if os.path.exists(OUT):
        old = json.load(open(OUT, encoding="utf-8"))
    items = {it["id"]: it for it in old}
    today = datetime.date.today(); start = today - datetime.timedelta(days=DAYS)
    added = 0
    for kw in KEYWORDS:
        page = 1
        while True:
            total, rs = search(kw, start, today, page)
            if page == 1: print(f"[{kw}] {start}~{today}: {total}건")
            if not rs: break
            for it in rs:
                nid = it.get("NEWS_ID")
                if not nid: continue
                d = it.get("DATE", "")
                rec = {"id": nid, "title": clean(it.get("TITLE")), "provider": it.get("PROVIDER", ""),
                       "date": f"{d[:4]}-{d[4:6]}-{d[6:8]}" if len(d) >= 8 else d,
                       "url": it.get("PROVIDER_LINK_PAGE") or f"https://www.bigkinds.or.kr/v2/news/newsDetailView.do?newsId={nid}",
                       "summary": clean(it.get("CONTENT"))[:SUMMARY_LEN], "byline": clean(it.get("BYLINE")).split("\n")[0][:40],
                       "keywords": sorted(set((items.get(nid, {}).get("keywords") or []) + [kw]))}
                if nid not in items: added += 1
                items[nid] = rec
            if page * 50 >= total or page >= 6: break
            page += 1; time.sleep(1)
    merged = sorted(items.values(), key=lambda x: (x["date"], x["id"]), reverse=True)[:KEEP]
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    json.dump(merged, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    print(f"신규 {added}건, 총 {len(merged)}건 → data/othernews.json")

if __name__ == "__main__":
    main()

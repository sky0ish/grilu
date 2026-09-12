# -*- coding: utf-8 -*-
"""
구글 캘린더 [GRILU] (공개 iCal 주소) → data/gcal.json
  python tools/fetch_gcal.py
설정: 구글 캘린더 > GRILU 캘린더 설정 > '일정 액세스 권한' 공개로 설정 > '캘린더 통합' 의 'iCal 형식의 공개 주소' 를
      아래 ICS_URL 에 넣거나 환경변수 GRILU_ICS_URL 로 넘깁니다. 2026-09-01 이후 일정만 가져옵니다.
"""
import os, re, json, sys, datetime as dt
import requests

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ICS_URL = os.environ.get("GRILU_ICS_URL") or "https://calendar.google.com/calendar/ical/ceua1ql1ql0cqsb4fqt9jvk44c%40group.calendar.google.com/public/basic.ics"   # 구글 캘린더 [GRILU] 공개 iCal 주소
SINCE = "2026-09-01"
OUT = os.path.join(ROOT, "data", "gcal.json")

def unfold(text):
    return re.sub(r"\r?\n[ \t]", "", text)

def parse(text):
    out = []
    for block in re.findall(r"BEGIN:VEVENT(.*?)END:VEVENT", unfold(text), re.S):
        f = {}
        for line in block.strip().splitlines():
            if ":" not in line: continue
            k, v = line.split(":", 1)
            name = k.split(";")[0].upper()
            f[name] = (k, v.strip())
        if "DTSTART" not in f or "SUMMARY" not in f: continue
        def day(key):
            k, v = f[key]
            m = re.match(r"(\d{4})(\d{2})(\d{2})(?:T(\d{2})(\d{2})(\d{2})(Z?))?", v)
            if not m: return None, ""
            d = dt.datetime(int(m.group(1)), int(m.group(2)), int(m.group(3)), int(m.group(4) or 0), int(m.group(5) or 0))
            allday = m.group(4) is None
            if not allday and m.group(7) == "Z": d = d + dt.timedelta(hours=9)      # UTC → KST
            return d, ("" if allday else f"{d.hour:02d}:{d.minute:02d}"), allday
        s = day("DTSTART"); e = day("DTEND") if "DTEND" in f else s
        if not s[0]: continue
        sd, st, allday = s; ed, et, _ = e
        end_date = ed - dt.timedelta(days=1) if allday and ed > sd else ed        # 종일 일정의 DTEND 는 다음날
        if end_date < sd: end_date = sd
        rec = {"uid": f.get("UID", ("", ""))[1], "date": sd.strftime("%Y-%m-%d"), "end": end_date.strftime("%Y-%m-%d"),
               "time": (st + ("~" + et if et and et != st else "")) if not allday else "",
               "title": f["SUMMARY"][1].replace("\,", ",").replace("\n", " "),
               "place": f.get("LOCATION", ("", ""))[1].replace("\,", ","),
               "desc": f.get("DESCRIPTION", ("", ""))[1].replace("\n", "\n").replace("\,", ",")}
        if rec["date"] < SINCE and rec["end"] < SINCE: continue
        if "RRULE" in f: rec["rrule"] = f["RRULE"][1]      # 반복 일정은 첫 회만 (필요 시 확장)
        out.append(rec)
    out.sort(key=lambda r: (r["date"], r["time"]))
    return out

def main():
    if not ICS_URL:
        print("ICS_URL 이 비어 있습니다. 구글 캘린더 [GRILU]의 공개 iCal 주소를 설정하세요."); return
    r = requests.get(ICS_URL, timeout=60); r.raise_for_status()
    items = parse(r.text)
    json.dump(items, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    print(f"gcal: {len(items)}건 → data/gcal.json")

if __name__ == "__main__":
    main()

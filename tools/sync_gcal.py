# -*- coding: utf-8 -*-
"""
구글 캘린더 [GRILU] ↔ 홈페이지 일정 양방향 동기화 (GitHub Actions 에서 30분마다)

  ① 홈페이지 일정(Supabase events, 관리자 누구나 쓴 것) → 구글 캘린더 [GRILU] 에 추가·수정·삭제
  ② 구글 캘린더 [GRILU] 의 일정(홈페이지에서 올라간 것은 제외) → data/gcal.json (홈페이지 달력에 표시)

준비 (한 번만, 캘린더 주인이):
  1. https://console.cloud.google.com → 프로젝트 → "API 및 서비스 > 라이브러리" 에서 Google Calendar API 사용 설정
  2. "IAM 및 관리자 > 서비스 계정" → 서비스 계정 만들기 → 키(JSON) 만들기 → 내려받기
  3. 구글 캘린더 → GRILU 캘린더 설정 → "특정 사용자와 공유" 에 서비스 계정 이메일(...@...iam.gserviceaccount.com)을
     "일정 변경 권한" 으로 추가
  4. GitHub 저장소 Settings > Secrets and variables > Actions > New repository secret
     이름 GCAL_SA_JSON, 값 = 내려받은 JSON 파일 내용 전체
서비스 계정 키가 없으면 공개 iCal 주소(tools/fetch_gcal.py)로 읽기만 합니다.
"""
import os, re, json, sys, time, datetime as dt
import requests

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CAL_ID = os.environ.get("GRILU_GCAL_ID") or "ceua1ql1ql0cqsb4fqt9jvk44c@group.calendar.google.com"
SA_JSON = os.environ.get("GCAL_SA_JSON") or ""
SB_URL = "https://ryyvwpkhlqbcsjbttxca.supabase.co"
SB_KEY = os.environ.get("SUPABASE_ANON_KEY") or "sb_publishable_-gj-jLFfB9L5yqlboJAD5A_Y-shrQI0"
SINCE = "2026-09-01"
OUT = os.path.join(ROOT, "data", "gcal.json")
TZ = "Asia/Seoul"
API = "https://www.googleapis.com/calendar/v3"

def sa_token():
    """서비스 계정 JWT → access token (외부 라이브러리 없이)"""
    import base64, hashlib
    from cryptography.hazmat.primitives import hashes, serialization
    from cryptography.hazmat.primitives.asymmetric import padding
    sa = json.loads(SA_JSON)
    now = int(time.time())
    hdr = base64.urlsafe_b64encode(json.dumps({"alg": "RS256", "typ": "JWT"}).encode()).rstrip(b"=")
    claim = base64.urlsafe_b64encode(json.dumps({"iss": sa["client_email"], "scope": "https://www.googleapis.com/auth/calendar",
                                                 "aud": "https://oauth2.googleapis.com/token", "iat": now, "exp": now + 3600}).encode()).rstrip(b"=")
    msg = hdr + b"." + claim
    key = serialization.load_pem_private_key(sa["private_key"].encode(), password=None)
    sig = base64.urlsafe_b64encode(key.sign(msg, padding.PKCS1v15(), hashes.SHA256())).rstrip(b"=")
    r = requests.post("https://oauth2.googleapis.com/token", data={"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer", "assertion": (msg + b"." + sig).decode()}, timeout=30)
    r.raise_for_status(); return r.json()["access_token"]

def site_events():
    r = requests.get(f"{SB_URL}/rest/v1/events?select=*&order=date", headers={"apikey": SB_KEY, "Authorization": "Bearer " + SB_KEY}, timeout=30)
    r.raise_for_status(); return r.json()

def to_gevent(e):
    """홈페이지 일정 → 구글 일정 본문"""
    date, end = e["date"], e.get("end_date") or e["date"]
    time_m = re.match(r"(\d{1,2}):(\d{2})\s*(?:[~\-]\s*(\d{1,2}):(\d{2}))?", e.get("time") or "")
    body = {"summary": e["title"], "location": e.get("place") or "", "description": (e.get("description") or "") +
            ("\n\n첨부: " + ", ".join(a.get("name", "") for a in (e.get("attachments") or [])) if e.get("attachments") else "") +
            "\n\n(grilu.kr 노동조합 일정)", "extendedProperties": {"private": {"grilu_id": str(e["id"])}}}
    if time_m:
        sh, sm = int(time_m.group(1)), int(time_m.group(2))
        eh, em = (int(time_m.group(3)), int(time_m.group(4))) if time_m.group(3) else ((sh + 1) % 24, sm)
        body["start"] = {"dateTime": f"{date}T{sh:02d}:{sm:02d}:00", "timeZone": TZ}
        body["end"] = {"dateTime": f"{end}T{eh:02d}:{em:02d}:00", "timeZone": TZ}
    else:
        nxt = (dt.date.fromisoformat(end) + dt.timedelta(days=1)).isoformat()
        body["start"] = {"date": date}; body["end"] = {"date": nxt}
    return body

def push(token):
    H = {"Authorization": "Bearer " + token}
    # 구글에 이미 올라간 홈페이지 일정 (grilu_id 로 식별)
    have = {}; page = None
    while True:
        params = {"privateExtendedProperty": "grilu_src=site", "maxResults": 2500, "showDeleted": "false", "singleEvents": "true"}
        if page: params["pageToken"] = page
        r = requests.get(f"{API}/calendars/{CAL_ID}/events", headers=H, params=params, timeout=60); r.raise_for_status()
        j = r.json()
        for it in j.get("items", []):
            gid = ((it.get("extendedProperties") or {}).get("private") or {}).get("grilu_id")
            if gid: have[gid] = it
        page = j.get("nextPageToken")
        if not page: break
    site = {str(e["id"]): e for e in site_events() if (e.get("end_date") or e["date"]) >= SINCE}
    n_add = n_upd = n_del = 0
    for sid, e in site.items():
        body = to_gevent(e); body["extendedProperties"]["private"]["grilu_src"] = "site"
        if sid in have:
            cur = have[sid]
            same = cur.get("summary") == body["summary"] and cur.get("location", "") == body["location"] and cur.get("start") == body["start"] and cur.get("end") == body["end"] and cur.get("description", "") == body["description"]
            if not same:
                requests.put(f"{API}/calendars/{CAL_ID}/events/{cur['id']}", headers=H, json=body, timeout=30).raise_for_status(); n_upd += 1
        else:
            requests.post(f"{API}/calendars/{CAL_ID}/events", headers=H, json=body, timeout=30).raise_for_status(); n_add += 1
    for sid, it in have.items():
        if sid not in site:
            requests.delete(f"{API}/calendars/{CAL_ID}/events/{it['id']}", headers=H, timeout=30); n_del += 1
    print(f"구글 캘린더 반영: 추가 {n_add}, 수정 {n_upd}, 삭제 {n_del}")

def pull(token):
    H = {"Authorization": "Bearer " + token}
    out = []; page = None
    while True:
        params = {"timeMin": SINCE + "T00:00:00+09:00", "maxResults": 2500, "singleEvents": "true", "orderBy": "startTime"}
        if page: params["pageToken"] = page
        r = requests.get(f"{API}/calendars/{CAL_ID}/events", headers=H, params=params, timeout=60); r.raise_for_status()
        j = r.json()
        for it in j.get("items", []):
            if ((it.get("extendedProperties") or {}).get("private") or {}).get("grilu_src") == "site": continue   # 홈페이지에서 올라간 것
            if it.get("status") == "cancelled": continue
            s, e = it.get("start", {}), it.get("end", {})
            if "date" in s:
                date = s["date"]; end = (dt.date.fromisoformat(e.get("date", date)) - dt.timedelta(days=1)).isoformat(); tm = ""
            else:
                sd = s.get("dateTime", ""); ed = e.get("dateTime", "")
                date = sd[:10]; end = ed[:10] or date
                tm = sd[11:16] + ("~" + ed[11:16] if ed[11:16] else "")
            out.append({"uid": it.get("iCalUID", it.get("id")), "date": date, "end": max(end, date), "time": tm,
                        "title": it.get("summary", "(제목 없음)"), "place": it.get("location", ""), "desc": it.get("description", "")})
        page = j.get("nextPageToken")
        if not page: break
    out.sort(key=lambda r: (r["date"], r["time"]))
    json.dump(out, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    print(f"구글 캘린더 → 홈페이지: {len(out)}건 → data/gcal.json")

def main():
    if not SA_JSON:
        print("GCAL_SA_JSON 이 없어 양방향 동기화를 건너뜁니다 (읽기 전용: tools/fetch_gcal.py)")
        sys.exit(0)
    token = sa_token()
    push(token)
    pull(token)

if __name__ == "__main__":
    main()

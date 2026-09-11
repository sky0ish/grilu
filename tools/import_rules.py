# -*- coding: utf-8 -*-
"""
경기연구원 홈페이지 제규정(https://www.gri.re.kr/web/contents/managenotice06.do)을 가져와
편(編)별로 묶은 전문 데이터 data/gri_rules.json 을 만듭니다. (build.py 가 gri/rules.html, gri/rules/partN.html 생성)

  python tools/import_rules.py          → 목록 파싱, PDF 내려받기, 텍스트 추출
필요 패키지: requests, pymupdf
"""
import os, re, json, html, io, zipfile, time
import requests, fitz

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BASE = "https://www.gri.re.kr"
LIST = BASE + "/web/contents/managenotice06.do"
CACHE = os.path.join(ROOT, "data", "gri_rules_files")
S = requests.Session(); S.headers["User-Agent"] = "Mozilla/5.0 (grilu.kr)"

def fetch_rows():
    h = S.get(LIST, timeout=60).text
    rows = []
    for m in re.finditer(r'<tr class="tr">(.*?)</tr>', h, re.S):
        seg = m.group(1)
        d = [html.unescape(re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", x))).strip() for x in re.findall(r'<td class="board_depth\d">(.*?)</td>', seg, re.S)]
        ids = re.findall(r"fn_goView\('(\d+)'\)", seg)
        dl = re.findall(r"href='(/afile/fileDownloadById/[^']+)'", seg)
        if len(d) >= 3 and ids:
            rows.append({"part": d[0], "sec": d[1], "sub": d[2], "id": ids[0], "dl": BASE + dl[0] if dl else "",
                         "view": f"{LIST}?schM=view&id={ids[0]}"})
    return rows

def download(r):
    os.makedirs(CACHE, exist_ok=True)
    for f in os.listdir(CACHE):
        if f.startswith(r["id"] + "."): return os.path.join(CACHE, f)
    resp = S.get(r["dl"], timeout=120)
    cd = resp.headers.get("content-disposition", "")
    fn = re.search(r'filename\*?=(?:UTF-8\'\')?"?([^";]+)', cd)
    ext = os.path.splitext(requests.utils.unquote(fn.group(1)))[1].lower() if fn else ".bin"
    path = os.path.join(CACHE, r["id"] + ext); open(path, "wb").write(resp.content)
    return path

def pdf_text(data):
    doc = fitz.open(stream=data, filetype="pdf")
    return "\n".join(p.get_text("text") for p in doc)

def texts_for(path):
    """(파일명, 텍스트) 목록. zip 이면 안의 PDF 모두 (원문 + 개정문)"""
    if path.endswith(".zip"):
        out = []
        zf = zipfile.ZipFile(path)
        for i in zf.infolist():
            n = i.filename
            try: n = n.encode("cp437").decode("cp949")
            except Exception: pass
            if n.lower().endswith(".pdf"): out.append((n, pdf_text(zf.read(i))))
        return sorted(out, key=lambda x: -len(x[1]))
    return [(os.path.basename(path), pdf_text(open(path, "rb").read()))]

DROP = [re.compile(p) for p in [r"^\s*-?\s*\d{1,3}\s*-?\s*$", r"^\s*규정집\s*$", r"^\s*제\d편\s.*[╷‧･].*$", r"^\s*참고:\s.*[╷].*$", r"^\s*제\d편\s+[가-힣‧･·]+\s+\d+-?\d*\.?\s*[가-힣 ]*$"]]
def to_html(text):
    """PDF 텍스트 → 단순 HTML (조문 제목 굵게, 장/절 소제목, 페이지 머리글 제거)"""
    lines = [l.rstrip() for l in text.split("\n")]
    out, buf, hist = [], [], []
    def flush():
        if buf: out.append("<p>" + html.escape(" ".join(buf)) + "</p>"); buf.clear()
    def flush_hist():
        if hist:
            out.append('<details class="rule-hist"><summary>제정·개정 연혁 (' + str(len(hist)) + '건)</summary><p>' + html.escape(" / ".join(hist)) + "</p></details>"); hist.clear()
    HIST = re.compile(r"^(전부개정|일부개정|제정|타법개정)?\s*\d{4}\.\s*\d{1,2}\.\s*\d{1,2}\.?\s*(규정|규칙|정관|조례|법률|대통령령)?\s*제?\s*\d*\s*호?.*$")
    for l in lines:
        s = l.strip()
        if not s or any(p.match(s) for p in DROP): continue
        if HIST.match(s) and not re.match(r"^제\s?\d+\s?조", s):
            flush(); hist.append(re.sub(r"\s+", " ", s)); continue
        flush_hist()
        if re.match(r"^제\s?\d+\s?장\b|^제\s?\d+\s?절\b|^부\s*칙|^부칙\b|^\[?별표|^\[?별지|^\[?서식", s):
            flush(); out.append('<h5 class="rule-ch">' + html.escape(s) + "</h5>"); continue
        m = re.match(r"^(제\s?\d+\s?조(?:의\s?\d+)?)\s*(\([^)]*\))?\s*(.*)$", s)
        if m:
            flush()
            head = (m.group(1) + (m.group(2) or "")).replace(" ", "")
            out.append('<p class="rule-art"><b>' + html.escape(head) + "</b> " + html.escape(m.group(3)) + "</p>")
            continue
        if re.match(r"^[①-⑳]|^\d+\.\s|^[가-하]\.\s|^\(\d+\)", s):
            flush(); buf.append(s); continue
        buf.append(s)
    flush(); flush_hist()
    return "\n".join(out)

def main():
    rows = fetch_rows(); print("목록", len(rows), "건")
    parts, order = {}, []
    for r in rows:
        r["title"] = r["sub"] or r["sec"]
        if not r["dl"]: r["html"] = ""; continue
        path = download(r); r["file"] = os.path.basename(path)
        docs = texts_for(path)
        r["html"] = "".join((f'<h4 class="rule-doc">{html.escape(n)}</h4>' if len(docs) > 1 else "") + to_html(t) for n, t in docs)
        r["chars"] = sum(len(t) for _, t in docs)
        print(f'  {r["part"]} | {r["title"]} | {r["chars"]}자')
        time.sleep(0.3)
        if r["part"] not in parts: parts[r["part"]] = []; order.append(r["part"])
        parts[r["part"]].append(r)
    data = [{"part": p, "no": i + 1, "items": parts[p]} for i, p in enumerate(order)]
    os.makedirs(os.path.join(ROOT, "data"), exist_ok=True)
    json.dump(data, open(os.path.join(ROOT, "data", "gri_rules.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    print("written data/gri_rules.json:", [(d["part"], len(d["items"])) for d in data])

if __name__ == "__main__":
    main()

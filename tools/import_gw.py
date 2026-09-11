# -*- coding: utf-8 -*-
"""
그룹웨어(gw.gri.re.kr)에서 내려받은 data/gw/gw_export.zip (게시글 + 첨부파일) 을
1) 첨부파일 → files/gw/ 에 저장 (사이트에서 내려받기)
2) 첨부파일 텍스트 추출 (pdf: pymupdf, hwp: pyhwp, hwpx: xml, xls: xlrd)
3) data/gw_posts.json 으로 정리 (build.py 가 정적 페이지·목록 생성, seed SQL 생성)
실행: python tools/import_gw.py
"""
import os, re, io, json, html, zipfile, tempfile, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ZIP = os.path.join(ROOT, "data", "gw", "gw_export.zip")
FILES = os.path.join(ROOT, "files", "gw")
BOARD_MAP = {"000000371": ("committee", "심의위원회 상정(안)"), "0000001yl": ("council", "노사협의회 운영규약"),
             "0000001ym": ("council", "공고 및 회의록"), "0000001yn": ("council", "안건 제안"), "0000001hy": ("director", "노동이사 활동보고")}

def pdf_text(b):
    import fitz
    return "\n".join(p.get_text("text") for p in fitz.open(stream=b, filetype="pdf"))

def hwp_text(b):
    from hwp5.xmlmodel import Hwp5File
    from hwp5.hwp5txt import TextTransform
    tmp = tempfile.NamedTemporaryFile(suffix=".hwp", delete=False); tmp.write(b); tmp.close()
    out = io.BytesIO()
    hf = Hwp5File(tmp.name)
    try:
        TextTransform().transform_hwp5_to_text(hf, out)
    finally:
        try: hf.close()
        except Exception: pass
        try: os.unlink(tmp.name)
        except Exception: pass
    return out.getvalue().decode("utf-8", "replace")

def hwpx_text(b):
    zz = zipfile.ZipFile(io.BytesIO(b)); parts = []
    for n in sorted(zz.namelist()):
        if n.startswith("Contents/section"):
            x = zz.read(n).decode("utf-8", "replace")
            x = re.sub(r"</hp:p>", "\n", x); x = re.sub(r"<[^>]+>", "", x)
            parts.append(html.unescape(x))
    return "\n".join(parts)

def xls_text(b):
    try:
        import xlrd
        wb = xlrd.open_workbook(file_contents=b); out = []
        for sh in wb.sheets():
            out.append("[" + sh.name + "]")
            for r in range(sh.nrows): out.append("\t".join(str(c) for c in sh.row_values(r) if c != ""))
        return "\n".join(out)
    except Exception as e:
        return ""

def extract(name, b):
    ext = os.path.splitext(name)[1].lower()
    try:
        if ext == ".pdf": return pdf_text(b)
        if ext == ".hwp": return hwp_text(b)
        if ext == ".hwpx": return hwpx_text(b)
        if ext in (".xls", ".xlsx"): return xls_text(b)
    except Exception as e:
        print("   ! 텍스트 추출 실패", name, e)
    return ""

def clean_text(t):
    t = t.replace("\x00", "").replace("﻿", "")
    t = re.sub(r"<그림>|<표>|</?[a-z]+>", " ", t)
    t = re.sub(r"[ \t　]+", " ", t)
    t = re.sub(r"\n\s*\n+", "\n", t)
    return t.strip()

def clean_body(h):
    m = re.search(r'<div class="write_area">(.*?)</div>\s*(?:<div class="brdr_dbl">|<div class="comment|<div class="reply|$)', h, re.S)
    body = m.group(1) if m else h
    body = re.sub(r"<script.*?</script>", "", body, flags=re.S)
    body = re.sub(r'\s(?:style|class|onmouseover|onmouseout|width|height)="[^"]*"', "", body)
    body = re.sub(r"<img[^>]*>", "", body)
    body = re.sub(r"<a [^>]*JAVASCRIPT[^>]*>(.*?)</a>", r"\1", body, flags=re.S)
    return body.strip()

def main():
    z = zipfile.ZipFile(ZIP)
    d = json.loads(z.read("posts.json").decode("utf-8"))
    posts = json.loads(d["posts"]) if isinstance(d["posts"], str) else d["posts"]
    os.makedirs(FILES, exist_ok=True)
    out = []
    for p in posts:
        if p["board"] not in BOARD_MAP: continue
        code, sub = BOARD_MAP[p["board"]]
        raw = z.read("raw/" + p["id"] + ".html").decode("utf-8", "replace")
        body_html = clean_body(raw)
        body_text = clean_text(html.unescape(re.sub(r"<[^>]+>", " ", body_html)))
        rec = {"id": p["id"], "code": code, "sub": sub, "title": p["title"], "author": p["author"], "dept": p.get("dept", ""),
               "date": p["date"].replace(".", "-"), "body_html": body_html, "body_text": body_text, "atts": []}
        print(f"[{code}] {rec['date']} {p['title'][:40]}")
        for a in p.get("atts", []):
            if "file" not in a: continue
            b = z.read("files/" + a["file"])
            safe = re.sub(r'[\\/:*?"<>|]', "_", a["file"])
            open(os.path.join(FILES, safe), "wb").write(b)
            text = clean_text(extract(a["name"], b))
            rec["atts"].append({"name": a["name"], "file": "files/gw/" + safe, "size": len(b), "text": text})
            print(f"    - {a['name']} ({len(b)//1024} KB) → {len(text)}자")
        out.append(rec)
    out.sort(key=lambda r: (r["date"], r["id"]), reverse=True)
    json.dump({"posts": out}, open(os.path.join(ROOT, "data", "gw_posts.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    print("총", len(out), "건 → data/gw_posts.json")

if __name__ == "__main__":
    main()

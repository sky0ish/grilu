# -*- coding: utf-8 -*-
"""
형태소 분석(Kiwi)으로 본문에서 명사 키워드만 뽑아 data/*.json 에 keywords 필드를 채웁니다.
  python tools/keywords.py            → data/audit.json, data/gw_posts.json(있으면) 갱신
build.py 가 정적 페이지에 <script type="application/json" class="kw-data"> 로 심고, board.js 가 이를 우선 사용합니다.
필요 패키지: kiwipiepy
"""
import os, re, json, html, sys
from collections import Counter
from kiwipiepy import Kiwi

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
kiwi = Kiwi()
STOP = set("""것 수 등 및 때 중 내 후 전 시 년 월 일 분 개 명 건 회 차 번 점 위 안 간 측 관련 경우 부분 정도 사항 내용 말씀 질의 답변 위원 위원장 위원님 의원 의원님 여러분 지금 이제
발언 개의 산회 정회 속개 회의 회의록 의석 정돈 의사 일정 진행 원장 원장님 실장 실장님 국장 과장 담당관 담당 답변자 관계 공무원 직원 기관 사무처 행정사무감사 행정사무 감사
경기도의회 의회 도의회 기획재정위원회 기획위원회 기획조정실 경기도 경기 연구원 경기연구원 경기개발연구원 피감사기관 피감기관 도 시 군 구
생각 이야기 얘기 문제 방법 시간 자료 보고 확인 정리 설명 검토 부탁 질문 이번 저번 다음 처음 마지막 오늘 어제 내년 올해 작년 지난 하나 우리 저희 자기 자체 전체 일부 각각 모두 전부
감사합니다 알겠습니다 그것 이것 저것 여기 거기 무엇 뭐 때문 이유 대해 대한 통해 위해 위한 관련해서 그대로 정말 사실 실제 결국 특히""".split())

POS = set("""성과 개선 향상 강화 확대 지원 협력 상생 존중 보장 보호 안정 발전 성장 우수 성공 달성 확보 합의 타결 해결 증가 인상 혜택 복지 만족 신뢰 투명 공정 공평 자율 배려 격려 칭찬 감사 기여 노력 혁신 효율 절감 활성화 개편 정상화 회복 상승 호전 긍정 환영 지지 동의 승인 통과 채택 수용 반영 확정 완료 추진 도입 시행 마련 구축 정비 보완 개정 제정 신설 증원 충원 채용 승진 보상 인센티브 격려금 수당 휴가 육아 건강 안전 소통 참여 협의 협약 화합 단결 연대 권익 권리 정의 평등 존엄 자부심 보람 활력 창의 전문성 역량 품질 신속 원활 적극 원만 우호""".split())
NEG = set("""문제 지적 미흡 부족 부실 불법 위반 위법 부당 불공정 불평등 차별 갑질 괴롭힘 폭언 폭행 성희롱 성폭력 비위 비리 부패 횡령 유용 은폐 축소 왜곡 조작 논란 갈등 분쟁 반발 항의 불만 불신 우려 걱정 불안 위기 위험 사고 재해 피해 손실 손해 적자 삭감 감축 축소 폐지 통폐합 구조조정 해고 해임 징계 감봉 정직 파면 경고 주의 시정 시정요구 감사지적 처분 고발 고소 소송 제소 패소 체불 미지급 지연 지체 연기 보류 부결 반려 거부 거절 무시 방치 태만 해태 소홀 누락 오류 실수 착오 하자 결함 노후 낙후 열악 과중 과로 야근 초과근무 스트레스 소진 이직 퇴직 사직 공석 결원 미달 저조 감소 하락 악화 후퇴 침체 정체 불투명 불명확 모호 혼란 혼선 중복 낭비 비효율 편법 꼼수 압박 강요 독단 일방 불통 배제 소외 홀대 경시 무리 무리수 부담 가중 악용 남용 오남용 불성실 불이행 미이행 미비 미완 지연 취소 철회 반대 항변 이의 규탄 투쟁 파업 쟁의 농성""".split())
def sentiment(w):
    if w in POS: return 1
    if w in NEG: return -1
    for k in NEG:
        if len(k) >= 2 and (w.endswith(k) or w.startswith(k)): return -1
    for k in POS:
        if len(k) >= 2 and (w.endswith(k) or w.startswith(k)): return 1
    return 0

def extract(text, speakers=(), top=20):
    text = re.sub(r"<[^>]+>", " ", text or "")
    text = html.unescape(text)
    stop = STOP | set(speakers)
    cnt = Counter()
    TITLES = {"위원", "의원", "위원장", "원장", "부원장", "과장", "실장", "사장", "국장", "팀장", "본부장", "대표", "이사", "님", "감사관", "담당관", "센터장", "부장", "차장", "주무관", "매니저", "연구위원", "연구원"}
    sents = [x for x in re.split(r"(?<=[.!?。\n])\s+", text) if x.strip()]
    for sent in sents:   # 1차: 직함 바로 앞의 고유명사(사람 이름) 수집 → 제외
        toks = kiwi.tokenize(sent)
        for a, b in zip(toks, toks[1:]):
            if a.tag == "NNP" and 2 <= len(a.form) <= 4 and b.form in TITLES: stop.add(a.form)
    for sent in sents:
        toks = kiwi.tokenize(sent)
        # 붙어 있는 명사(NNG/NNP)끼리 합쳐 복합명사로 (경기+연구원 → 경기연구원)
        i = 0
        while i < len(toks):
            t = toks[i]
            if t.tag in ("NNG", "NNP"):
                form, end = t.form, t.start + t.len
                j = i + 1
                while j < len(toks) and toks[j].tag in ("NNG", "NNP") and toks[j].start == end:
                    form += toks[j].form; end = toks[j].start + toks[j].len; j += 1
                if len(form) >= 2 and form not in stop and not re.fullmatch(r"[0-9]+.*", form):
                    cnt[form] += 1
                    # 복합명사의 구성 명사도 따로 집계 (예산/연구 등)
                    if j - i > 1:
                        for k in range(i, j):
                            f = toks[k].form
                            if len(f) >= 2 and f not in stop: cnt[f] += 1
                i = j
            else:
                i += 1
    ranked = [[w, n] for w, n in cnt.most_common(top * 4) if n >= 2]
    main = [[w, n, sentiment(w)] for w, n in ranked[:top]]
    pos = [[w, n, 1] for w, n in ranked if sentiment(w) > 0][:8]
    neg = [[w, n, -1] for w, n in ranked if sentiment(w) < 0][:8]
    return {"top": main, "pos": pos, "neg": neg}

def speakers_of(html_text):
    """<b>○ 위원장 홍길동</b> 같은 발언자 표기에서 이름 추출"""
    names = set()
    for m in re.findall(r"<b>([^<]{2,40})</b>", html_text or ""):
        for w in re.findall(r"[가-힣]{2,20}", m): names.add(w)
    return names

def main():
    p = os.path.join(ROOT, "data", "audit.json")
    data = json.load(open(p, encoding="utf-8"))
    for r in data:
        r["keywords"] = extract(r.get("body", ""), speakers_of(r.get("body", "")))
        print(r["date"], [w for w, n, s in r["keywords"]["top"][:8]], "NEG:", [w for w, n, s in r["keywords"]["neg"][:4]])
    json.dump(data, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    q = os.path.join(ROOT, "data", "gw_posts.json")
    if os.path.exists(q):
        gw = json.load(open(q, encoding="utf-8"))
        for r in gw["posts"]:
            full = (r.get("body_text") or "") + "\n" + "\n".join(a.get("text", "") for a in r.get("atts", []))
            r["keywords"] = extract(full)
        json.dump(gw, open(q, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
        print("gw_posts keywords ok")

if __name__ == "__main__":
    main()

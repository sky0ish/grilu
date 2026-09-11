/* ============================================================
   달력 일정 데이터 (grilu.kr)
   - 이 파일만 수정하면 메인 달력과 일정 페이지에 모두 반영됩니다.
   - type : union(노조 회의), council(노사협의회), event(행사), holiday(휴일)
   - date : YYYY-MM-DD,  end(선택) : 종료일
   ※ 아래는 예시 일정입니다. 실제 일정으로 교체해 주세요.
   ============================================================ */
window.GRILU_EVENTS = [
  { date: "2026-09-03", title: "정기 운영위원회", type: "union",   desc: "9월 정기 운영위원회 (노조사무실, 12:00)" },
  { date: "2026-09-15", title: "노사협의회 사전협의", type: "council", desc: "3분기 노사협의회 안건 사전 조율" },
  { date: "2026-09-22", title: "3분기 노사협의회", type: "council", desc: "본관 대회의실 14:00" },
  { date: "2026-09-24", title: "추석 연휴", end: "2026-09-26", type: "holiday" },
  { date: "2026-10-01", title: "조합원 간담회", type: "event", desc: "신규 조합원 환영 및 간담회" },
  { date: "2026-10-08", title: "정기 운영위원회", type: "union", desc: "10월 정기 운영위원회" },
  { date: "2026-10-09", title: "한글날", type: "holiday" },
  { date: "2026-10-23", title: "조합원 체육행사", type: "event", desc: "가을 조합원 한마음 행사" },
  { date: "2026-11-05", title: "정기 운영위원회", type: "union" },
  { date: "2026-11-19", title: "임금·단체교섭 상견례", type: "council", desc: "2027년 임단협 시작" },
  { date: "2026-12-03", title: "정기 운영위원회", type: "union" },
  { date: "2026-12-17", title: "4분기 노사협의회", type: "council" },
  { date: "2026-12-22", title: "정기 대의원대회", type: "event", desc: "2026년 사업보고 및 2027년 사업계획 의결" },
  { date: "2026-12-25", title: "성탄절", type: "holiday" }
];

/* ============================================================
   Supabase 연결 설정
   Supabase 대시보드 > Project Settings > API 에서 복사해 넣으세요.
   - Project URL           → SUPABASE_URL
   - anon / publishable key → SUPABASE_ANON_KEY  (공개되어도 되는 키입니다)
   값이 비어 있으면 사이트는 예시 데이터(정적)로 동작합니다.
   ============================================================ */
window.GRILU_CONFIG = {
  SUPABASE_URL: "https://ryyvwpkhlqbcsjbttxca.supabase.co",
  SUPABASE_ANON_KEY: "sb_publishable_-gj-jLFfB9L5yqlboJAD5A_Y-shrQI0",
  SITE_NAME: "경기연구원 노동조합",
  PAGE_SIZE: 15,
  /* 구글 캘린더 [GRILU] 연동 (관리자가 달력 페이지에서 "구글 캘린더 잇기"를 누르면 권한 요청 창이 뜹니다)
     - GCAL_CLIENT_ID: Google Cloud 콘솔 OAuth 클라이언트 ID. "승인된 자바스크립트 원본"에 https://grilu.kr 를 넣어야 합니다.
     - GCAL_ID: 일정을 넣고 가져올 구글 캘린더 ID ([GRILU]) */
  GCAL_CLIENT_ID: "837685540720-kfchnbh2f437oct140j7utkdso3626bs.apps.googleusercontent.com",
  GCAL_ID: "ceua1ql1ql0cqsb4fqt9jvk44c@group.calendar.google.com"
};

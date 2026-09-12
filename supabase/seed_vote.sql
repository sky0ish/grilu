-- 조합원 투표 게시판 (구글 설문 + 결과 시트 통계). 조합원 열람, 운영진만 글쓰기
insert into public.boards (code, name, members_only, admin_only_write) values ('vote', '조합원 투표', true, true) on conflict (code) do update set name = excluded.name, members_only = excluded.members_only, admin_only_write = excluded.admin_only_write;
-- 기타참고자료 분석 글은 정적 페이지(data/reports.json)로 옮겨 매주 자동 갱신하므로 DB 사본은 삭제
delete from public.posts where attachments->>'legacy_id' like 'gw-report-%';

-- 게시판 구성 변경 (2026-09-12): 소통마당 = 운영진 게시판 / 자유게시판 / 소통상담, GRI = 행정사무감사
insert into public.boards (code, name, members_only, admin_only_write) values
  ('staff', '운영진 게시판', true, true),
  ('audit', '행정사무감사', false, true)
on conflict (code) do update set name = excluded.name, members_only = excluded.members_only, admin_only_write = excluded.admin_only_write;
update public.boards set name = '자유게시판' where code = 'board';
delete from public.boards where code = 'newsletter';

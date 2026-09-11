-- 게시판 구성 변경 (2026-09-12): 소통마당 = 운영진 게시판 / 조합원 자유게시판 / 소통상담, GRI = 행정사무감사
insert into public.boards (code, name, members_only, admin_only_write) values
  ('staff', '운영진 게시판', true, true),
  ('audit', '행정사무감사', false, true)
on conflict (code) do update set name = excluded.name, members_only = excluded.members_only, admin_only_write = excluded.admin_only_write;
update public.boards set name = '조합원 자유게시판' where code = 'board';
delete from public.boards where code = 'newsletter';

-- 2026-09-12 추가
insert into public.boards (code, name, members_only, admin_only_write) values ('othernews', '기타 노조 소식', false, true) on conflict (code) do nothing;
insert into public.boards (code, name, members_only, admin_only_write) values ('delegate', '대의원 회의자료', true, true), ('wish', '노조에 바란다', false, false) on conflict (code) do nothing;
update public.boards set name = '기타참고자료' where code = 'documents';
insert into public.boards (code, name, members_only, admin_only_write) values ('director', '노동이사 활동보고', false, true) on conflict (code) do nothing;
insert into public.boards (code, name, members_only, admin_only_write) values ('budget', '예산결산서', false, true) on conflict (code) do nothing;
insert into public.boards (code, name, members_only, admin_only_write) values ('guide', '가이드라인', false, true) on conflict (code) do nothing;

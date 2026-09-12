-- 일정 달력 v2: 시간·장소·첨부·회의자료 글 연결 (2026-09-12)
alter table public.events add column if not exists time text;
alter table public.events add column if not exists place text;
alter table public.events add column if not exists post_id bigint;
alter table public.events add column if not exists attachments jsonb not null default '[]'::jsonb;
alter table public.events drop constraint if exists events_type_check;
alter table public.events add constraint events_type_check check (type in ('union','council','event','holiday','meeting'));
-- 대의원 회의자료 → 회의자료 (일정 달력의 첨부자료가 올라가는 게시판)
update public.boards set name = '회의자료' where code = 'delegate';
insert into public.boards (code, name, members_only, admin_only_write) values ('delegate', '회의자료', true, true) on conflict (code) do nothing;
-- 관리자가 저장소에 일정 첨부를 올릴 수 있도록 (attachments 버킷 정책은 schema.sql 그대로 사용)
notify pgrst, 'reload schema';

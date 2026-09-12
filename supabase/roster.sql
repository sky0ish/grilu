-- ============================================================
-- 회원 종류 셋(회원 · 준회원 · 관리자) + 노조 회원 명단 대조
--   ※ grilu.kr 의 Supabase 프로젝트 SQL Editor 에서 실행 (skyish.kr 프로젝트가 아닙니다)
--
-- · role 에 'associate'(준회원) 을 더합니다. 준회원도 approved=true 면 is_member() 가 참이라
--   조합원 게시판을 볼 수 있습니다 — 준회원의 권한을 좁히려면 posts 정책에서 role='member' 를 따로 보면 됩니다.
-- · union_roster: 노조 회원 명단 (관리자만 읽고 씀). 회원관리 화면의 「명단 대조 승인」 이
--   대기자를 명단에 있으면 회원, 없으면 준회원으로 승인합니다.
-- 여러 번 실행해도 안전합니다.
-- ============================================================

alter table public.profiles drop constraint if exists profiles_role_check;
alter table public.profiles add constraint profiles_role_check check (role in ('member','associate','admin'));

-- 본인이 제 이름·소속을 고칠 때 role 을 바꾸지 못하게 (전에는 role='member' 만 허용해 준회원이 제 정보를 못 고쳤습니다)
drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles for update
  using (id = auth.uid())
  with check (id = auth.uid()
    and role = (select p.role from public.profiles p where p.id = auth.uid())
    and approved = (select p.approved from public.profiles p where p.id = auth.uid()));

create table if not exists public.union_roster (
  key      text primary key,          -- 이메일(소문자) 또는 이름(띄어쓰기 뺀 것)
  name     text,
  email    text,
  added_at timestamptz not null default now()
);
alter table public.union_roster enable row level security;
drop policy if exists "roster_admin" on public.union_roster;
create policy "roster_admin" on public.union_roster for all using (public.is_admin()) with check (public.is_admin());

-- 확인
select email, name, role, approved from public.profiles order by created_at desc;

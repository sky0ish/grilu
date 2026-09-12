-- ═══════════════════════════════════════════════════════════
-- 회원 종류(회원·준회원·관리자) 한 번에 — grilu.kr 의 Supabase SQL Editor 에 통째로 붙여넣고 Run
--   (company_autoconfirm.sql + roster.sql + roles_access.sql 을 이은 것. 여러 번 실행해도 안전)
-- ═══════════════════════════════════════════════════════════

-- ============================================================
-- 경기연구원 메일(@gri.re.kr, @gri.kr)은 인증 메일 없이 바로 가입 접수
--   ※ grilu.kr 의 Supabase 프로젝트 SQL Editor 에서 실행 (skyish.kr 프로젝트가 아닙니다)
--
-- 왜: 연구원 메일서버가 Supabase 의 인증 메일을 걸러 「가입은 됐는데 로그인이 안 되는」
--     분이 생깁니다. 회사 메일이면 인증을 건너뛰고, 회원/관리자 승인은 여전히
--     관리자가 회원관리에서 합니다 (approved 는 그대로 false 로 시작).
-- 여러 번 실행해도 안전합니다.
-- ============================================================

create or replace function public.autoconfirm_company_email()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.email ~* '@(gri\.re\.kr|gri\.kr)$' and new.email_confirmed_at is null then
    new.email_confirmed_at := now();
  end if;
  return new;
end $$;

drop trigger if exists on_auth_user_autoconfirm on auth.users;
create trigger on_auth_user_autoconfirm
  before insert on auth.users
  for each row execute procedure public.autoconfirm_company_email();

-- 이미 신청해 둔 회사 메일 계정도 인증 처리 (관리자 승인은 따로)
update auth.users
   set email_confirmed_at = now()
 where email ~* '@(gri\.re\.kr|gri\.kr)$' and email_confirmed_at is null;

-- 확인
select u.email, u.email_confirmed_at, p.name, p.role, p.approved
  from auth.users u left join public.profiles p on p.id = u.id
 order by u.created_at desc;

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

-- ============================================================
-- 회원 종류별 권한
--   ※ grilu.kr 의 Supabase 프로젝트 SQL Editor 에서 실행 (roster.sql 다음에)
--
--   관리자(admin)      : 모든 것 — 회원관리, 모든 글 쓰기·고치기·지우기
--   회원(member)       : 모든 게시판을 보고 씁니다 (제 글은 고치고 지울 수 있음)
--   준회원(associate)  : 보기만 — 자료마당·소통마당 게시판은 못 봅니다
--   승인 대기          : 손님과 같습니다
-- 여러 번 실행해도 안전합니다.
-- ============================================================

-- 준회원에게 감추는 게시판 (자료마당 · 소통마당)
alter table public.boards add column if not exists associate_hidden boolean not null default false;
update public.boards set associate_hidden = (code in
  ('council','agreement','rules','law','delegate','documents',        -- 자료마당
   'staff','board','wish','vote','counsel'));                          -- 소통마당

create or replace function public.is_full_member()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and (role = 'admin' or (approved and role = 'member')));
$$;
create or replace function public.is_associate()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and approved and role = 'associate');
$$;

-- 글 보기: 조합원 전용 게시판은 승인된 분만, 준회원은 감춘 게시판을 못 봅니다
drop policy if exists "posts_select" on public.posts;
create policy "posts_select" on public.posts for select using (
  public.is_admin()
  or (
    (not exists (select 1 from public.boards b where b.code = posts.board and b.members_only) or public.is_member())
    and not (public.is_associate() and exists (select 1 from public.boards b where b.code = posts.board and b.associate_hidden))
  )
);

-- 글 쓰기: 관리자와 회원은 어느 게시판이든 (준회원은 못 씁니다)
drop policy if exists "posts_insert" on public.posts;
create policy "posts_insert" on public.posts for insert with check (
  auth.uid() = author_id and public.is_full_member()
);

-- 고치기·지우기: 제 글 또는 관리자 (관리자는 모든 글)
drop policy if exists "posts_update" on public.posts;
create policy "posts_update" on public.posts for update using (author_id = auth.uid() or public.is_admin());
drop policy if exists "posts_delete" on public.posts;
create policy "posts_delete" on public.posts for delete using (author_id = auth.uid() or public.is_admin());

-- 확인
select code, name, members_only, admin_only_write, associate_hidden from public.boards order by code;

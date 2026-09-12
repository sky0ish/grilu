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

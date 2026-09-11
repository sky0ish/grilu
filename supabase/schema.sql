-- ============================================================
-- 경기연구원 노동조합 홈페이지 (grilu.kr) - Supabase 스키마
-- Supabase 대시보드 > SQL Editor 에 전체를 붙여넣고 Run 하세요.
-- (여러 번 실행해도 안전하도록 작성되어 있습니다)
-- ============================================================

-- ---------- 1. 회원 프로필 ----------
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  email       text,
  name        text,
  dept        text,
  position    text,                                 -- 직급
  role        text not null default 'member' check (role in ('member','admin')),
  approved    boolean not null default false,        -- 조합원 확인 후 관리자가 승인
  created_at  timestamptz not null default now()
);

-- 회원가입 시 프로필 자동 생성
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, name, dept, position)
  values (new.id, new.email,
          coalesce(new.raw_user_meta_data->>'name', ''),
          coalesce(new.raw_user_meta_data->>'dept', ''),
          nullif(new.raw_user_meta_data->>'position', ''))
  on conflict (id) do nothing;
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 관리자 여부 / 승인 조합원 여부 헬퍼
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;
create or replace function public.is_member()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and (approved or role = 'admin'));
$$;

-- ---------- 2. 게시판 ----------
-- board 코드: notice(공지) news(노조소식) statement(성명서) regulation(규정및지침)
--             council(노사협의회) newsletter(노보) documents(문서자료) agreement(단체협약)
--             law(노동관계법령) rules(규약·규정) board(조합원게시판) photo(사진) video(동영상)
create table if not exists public.posts (
  id           bigint generated always as identity primary key,
  board        text not null,
  title        text not null,
  content      text,
  author_id    uuid references auth.users(id) on delete set null,
  author_name  text,
  is_notice    boolean not null default false,
  views        integer not null default 0,
  attachments  jsonb not null default '[]'::jsonb,   -- [{name,path,url,size}]
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index if not exists posts_board_idx on public.posts (board, created_at desc);

-- 조회수 증가 (누구나 호출 가능)
create or replace function public.increment_views(post_id bigint)
returns void language sql security definer set search_path = public as $$
  update public.posts set views = views + 1 where id = post_id;
$$;

-- 조합원 전용 게시판 목록 (여기 포함된 board 는 승인 조합원만 열람)
create table if not exists public.boards (
  code         text primary key,
  name         text not null,
  members_only boolean not null default false,
  admin_only_write boolean not null default false
);
insert into public.boards (code, name, members_only, admin_only_write) values
  ('notice','공지사항',false,true), ('news','노조소식',false,true), ('statement','성명서·보도자료',false,true),
  ('regulation','규정 및 지침',false,true), ('council','노사협의회',false,true), ('newsletter','노보(소식지)',false,true),
  ('documents','문서자료',false,true), ('agreement','단체협약',false,true), ('law','노동관계법령',false,true),
  ('rules','규약·규정',false,true), ('board','조합원 게시판',true,false), ('photo','사진자료',false,true), ('video','동영상',false,true)
on conflict (code) do nothing;

-- ---------- 3. 일정(달력) ----------
create table if not exists public.events (
  id          bigint generated always as identity primary key,
  date        date not null,
  end_date    date,
  title       text not null,
  type        text not null default 'union' check (type in ('union','council','event','holiday')),
  description text,
  created_at  timestamptz not null default now()
);
create index if not exists events_date_idx on public.events (date);

-- ---------- 4. 고충상담 ----------
create table if not exists public.counsel (
  id          bigint generated always as identity primary key,
  name        text,
  contact     text,
  category    text,
  title       text not null,
  content     text not null,
  status      text not null default 'received' check (status in ('received','processing','done')),
  memo        text,
  created_at  timestamptz not null default now()
);

-- ---------- 5. RLS (행 수준 보안) ----------
alter table public.profiles enable row level security;
alter table public.posts    enable row level security;
alter table public.boards   enable row level security;
alter table public.events   enable row level security;
alter table public.counsel  enable row level security;

-- profiles
drop policy if exists "profiles_select" on public.profiles;
create policy "profiles_select" on public.profiles for select using (id = auth.uid() or public.is_admin());
drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles for update using (id = auth.uid()) with check (id = auth.uid() and role = 'member' and approved = (select approved from public.profiles where id = auth.uid()));
drop policy if exists "profiles_admin_all" on public.profiles;
create policy "profiles_admin_all" on public.profiles for all using (public.is_admin()) with check (public.is_admin());

-- boards (목록은 누구나)
drop policy if exists "boards_select" on public.boards;
create policy "boards_select" on public.boards for select using (true);
drop policy if exists "boards_admin" on public.boards;
create policy "boards_admin" on public.boards for all using (public.is_admin()) with check (public.is_admin());

-- posts
drop policy if exists "posts_select" on public.posts;
create policy "posts_select" on public.posts for select using (
  not exists (select 1 from public.boards b where b.code = posts.board and b.members_only)
  or public.is_member()
);
drop policy if exists "posts_insert" on public.posts;
create policy "posts_insert" on public.posts for insert with check (
  auth.uid() = author_id and (
    public.is_admin() or (
      public.is_member() and not exists (select 1 from public.boards b where b.code = posts.board and b.admin_only_write)
    )
  )
);
drop policy if exists "posts_update" on public.posts;
create policy "posts_update" on public.posts for update using (author_id = auth.uid() or public.is_admin());
drop policy if exists "posts_delete" on public.posts;
create policy "posts_delete" on public.posts for delete using (author_id = auth.uid() or public.is_admin());

-- events (읽기 누구나, 쓰기 관리자)
drop policy if exists "events_select" on public.events;
create policy "events_select" on public.events for select using (true);
drop policy if exists "events_admin" on public.events;
create policy "events_admin" on public.events for all using (public.is_admin()) with check (public.is_admin());

-- counsel (접수는 누구나, 열람은 관리자만)
drop policy if exists "counsel_insert" on public.counsel;
create policy "counsel_insert" on public.counsel for insert with check (true);
drop policy if exists "counsel_admin" on public.counsel;
create policy "counsel_admin" on public.counsel for all using (public.is_admin()) with check (public.is_admin());

-- ---------- 6. 첨부파일 저장소 ----------
insert into storage.buckets (id, name, public) values ('attachments', 'attachments', true)
on conflict (id) do nothing;
drop policy if exists "attachments_read" on storage.objects;
create policy "attachments_read" on storage.objects for select using (bucket_id = 'attachments');
drop policy if exists "attachments_write" on storage.objects;
create policy "attachments_write" on storage.objects for insert with check (bucket_id = 'attachments' and public.is_member());
drop policy if exists "attachments_delete" on storage.objects;
create policy "attachments_delete" on storage.objects for delete using (bucket_id = 'attachments' and (owner = auth.uid() or public.is_admin()));

-- ---------- 7. 예시 일정 (필요 없으면 삭제) ----------
insert into public.events (date, end_date, title, type, description)
select * from (values
  ('2026-09-22'::date, null::date, '3분기 노사협의회', 'council', '본관 대회의실 14:00'),
  ('2026-09-24'::date, '2026-09-26'::date, '추석 연휴', 'holiday', null),
  ('2026-10-08'::date, null::date, '정기 운영위원회', 'union', '10월 정기 운영위원회')
) as v(date, end_date, title, type, description)
where not exists (select 1 from public.events);

-- ============================================================
-- 실행 후 할 일
-- 1) Authentication > Providers > Email 이 켜져 있는지 확인 (기본 ON)
--    개발 중에는 "Confirm email" 을 꺼두면 가입 즉시 로그인됩니다.
-- 2) 홈페이지에서 관리자 계정으로 회원가입한 뒤, 아래 SQL 로 관리자 권한 부여:
--    update public.profiles set role='admin', approved=true where email='skyish76@gmail.com';
-- ============================================================

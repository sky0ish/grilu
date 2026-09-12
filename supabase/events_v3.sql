-- 구글 캘린더 [GRILU] 양방향 동기화용 칸 (2026-09-12)
alter table public.events add column if not exists gcal_id text;
alter table public.events add column if not exists synced_at timestamptz;
alter table public.events add column if not exists updated_at timestamptz not null default now();
create unique index if not exists events_gcal_idx on public.events (gcal_id) where gcal_id is not null;
alter table public.events drop constraint if exists events_type_check;
alter table public.events add constraint events_type_check check (type in ('union','council','event','holiday','meeting','gcal'));
notify pgrst, 'reload schema';

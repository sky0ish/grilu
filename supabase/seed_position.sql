-- 회원 직급 컬럼 추가 (2026-09-12): 선임연구위원/연구위원/선임연구원/연구원/행정직
alter table public.profiles add column if not exists position text;
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

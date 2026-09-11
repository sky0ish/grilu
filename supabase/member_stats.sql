-- 조합원 현황 집계 함수 (개인정보 없이 인원수만 반환, 누구나 호출 가능)
create or replace function public.member_stats()
returns json language sql stable security definer set search_path = public as $$
  with m as (select * from public.profiles where approved = true)
  select json_build_object(
    'total', (select count(*) from m),
    'recent', (select count(*) from m where created_at >= date_trunc('month', now())),
    'by_position', (select coalesce(json_agg(json_build_object('name', p, 'n', n) order by n desc, p), '[]'::json)
                    from (select coalesce(nullif(position, ''), '(미입력)') p, count(*) n from m group by 1) t),
    'by_dept', (select coalesce(json_agg(json_build_object('name', d, 'n', n) order by n desc, d), '[]'::json)
                from (select coalesce(nullif(dept, ''), '(미입력)') d, count(*) n from m group by 1) t)
  );
$$;
grant execute on function public.member_stats() to anon, authenticated;

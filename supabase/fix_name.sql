-- 가입 때 잘못 적힌 이름 바로잡기 (grilu.kr 의 Supabase SQL Editor 에서 실행)
update public.profiles set name = '옥진아' where email = 'oja6473@gri.re.kr';
select email, name, dept, position, role, approved from public.profiles order by created_at desc;

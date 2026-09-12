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

-- 관리자 지정: 홈페이지에서 회원가입한 뒤 SQL Editor 에서 실행
update public.profiles set role = 'admin', approved = true
 where email in ('skyish76@gmail.com', 'skyish@gri.re.kr');
select email, name, role, approved from public.profiles order by created_at;

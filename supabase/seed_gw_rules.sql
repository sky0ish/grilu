-- 노사협의회 운영규약 4건을 규약·규정(rules) 게시판으로 이동
update public.posts set board='rules', title=replace(title,' [노사협의회 운영규약]','') where attachments->>'legacy_id' in ('gw-000000oeq','gw-000000n0u','gw-000000mm8','gw-000000lm2');

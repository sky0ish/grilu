-- 그룹웨어 노사협의회 게시판 이관 데이터 (자동 생성: tools/import_council.py)
-- 게시판 코드 council 에 넣습니다. 여러 번 실행해도 중복되지 않습니다.
create unique index if not exists posts_legacy_idx on public.posts ((attachments->>'legacy_id')) where attachments ? 'legacy_id';

insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2020년 제3차 노사협의회 회의록 게시','2020년도 제3차 노사협의회 회의록을 게시합니다.

[첨부파일]
- ★2020년도 3차 노사협의회 회의록(게시용).hwp (335.5 KB)','장영자',false,'{"legacy_id": "000000ilx", "files": ["★2020년도 3차 노사협의회 회의록(게시용).hwp (335.5 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2020-12-29'::date,'2020-12-29'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000ilx');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2020년 제4차 노사협의회 회의록 게시','2020년도 제4차 노사협의회 회의록을 게시합니다.

[첨부파일]
- ★2020년도 제4차 노사협의회 회의록(게시용).hwp (459 KB)','장영자',false,'{"legacy_id": "000000ink", "files": ["★2020년도 제4차 노사협의회 회의록(게시용).hwp (459 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2021-01-21'::date,'2021-01-21'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000ink');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2021년도 제1차 노사협의회 회의록 게시','2021년도 제1차 노사협의회(2021.5.6) 회의록을 게시합니다.

[첨부파일]
- 2021년도 제1차 노사협의회 회의록(게시).pdf (2,179.2 KB)','장영자',false,'{"legacy_id": "000000j2l", "files": ["2021년도 제1차 노사협의회 회의록(게시).pdf (2,179.2 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2021-09-23'::date,'2021-09-23'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000j2l');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2021년도 제2차 노사협의회 회의록 게시','2021년도 제2차 노사협의회(2021.10.28) 회의록을 게시합니다.

[첨부파일]
- 2021년 제2차 노사협의회 회의록(2021.10.28)(게시).pdf (1,692.6 KB)','장영자',false,'{"legacy_id": "000000jb9", "files": ["2021년 제2차 노사협의회 회의록(2021.10.28)(게시).pdf (1,692.6 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-10'::date,'2022-01-10'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000jb9');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 선출을 위한 선거관리위원회 구성공고','<GRI노사협의회 근로자위원 선출을 위한 선거관리위원회 구성 공고>
GRI노사협의회 근로자위원 궐위(공석 3명)에 따라 노사협의회운영규약 제3장 제11조(선거관리위원회 구성)에 의거 GRI노사협의회 근로자위원 선출(3명 선출)을 위한 선거관리위원회를 아래와 같이 구성하고자 합니다. 선거관리위원회 위원으로 참여를 희망하는 직원은 22.1.12(수)까지 신청하여 주시기 바랍니다.
(담당자 행정지원부 장영자과장(내선 269))
- 아 래 -
□ 선거관리위원회 위원수: 선거관리 참여 희망 근로자 중 추첨에 의하여 2명 구성 ※선거관리위원회 위원은 향후 근로자위원에 입후보 불가
□ 선거관리위원회 구성기한: 선거공고일 14일 전까지 구성
□ 선거관리위원회 수행임무: 1. 선거 및 일정공고 2. 투표 및 입후보자 등록등에 관한사항','장영자',false,'{"legacy_id": "000000jba", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-10'::date,'2022-01-10'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000jba');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 선출을 위한 선거관리위원회 구성결과 공고','GRI노사협의회 근로자위원 선출을 위한 선거관리위원회 구성 결과 공고
GRI노사협의회 근로자위원 선출을 위한 선거관리위원회가 아래와 같이 구성되었음을 공고합니다.
- 아 래 -
□ 선거관리위원회 위원명단
- 조영무 연구위원(시군연구센터)
- 조영진 연구원(대외협력부)
□ 선거관리위원회 수행임무
1. 선거 및 일정공고
2. 투표 및 입후보자 등록 등에 관한사항
3. 당선자 결정에 관한 사항
4. 기타 선거와 관련된 사항
□ 향후 절차
• 근로자 위원 선출공고
• 근로자 위원 후보등록
• 선출투표 실시(직접·비밀·무기명 투표)','장영자',false,'{"legacy_id": "000000jbg", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-13'::date,'2022-01-13'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000jbg');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 보궐선거 및 일정 공고','GRI노사협의회 근로자위원 보궐선거 및 일정 공고
GRI노사협의회 구성을 위한 “근로자위원 선출”을 위한 선거를 아래와 같이 실시함을 공고합니다.
- 아 래 -
□ 선거명 노사협의회 근로자위원 선출 보궐선거
□ 선출 근로자위원 수 -연구직군 2명 -관리직군 1명 ※선출 근로자위원의 임기는 ~22.8.19까지
□ 선거일정 1) 위원선거인 : 직군별 재직중인 모든 근로자(실·부서장 제외) 2) 근로자위원 입후보자 등록 : 22.1.17(월) ~ 1.21(금), 5일간 3) 입후보자 확정공고 및 선거안내 : 22.1.24(월) 4) 투표일시 : 22.1.25(화), 전자투표 실시
□ 선출방법 1) 직군별 선거인은 입후보자 중 선호하는 후보자에 투표 2) 득표수가 같을 경우 장기근속자, 연장자순으로 당선자 결정 3) 근로자위원 선출인원과 입후보 인원이 동일할 경우 찬반투표를 실시하며, 유효투표 중 과반수의 찬성으로 근로자 위원 선출결정
GRI노사협의회 선거관리위원회

[첨부파일]
- GRI노사협의회 근로자위원 보궐선거 및 일정 공고(22.1.17).hwp (55 KB)
- 【서식】근로자위원 입후보자추천서.hwp (48 KB)','조영진',false,'{"legacy_id": "000000jbo", "files": ["GRI노사협의회 근로자위원 보궐선거 및 일정 공고(22.1.17).hwp (55 KB)", "【서식】근로자위원 입후보자추천서.hwp (48 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-17'::date,'2022-01-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000jbo');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 입후보자 확정 및 선거일정 공고(관리·정보·기능직군)','GRI노사협의회 근로자위원 입후보자 확정 및 선거일정 공고(관리·정보·기능직군)
GRI노사협의회 관리·정보·기능직군 근로자위원 입후보 결과에 따른 선거를 아래와 같이 실시함을 공고합니다.
- 아 래 -
□ 선거명 노사협의회 근로자위원 선출 보궐선거(관리·정보·기능직군)
□ 선출 근로자위원 수 -관리직군 1명 ※선출 근로자위원의 임기는 ~22.8.19까지
□ 근로자위원 입후보자 -성과관리부 민경진(관리 5급)
□ 선거일정 1) 선거일시 : 2022.1.25.(화) 09:00~18:00 2) 선거방법 : 전자투표 시행(그룹웨어사용) 3) 선거권자 : 22.1.24일 기준 재직중인 관리·정보·기능직 직원 27명(부서장 제외) ※근로자위원 선출인원과 입후보 인원이 동일할 경우 찬반투표를 실시하며, 유효투표 중 과반수의 찬성으로 근로자 위원 선출결정
2022. 1. 24 GRI노사협의회 선거관리위원회

[첨부파일]
- 220124 근로자위원 입후보자 확정 및 선거일정 공고.hwp (106.5 KB)','조영진',false,'{"legacy_id": "000000jdp", "files": ["220124 근로자위원 입후보자 확정 및 선거일정 공고.hwp (106.5 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-24'::date,'2022-01-24'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000jdp');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군)','GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군)
GRI노사협의회 구성을 위한 연구직군 근로자위원 선거를 아래와 같이 실시함을 재공고합니다.
- 아 래 -
□ 선거명 노사협의회 근로자위원 선출 보궐선거(연구직군)
□ 선출 근로자위원 수 -연구직군 2명 ※선출 근로자위원의 임기는 ~22.8.19까지
□ 입후보자 자격 -현재 경기연구원에 연구직으로 근무 중인 직원(실·부서장 제외) -직원 10명 이상의 추천서를 선거관리위원회에 제출
□ 선거일정 1) 근로자위원 입후보자 등록 : 22.1.24(월) ~ 2.4(금) 2) 입후보자 확정공고 및 선거안내 : 22.2.7(월) 3) 투표일시 : 22.2.8(화), 전자투표 실시 4) 위원선거인 : 재직중인 연구직군 직원(실·부서장 제외)
□ 선출방법 1) 위원선거인은 입후보자 중 선호하는 후보자에 투표 2) 득표수가 같을 경우 장기근속자, 연장자순으로 당선자 결정 3) 근로자위원 선출인원과 입후보 인원이 동일할 경우 찬반투표를 실시하며, 유효투표 중 과반수의 찬성으로 근로자 위원 선출결정
직원 여러분들의 많은 참여 바랍니다.
2022. 1. 24 GRI노사협의회 선거관리위원회

[첨부파일]
- 220124 GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군).hwp (80 KB)
- 【서식】근로자위원 입후보자추천서.hwp (48 KB)','조영진',false,'{"legacy_id": "000000jdq", "files": ["220124 GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군).hwp (80 KB)", "【서식】근로자위원 입후보자추천서.hwp (48 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-24'::date,'2022-01-24'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000jdq');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 선거결과 공고(관리·정보·기능직군)','','조영진',false,'{"legacy_id": "000000je6", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-28'::date,'2022-01-28'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000je6');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군)','GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군)
GRI노사협의회 구성을 위한 연구직군 근로자위원 선거를 아래와 같이 실시함을 재공고합니다.
- 아 래 -
□ 선거명 노사협의회 근로자위원 선출 보궐선거(연구직군)
□ 선출 근로자위원 수 -연구직군 2명 ※선출 근로자위원의 임기는 ~22.8.19까지
□ 입후보자 자격 -현재 경기연구원에 연구직으로 근무 중인 직원(실·부서장 제외) -직원 10명 이상의 추천서를 선거관리위원회에 제출
□ 선거일정 1) 근로자위원 입후보자 등록 : 22.3.17(목) ~ 3.22(화) 2) 입후보자 확정공고 및 선거안내 : 22.3.23(수) 3) 투표일시 : 22.3.24(목), 전자투표 실시 4) 위원선거인 : 재직중인 연구직군 직원(실·부서장 제외)
□ 선출방법 1) 위원선거인은 입후보자 중 선호하는 후보자에 투표 2) 득표수가 같을 경우 장기근속자, 연장자순으로 당선자 결정 3) 근로자위원 선출인원과 입후보 인원이 동일할 경우 찬반투표를 실시하며, 유효투표 중 과반수의 찬성으로 근로자 위원 선출결정
직원 여러분들의 많은 참여 바랍니다.
2022. 3. 17 GRI노사협의회 선거관리위원회

[첨부파일]
- GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(3.17).hwp (131.5 KB)
- 【서식】근로자위원 입후보자추천서.hwp (48 KB)','조영진',false,'{"legacy_id": "000000jic", "files": ["GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(3.17).hwp (131.5 KB)", "【서식】근로자위원 입후보자추천서.hwp (48 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-03-17'::date,'2022-03-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000jic');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군)','GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군)
GRI노사협의회 구성을 위한 연구직군 근로자위원 선거를 아래와 같이 실시함을 재공고합니다.
- 아 래 -
□ 선거명 노사협의회 근로자위원 선출 보궐선거(연구직군)
□ 선출 근로자위원 수 -연구직군 2명 ※선출 근로자위원의 임기는 ~22.8.19까지
□ 입후보자 자격 -현재 경기연구원에 연구직으로 근무 중인 직원(실·부서장 제외) -직원 10명 이상의 추천서를 선거관리위원회에 제출
□ 선거일정 1) 근로자위원 입후보자 등록 : 22.3.24.(목) ~ 3.30.(수) 2) 입후보자 확정공고 및 선거안내 : 22.3.31.(목) 3) 투표일시 : 22.4.1.(금), 전자투표 실시 4) 위원선거인 : 재직중인 연구직군 직원(실·부서장 제외)
□ 선출방법 1) 위원선거인은 입후보자 중 선호하는 후보자에 투표 2) 득표수가 같을 경우 장기근속자, 연장자순으로 당선자 결정 3) 근로자위원 선출인원과 입후보 인원이 동일할 경우 찬반투표를 실시하며, 유효투표 중 과반수의 찬성으로 근로자 위원 선출결정
직원 여러분들의 많은 참여 바랍니다.
2022. 3. 23 GRI노사협의회 선거관리위원회

[첨부파일]
- 【서식】근로자위원 입후보자추천서.hwp (48 KB)
- GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(3.23).hwp (131.5 KB)','조영진',false,'{"legacy_id": "000000jin", "files": ["【서식】근로자위원 입후보자추천서.hwp (48 KB)", "GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(3.23).hwp (131.5 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-03-23'::date,'2022-03-23'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000jin');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 입후보자 확정 및 선거일정 공고(연구직군)','GRI노사협의회 근로자위원 입후보자 확정 및 선거일정 공고(연구직군)
GRI노사협의회 연구직군 근로자위원 입후보 결과에 따른 선거를 아래와 같이 실시함을 공고합니다.
- 아 래 -
□ 선거명 노사협의회 근로자위원 선출 보궐선거(연구직군)
□ 선출 근로자위원 수 -연구직군 2명 ※선출 근로자위원의 임기는 ~22.8.19까지
□ 근로자위원 입후보자 -생태환경연구실 이양주(선임연구위원) -교통물류연구실 김채만(선임연구위원)
□ 선거일정 1) 선거일시 : 2022.4.1.(금) 09:00~18:00 2) 선거방법 : 전자투표 시행(그룹웨어사용) 3) 선거권자 : 22.3.31일 기준 재직중인 연구직 직원 58명 (부서장 제외, 공투센터 연구직 및 초빙연구직 포함) 4) 근로자위원 선출인원과 입후보 인원이 동일하여 찬반투표 실시, 유효투표 중 과반수의 찬성으로 근로자 위원 선출결정
2022. 3. 31 GRI노사협의회 선거관리위원회

[첨부파일]
- 220331 근로자위원 입후보자 확정 및 선거일정 공고(연구직군).hwp (112 KB)','조영진',false,'{"legacy_id": "000000jj7", "files": ["220331 근로자위원 입후보자 확정 및 선거일정 공고(연구직군).hwp (112 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-03-31'::date,'2022-03-31'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000jj7');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2022년 정기(1차) 노사협의회 회의록 게시','2022년도 정기(1차) 노사협의회(2022.5.26) 회의록을 게시합니다.

[첨부파일]
- 2022년 정기(1차) 노사협의회 회의록(22.5.26)(최종).pdf (2,067.5 KB)','장영자',false,'{"legacy_id": "000000jxe", "files": ["2022년 정기(1차) 노사협의회 회의록(22.5.26)(최종).pdf (2,067.5 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-06-13'::date,'2022-06-13'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000jxe');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2023년 정기(1차) 노사협의회 회의록 게시','2023년도 정기(1차) 노사협의회(2023.3.30) 회의록을 게시합니다.

[첨부파일]
- 2023년 정기(1차) 노사협의회 회의록(23.3.30).pdf (1,401.7 KB)','장소희',false,'{"legacy_id": "000000krh", "files": ["2023년 정기(1차) 노사협의회 회의록(23.3.30).pdf (1,401.7 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2023-05-23'::date,'2023-05-23'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000krh');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2023년도 제2차 노사협의회 회의록 게시','2023년도 제2차 노사협의회(2023.7.27) 회의록을 게시합니다

[첨부파일]
- 2023년도 제2차 노사협의회 결과 및 회의록.pdf (1,244.7 KB)','장소희',false,'{"legacy_id": "000000l23", "files": ["2023년도 제2차 노사협의회 결과 및 회의록.pdf (1,244.7 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2023-08-17'::date,'2023-08-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000l23');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2023년 제3차 및 제4차 노사협의회 결과 및 회의록','2023년 제3차 및 제4차 노사협의회 결과 및 회의록을 붙임과 같이 게시합니다.

[첨부파일]
- 2023년 제3차 노사협의회 결과 및 회의록.pdf (628.8 KB)
- 2023년도 제4차 노사협의회 결과 및 회의록.pdf (75.8 KB)','장소희',false,'{"legacy_id": "000000lbp", "files": ["2023년 제3차 노사협의회 결과 및 회의록.pdf (628.8 KB)", "2023년도 제4차 노사협의회 결과 및 회의록.pdf (75.8 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2024-01-03'::date,'2024-01-03'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000lbp');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2024년도 제1차 및 제2차 노사협의회 결과 및 회의록','2024년 제1차 및 제2차 노사협의회 결과 및 회의록을 붙임과 같이 게시합니다.

[첨부파일]
- 2024년도 제1차 노사협의회 결과 및 회의록.(최종).pdf (75.9 KB)
- 2024년도 제2차 노사협의회 결과 및 회의록(최종).pdf (69.9 KB)','정지선',false,'{"legacy_id": "000000lmn", "files": ["2024년도 제1차 노사협의회 결과 및 회의록.(최종).pdf (75.9 KB)", "2024년도 제2차 노사협의회 결과 및 회의록(최종).pdf (69.9 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2024-07-03'::date,'2024-07-03'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000lmn');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2024년도 제3차 노사협의회 결과 및 회의록','2024년도 제3차 노사협의회 결과 및 회의록을 붙임과 같이 게시합니다.

[첨부파일]
- 2024년도 제3차 노사협의회 결과 및 회의록.pdf (77.7 KB)','장소희',false,'{"legacy_id": "000000lqx", "files": ["2024년도 제3차 노사협의회 결과 및 회의록.pdf (77.7 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2024-10-04'::date,'2024-10-04'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000lqx');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2024년 제4차 노사협의회 결과 및 회의록','2024년 제4차 노사협의회 결과 및 회의록, 보고사항 관련 참고자료를 게시합니다.

[첨부파일]
- 2024년도 제4차 노사협의회 결과 및 회의록.pdf (75 KB)
- (별첨) 보고사항_2025년도 사업계획(안).pdf (3,521.8 KB)','장소희',false,'{"legacy_id": "000000mhc", "files": ["2024년도 제4차 노사협의회 결과 및 회의록.pdf (75 KB)", "(별첨) 보고사항_2025년도 사업계획(안).pdf (3,521.8 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2025-01-02'::date,'2025-01-02'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000mhc');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','경기연구원 기관이전 관련 전직원 설문조사 결과보고','경기연구원 기관이전 관련 전직원 설문조사 결과보고를 붙임과 같이 게시합니다.
- 조사대상 : 경기연구원 전직원
- 모집단 수 : 207명(2025. 2. 12. 기준 남101, 여 106)
- 응답자 수 : 151명
- 조사기간 : 2025. 2. 10. ~ 2025. 2. 12.(3일간)
- 조사방법 : 구글폼을 통한 설문조사

[첨부파일]
- (노조)경기연구원 기관이전 관련 전직원 설문조사_결과보고_최종(배포용).pdf (829.9 KB)','황지현',false,'{"legacy_id": "000000mmt", "files": ["(노조)경기연구원 기관이전 관련 전직원 설문조사_결과보고_최종(배포용).pdf (829.9 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2025-02-24'::date,'2025-02-24'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000mmt');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2025년 제1차 노사협의회 회의록','

[첨부파일]
- 2025년 제1차 노사협의회 회의록.pdf (1,046.4 KB)','정지선',false,'{"legacy_id": "000000msc", "files": ["2025년 제1차 노사협의회 회의록.pdf (1,046.4 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2025-04-17'::date,'2025-04-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000msc');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2025년 제2차 노사협의회 회의록','

[첨부파일]
- 2025년도 제2차 노사협의회 결과 및 회의록(최종).pdf (85.8 KB)','정지선',false,'{"legacy_id": "000000n0t", "files": ["2025년도 제2차 노사협의회 결과 및 회의록(최종).pdf (85.8 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2025-06-25'::date,'2025-06-25'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000n0t');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2025년 제3차 노사협의회 회의록','

[첨부파일]
- 2025년도 제3차 노사협의회 결과 및 회의록.hwp (149.5 KB)','정지선',false,'{"legacy_id": "000000nuv", "files": ["2025년도 제3차 노사협의회 결과 및 회의록.hwp (149.5 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2026-01-07'::date,'2026-01-07'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000nuv');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2025년 제4차 노사협의회 회의록','

[첨부파일]
- 2025년도 제4차 노사협의회 결과 및 회의록(최종).hwp.pdf (94.8 KB)','정지선',false,'{"legacy_id": "000000nv3", "files": ["2025년도 제4차 노사협의회 결과 및 회의록(최종).hwp.pdf (94.8 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2026-01-09'::date,'2026-01-09'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000nv3');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2026년 제1차 노사협의회 회의록','

[첨부파일]
- 2026년 제1차 노사협의회 결과보고.pdf (69.3 KB)','장소희',false,'{"legacy_id": "000000oer", "files": ["2026년 제1차 노사협의회 결과보고.pdf (69.3 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2026-05-22'::date,'2026-05-22'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000oer');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2026년 제2차 노사협의회 회의록','

[첨부파일]
- 2026년 제2차 노사협의회 결과보고(회의록).pdf (62.1 KB)','장소희',false,'{"legacy_id": "000000omc", "files": ["2026년 제2차 노사협의회 결과보고(회의록).pdf (62.1 KB)"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2026-07-09'::date,'2026-07-09'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = '000000omc');
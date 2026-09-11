-- 그룹웨어 이관 게시글 (심의위원회/노동이사 활동보고/노사협의회) 자동 생성: tools/import_gw.py + build 스크립트
insert into public.boards (code, name, members_only, admin_only_write) values ('committee','심의위원회',false,true) on conflict (code) do nothing;
create unique index if not exists posts_legacy_idx on public.posts ((attachments->>'legacy_id')) where attachments ? 'legacy_id';
-- 이전에 넣은 노사협의회 27건(요약본) 삭제 후 전체 82건으로 교체
delete from public.posts where board='council' and attachments ? 'legacy_id' and attachments->>'legacy_id' not like 'gw-%';
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','26-4차 심의위원회 상정(안) 게시 및 직원 의견청취 안','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2026-09-08<br><a href="https://grilu.kr/gri/committee/000000oz2.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000oz2&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000oz2&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 심의위원회 심의안건(26-4차).pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000oz2", "page": "gri/committee/000000oz2.html", "files": ["심의위원회 심의안건(26-4차).pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2026-09-08'::date,'2026-09-08'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000oz2');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2026년 제2차 노사협의회 회의록','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장소희 · 게시일 2026-07-09<br><a href="https://grilu.kr/archive/council/000000omc.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000omc&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000omc&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2026년 제2차 노사협의회 결과보고(회의록).pdf</p>','장소희',false,'{"legacy_id": "gw-000000omc", "page": "archive/council/000000omc.html", "files": ["2026년 제2차 노사협의회 결과보고(회의록).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2026-07-09'::date,'2026-07-09'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000omc');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','26-3차 심의위원회 상정(안) 게시 및 직원 의견청취 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2026-06-08<br><a href="https://grilu.kr/gri/committee/000000og1.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000og1&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000og1&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 심의위원회 심의안건(26-3차).pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000og1", "page": "gri/committee/000000og1.html", "files": ["심의위원회 심의안건(26-3차).pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2026-06-08'::date,'2026-06-08'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000og1');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2026년 제1차 노사협의회 회의록','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장소희 · 게시일 2026-05-22<br><a href="https://grilu.kr/archive/council/000000oer.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000oer&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000oer&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2026년 제1차 노사협의회 결과보고.pdf</p>','장소희',false,'{"legacy_id": "gw-000000oer", "page": "archive/council/000000oer.html", "files": ["2026년 제1차 노사협의회 결과보고.pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2026-05-22'::date,'2026-05-22'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000oer');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','노사협의회 운영규약(2026.5.22.) [노사협의회 운영규약]','<div class="box" style="margin-bottom:16px"><b>노사협의회 운영규약</b> · 작성자 장소희 · 게시일 2026-05-22<br><a href="https://grilu.kr/archive/council/000000oeq.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000oeq&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000oeq&amp;BRDID=0000001yl&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 노사협의회 운영규약 일부개정 공포문 (2026.5.22.).pdf</p>','장소희',false,'{"legacy_id": "gw-000000oeq", "page": "archive/council/000000oeq.html", "files": ["노사협의회 운영규약 일부개정 공포문 (2026.5.22.).pdf"], "source": "gw.gri.re.kr 노사협의회 운영규약"}'::jsonb,'2026-05-22'::date,'2026-05-22'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000oeq');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','26-1차 심의위원회 상정(안) 게시 및 직원 의견청취 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2026-03-05<br><a href="https://grilu.kr/gri/committee/000000o1k.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000o1k&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000o1k&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 심의위원회 심의안건(26-1차).pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000o1k", "page": "gri/committee/000000o1k.html", "files": ["심의위원회 심의안건(26-1차).pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2026-03-05'::date,'2026-03-05'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000o1k');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','2025년 하반기 경기연구원 노동이사 활동 보고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 김정훈 · 게시일 2026-01-09<br><a href="https://grilu.kr/gri/director/000000nv5.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000nv5&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000nv5&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 경기연구원 노동이사 활동 보고(2025년 하반기)_251231.hwp</p>','김정훈',false,'{"legacy_id": "gw-000000nv5", "page": "gri/director/000000nv5.html", "files": ["경기연구원 노동이사 활동 보고(2025년 하반기)_251231.hwp"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2026-01-09'::date,'2026-01-09'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000nv5');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','2025년 상반기 경기연구원 노동이사 활동 보고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 김정훈 · 게시일 2026-01-09<br><a href="https://grilu.kr/gri/director/000000nv4.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000nv4&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000nv4&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 경기연구원 노동이사 활동 보고(2025년 상반기)_250630.hwp</p>','김정훈',false,'{"legacy_id": "gw-000000nv4", "page": "gri/director/000000nv4.html", "files": ["경기연구원 노동이사 활동 보고(2025년 상반기)_250630.hwp"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2026-01-09'::date,'2026-01-09'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000nv4');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2025년 제4차 노사협의회 회의록','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정지선 · 게시일 2026-01-09<br><a href="https://grilu.kr/archive/council/000000nv3.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000nv3&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000nv3&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2025년도 제4차 노사협의회 결과 및 회의록(최종).hwp.pdf</p>','정지선',false,'{"legacy_id": "gw-000000nv3", "page": "archive/council/000000nv3.html", "files": ["2025년도 제4차 노사협의회 결과 및 회의록(최종).hwp.pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2026-01-09'::date,'2026-01-09'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000nv3');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2025년 제3차 노사협의회 회의록','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정지선 · 게시일 2026-01-07<br><a href="https://grilu.kr/archive/council/000000nuv.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000nuv&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000nuv&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2025년도 제3차 노사협의회 결과 및 회의록.hwp</p>','정지선',false,'{"legacy_id": "gw-000000nuv", "page": "archive/council/000000nuv.html", "files": ["2025년도 제3차 노사협의회 결과 및 회의록.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2026-01-07'::date,'2026-01-07'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000nuv');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','25-12차 심의위원회 상정(안) 게시 및 직원 의견청취 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2025-12-31<br><a href="https://grilu.kr/gri/committee/000000nts.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000nts&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000nts&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 심의위원회 심의안건(25-12차).hwp</p>','장소희',false,'{"legacy_id": "gw-000000nts", "page": "gri/committee/000000nts.html", "files": ["심의위원회 심의안건(25-12차).hwp"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2025-12-31'::date,'2025-12-31'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000nts');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','25-10차 심의위원회 상정(안) 게시 및 직원 의견청취 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2025-11-10<br><a href="https://grilu.kr/gri/committee/000000nns.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000nns&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000nns&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 심의위원회 심의안건(25-10차)_의견수렴.pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000nns", "page": "gri/committee/000000nns.html", "files": ["심의위원회 심의안건(25-10차)_의견수렴.pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2025-11-10'::date,'2025-11-10'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000nns');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','노사협의회 운영규약(2025.06.17) [노사협의회 운영규약]','<div class="box" style="margin-bottom:16px"><b>노사협의회 운영규약</b> · 작성자 정지선 · 게시일 2025-06-25<br><a href="https://grilu.kr/archive/council/000000n0u.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000n0u&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000n0u&amp;BRDID=0000001yl&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 노사협의회 운영규약(일부개정)_250617.pdf</p>','정지선',false,'{"legacy_id": "gw-000000n0u", "page": "archive/council/000000n0u.html", "files": ["노사협의회 운영규약(일부개정)_250617.pdf"], "source": "gw.gri.re.kr 노사협의회 운영규약"}'::jsonb,'2025-06-25'::date,'2025-06-25'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000n0u');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2025년 제2차 노사협의회 회의록','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정지선 · 게시일 2025-06-25<br><a href="https://grilu.kr/archive/council/000000n0t.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000n0t&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000n0t&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2025년도 제2차 노사협의회 결과 및 회의록(최종).pdf</p>','정지선',false,'{"legacy_id": "gw-000000n0t", "page": "archive/council/000000n0t.html", "files": ["2025년도 제2차 노사협의회 결과 및 회의록(최종).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2025-06-25'::date,'2025-06-25'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000n0t');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2025년 제1차 노사협의회 회의록','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정지선 · 게시일 2025-04-17<br><a href="https://grilu.kr/archive/council/000000msc.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000msc&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000msc&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2025년 제1차 노사협의회 회의록.pdf</p>','정지선',false,'{"legacy_id": "gw-000000msc", "page": "archive/council/000000msc.html", "files": ["2025년 제1차 노사협의회 회의록.pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2025-04-17'::date,'2025-04-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000msc');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','경기연구원 기관이전 관련 전직원 설문조사 결과보고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 황지현 · 게시일 2025-02-24<br><a href="https://grilu.kr/archive/council/000000mmt.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000mmt&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000mmt&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: (노조)경기연구원 기관이전 관련 전직원 설문조사_결과보고_최종(배포용).pdf</p>','황지현',false,'{"legacy_id": "gw-000000mmt", "page": "archive/council/000000mmt.html", "files": ["(노조)경기연구원 기관이전 관련 전직원 설문조사_결과보고_최종(배포용).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2025-02-24'::date,'2025-02-24'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000mmt');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','25-1차 심의위원회 상정(안) 게시 및 직원 의견청취 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2025-02-17<br><a href="https://grilu.kr/gri/committee/000000mmh.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000mmh&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000mmh&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 심의위원회 심의안건(25-1).pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000mmh", "page": "gri/committee/000000mmh.html", "files": ["심의위원회 심의안건(25-1).pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2025-02-17'::date,'2025-02-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000mmh');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','노사협의회 운영규약(2024.12.31.) [노사협의회 운영규약]','<div class="box" style="margin-bottom:16px"><b>노사협의회 운영규약</b> · 작성자 장소희 · 게시일 2025-02-13<br><a href="https://grilu.kr/archive/council/000000mm8.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000mm8&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000mm8&amp;BRDID=0000001yl&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 노사협의회 운영규약(일부 개정안)_241231.pdf</p>','장소희',false,'{"legacy_id": "gw-000000mm8", "page": "archive/council/000000mm8.html", "files": ["노사협의회 운영규약(일부 개정안)_241231.pdf"], "source": "gw.gri.re.kr 노사협의회 운영규약"}'::jsonb,'2025-02-13'::date,'2025-02-13'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000mm8');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2024년 제4차 노사협의회 결과 및 회의록','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장소희 · 게시일 2025-01-02<br><a href="https://grilu.kr/archive/council/000000mhc.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000mhc&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000mhc&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2024년도 제4차 노사협의회 결과 및 회의록.pdf, (별첨) 보고사항_2025년도 사업계획(안).pdf</p>','장소희',false,'{"legacy_id": "gw-000000mhc", "page": "archive/council/000000mhc.html", "files": ["2024년도 제4차 노사협의회 결과 및 회의록.pdf", "(별첨) 보고사항_2025년도 사업계획(안).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2025-01-02'::date,'2025-01-02'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000mhc');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','24-14차 심의위원회 상정(안) 게시 및 직원 의견청취 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2024-12-06<br><a href="https://grilu.kr/gri/committee/000000ltv.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ltv&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ltv&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 심의위원회 심의안건(24-14).pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000ltv", "page": "gri/committee/000000ltv.html", "files": ["심의위원회 심의안건(24-14).pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2024-12-06'::date,'2024-12-06'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ltv');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','24-13차 심의위원회 상정(안) 게시 및 직원 의견청취 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2024-11-06<br><a href="https://grilu.kr/gri/committee/000000lsd.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000lsd&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000lsd&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 심의위원회 심의안건(24-13)_게시.pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000lsd", "page": "gri/committee/000000lsd.html", "files": ["심의위원회 심의안건(24-13)_게시.pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2024-11-06'::date,'2024-11-06'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000lsd');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 선거결과 공고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 이용원 · 게시일 2024-10-30<br><a href="https://grilu.kr/gri/director/000000ls3.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ls3&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ls3&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 선거결과 공고(게시).pdf</p>','이용원',false,'{"legacy_id": "gw-000000ls3", "page": "gri/director/000000ls3.html", "files": ["선거결과 공고(게시).pdf"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2024-10-30'::date,'2024-10-30'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ls3');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 선출을 위한 ''입후보자 및 선거일정'' 공고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 이용원 · 게시일 2024-10-21<br><a href="https://grilu.kr/gri/director/000000lrn.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000lrn&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000lrn&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 노동이사 입후보자 선거공고.pdf</p>','이용원',false,'{"legacy_id": "gw-000000lrn", "page": "gri/director/000000lrn.html", "files": ["노동이사 입후보자 선거공고.pdf"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2024-10-21'::date,'2024-10-21'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000lrn');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2024년도 제3차 노사협의회 결과 및 회의록','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장소희 · 게시일 2024-10-04<br><a href="https://grilu.kr/archive/council/000000lqx.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000lqx&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000lqx&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2024년도 제3차 노사협의회 결과 및 회의록.pdf</p>','장소희',false,'{"legacy_id": "gw-000000lqx", "page": "archive/council/000000lqx.html", "files": ["2024년도 제3차 노사협의회 결과 및 회의록.pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2024-10-04'::date,'2024-10-04'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000lqx');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 공개모집 공고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 이용원 · 게시일 2024-10-04<br><a href="https://grilu.kr/gri/director/000000lqw.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000lqw&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000lqw&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI 노동이사 공개모집 공고문.hwpx, GRI 노동이사 공개모집 신청서 및 제출서류(양식).hwpx</p>','이용원',false,'{"legacy_id": "gw-000000lqw", "page": "gri/director/000000lqw.html", "files": ["GRI 노동이사 공개모집 공고문.hwpx", "GRI 노동이사 공개모집 신청서 및 제출서류(양식).hwpx"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2024-10-04'::date,'2024-10-04'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000lqw');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','[답글] 24-10차 심의위원회 상정(안)에 대한 직원 의견 관련 답변서','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2024-08-26<br><a href="https://grilu.kr/gri/committee/000000lpd.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000lpd&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000lpd&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 심의위원회 개최에 따른 직원 의견제안 답변서.pdf</p>','장소희',false,'{"legacy_id": "gw-000000lpd", "page": "gri/committee/000000lpd.html", "files": ["심의위원회 개최에 따른 직원 의견제안 답변서.pdf"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2024-08-26'::date,'2024-08-26'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000lpd');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','24-10차 심의위원회 상정(안) 게시 및 직원 의견청취 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2024-08-05<br><a href="https://grilu.kr/gri/committee/000000lo7.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000lo7&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000lo7&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 심의위원회 심의안건(24-10).pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000lo7", "page": "gri/committee/000000lo7.html", "files": ["심의위원회 심의안건(24-10).pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2024-08-05'::date,'2024-08-05'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000lo7');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','24-8차 심의위원회 상정(안) 게시 및 직원 의견청취 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2024-07-04<br><a href="https://grilu.kr/gri/committee/000000lmq.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000lmq&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000lmq&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 24-8차 심의위원회 심의안건.pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000lmq", "page": "gri/committee/000000lmq.html", "files": ["24-8차 심의위원회 심의안건.pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2024-07-04'::date,'2024-07-04'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000lmq');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2024년도 제1차 및 제2차 노사협의회 결과 및 회의록','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정지선 · 게시일 2024-07-03<br><a href="https://grilu.kr/archive/council/000000lmn.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000lmn&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000lmn&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2024년도 제1차 노사협의회 결과 및 회의록.(최종).pdf, 2024년도 제2차 노사협의회 결과 및 회의록(최종).pdf</p>','정지선',false,'{"legacy_id": "gw-000000lmn", "page": "archive/council/000000lmn.html", "files": ["2024년도 제1차 노사협의회 결과 및 회의록.(최종).pdf", "2024년도 제2차 노사협의회 결과 및 회의록(최종).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2024-07-03'::date,'2024-07-03'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000lmn');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','노사협의회 운영규약 (2024.06.27) [노사협의회 운영규약]','<div class="box" style="margin-bottom:16px"><b>노사협의회 운영규약</b> · 작성자 정지선 · 게시일 2024-06-27<br><a href="https://grilu.kr/archive/council/000000lm2.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000lm2&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000lm2&amp;BRDID=0000001yl&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 노사협의회 운영규약(일부 개정)_24.06.27.pdf</p>','정지선',false,'{"legacy_id": "gw-000000lm2", "page": "archive/council/000000lm2.html", "files": ["노사협의회 운영규약(일부 개정)_24.06.27.pdf"], "source": "gw.gri.re.kr 노사협의회 운영규약"}'::jsonb,'2024-06-27'::date,'2024-06-27'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000lm2');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','24-7차 심의위원회 상정(안) 게시 및 직원 의견청취 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2024-06-12<br><a href="https://grilu.kr/gri/committee/000000ll4.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ll4&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ll4&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 규정 및 규칙 제·개정(안) -의견청취-.pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx, 24-7차 심의위원회 심의안건(게시).pdf</p>','장소희',false,'{"legacy_id": "gw-000000ll4", "page": "gri/committee/000000ll4.html", "files": ["규정 및 규칙 제·개정(안) -의견청취-.pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx", "24-7차 심의위원회 심의안건(게시).pdf"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2024-06-12'::date,'2024-06-12'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ll4');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','24-2차 심의위원회 상정(안) 게시 및 직원 의견청취','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2024-01-26<br><a href="https://grilu.kr/gri/committee/000000ldb.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ldb&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ldb&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 24-2차 심의위원회 안건자료(게시).pdf, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000ldb", "page": "gri/committee/000000ldb.html", "files": ["24-2차 심의위원회 안건자료(게시).pdf", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2024-01-26'::date,'2024-01-26'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ldb');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2023년 제3차 및 제4차 노사협의회 결과 및 회의록','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장소희 · 게시일 2024-01-03<br><a href="https://grilu.kr/archive/council/000000lbp.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000lbp&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000lbp&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2023년 제3차 노사협의회 결과 및 회의록.pdf, 2023년도 제4차 노사협의회 결과 및 회의록.pdf</p>','장소희',false,'{"legacy_id": "gw-000000lbp", "page": "archive/council/000000lbp.html", "files": ["2023년 제3차 노사협의회 결과 및 회의록.pdf", "2023년도 제4차 노사협의회 결과 및 회의록.pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2024-01-03'::date,'2024-01-03'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000lbp');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','23-13차 심의위원회 상정(안) 게시 및 직원 의견청취 관련 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2023-08-24<br><a href="https://grilu.kr/gri/committee/000000l2i.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000l2i&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000l2i&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 23-13차 심의위원회 안건자료(8.28).hwp, (양식) 심의위원회 안건 관련 의견 작성 양식 (1).hwpx</p>','장소희',false,'{"legacy_id": "gw-000000l2i", "page": "gri/committee/000000l2i.html", "files": ["23-13차 심의위원회 안건자료(8.28).hwp", "(양식) 심의위원회 안건 관련 의견 작성 양식 (1).hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2023-08-24'::date,'2023-08-24'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000l2i');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2023년도 제2차 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장소희 · 게시일 2023-08-17<br><a href="https://grilu.kr/archive/council/000000l23.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000l23&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000l23&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2023년도 제2차 노사협의회 결과 및 회의록.pdf</p>','장소희',false,'{"legacy_id": "gw-000000l23", "page": "archive/council/000000l23.html", "files": ["2023년도 제2차 노사협의회 결과 및 회의록.pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2023-08-17'::date,'2023-08-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000l23');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','23-11차 심의위원회 상정(안) 게시 및 직원 의견청취 관련 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2023-07-19<br><a href="https://grilu.kr/gri/committee/000000kzx.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000kzx&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000kzx&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 23-11차 심의위원회 안건자료_게시.hwp, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000kzx", "page": "gri/committee/000000kzx.html", "files": ["23-11차 심의위원회 안건자료_게시.hwp", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2023-07-19'::date,'2023-07-19'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000kzx');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','23-9차 심의위원회 상정(안) 게시 및 의견청취 관련 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장소희 · 게시일 2023-06-09<br><a href="https://grilu.kr/gri/committee/000000kve.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000kve&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000kve&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 23-9차 심의위원회 안건자료_연구윤리규칙 일부 규칙개정(안).hwp, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장소희',false,'{"legacy_id": "gw-000000kve", "page": "gri/committee/000000kve.html", "files": ["23-9차 심의위원회 안건자료_연구윤리규칙 일부 규칙개정(안).hwp", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2023-06-09'::date,'2023-06-09'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000kve');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2023년 정기(1차) 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장소희 · 게시일 2023-05-23<br><a href="https://grilu.kr/archive/council/000000krh.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000krh&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000krh&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2023년 정기(1차) 노사협의회 회의록(23.3.30).pdf</p>','장소희',false,'{"legacy_id": "gw-000000krh", "page": "archive/council/000000krh.html", "files": ["2023년 정기(1차) 노사협의회 회의록(23.3.30).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2023-05-23'::date,'2023-05-23'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000krh');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','23-6차 심의위원회 상정(안) 게시 및 의견청취 관련 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 정형기 · 게시일 2023-04-10<br><a href="https://grilu.kr/gri/committee/000000koe.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000koe&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000koe&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 23-6 심의위원회 안건자료.hwp, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','정형기',false,'{"legacy_id": "gw-000000koe", "page": "gri/committee/000000koe.html", "files": ["23-6 심의위원회 안건자료.hwp", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2023-04-10'::date,'2023-04-10'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000koe');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','23-2차 심의위원회 상정(안) 게시 및 의견청취 관련 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 정형기 · 게시일 2023-02-22<br><a href="https://grilu.kr/gri/committee/000000kkr.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000kkr&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000kkr&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 23-2차 심의위원회 안건자료(2.27) 게시.hwp, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','정형기',false,'{"legacy_id": "gw-000000kkr", "page": "gri/committee/000000kkr.html", "files": ["23-2차 심의위원회 안건자료(2.27) 게시.hwp", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2023-02-22'::date,'2023-02-22'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000kkr');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'committee','23-1차 심의위원회 상정(안) 게시 및 직원 의견청취 관련 안내','<div class="box" style="margin-bottom:16px"><b>심의위원회 상정(안)</b> · 작성자 장영자 · 게시일 2023-01-17<br><a href="https://grilu.kr/gri/committee/000000keq.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000keq&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000keq&amp;BRDID=000000371&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 23-1차 심의위원회 안건자료.hwp, (양식) 심의위원회 안건 관련 의견 작성 양식.hwpx</p>','장영자',false,'{"legacy_id": "gw-000000keq", "page": "gri/committee/000000keq.html", "files": ["23-1차 심의위원회 안건자료.hwp", "(양식) 심의위원회 안건 관련 의견 작성 양식.hwpx"], "source": "gw.gri.re.kr 심의위원회 상정(안)"}'::jsonb,'2023-01-17'::date,'2023-01-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000keq');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2022년 정기(1차) 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2022-06-13<br><a href="https://grilu.kr/archive/council/000000jxe.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jxe&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jxe&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2022년 정기(1차) 노사협의회 회의록(22.5.26)(최종).pdf</p>','장영자',false,'{"legacy_id": "gw-000000jxe", "page": "archive/council/000000jxe.html", "files": ["2022년 정기(1차) 노사협의회 회의록(22.5.26)(최종).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-06-13'::date,'2022-06-13'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jxe');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 선거결과 공고(연구직군)','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 조영진 · 게시일 2022-04-04<br><a href="https://grilu.kr/archive/council/000000jjk.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jjk&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jjk&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p>','조영진',false,'{"legacy_id": "gw-000000jjk", "page": "archive/council/000000jjk.html", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-04-04'::date,'2022-04-04'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jjk');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 입후보자 확정 및 선거일정 공고(연구직군)','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 조영진 · 게시일 2022-03-31<br><a href="https://grilu.kr/archive/council/000000jj7.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jj7&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jj7&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 220331 근로자위원 입후보자 확정 및 선거일정 공고(연구직군).hwp</p>','조영진',false,'{"legacy_id": "gw-000000jj7", "page": "archive/council/000000jj7.html", "files": ["220331 근로자위원 입후보자 확정 및 선거일정 공고(연구직군).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-03-31'::date,'2022-03-31'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jj7');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군)','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 조영진 · 게시일 2022-03-23<br><a href="https://grilu.kr/archive/council/000000jin.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jin&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jin&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 【서식】근로자위원 입후보자추천서.hwp, GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(3.23).hwp</p>','조영진',false,'{"legacy_id": "gw-000000jin", "page": "archive/council/000000jin.html", "files": ["【서식】근로자위원 입후보자추천서.hwp", "GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(3.23).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-03-23'::date,'2022-03-23'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jin');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군)','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 조영진 · 게시일 2022-03-17<br><a href="https://grilu.kr/archive/council/000000jic.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jic&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jic&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(3.17).hwp, 【서식】근로자위원 입후보자추천서.hwp</p>','조영진',false,'{"legacy_id": "gw-000000jic", "page": "archive/council/000000jic.html", "files": ["GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(3.17).hwp", "【서식】근로자위원 입후보자추천서.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-03-17'::date,'2022-03-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jic');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 선거결과 공고(관리·정보·기능직군)','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 조영진 · 게시일 2022-01-28<br><a href="https://grilu.kr/archive/council/000000je6.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000je6&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000je6&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p>','조영진',false,'{"legacy_id": "gw-000000je6", "page": "archive/council/000000je6.html", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-28'::date,'2022-01-28'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000je6');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군)','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 조영진 · 게시일 2022-01-24<br><a href="https://grilu.kr/archive/council/000000jdq.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jdq&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jdq&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 220124 GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군).hwp, 【서식】근로자위원 입후보자추천서.hwp</p>','조영진',false,'{"legacy_id": "gw-000000jdq", "page": "archive/council/000000jdq.html", "files": ["220124 GRI노사협의회 근로자위원 보궐선거 및 일정 재공고(연구직군).hwp", "【서식】근로자위원 입후보자추천서.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-24'::date,'2022-01-24'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jdq');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 입후보자 확정 및 선거일정 공고(관리·정보·기능직군)','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 조영진 · 게시일 2022-01-24<br><a href="https://grilu.kr/archive/council/000000jdp.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jdp&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jdp&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 220124 근로자위원 입후보자 확정 및 선거일정 공고.hwp</p>','조영진',false,'{"legacy_id": "gw-000000jdp", "page": "archive/council/000000jdp.html", "files": ["220124 근로자위원 입후보자 확정 및 선거일정 공고.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-24'::date,'2022-01-24'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jdp');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 보궐선거 및 일정 공고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 조영진 · 게시일 2022-01-17<br><a href="https://grilu.kr/archive/council/000000jbo.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jbo&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jbo&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI노사협의회 근로자위원 보궐선거 및 일정 공고(22.1.17).hwp, 【서식】근로자위원 입후보자추천서.hwp</p>','조영진',false,'{"legacy_id": "gw-000000jbo", "page": "archive/council/000000jbo.html", "files": ["GRI노사협의회 근로자위원 보궐선거 및 일정 공고(22.1.17).hwp", "【서식】근로자위원 입후보자추천서.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-17'::date,'2022-01-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jbo');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 선출을 위한 선거관리위원회 구성결과 공고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2022-01-13<br><a href="https://grilu.kr/archive/council/000000jbg.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jbg&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jbg&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p>','장영자',false,'{"legacy_id": "gw-000000jbg", "page": "archive/council/000000jbg.html", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-13'::date,'2022-01-13'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jbg');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI노사협의회 근로자위원 선출을 위한 선거관리위원회 구성공고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2022-01-10<br><a href="https://grilu.kr/archive/council/000000jba.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jba&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jba&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p>','장영자',false,'{"legacy_id": "gw-000000jba", "page": "archive/council/000000jba.html", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-10'::date,'2022-01-10'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jba');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2021년도 제2차 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2022-01-10<br><a href="https://grilu.kr/archive/council/000000jb9.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000jb9&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000jb9&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2021년 제2차 노사협의회 회의록(2021.10.28)(게시).pdf</p>','장영자',false,'{"legacy_id": "gw-000000jb9", "page": "archive/council/000000jb9.html", "files": ["2021년 제2차 노사협의회 회의록(2021.10.28)(게시).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2022-01-10'::date,'2022-01-10'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000jb9');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 선거결과공고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 송성종 · 게시일 2021-12-14<br><a href="https://grilu.kr/gri/director/000000j6b.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000j6b&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000j6b&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p>','송성종',false,'{"legacy_id": "gw-000000j6b", "page": "gri/director/000000j6b.html", "files": [], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2021-12-14'::date,'2021-12-14'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000j6b');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 후보자 사퇴 공고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 송성종 · 게시일 2021-12-09<br><a href="https://grilu.kr/gri/director/000000j64.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000j64&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000j64&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 후보자 사퇴공고문.pdf</p>','송성종',false,'{"legacy_id": "gw-000000j64", "page": "gri/director/000000j64.html", "files": ["후보자 사퇴공고문.pdf"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2021-12-09'::date,'2021-12-09'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000j64');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 입후보자 및 선거일정공고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 송성종 · 게시일 2021-12-01<br><a href="https://grilu.kr/gri/director/000000j5l.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000j5l&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000j5l&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 입후보자 및 선거공고.pdf, 입후보자직무수행계획서(송제룡).pdf, 입후보자직무수행계획서(조영무).pdf, 입후보자직무수행계획서(김점산).pdf</p>','송성종',false,'{"legacy_id": "gw-000000j5l", "page": "gri/director/000000j5l.html", "files": ["입후보자 및 선거공고.pdf", "입후보자직무수행계획서(송제룡).pdf", "입후보자직무수행계획서(조영무).pdf", "입후보자직무수행계획서(김점산).pdf"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2021-12-01'::date,'2021-12-01'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000j5l');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 공개모집 재공고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 송성종 · 게시일 2021-11-22<br><a href="https://grilu.kr/gri/director/000000j55.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000j55&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000j55&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 노동이사제 입후보자 공개모집 재공고문.hwp</p>','송성종',false,'{"legacy_id": "gw-000000j55", "page": "gri/director/000000j55.html", "files": ["노동이사제 입후보자 공개모집 재공고문.hwp"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2021-11-22'::date,'2021-11-22'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000j55');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 공개모집 공고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 송성종 · 게시일 2021-11-04<br><a href="https://grilu.kr/gri/director/000000j4c.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000j4c&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000j4c&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 노동이사제 입후보자 공개모집 공고문.hwp</p>','송성종',false,'{"legacy_id": "gw-000000j4c", "page": "gri/director/000000j4c.html", "files": ["노동이사제 입후보자 공개모집 공고문.hwp"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2021-11-04'::date,'2021-11-04'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000j4c');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2021년도 제1차 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2021-09-23<br><a href="https://grilu.kr/archive/council/000000j2l.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000j2l&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000j2l&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2021년도 제1차 노사협의회 회의록(게시).pdf</p>','장영자',false,'{"legacy_id": "gw-000000j2l", "page": "archive/council/000000j2l.html", "files": ["2021년도 제1차 노사협의회 회의록(게시).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2021-09-23'::date,'2021-09-23'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000j2l');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 활동사항 보고(2020. 5. 27- 2021.5.26)','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 이상훈 · 게시일 2021-05-25<br><a href="https://grilu.kr/gri/director/000000iv3.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000iv3&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000iv3&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI 노동이사 활동사항 보고(2020-2021).hwp</p>','이상훈',false,'{"legacy_id": "gw-000000iv3", "page": "gri/director/000000iv3.html", "files": ["GRI 노동이사 활동사항 보고(2020-2021).hwp"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2021-05-25'::date,'2021-05-25'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000iv3');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2020년 제4차 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2021-01-21<br><a href="https://grilu.kr/archive/council/000000ink.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ink&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ink&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: ★2020년도 제4차 노사협의회 회의록(게시용).hwp</p>','장영자',false,'{"legacy_id": "gw-000000ink", "page": "archive/council/000000ink.html", "files": ["★2020년도 제4차 노사협의회 회의록(게시용).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2021-01-21'::date,'2021-01-21'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ink');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2020년 제3차 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2020-12-29<br><a href="https://grilu.kr/archive/council/000000ilx.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ilx&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ilx&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: ★2020년도 3차 노사협의회 회의록(게시용).hwp</p>','장영자',false,'{"legacy_id": "gw-000000ilx", "page": "archive/council/000000ilx.html", "files": ["★2020년도 3차 노사협의회 회의록(게시용).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2020-12-29'::date,'2020-12-29'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ilx');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2020년 제2차 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2020-12-29<br><a href="https://grilu.kr/archive/council/000000ilw.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ilw&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ilw&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: ★2020년도 2차 노사협의회 회의록(게시용).hwp</p>','장영자',false,'{"legacy_id": "gw-000000ilw", "page": "archive/council/000000ilw.html", "files": ["★2020년도 2차 노사협의회 회의록(게시용).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2020-12-29'::date,'2020-12-29'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ilw');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2020년 제1차 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2020-09-15<br><a href="https://grilu.kr/archive/council/000000ihg.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ihg&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ihg&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: ★2020년도 1차 노사협의회 회의록(게시용).hwp</p>','장영자',false,'{"legacy_id": "gw-000000ihg", "page": "archive/council/000000ihg.html", "files": ["★2020년도 1차 노사협의회 회의록(게시용).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2020-09-15'::date,'2020-09-15'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ihg');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 선거결과공고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 이대민 · 게시일 2020-04-16<br><a href="https://grilu.kr/gri/director/000000i72.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000i72&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000i72&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p>','이대민',false,'{"legacy_id": "gw-000000i72", "page": "gri/director/000000i72.html", "files": [], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2020-04-16'::date,'2020-04-16'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000i72');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 입후보자 및 선거일정공고','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 이대민 · 게시일 2020-04-06<br><a href="https://grilu.kr/gri/director/000000i6h.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000i6h&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000i6h&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 입후보자 공고문 및 선거공보.pdf, 입후보자 직무수행계획서(이상훈).hwp, 입후보자 직무수행계획서(고재경).hwp</p>','이대민',false,'{"legacy_id": "gw-000000i6h", "page": "gri/director/000000i6h.html", "files": ["입후보자 공고문 및 선거공보.pdf", "입후보자 직무수행계획서(이상훈).hwp", "입후보자 직무수행계획서(고재경).hwp"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2020-04-06'::date,'2020-04-06'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000i6h');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','경기연구원 사내근로복지기금 안내','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2020-04-02<br><a href="https://grilu.kr/archive/council/000000i63.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000i63&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000i63&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 정관.hwp, 2020년도 사업계획서(경기연구원사내근로복지기금).pdf</p>','장영자',false,'{"legacy_id": "gw-000000i63", "page": "archive/council/000000i63.html", "files": ["정관.hwp", "2020년도 사업계획서(경기연구원사내근로복지기금).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2020-04-02'::date,'2020-04-02'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000i63');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','취업규칙 일부 개정규칙 공포','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 장영자 · 게시일 2020-04-01<br><a href="https://grilu.kr/archive/council/000000i61.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000i61&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000i61&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 취업규칙 일부개정 공포문(2020.4.1).pdf, 경기연구원 취업규칙(전문)(2020.4.1).pdf</p>','장영자',false,'{"legacy_id": "gw-000000i61", "page": "archive/council/000000i61.html", "files": ["취업규칙 일부개정 공포문(2020.4.1).pdf", "경기연구원 취업규칙(전문)(2020.4.1).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2020-04-01'::date,'2020-04-01'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000i61');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'director','경기연구원 노동이사 공개모집 3차 재공고 안내','<div class="box" style="margin-bottom:16px"><b>노동이사 활동보고</b> · 작성자 이대민 · 게시일 2020-03-17<br><a href="https://grilu.kr/gri/director/000000i52.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000i52&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000i52&amp;BRDID=0000001hy&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 노동이사제 입후보자 공개모집 3차 재공고문.hwp</p>','이대민',false,'{"legacy_id": "gw-000000i52", "page": "gri/director/000000i52.html", "files": ["노동이사제 입후보자 공개모집 3차 재공고문.hwp"], "source": "gw.gri.re.kr 노동이사 활동보고"}'::jsonb,'2020-03-17'::date,'2020-03-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000i52');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','취업규칙 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2019-12-17<br><a href="https://grilu.kr/archive/council/000000hvo.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000hvo&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000hvo&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2019년 취업규칙(전문)(2019.12.17).hwp</p>','정형기',false,'{"legacy_id": "gw-000000hvo", "page": "archive/council/000000hvo.html", "files": ["2019년 취업규칙(전문)(2019.12.17).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2019-12-17'::date,'2019-12-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000hvo');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2019년 2차 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2019-11-06<br><a href="https://grilu.kr/archive/council/000000htu.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000htu&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000htu&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2019년 제 2차 노사협의회 회의록.hwp</p>','정형기',false,'{"legacy_id": "gw-000000htu", "page": "archive/council/000000htu.html", "files": ["2019년 제 2차 노사협의회 회의록.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2019-11-06'::date,'2019-11-06'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000htu');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','단체교섭 요구 노동조합 확정 공고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2019-07-12<br><a href="https://grilu.kr/archive/council/000000gzo.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000gzo&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000gzo&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 단체교섭 요구 노동조합 확정 공고문.pdf</p>','정형기',false,'{"legacy_id": "gw-000000gzo", "page": "archive/council/000000gzo.html", "files": ["단체교섭 요구 노동조합 확정 공고문.pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2019-07-12'::date,'2019-07-12'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000gzo');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','단체교섭 요구사실 공고문','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2019-07-04<br><a href="https://grilu.kr/archive/council/000000gxm.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000gxm&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000gxm&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 단체교섭 요구사실 공고문(2019년).pdf</p>','정형기',false,'{"legacy_id": "gw-000000gxm", "page": "archive/council/000000gxm.html", "files": ["단체교섭 요구사실 공고문(2019년).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2019-07-04'::date,'2019-07-04'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000gxm');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2019년 제1차 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2019-06-17<br><a href="https://grilu.kr/archive/council/000000gtv.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000gtv&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000gtv&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: ★2019년 1분기 노사협의회 결과보고_최종.hwp</p>','박아름',false,'{"legacy_id": "gw-000000gtv", "page": "archive/council/000000gtv.html", "files": ["★2019년 1분기 노사협의회 결과보고_최종.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2019-06-17'::date,'2019-06-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000gtv');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2018년 4/4분기 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2019-01-03<br><a href="https://grilu.kr/archive/council/000000gj9.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000gj9&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000gj9&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: ★2018년 4분기 노사협의회 결과보고(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000gj9", "page": "archive/council/000000gj9.html", "files": ["★2018년 4분기 노사협의회 결과보고(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2019-01-03'::date,'2019-01-03'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000gj9');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2018년 3분기 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2018-12-12<br><a href="https://grilu.kr/archive/council/000000ghu.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ghu&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ghu&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: ★2018년 3분기 노사협의회 결과보고(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000ghu", "page": "archive/council/000000ghu.html", "files": ["★2018년 3분기 노사협의회 결과보고(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2018-12-12'::date,'2018-12-12'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ghu');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2018년 2분기 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2018-12-12<br><a href="https://grilu.kr/archive/council/000000ght.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ght&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ght&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: ★2018년 2분기 노사협의회 결과보고(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000ght", "page": "archive/council/000000ght.html", "files": ["★2018년 2분기 노사협의회 결과보고(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2018-12-12'::date,'2018-12-12'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ght');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','단체협약 관련 규정개정(안) 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2018-11-02<br><a href="https://grilu.kr/archive/council/000000gfh.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000gfh&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000gfh&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 규정, 규칙 개정안(단체협약관련 조항).hwp</p>','박아름',false,'{"legacy_id": "gw-000000gfh", "page": "archive/council/000000gfh.html", "files": ["규정, 규칙 개정안(단체협약관련 조항).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2018-11-02'::date,'2018-11-02'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000gfh');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2018년 1분기 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2018-05-17<br><a href="https://grilu.kr/archive/council/000000g5c.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000g5c&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000g5c&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2018년 1분기 노사협의회 결과보고.hwp</p>','박아름',false,'{"legacy_id": "gw-000000g5c", "page": "archive/council/000000g5c.html", "files": ["2018년 1분기 노사협의회 결과보고.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2018-05-17'::date,'2018-05-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000g5c');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2017년 4/4분기 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2018-01-08<br><a href="https://grilu.kr/archive/council/000000fy4.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000fy4&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000fy4&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2017년 4분기 노사협의회 결과보고(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000fy4", "page": "archive/council/000000fy4.html", "files": ["2017년 4분기 노사협의회 결과보고(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2018-01-08'::date,'2018-01-08'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000fy4');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2017년 3/4분기 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2017-11-24<br><a href="https://grilu.kr/archive/council/000000fuu.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000fuu&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000fuu&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2017년 3분기 노사협의회 회의록(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000fuu", "page": "archive/council/000000fuu.html", "files": ["2017년 3분기 노사협의회 회의록(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2017-11-24'::date,'2017-11-24'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000fuu');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','경기연구원 단체협약 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2017-09-12<br><a href="https://grilu.kr/archive/council/000000fqd.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000fqd&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000fqd&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 경기연구원 단체협약(2017.9.11).pdf</p>','박아름',false,'{"legacy_id": "gw-000000fqd", "page": "archive/council/000000fqd.html", "files": ["경기연구원 단체협약(2017.9.11).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2017-09-12'::date,'2017-09-12'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000fqd');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2017년 제3차, 제4차 노사협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2017-08-21<br><a href="https://grilu.kr/archive/council/000000fp0.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000fp0&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000fp0&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2017년 제3차 노사협의회 회의록(게시).hwp, 2017년 제4차 노사협의회 회의록(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000fp0", "page": "archive/council/000000fp0.html", "files": ["2017년 제3차 노사협의회 회의록(게시).hwp", "2017년 제4차 노사협의회 회의록(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2017-08-21'::date,'2017-08-21'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000fp0');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','노사협의회 운영규약 전문 개정안 공포(2017.5.18)','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2017-05-18<br><a href="https://grilu.kr/archive/council/000000fia.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000fia&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000fia&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 노사협의회 운영규약(전문 개정안)2017.5.18. 공포.hwp</p>','박아름',false,'{"legacy_id": "gw-000000fia", "page": "archive/council/000000fia.html", "files": ["노사협의회 운영규약(전문 개정안)2017.5.18. 공포.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2017-05-18'::date,'2017-05-18'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000fia');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2017년 (임시)GRI협의회 회의록 세시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2017-04-28<br><a href="https://grilu.kr/archive/council/000000fhd.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000fhd&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000fhd&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2017년 임시 노사협의회 회의록(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000fhd", "page": "archive/council/000000fhd.html", "files": ["2017년 임시 노사협의회 회의록(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2017-04-28'::date,'2017-04-28'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000fhd');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2017년 GRI협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2017-04-19<br><a href="https://grilu.kr/archive/council/000000fgp.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000fgp&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000fgp&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2017년 제1차 노사협의회 회의록(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000fgp", "page": "archive/council/000000fgp.html", "files": ["2017년 제1차 노사협의회 회의록(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2017-04-19'::date,'2017-04-19'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000fgp');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','노사협의회 안건을 제안하시면 반영하겠습니다 [안건 제안]','<div class="box" style="margin-bottom:16px"><b>안건 제안</b> · 작성자 김점산 · 게시일 2017-03-28<br><a href="https://grilu.kr/archive/council/000000fe0.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000fe0&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000fe0&amp;BRDID=0000001yn&amp;K=00Rk62hAq3&amp;…</p>','김점산',false,'{"legacy_id": "gw-000000fe0", "page": "archive/council/000000fe0.html", "files": [], "source": "gw.gri.re.kr 안건 제안"}'::jsonb,'2017-03-28'::date,'2017-03-28'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000fe0');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2016년 제4차 GRI협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2017-01-23<br><a href="https://grilu.kr/archive/council/000000f8x.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000f8x&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000f8x&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2016년 제4차 노사협의회 결과보고(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000f8x", "page": "archive/council/000000f8x.html", "files": ["2016년 제4차 노사협의회 결과보고(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2017-01-23'::date,'2017-01-23'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000f8x');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2016년 제3차 GRI협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2016-12-01<br><a href="https://grilu.kr/archive/council/000000f2c.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000f2c&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000f2c&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2016년 제3차 GRI협의회 회의록(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000f2c", "page": "archive/council/000000f2c.html", "files": ["2016년 제3차 GRI협의회 회의록(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2016-12-01'::date,'2016-12-01'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000f2c');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2016년 제2차 GRI협의회 회의록 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2016-06-15<br><a href="https://grilu.kr/archive/council/000000ecf.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ecf&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ecf&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2016년 제2차 GRI 협의회 회의록(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000ecf", "page": "archive/council/000000ecf.html", "files": ["2016년 제2차 GRI 협의회 회의록(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2016-06-15'::date,'2016-06-15'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ecf');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2016년도 1/4분기 GRI협의회 개최결과 공지','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2016-03-12<br><a href="https://grilu.kr/archive/council/000000e64.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000e64&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000e64&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2016년 제1차 GRI 협의회 회의록(게시).hwp</p>','박아름',false,'{"legacy_id": "gw-000000e64", "page": "archive/council/000000e64.html", "files": ["2016년 제1차 GRI 협의회 회의록(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2016-03-12'::date,'2016-03-12'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000e64');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2015년도 3/4분기 GRI협의회 개최결과 공지','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 박아름 · 게시일 2015-10-20<br><a href="https://grilu.kr/archive/council/000000dvk.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000dvk&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000dvk&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2015년도 3분기 GRI협의회 결과보고.hwp</p>','박아름',false,'{"legacy_id": "gw-000000dvk", "page": "archive/council/000000dvk.html", "files": ["2015년도 3분기 GRI협의회 결과보고.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2015-10-20'::date,'2015-10-20'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000dvk');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2015년도 2/4분기 GRI 협의회 개최결과 공지','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 전성현 · 게시일 2015-07-14<br><a href="https://grilu.kr/archive/council/000000dmf.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000dmf&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000dmf&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI 협의회(2차) 결과 게시.hwp</p>','전성현',false,'{"legacy_id": "gw-000000dmf", "page": "archive/council/000000dmf.html", "files": ["GRI 협의회(2차) 결과 게시.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2015-07-14'::date,'2015-07-14'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000dmf');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2015년도 1/4분기 GRI 협의회 개최결과 공지','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 전성현 · 게시일 2015-02-10<br><a href="https://grilu.kr/archive/council/000000d23.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000d23&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000d23&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 홈페이지 게시(결과보고).hwp</p>','전성현',false,'{"legacy_id": "gw-000000d23", "page": "archive/council/000000d23.html", "files": ["홈페이지 게시(결과보고).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2015-02-10'::date,'2015-02-10'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000d23');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2014년도 4/4분기 GRI 협의회 개최결과 공지','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 전성현 · 게시일 2015-01-21<br><a href="https://grilu.kr/archive/council/000000cvq.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000cvq&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000cvq&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 홈페이지 게시(결과보고).hwp</p>','전성현',false,'{"legacy_id": "gw-000000cvq", "page": "archive/council/000000cvq.html", "files": ["홈페이지 게시(결과보고).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2015-01-21'::date,'2015-01-21'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000cvq');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2014년도 제2차 GRI협의회 협의결과 게시','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 전성현 · 게시일 2014-10-15<br><a href="https://grilu.kr/archive/council/000000cpp.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000cpp&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000cpp&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2차 GRI협의회 결과 보고 게시(2014.10).pdf</p>','전성현',false,'{"legacy_id": "gw-000000cpp", "page": "archive/council/000000cpp.html", "files": ["2차 GRI협의회 결과 보고 게시(2014.10).pdf"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2014-10-15'::date,'2014-10-15'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000cpp');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2014년도 제1차 GRI협의회 결과보고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 전성현 · 게시일 2014-03-31<br><a href="https://grilu.kr/archive/council/000000ca3.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ca3&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ca3&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2014년도 GRI협의회 결과 보고(게시판 공지).hwp</p>','전성현',false,'{"legacy_id": "gw-000000ca3", "page": "archive/council/000000ca3.html", "files": ["2014년도 GRI협의회 결과 보고(게시판 공지).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2014-03-31'::date,'2014-03-31'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ca3');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2013년도 제1차 GRI협의회 결과보고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 전성현 · 게시일 2014-03-31<br><a href="https://grilu.kr/archive/council/000000ca2.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ca2&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ca2&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2013년도 GRI협의회 결과 보고(게시판 공지).hwp</p>','전성현',false,'{"legacy_id": "gw-000000ca2", "page": "archive/council/000000ca2.html", "files": ["2013년도 GRI협의회 결과 보고(게시판 공지).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2014-03-31'::date,'2014-03-31'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ca2');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2012년 2차 노사협의회 협의결과 안내','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2012-12-31<br><a href="https://grilu.kr/archive/council/000000b1t.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000b1t&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000b1t&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI협의회 결과 보고(2012년 2차) 협의문 게시.hwp</p>','정형기',false,'{"legacy_id": "gw-000000b1t", "page": "archive/council/000000b1t.html", "files": ["GRI협의회 결과 보고(2012년 2차) 협의문 게시.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2012-12-31'::date,'2012-12-31'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000b1t');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','노사협의회 노측위원 1차회의 내용(2012.11.5)','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 문미성 · 게시일 2012-12-04<br><a href="https://grilu.kr/archive/council/000000ayu.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ayu&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ayu&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p>','문미성',false,'{"legacy_id": "gw-000000ayu", "page": "archive/council/000000ayu.html", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2012-12-04'::date,'2012-12-04'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ayu');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','취업규칙(2012.11.21)','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2012-12-02<br><a href="https://grilu.kr/archive/council/000000ayl.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;000000ayl&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=000000ayl&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 경기개발연구원 취 업 규 칙(20121121).hwp</p>','정형기',false,'{"legacy_id": "gw-000000ayl", "page": "archive/council/000000ayl.html", "files": ["경기개발연구원 취 업 규 칙(20121121).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2012-12-02'::date,'2012-12-02'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-000000ayl');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2012년도 1차 GRI 협의회 협의결과 안내','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2012-04-13<br><a href="https://grilu.kr/archive/council/0000009ua.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000009ua&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000009ua&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI협의회 결과 보고(2012년 1차) 협의문 게시.hwp</p>','정형기',false,'{"legacy_id": "gw-0000009ua", "page": "archive/council/0000009ua.html", "files": ["GRI협의회 결과 보고(2012년 1차) 협의문 게시.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2012-04-13'::date,'2012-04-13'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000009ua');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2012년 경기개발연구원 사내근로복지기금 혐의회 회의 결과 안내','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2012-03-21<br><a href="https://grilu.kr/archive/council/0000009pw.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000009pw&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000009pw&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 감사보고서(사내복지기금최종) 게시.XLS, 2012 사업계획 및 예산(안).hwp, 근로복지기금 운영규정(2.17).hwp</p>','정형기',false,'{"legacy_id": "gw-0000009pw", "page": "archive/council/0000009pw.html", "files": ["감사보고서(사내복지기금최종) 게시.XLS", "2012 사업계획 및 예산(안).hwp", "근로복지기금 운영규정(2.17).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2012-03-21'::date,'2012-03-21'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000009pw');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2011년 3차 GRI 협의회 결과 보고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2011-11-02<br><a href="https://grilu.kr/archive/council/0000009aj.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000009aj&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000009aj&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI협의회 결과 보고(2011년 3차) 게시.hwp</p>','정형기',false,'{"legacy_id": "gw-0000009aj", "page": "archive/council/0000009aj.html", "files": ["GRI협의회 결과 보고(2011년 3차) 게시.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2011-11-02'::date,'2011-11-02'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000009aj');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','''2/4분기 노사협의회'' 결과 안내 ...','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 김동영 · 게시일 2011-07-05<br><a href="https://grilu.kr/archive/council/0000008ym.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000008ym&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000008ym&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p>','김동영',false,'{"legacy_id": "gw-0000008ym", "page": "archive/council/0000008ym.html", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2011-07-05'::date,'2011-07-05'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000008ym');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2011년 2차 GRI 협의회 결과 보고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2011-07-05<br><a href="https://grilu.kr/archive/council/0000008yl.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000008yl&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000008yl&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI협의회 협의 결과 보고(2011년 2차).hwp</p>','정형기',false,'{"legacy_id": "gw-0000008yl", "page": "archive/council/0000008yl.html", "files": ["GRI협의회 협의 결과 보고(2011년 2차).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2011-07-05'::date,'2011-07-05'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000008yl');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2/4분기 노사협의회 추가 안건 초안','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 김동영 · 게시일 2011-06-29<br><a href="https://grilu.kr/archive/council/0000008vy.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000008vy&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000008vy&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 추가안건-근무성적평정제도.hwp</p>','김동영',false,'{"legacy_id": "gw-0000008vy", "page": "archive/council/0000008vy.html", "files": ["추가안건-근무성적평정제도.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2011-06-29'::date,'2011-06-29'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000008vy');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2011년 2/4분기 노사협의회 상정 안건 초안','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 김동영 · 게시일 2011-06-23<br><a href="https://grilu.kr/archive/council/0000008vl.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000008vl&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000008vl&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 20110623_2011년 2분기 GRI협의회 안건.hwp</p>','김동영',false,'{"legacy_id": "gw-0000008vl", "page": "archive/council/0000008vl.html", "files": ["20110623_2011년 2분기 GRI협의회 안건.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2011-06-23'::date,'2011-06-23'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000008vl');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','사내근로복지기금 2011년 정기 협의회 결과 안내','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2011-03-24<br><a href="https://grilu.kr/archive/council/0000008i0.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000008i0&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000008i0&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 2011 사업계획 및 예산(안).hwp, 2010년 감사보고서(사내복지기금).XLS, 근로복지기금 운영규정(3.24).hwp</p>','정형기',false,'{"legacy_id": "gw-0000008i0", "page": "archive/council/0000008i0.html", "files": ["2011 사업계획 및 예산(안).hwp", "2010년 감사보고서(사내복지기금).XLS", "근로복지기금 운영규정(3.24).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2011-03-24'::date,'2011-03-24'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000008i0');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','2011년 1차 GRI 협의회 협의 결과','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2011-01-17<br><a href="https://grilu.kr/archive/council/0000008c9.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000008c9&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000008c9&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI협의회 결과 보고(2011년 1차) 게시.hwp</p>','정형기',false,'{"legacy_id": "gw-0000008c9", "page": "archive/council/0000008c9.html", "files": ["GRI협의회 결과 보고(2011년 1차) 게시.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2011-01-17'::date,'2011-01-17'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000008c9');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','GRI 협의회 3차 결과 보고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2010-10-31<br><a href="https://grilu.kr/archive/council/0000007x7.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000007x7&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000007x7&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: GRI협의회 결과 보고(2010년 3분기) 게시.hwp</p>','정형기',false,'{"legacy_id": "gw-0000007x7", "page": "archive/council/0000007x7.html", "files": ["GRI협의회 결과 보고(2010년 3분기) 게시.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2010-10-31'::date,'2010-10-31'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000007x7');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','오늘 워크샵을 마치고','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 김희연 · 게시일 2010-10-19<br><a href="https://grilu.kr/archive/council/0000007vx.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000007vx&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000007vx&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p>','김희연',false,'{"legacy_id": "gw-0000007vx", "page": "archive/council/0000007vx.html", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2010-10-19'::date,'2010-10-19'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000007vx');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','연구원 워크샵을 제대로 하려면','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 김희연 · 게시일 2010-10-19<br><a href="https://grilu.kr/archive/council/0000007vw.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000007vw&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000007vw&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p>','김희연',false,'{"legacy_id": "gw-0000007vw", "page": "archive/council/0000007vw.html", "files": [], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2010-10-19'::date,'2010-10-19'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000007vw');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','고충처리위원회 지침','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2009-08-14<br><a href="https://grilu.kr/archive/council/0000005so.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000005so&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000005so&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 연구원 고충처리위원회_운영지침(게시).hwp</p>','정형기',false,'{"legacy_id": "gw-0000005so", "page": "archive/council/0000005so.html", "files": ["연구원 고충처리위원회_운영지침(게시).hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2009-08-14'::date,'2009-08-14'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000005so');
insert into public.posts (board,title,content,author_name,is_notice,attachments,created_at,updated_at) select 'council','경기개발연구원 사내근로복지기금 안내','<div class="box" style="margin-bottom:16px"><b>공고 및 회의록</b> · 작성자 정형기 · 게시일 2009-03-10<br><a href="https://grilu.kr/archive/council/0000004qe.html" style="color:var(--primary);text-decoration:underline;font-weight:700">▶ 본문·첨부파일 전문 보기</a></div><p style="line-height:1.8;color:#444">게시물읽기
var j$ = jQuery.noConflict();
var KeyValue=&quot;00Rk62hAq3&quot;;
var bExpress = false;
var bTopAnn = false;
var popupFlag = eval(&quot;true&quot;);
var readType = &quot;2&quot;;
var callbackFn = &quot;&quot;;
var status = &quot;&quot;;
var mtrlID = &quot;0000004qe&quot;;
var itemTr;
var activeXAttach = eval(&quot;false&quot;);
var searchOnlyInDate = eval(&quot;false&quot;);
var bThreadBoard = eval(&quot;false&quot;);
var bUseBBSCommentAttach = eval(&quot;false&quot;);
var bUseChoiceCommentRegister = eval(&quot;false&quot;);
var commentResponseView = &quot;&quot;;
var bUseMaterialViewPassword = eval(&quot;false&quot;);
var returnUrl = &quot;&amp;NL=1&amp;LMET=CLOSE&amp;BMID=0000004qe&amp;BRDID=0000001ym&amp;K=00Rk62hAq3&amp;…</p><p class="note">첨부: 경기개발연구원 사내근로복지 기금 정관.hwp, 2009 경기개발연구원 사내근로복지기금 사업계획 및 예산.hwp</p>','정형기',false,'{"legacy_id": "gw-0000004qe", "page": "archive/council/0000004qe.html", "files": ["경기개발연구원 사내근로복지 기금 정관.hwp", "2009 경기개발연구원 사내근로복지기금 사업계획 및 예산.hwp"], "source": "gw.gri.re.kr 공고 및 회의록"}'::jsonb,'2009-03-10'::date,'2009-03-10'::date where not exists (select 1 from public.posts where attachments->>'legacy_id' = 'gw-0000004qe');
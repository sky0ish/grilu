# 경기연구원 노동조합 홈페이지 (grilu.kr)

정적 HTML 사이트입니다. 서버 프로그램 없이 웹호스팅(또는 GitHub Pages, Netlify 등)에 파일을 그대로 올리면 동작합니다.

## 폴더 구성

```
index.html            메인 페이지
about/                조합소개 (인사말, 집행부, 연혁, 선언·강령, 규약·규정, 조직도, 오시는 길)
news/                 소식마당 (공지사항, 노조소식, 성명서, 규정 및 지침, 노사협의회, 노보)
archive/              자료마당 (사진, 동영상, 단체협약, 노동관계법령, 문서자료)
community/            소통마당 (일정 달력, 조합원 게시판, 고충상담, 조합원 복지, 조합가입 안내)
member/, etc/         로그인·회원가입, 개인정보처리방침·이용약관
css/style.css         공통 스타일
js/main.js            메뉴·슬라이드·탭·달력 스크립트
js/events.js          달력 일정 데이터  ← 일정은 여기서 수정
images/               로고, 배경 이미지
build.py              모든 HTML을 생성하는 스크립트 (메뉴·헤더·푸터·본문을 한 곳에서 관리)
```

## 자주 하는 작업

### 1. 배경 이미지 교체
톱니바퀴 이미지를 `images/hero-bg.jpg` 라는 이름으로 저장하면 메인 히어로와 서브 페이지 상단 배경에 자동 적용됩니다.
(파일이 없으면 임시로 만들어 둔 `images/hero-bg.svg` 가 대신 표시됩니다.)

### 2. 일정(달력) 추가·수정
`js/events.js` 를 열어 항목을 추가합니다.

```js
{ date: "2026-10-15", title: "정기 운영위원회", type: "union", desc: "노조사무실 12:00" },
{ date: "2026-10-20", end: "2026-10-21", title: "워크숍", type: "event" },
```

- `type` : `union`(노조 회의) / `council`(노사협의회) / `event`(행사) / `holiday`(휴일)
- 메인 페이지 달력과 `community/calendar.html` 에 모두 반영됩니다.

### 3. 메뉴·본문 수정 후 다시 생성
`build.py` 의 `MENUS`(메뉴)와 `PAGES`(각 페이지 본문 함수)를 수정한 뒤 실행합니다.

```bash
python build.py
```

HTML 파일을 직접 수정해도 되지만, 헤더/푸터가 모든 페이지에 공통이므로 `build.py` 로 관리하는 편이 편합니다.

### 4. 로컬에서 미리보기

```bash
python -m http.server 8765
```

브라우저에서 <http://localhost:8765> 접속.

## 아직 예시로 채워진 부분
- 게시판 글 목록(공지사항, 규정 및 지침, 노사협의회 등)은 모두 **예시 데이터**입니다. 그룹웨어(gw.gri.re.kr)는 내부망이라 외부에서 목록을 가져올 수 없었습니다.
- 위원장 성함, 조합원 수, 설립연도, 연혁, 집행부 명단은 `○○○` 자리표시자입니다.
- 게시판 글쓰기·로그인·고충상담 접수는 화면만 있고 실제 저장은 되지 않습니다. 실제 운영하려면 게시판 솔루션(그누보드, 워드프레스 등) 또는 폼 서비스 연동이 필요합니다.

## Supabase 연동 (회원·게시판·일정·고충상담)

1. Supabase 대시보드(프로젝트 GRILU) > **SQL Editor** > `supabase/schema.sql` 내용 전체를 붙여넣고 **Run**.
2. **Project Settings > API** 에서 `Project URL` 과 `anon public` 키를 복사해 `js/config.js` 에 입력.
3. 홈페이지에서 회원가입(skyish76@gmail.com) 후, SQL Editor 에서 관리자 지정:
   ```sql
   update public.profiles set role='admin', approved=true where email='skyish76@gmail.com';
   ```
4. 이후 `/admin/index.html` 에서 회원 승인, 일정 등록, 고충상담 열람이 가능합니다.
5. 개발 중에는 **Authentication > Providers > Email > Confirm email** 을 꺼 두면 가입 즉시 로그인됩니다.

권한 요약: 공지·규정·노사협의회 등 공식 게시판은 관리자만 글쓰기, 조합원 게시판은 승인된 조합원만 열람·글쓰기,
고충상담은 누구나 접수 가능하고 관리자만 열람.

## 배포 (현재 상태: 2026-09-12)

- GitHub 저장소 **sky0ish/grilu** 의 `main` 브랜치가 GitHub Pages 로 자동 배포됩니다. (`git push` 하면 1~2분 뒤 반영)
- Pages 의 Custom domain 은 `grilu.kr` 로 설정되어 있습니다. (저장소의 `CNAME` 파일)
- 도메인은 가비아(gabia)에서 등록되어 있으므로, **가비아 > My가비아 > 도메인 관리 > DNS 설정** 에 아래 레코드를 추가해야 접속됩니다.

| 타입 | 호스트 | 값 |
|---|---|---|
| A | @ | 185.199.108.153 |
| A | @ | 185.199.109.153 |
| A | @ | 185.199.110.153 |
| A | @ | 185.199.111.153 |
| CNAME | www | sky0ish.github.io |

DNS 반영 후 GitHub 저장소 Settings > Pages 에서 **Enforce HTTPS** 를 켭니다. (인증서 발급까지 최대 1시간)

Supabase 는 프로젝트 `ryyvwpkhlqbcsjbttxca` 에 연결되어 있고(`js/config.js`), 아래 SQL 은 이미 실행되었습니다.
`schema.sql`, `seed_council.sql`(노사협의회 27건), `seed_boards.sql`(게시판 구성), `seed_position.sql`(직급 컬럼), `seed_audit.sql`(행정사무감사 31건).
관리자 지정은 `make_admin.sql` 을 SQL Editor 에서 실행합니다.

### 배경 이미지
`5.images/배경1.webp` → `images/hero-bg.jpg` 로 변환해 사용 중. 교체하려면 새 사진을 `images/hero-bg.jpg` 로 저장하면 됩니다.
(사진이 없으면 `images/gen_bg_scene.py` 로 만든 `hero-bg.svg` 가 대신 표시됩니다.)

### 행정사무감사 자료 갱신
`python tools/import_audit.py` 실행 → `data/audit.json`, `supabase/seed_audit.sql` 갱신 → `python build.py` → 새 SQL 을 Supabase 에서 실행.


정적 파일이므로 아래 중 하나로 올리면 됩니다. (`grilu-site.zip` 은 업로드용으로 사이트 파일만 묶은 것)

- **Netlify Drop** (가장 간단): <https://app.netlify.com/drop> 에 폴더(또는 zip)를 끌어다 놓으면 즉시 주소가 생깁니다.
  이후 Site settings > Domain management 에서 `grilu.kr` 추가.
- **GitHub Pages**: GitHub 에 저장소를 만들고 이 폴더를 push → Settings > Pages > Branch: main 선택 → Custom domain 에 `grilu.kr` 입력.
- **Cloudflare Pages / Vercel**: GitHub 저장소 연결 또는 직접 업로드.

### 도메인(grilu.kr) 연결 – DNS 설정 (도메인 구입한 업체의 DNS 관리 화면에서)
| 호스팅 | 레코드 |
|---|---|
| Netlify | `A  @  75.2.60.5` , `CNAME  www  <사이트명>.netlify.app` |
| GitHub Pages | `A  @  185.199.108.153 / 109.153 / 110.153 / 111.153` , `CNAME  www  <계정>.github.io` |

배포 후 Supabase **Authentication > URL Configuration > Site URL** 을 `https://grilu.kr` 로 바꿔야 비밀번호 재설정 메일 링크가 올바르게 동작합니다.

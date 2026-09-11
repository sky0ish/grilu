# -*- coding: utf-8 -*-
"""
메인 배경 이미지 생성기 (저작권 없는 자체 제작 벡터)
- 위쪽: 흰 분필 낙서(TEAMWORK, SUCCESS, 톱니, 전구, 성장 그래프 ...)
- 오른쪽 아래: 노을 역광 앞에 선 사람들 실루엣
- 왼쪽 아래: 홈페이지 문구가 들어갈 여백
- 실행: python images/gen_bg_scene.py  → images/hero-bg.svg
- 실제 사진을 쓰려면 images/hero-bg.jpg 로 저장하면 이 SVG 대신 표시됩니다.
"""
import math, random, os
from gen_bg import person, W, H, GROUND   # 실루엣 함수 재사용

random.seed(11)
FONT = "'Segoe Print','Chalkboard SE','Marker Felt','Comic Sans MS',cursive"

s = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid slice">',
'<defs>',
' <linearGradient id="sky" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1656ab"/><stop offset="0.5" stop-color="#3c8fd3"/><stop offset="0.78" stop-color="#7cb9e6"/><stop offset="0.9" stop-color="#f2cf94"/><stop offset="1" stop-color="#f6b45a"/></linearGradient>',
' <radialGradient id="sun" cx="0.5" cy="0.5" r="0.5"><stop offset="0" stop-color="#ffffff"/><stop offset="0.18" stop-color="#fff3cc" stop-opacity="0.9"/><stop offset="0.5" stop-color="#ffd27a" stop-opacity="0.45"/><stop offset="1" stop-color="#ffd27a" stop-opacity="0"/></radialGradient>',
' <linearGradient id="ground" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#0c1730"/><stop offset="1" stop-color="#050b1a"/></linearGradient>',
' <filter id="blur"><feGaussianBlur stdDeviation="18"/></filter>',
' <filter id="chalk" x="-5%" y="-5%" width="110%" height="110%"><feTurbulence type="fractalNoise" baseFrequency="0.05" numOctaves="2" seed="3" result="n"/><feDisplacementMap in="SourceGraphic" in2="n" scale="3.5"/></filter>',
'</defs>',
f'<rect width="{W}" height="{H}" fill="url(#sky)"/>',
]
# 구름
for cx, cy, rx, ry, op, col in [(260,150,330,40,.22,"#ffffff"),(760,90,260,30,.18,"#ffffff"),(1250,170,380,45,.2,"#ffffff"),
                                 (1650,110,300,34,.16,"#ffffff"),(500,300,420,60,.16,"#ffffff"),(1150,330,500,70,.14,"#ffffff"),
                                 (300,470,520,70,.35,"#ffe2b0"),(900,520,600,60,.4,"#ffd9a0"),(1600,470,500,70,.32,"#ffe2b0")]:
    s.append(f'<ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}" fill="{col}" opacity="{op}" filter="url(#blur)"/>')
# 역광 태양
s.append(f'<ellipse cx="1290" cy="{GROUND-30}" rx="620" ry="330" fill="url(#sun)"/>')
s.append(f'<ellipse cx="1290" cy="{GROUND-10}" rx="180" ry="120" fill="url(#sun)"/>')

# ---------- 분필 낙서 ----------
d = ['<g fill="none" stroke="#ffffff" stroke-width="5" stroke-linecap="round" stroke-linejoin="round" opacity="0.92" filter="url(#chalk)">']
def txt(x, y, t, size, weight="700", anchor="start", rot=0):
    tr = f' transform="rotate({rot} {x} {y})"' if rot else ""
    d.append(f'<text x="{x}" y="{y}" font-family="{FONT}" font-size="{size}" font-weight="{weight}" text-anchor="{anchor}" fill="#ffffff" stroke="none"{tr}>{t}</text>')
def gear(cx, cy, r, n, w=5):
    pts = []
    for i in range(n*2):
        a = math.pi*2*i/(n*2) - math.pi/2
        rr = r if i % 2 == 0 else r*0.78
        a2 = a + math.pi*2/(n*2)
        pts.append(f'{cx+rr*math.cos(a):.1f},{cy+rr*math.sin(a):.1f}')
        pts.append(f'{cx+rr*math.cos(a2-0.02):.1f},{cy+rr*math.sin(a2-0.02):.1f}')
    d.append(f'<polygon points="{" ".join(pts)}" stroke-width="{w}"/>')
    d.append(f'<circle cx="{cx}" cy="{cy}" r="{r*0.42:.0f}" stroke-width="{w}"/>')

# 왼쪽 체크리스트
for y, mark in [(70, "check"), (150, "?"), (230, "$"), (310, "bar")]:
    d.append(f'<rect x="60" y="{y}" width="58" height="58" rx="6"/>')
    if mark == "check": d.append(f'<path d="M72,{y+30} L88,{y+46} L112,{y+14}"/>')
    elif mark == "bar": d.append(f'<path d="M74,{y+46} v-14 M89,{y+46} v-26 M104,{y+46} v-36"/>')
    else: txt(89, y+44, mark, 40, anchor="middle")
d.append('<path d="M118,99 h50 M118,179 h50 M118,259 h50 M118,339 h100 q60,0 100,-40"/>')
# HELP! 상자
d.append('<rect x="180" y="215" width="200" height="72" rx="6"/>'); txt(280, 270, "HELP!", 52, anchor="middle")
# 전구
d.append('<path d="M300,60 a48,48 0 1,1 -20,86 q-8,10 -8,20 h30 q0,-10 -8,-20 a48,48 0 0,1 6,-86 Z"/>')
d.append('<path d="M284,175 h32 M288,188 h24"/>')
for a in range(0, 360, 45):
    r1, r2 = 70, 90
    d.append(f'<path d="M{300+r1*math.cos(math.radians(a-90)):.0f},{96+r1*math.sin(math.radians(a-90)):.0f} L{300+r2*math.cos(math.radians(a-90)):.0f},{96+r2*math.sin(math.radians(a-90)):.0f}"/>')
# 화살표 → 성장 그래프
d.append('<path d="M400,150 h60 M448,140 l14,10 -14,10"/>')
d.append('<path d="M500,210 v-40 h22 v40 M534,210 v-70 h22 v70 M568,210 v-100 h22 v100 M602,210 v-130 h22 v130"/>')
d.append('<path d="M500,140 L560,110 L600,125 L650,60 M630,62 l22,-4 -2,22"/>')
txt(690, 150, "GROWTH", 58, rot=-4)
# 톱니바퀴
gear(800, 300, 105, 12, 6); gear(690, 430, 62, 9); gear(905, 445, 58, 9)
# TOGETHER
d.append('<path d="M1000,130 q20,-30 40,0 M1030,110 q20,-30 40,0 M1060,130 q20,-30 40,0 M1010,150 q25,20 50,0 M1050,150 q25,20 50,0"/>')
txt(1060, 205, "TOGETHER", 34, anchor="middle")
# 말풍선
d.append('<path d="M1150,90 h180 a22,22 0 0,1 22,22 v60 a22,22 0 0,1 -22,22 h-120 l-30,26 v-26 h-30 a22,22 0 0,1 -22,-22 v-60 a22,22 0 0,1 22,-22 Z"/>')
d.append('<path d="M1180,135 h110 M1180,160 h80"/>')
d.append('<path d="M1360,120 h100 a18,18 0 0,1 18,18 v45 a18,18 0 0,1 -18,18 h-40 v22 l-24,-22 h-36 a18,18 0 0,1 -18,-18 v-45 a18,18 0 0,1 18,-18 Z"/>')
# 큰 화살표
d.append('<path d="M1480,90 q120,-60 220,10 M1690,80 l14,22 -26,6"/>')
# 퍼즐
d.append('<path d="M1740,150 h50 q-14,-30 12,-30 t12,30 h50 v50 q30,-14 30,12 t-30,12 v50 h-50 q14,30 -12,30 t-12,-30 h-50 v-50 q-30,14 -30,-12 t30,-12 Z"/>')
# TEAMWORK / SUCCESS
txt(1400, 370, "TEAMWORK", 130, rot=-5, anchor="middle")
d.append('<path d="M1160,395 q120,-16 300,-6 t250,-8" stroke-width="12"/>')
d.append('<path d="M1200,420 q160,-8 360,-4" stroke-width="7"/>')
txt(1470, 480, "SUCCESS", 72, rot=-3, anchor="middle")
# 지구본
d.append('<circle cx="215" cy="530" r="62"/><ellipse cx="215" cy="530" rx="26" ry="62"/><path d="M155,515 h120 M155,545 h120"/>')
d.append('<path d="M275,505 q30,-20 20,-50 M285,595 q-30,20 -70,10"/>')
txt(345, 555, "Ideas!", 40); txt(330, 615, "Brainstorm", 40, rot=-3)
# 파이차트
d.append('<circle cx="640" cy="590" r="58"/><path d="M640,590 v-58 M640,590 l50,-30 M640,590 l30,50"/>')
d.append('<path d="M700,540 h60 M710,600 h50"/>'); txt(770, 552, "30%", 34); txt(770, 612, "10%", 34)
# Vision / PARTNER
d.append('<rect x="1000" y="540" width="100" height="70" rx="4"/><path d="M1015,560 h70 M1015,578 h70 M1015,596 h40"/>')
txt(1015, 528, "Vision", 34, weight="400"); txt(1000, 655, "PARTNER", 46)
# 사람 네트워크
d.append('<circle cx="1240" cy="490" r="14"/><path d="M1220,530 q20,-30 40,0"/><circle cx="1180" cy="580" r="14"/><path d="M1160,620 q20,-30 40,0"/><circle cx="1300" cy="580" r="14"/><path d="M1280,620 q20,-30 40,0"/>')
d.append('<path d="M1225,535 l-30,30 M1255,535 l30,30 M1200,595 h80 M1205,585 l-8,10 8,10 M1275,585 l8,10 -8,10"/>')
d.append('</g>')
s += d

# ---------- 지면 + 사람 ----------
s.append(f'<path d="M0,{GROUND+56} Q480,{GROUND+30} 960,{GROUND+14} T{W},{GROUND-2} L{W},{H} L0,{H} Z" fill="url(#ground)"/>')
s.append('<g fill="#08122b">')
xs = [1020, 1080, 1140, 1230, 1290, 1370, 1440, 1520, 1590, 1660, 1740, 1810, 1870]
poses = ["stand", "skirt", "wide", "stand", "skirt", "stand", "wide", "stand", "skirt", "stand", "wide", "stand", "stand"]
for i, x in enumerate(xs):
    x += random.randint(-8, 8)
    base = GROUND + 14 - (x - 960) * 0.016
    h = random.randint(180, 220)
    s.append(person(x, base, h, poses[i], flip=(i % 3 == 2)))
s.append('</g>')
for i in range(0, W, 9):
    hh = random.randint(2, 9)
    yy = GROUND + 56 - (i / W) * 58
    s.append(f'<rect x="{i}" y="{yy-hh}" width="2" height="{hh}" fill="#08122b"/>')
s.append('</svg>')
out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "hero-bg.svg")
open(out, "w", encoding="utf-8").write("\n".join(s))
print("ok", out)

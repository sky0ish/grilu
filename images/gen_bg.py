# -*- coding: utf-8 -*-
"""
메인 배경 이미지 생성기 (저작권 없는 자체 제작 벡터)
- 왼쪽: 문구가 들어갈 여백, 오른쪽: 언덕 위에 서 있는 사람들의 실루엣, 뒤로는 역광의 하늘
- 실행: python images/gen_bg.py  → images/hero-bg.svg
"""
import math, random
random.seed(7)
W, H = 1920, 700
GROUND = 560

def person(x, base, h, pose, flip=False):
    """머리+몸통+팔+다리 실루엣. x=발 중심, base=지면 y, h=키"""
    s = h / 180.0
    hw = 22 * s  # 어깨 반폭
    head_r = 13 * s
    neck = base - h + head_r * 2 + 4 * s
    hip = base - 75 * s
    parts = []
    # 머리
    parts.append(f'<circle cx="{x}" cy="{base - h + head_r}" r="{head_r}"/>')
    # 몸통 (어깨→허리)
    parts.append(f'<path d="M{x-hw},{neck} Q{x-hw-3*s},{hip-20*s} {x-hw+6*s},{hip} L{x+hw-6*s},{hip} Q{x+hw+3*s},{hip-20*s} {x+hw},{neck} Q{x},{neck-8*s} {x-hw},{neck} Z"/>')
    # 다리
    if pose == "stand":
        parts.append(f'<path d="M{x-hw+6*s},{hip} L{x-14*s},{base} L{x-3*s},{base} L{x-1*s},{hip+10*s} L{x+1*s},{hip+10*s} L{x+3*s},{base} L{x+14*s},{base} L{x+hw-6*s},{hip} Z"/>')
    elif pose == "wide":
        parts.append(f'<path d="M{x-hw+6*s},{hip} L{x-26*s},{base} L{x-12*s},{base} L{x-2*s},{hip+14*s} L{x+2*s},{hip+14*s} L{x+12*s},{base} L{x+26*s},{base} L{x+hw-6*s},{hip} Z"/>')
    else:  # skirt
        parts.append(f'<path d="M{x-hw+6*s},{hip} L{x-hw-6*s},{hip+55*s} L{x+hw+6*s},{hip+55*s} L{x+hw-6*s},{hip} Z"/>')
        parts.append(f'<path d="M{x-12*s},{hip+50*s} L{x-11*s},{base} L{x-3*s},{base} L{x-3*s},{hip+50*s} Z M{x+3*s},{hip+50*s} L{x+3*s},{base} L{x+11*s},{base} L{x+12*s},{hip+50*s} Z"/>')
    # 팔
    d = -1 if flip else 1
    arm = random.choice(["down", "gesture", "laptop", "shake", "fold"])
    ay = neck + 6 * s
    if arm == "down":
        parts.append(f'<path d="M{x-hw},{ay} L{x-hw-6*s},{hip+5*s} L{x-hw+2*s},{hip+6*s} L{x-hw+8*s},{ay+10*s} Z"/>')
        parts.append(f'<path d="M{x+hw},{ay} L{x+hw+6*s},{hip+5*s} L{x+hw-2*s},{hip+6*s} L{x+hw-8*s},{ay+10*s} Z"/>')
    elif arm == "gesture":
        parts.append(f'<path d="M{x+d*hw},{ay} L{x+d*(hw+30*s)},{ay+20*s} L{x+d*(hw+52*s)},{ay-2*s} L{x+d*(hw+55*s)},{ay+8*s} L{x+d*(hw+32*s)},{ay+30*s} L{x+d*(hw-6*s)},{ay+12*s} Z"/>')
        parts.append(f'<path d="M{x-d*hw},{ay} L{x-d*(hw+6*s)},{hip+5*s} L{x-d*(hw-2*s)},{hip+6*s} L{x-d*(hw-8*s)},{ay+10*s} Z"/>')
    elif arm == "laptop":
        parts.append(f'<path d="M{x+d*hw},{ay} L{x+d*(hw+28*s)},{ay+40*s} L{x+d*(hw+22*s)},{ay+48*s} L{x+d*(hw-4*s)},{ay+14*s} Z"/>')
        parts.append(f'<rect x="{x+d*(hw-2*s) - (34*s if d<0 else 0)}" y="{ay+34*s}" width="{34*s}" height="{18*s}" rx="2"/>')
        parts.append(f'<path d="M{x-d*hw},{ay} L{x-d*(hw+6*s)},{hip+5*s} L{x-d*(hw-2*s)},{hip+6*s} L{x-d*(hw-8*s)},{ay+10*s} Z"/>')
    elif arm == "shake":
        parts.append(f'<path d="M{x+d*hw},{ay} L{x+d*(hw+40*s)},{ay+38*s} L{x+d*(hw+34*s)},{ay+46*s} L{x+d*(hw-4*s)},{ay+14*s} Z"/>')
        parts.append(f'<path d="M{x-d*hw},{ay} L{x-d*(hw+6*s)},{hip+5*s} L{x-d*(hw-2*s)},{hip+6*s} L{x-d*(hw-8*s)},{ay+10*s} Z"/>')
    else:  # fold
        parts.append(f'<path d="M{x-hw},{ay} L{x-hw-6*s},{ay+30*s} L{x+hw+6*s},{ay+30*s} L{x+hw},{ay} L{x+hw-8*s},{ay+10*s} L{x-hw+8*s},{ay+10*s} Z"/>')
    return "".join(parts)

s = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid slice">',
'<defs>',
' <linearGradient id="sky" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#0d2a66"/><stop offset="0.45" stop-color="#1e4f9e"/><stop offset="0.8" stop-color="#5fa8dc"/><stop offset="1" stop-color="#bfe3f7"/></linearGradient>',
' <radialGradient id="sun" cx="0.5" cy="0.5" r="0.5"><stop offset="0" stop-color="#ffffff" stop-opacity="0.95"/><stop offset="0.35" stop-color="#ffe9b0" stop-opacity="0.55"/><stop offset="1" stop-color="#ffe9b0" stop-opacity="0"/></radialGradient>',
' <linearGradient id="ground" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#0a1a3a"/><stop offset="1" stop-color="#050d1f"/></linearGradient>',
' <linearGradient id="haze" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#ffffff" stop-opacity="0"/><stop offset="1" stop-color="#ffffff" stop-opacity="0.35"/></linearGradient>',
'</defs>',
f'<rect width="{W}" height="{H}" fill="url(#sky)"/>',
# 역광 태양
f'<ellipse cx="1330" cy="{GROUND-20}" rx="520" ry="300" fill="url(#sun)"/>',
f'<rect x="0" y="{GROUND-160}" width="{W}" height="160" fill="url(#haze)"/>',
]
# 얇은 구름 띠
for i, (cx, cy, rx) in enumerate([(300, 120, 260), (900, 70, 200), (1500, 150, 300), (600, 220, 180)]):
    s.append(f'<ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{9+i*2}" fill="#ffffff" opacity="0.07"/>')
# 언덕 지면
s.append(f'<path d="M0,{GROUND+40} Q480,{GROUND+18} 960,{GROUND+4} T{W},{GROUND-6} L{W},{H} L0,{H} Z" fill="url(#ground)"/>')
# 사람들 (오른쪽 55% 영역)
s.append('<g fill="#08122b">')
xs = [1010, 1075, 1150, 1235, 1300, 1380, 1445, 1520, 1600, 1665, 1745, 1830]
poses = ["stand", "skirt", "wide", "stand", "skirt", "stand", "wide", "stand", "skirt", "stand", "wide", "stand"]
for i, x in enumerate(xs):
    x += random.randint(-8, 8)
    base = GROUND + 4 - (x - 960) * 0.011
    h = random.randint(178, 215)
    s.append(person(x, base, h, poses[i], flip=(i % 3 == 2)))
s.append('</g>')
# 지면 잔풀 느낌
for i in range(0, W, 9):
    hh = random.randint(2, 9)
    yy = GROUND + 40 - (i / W) * 46
    s.append(f'<rect x="{i}" y="{yy-hh}" width="2" height="{hh}" fill="#08122b"/>')
s.append('</svg>')
open(__file__.replace("gen_bg.py", "hero-bg.svg"), "w", encoding="utf-8").write("\n".join(s))
print("ok")

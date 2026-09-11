# -*- coding: utf-8 -*-
"""
메인 배경 이미지 생성기 (저작권 없는 자체 제작 벡터)
- 왼쪽: 문구가 들어갈 여백, 오른쪽: 언덕 위에 서 있는 사람들의 실루엣, 뒤로는 역광의 하늘
- 실행: python images/gen_bg_scene.py  → images/hero-bg.svg
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

# (아래 장면 구성은 gen_bg_scene.py 로 이동했습니다. 이 파일은 person() 실루엣 함수만 제공합니다)

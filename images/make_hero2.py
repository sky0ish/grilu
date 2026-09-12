# -*- coding: utf-8 -*-
"""images/전체배경2.png (와이드 원본) → images/hero-bg.jpg
오른쪽(사람들·낙서)은 선명하게, 문구가 들어가는 왼쪽은 경계 없이 서서히 뿌옇게(가로 블러 램프). 실행: python images/make_hero2.py"""
import os, numpy as np
from PIL import Image, ImageFilter
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
src = Image.open(os.path.join(ROOT, "images", "전체배경2.png")).convert("RGB")
W = 2400; H = int(src.height * W / src.width)
img = src.resize((W, H), Image.LANCZOS)
base = np.asarray(img).astype(np.float32)
levels = [0, 4, 10, 20, 34, 52]
blurred = [base] + [np.asarray(img.filter(ImageFilter.GaussianBlur(r))).astype(np.float32) for r in levels[1:]]
xs = np.arange(W, dtype=np.float32)
SHARP_X, SOFT_X = W * 0.60, W * 0.36            # 오른쪽 60% 지점부터 선명, 36% 지점(문구 자리)에서 완전 블러
u = np.clip((SHARP_X - xs) / (SHARP_X - SOFT_X), 0, 1); u = u * u * (3 - 2 * u)
pos = u * (len(levels) - 1); lo = np.floor(pos).astype(int); hi = np.minimum(lo + 1, len(levels) - 1); fr = pos - lo
out = np.zeros_like(base)
for k in range(len(levels)):
    wk = np.where(lo == k, 1 - fr, 0) + np.where(hi == k, fr, 0)
    out += blurred[k] * wk[None, :, None]
res = Image.fromarray(np.clip(out, 0, 255).astype(np.uint8))
res.save(os.path.join(ROOT, "images", "hero-bg.jpg"), quality=86, optimize=True, progressive=True)
print("ok", res.size, os.path.getsize(os.path.join(ROOT, "images", "hero-bg.jpg")))

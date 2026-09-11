# -*- coding: utf-8 -*-
"""
5.images/배경1.webp(원본 사진) → images/hero-bg.jpg (와이드 합성)
- 오른쪽: 원본 사진(사람들+낙서)을 높이에 맞춰 축소 배치
- 왼쪽: 사진 왼쪽 가장자리 색을 행별로 이어 붙인 하늘 + 부드러운 구름  → 문구가 들어갈 여백
실행: python images/make_hero.py
"""
import os, numpy as np
from PIL import Image, ImageFilter
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
src = Image.open(os.path.join(ROOT, "5.images", "배경1.webp")).convert("RGB")
W, H = 2400, 900
ph = H; pw = int(src.width * ph / src.height)          # 사진을 높이에 맞춤
photo = src.resize((pw, ph), Image.LANCZOS)
px = np.asarray(photo).astype(np.float32)

# 1) 왼쪽 하늘: 사진 왼쪽 90px 의 행별 중앙값(흰 낙서선 제거) → 세로로 부드럽게
strip = np.median(px[:, :90, :], axis=1)                 # (H,3)
k = 70
strip = np.stack([np.convolve(np.pad(strip[:, c], (k, k), mode="edge"), np.ones(2*k+1)/(2*k+1), mode="valid") for c in range(3)], axis=1)
sky = np.repeat(strip[:, None, :], W, axis=1)            # (H,W,3)
# 왼쪽으로 갈수록 살짝 더 진하고 푸르게 (사진 상단 하늘색 유지)
grad = np.linspace(1.0, 0.92, W)[None, :, None]
sky = sky * grad

# 2) 구름: 저주파 노이즈를 흐려서 밝은 얼룩으로
rng = np.random.default_rng(7)
noise = rng.random((H // 60 + 2, W // 60 + 2)).astype(np.float32)
noise_img = Image.fromarray((noise * 255).astype(np.uint8)).resize((W, H), Image.BICUBIC).filter(ImageFilter.GaussianBlur(40))
n = np.asarray(noise_img).astype(np.float32) / 255.0
n = np.clip((n - 0.45) * 2.2, 0, 1)                       # 밝은 부분만
# 아래쪽(지평선 근처) 구름은 노을빛, 위쪽은 흰색
warm = np.array([255, 226, 190], np.float32); white = np.array([255, 255, 255], np.float32)
t = np.linspace(0, 1, H)[:, None, None]
cloud_col = white * (1 - t) + warm * t
sky = sky + (cloud_col - sky) * (n[..., None] * 0.28)

# 3) 사진을 오른쪽에 붙이고 왼쪽 가장자리를 하늘과 페이드 블렌딩
canvas = sky.copy()
x0 = W - pw
# 이음새: 하늘 부분은 넓게(520px), 사람들이 있는 아랫부분은 좁게(60px) 섞어 자연스럽게 연결
alpha = np.ones((ph, pw), np.float32)
xs = np.arange(pw, dtype=np.float32)
for y in range(ph):
    t = min(1.0, max(0.0, (y - 420) / 100.0))          # 사람 머리 위(420~520px)에서 좁아짐
    fw = 520 * (1 - t) + 60 * t
    a = np.clip(xs / fw, 0, 1)
    alpha[y] = a * a * (3 - 2 * a)                     # smoothstep
alpha = alpha[..., None]
canvas[:, x0:, :] = canvas[:, x0:, :] * (1 - alpha) + px * alpha

# 4) 지면(어두운 언덕)을 왼쪽까지 이어서 사람들 발밑 선이 끊기지 않게
ground_row = px[-1, :60, :].mean(axis=0)              # 사진 맨 아래 왼쪽 색
for y in range(H - 70, H):
    a = ((y - (H - 70)) / 70) ** 2
    canvas[y, :x0 + 60, :] = canvas[y, :x0 + 60, :] * (1 - a) + ground_row * a

out = Image.fromarray(np.clip(canvas, 0, 255).astype(np.uint8))
out.save(os.path.join(ROOT, "images", "hero-bg.jpg"), quality=86, optimize=True, progressive=True)
print("ok", out.size, os.path.getsize(os.path.join(ROOT, "images", "hero-bg.jpg")))

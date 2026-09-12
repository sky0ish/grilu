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

# 3) 왼쪽 하늘 확장: 사진의 하늘(낙서 제거한 중간값 필터본)을 좌우 반전해 이어 붙여 실제 구름 사진이 왼쪽으로 이어지게 하고,
#    이음새에서 멀어질수록(문구가 나타나는 자리부터) 천천히 뿌옇게 흐려지도록 블러를 단계적으로 섞는다
x0 = W - pw
import cv2
_m = ((px.min(axis=2) > 185) & ((px.max(axis=2) - px.min(axis=2)) < 60)).astype(np.uint8)      # 흰 낙서선(밝고 채도 낮음)
_m[500:, :] = 0                                                                                 # 사람들·노을 구름 행은 제외
_m = cv2.dilate(_m, np.ones((17, 17), np.uint8))
_bgr = cv2.cvtColor(np.clip(px, 0, 255).astype(np.uint8), cv2.COLOR_RGB2BGR)
med = cv2.cvtColor(cv2.inpaint(_bgr, _m, 20, cv2.INPAINT_TELEA), cv2.COLOR_BGR2RGB).astype(np.float32)
med = np.asarray(Image.fromarray(med.astype(np.uint8)).filter(ImageFilter.GaussianBlur(3))).astype(np.float32)   # 인페인팅 흔적 완화
mirror = med[:, ::-1, :]                                                        # 좌우 반전 → 이음새에서 하늘이 정확히 이어짐
ext = np.concatenate([mirror, med, mirror], axis=1)[:, -x0:, :] if pw * 3 >= x0 else None
if ext is None or ext.shape[1] < x0:
    reps = int(np.ceil(x0 / pw)) + 1
    tiles = [mirror if k % 2 == 0 else med for k in range(reps)][::-1]
    ext = np.concatenate(tiles, axis=1)[:, -x0:, :]
ext_img = Image.fromarray(np.clip(ext, 0, 255).astype(np.uint8))
levels = [0, 6, 16, 34, 60]                                                      # 블러 반경 단계
blurred = [ext.astype(np.float32)] + [np.asarray(ext_img.filter(ImageFilter.GaussianBlur(r))).astype(np.float32) for r in levels[1:]]
d = (x0 - np.arange(x0, dtype=np.float32))                                      # 이음새로부터의 거리
SHARP, SOFT = 300.0, 1050.0                                                      # 300px 까지 선명, 그 뒤 문구 자리부터 서서히 흐려짐
u = np.clip((d - SHARP) / (SOFT - SHARP), 0, 1); u = u * u * (3 - 2 * u)
pos = u * (len(levels) - 1)
lo = np.floor(pos).astype(int); hi = np.minimum(lo + 1, len(levels) - 1); fr = (pos - lo)[None, :, None]
ext_sky = np.zeros_like(ext)
for k in range(len(levels)):
    wk = np.where(lo == k, 1 - fr[0, :, 0], 0) + np.where(hi == k, fr[0, :, 0], 0)
    ext_sky += blurred[k] * wk[None, :, None]
# 사람들 높이(아래쪽) 행은 반전 사진에 사람이 비치므로 합성 하늘을 쓰고, 그 위 행은 반전 사진 하늘을 쓴다 (세로로 부드럽게 전환)
ty = np.clip((np.arange(H, dtype=np.float32) - 440) / 70.0, 0, 1)[:, None, None]; ty = ty * ty * (3 - 2 * ty)
canvas = sky.copy()
canvas[:, :x0, :] = ext_sky * (1 - ty) + sky[:, :x0, :] * ty
# 이음새: 하늘 부분은 짧게(80px), 사람들이 있는 아랫부분도 좁게(60px) 섞어 연결
alpha = np.ones((ph, pw), np.float32)
xs = np.arange(pw, dtype=np.float32)
for y in range(ph):
    t = min(1.0, max(0.0, (y - 420) / 100.0))
    fw = 80 * (1 - t) + 60 * t
    a = np.clip(xs / fw, 0, 1)
    alpha[y] = a * a * (3 - 2 * a)
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

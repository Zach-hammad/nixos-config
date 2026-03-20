#!/usr/bin/env python3
"""Generate a looping ASCII rain video wallpaper."""

import random
import subprocess
import tempfile
import os
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ASCII_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&*+=-~^.:;|/\\[]{}()<>!?"

BG_COLOR = (10, 10, 10)
CHAR_COLORS = [
    (25, 25, 25),
    (30, 30, 30),
    (35, 35, 35),
    (40, 40, 40),
    (45, 45, 45),
    (50, 50, 50),
    (55, 55, 55),
    (65, 65, 65),
]

WIDTH = 3440
HEIGHT = 1440
FPS = 8
DURATION = 10  # seconds, will loop
TOTAL_FRAMES = FPS * DURATION


def get_font():
    font_size = 14
    for fname in [
        "/run/current-system/sw/share/X11/fonts/JetBrainsMonoNerdFont-Regular.ttf",
        "/run/current-system/sw/share/X11/fonts/JetBrainsMono-Regular.ttf",
    ]:
        if Path(fname).exists():
            return ImageFont.truetype(fname, font_size), font_size
    return ImageFont.load_default(), 14


def generate_frame(frame_num, font, font_size):
    img = Image.new("RGB", (WIDTH, HEIGHT), BG_COLOR)
    draw = ImageDraw.Draw(img)

    char_w = font_size * 0.6
    char_h = font_size * 1.2
    cols = int(WIDTH / char_w) + 1
    rows = int(HEIGHT / char_h) + 1

    random.seed(frame_num * 7919)

    for r in range(rows):
        for c in range(cols):
            x = int(c * char_w)
            y = int(r * char_h)

            cx = abs(c - cols / 2) / (cols / 2)
            cy = abs(r - rows / 2) / (rows / 2)
            dist = (cx ** 2 + cy ** 2) ** 0.5

            if random.random() > dist * 0.6:
                char = random.choice(ASCII_CHARS)
                brightness_idx = max(0, len(CHAR_COLORS) - 1 - int(dist * len(CHAR_COLORS)))
                brightness_idx = max(0, min(len(CHAR_COLORS) - 1, brightness_idx + random.randint(-2, 1)))
                color = CHAR_COLORS[brightness_idx]
                draw.text((x, y), char, fill=color, font=font)

    # Scanline
    for y in range(0, HEIGHT, 4):
        draw.line([(0, y), (WIDTH, y)], fill=(8, 8, 8), width=1)

    return img


def main():
    font, font_size = get_font()
    out_dir = Path.home() / ".config" / "wallpaper"
    out_path = out_dir / "ascii-rain.mp4"

    with tempfile.TemporaryDirectory() as tmpdir:
        print(f"Generating {TOTAL_FRAMES} frames at {FPS}fps...")
        for i in range(TOTAL_FRAMES):
            frame = generate_frame(i, font, font_size)
            frame.save(os.path.join(tmpdir, f"frame_{i:04d}.png"))
            if (i + 1) % 10 == 0:
                print(f"  frame {i + 1}/{TOTAL_FRAMES}")

        print("Encoding video...")
        subprocess.run([
            "ffmpeg", "-y",
            "-framerate", str(FPS),
            "-i", os.path.join(tmpdir, "frame_%04d.png"),
            "-c:v", "libx264",
            "-pix_fmt", "yuv420p",
            "-crf", "23",
            "-preset", "medium",
            str(out_path),
        ], check=True, capture_output=True)

    print(f"\nGenerated: {out_path}")
    print(f"Duration: {DURATION}s, loops seamlessly")


if __name__ == "__main__":
    main()

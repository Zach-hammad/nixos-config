#!/usr/bin/env python3
"""Generate monochrome ASCII rain wallpapers matching the site aesthetic."""

import random
import hashlib
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("Installing Pillow...")
    import subprocess
    subprocess.check_call(["pip", "install", "Pillow"])
    from PIL import Image, ImageDraw, ImageFont

ASCII_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&*+=-~^.:;|/\\[]{}()<>!?"

BG_COLOR = (10, 10, 10)
# Varying opacity levels for depth effect
CHAR_COLORS = [
    (30, 30, 30),   # barely visible
    (35, 35, 35),
    (40, 40, 40),
    (45, 45, 45),
    (50, 50, 50),   # subtle
    (55, 55, 55),
    (60, 60, 60),   # slightly visible
    (70, 70, 70),   # noticeable
]

RESOLUTIONS = {
    "ultrawide": (3440, 1440),
    "2k": (2560, 1440),
    "laptop": (1920, 1200),
    "fhd": (1920, 1080),
}


def generate_wallpaper(width, height, name, font_path=None):
    img = Image.new("RGB", (width, height), BG_COLOR)
    draw = ImageDraw.Draw(img)

    # Try to use a monospace font
    font_size = 14
    try:
        if font_path:
            font = ImageFont.truetype(font_path, font_size)
        else:
            # Try common monospace fonts
            for fname in [
                "/run/current-system/sw/share/X11/fonts/JetBrainsMonoNerdFont-Regular.ttf",
                "/run/current-system/sw/share/X11/fonts/JetBrainsMono-Regular.ttf",
            ]:
                if Path(fname).exists():
                    font = ImageFont.truetype(fname, font_size)
                    break
            else:
                font = ImageFont.load_default()
    except (OSError, IOError):
        font = ImageFont.load_default()

    char_w = font_size * 0.6  # approximate monospace char width
    char_h = font_size * 1.2

    cols = int(width / char_w) + 1
    rows = int(height / char_h) + 1

    random.seed(42)  # deterministic for reproducibility

    for r in range(rows):
        for c in range(cols):
            x = int(c * char_w)
            y = int(r * char_h)

            # Distance from center (normalized 0-1)
            cx = abs(c - cols / 2) / (cols / 2)
            cy = abs(r - rows / 2) / (rows / 2)
            dist = (cx ** 2 + cy ** 2) ** 0.5

            # More characters near center, fewer at edges (like the site)
            if random.random() > dist * 0.6:
                char = random.choice(ASCII_CHARS)
                # Closer to center = slightly brighter
                brightness_idx = max(0, len(CHAR_COLORS) - 1 - int(dist * len(CHAR_COLORS)))
                # Add some randomness to brightness
                brightness_idx = max(0, min(len(CHAR_COLORS) - 1, brightness_idx + random.randint(-2, 1)))
                color = CHAR_COLORS[brightness_idx]
                draw.text((x, y), char, fill=color, font=font)

    # Add some "scanline" effect — subtle horizontal lines
    for y in range(0, height, 4):
        draw.line([(0, y), (width, y)], fill=(8, 8, 8), width=1)

    out_dir = Path.home() / ".config" / "wallpaper"
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / f"{name}.png"
    img.save(out_path, "PNG")
    print(f"Generated: {out_path} ({width}x{height})")
    return out_path


if __name__ == "__main__":
    for name, (w, h) in RESOLUTIONS.items():
        generate_wallpaper(w, h, name)
    print("\nDone. Set wallpaper with:")
    print("  gsettings set org.gnome.desktop.background picture-uri 'file:///home/zach/.config/wallpaper/ultrawide.png'")
    print("  gsettings set org.gnome.desktop.background picture-uri-dark 'file:///home/zach/.config/wallpaper/ultrawide.png'")

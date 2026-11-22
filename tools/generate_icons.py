#!/usr/bin/env python3
"""يولّد أيقونة التطبيق (نجمة ذهبية ثمانية على أخضر عميق) لكل كثافات أندرويد.

تعمل ببايثون القياسي فقط (بدون أي مكتبات خارجية)، وتُنفَّذ تلقائيًا
في GitHub Actions قبل البناء، لأن ملفات PNG لا تُرفع عبر واجهة GitHub.
"""
import math
import os
import struct
import zlib


def png_rgba(w, h, pixels):
    raw = b""
    for row in pixels:
        raw += b"\x00" + b"".join(struct.pack("BBBB", *p) for p in row)

    def chunk(typ, data):
        c = struct.pack(">I", len(data)) + typ + data
        return c + struct.pack(">I", zlib.crc32(typ + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    return (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", ihdr)
        + chunk(b"IDAT", zlib.compress(raw))
        + chunk(b"IEND", b"")
    )


def make_icon(size):
    bg = (13, 31, 26, 255)
    gold = (201, 168, 106, 255)
    inner = (20, 48, 38, 255)
    cx = cy = size / 2
    pixels = []
    for y in range(size):
        row = []
        for x in range(size):
            d = math.hypot(x - cx, y - cy)
            color = inner if d <= size * 0.30 else bg
            r = size * 0.16
            dx, dy = x - cx, y - cy
            inside = False
            for rot in (0.0, math.pi / 4):
                c, s = math.cos(-rot), math.sin(-rot)
                rx, ry = dx * c - dy * s, dx * s + dy * c
                if abs(rx) + abs(ry) <= r * 1.15:
                    inside = True
            if inside:
                color = gold
            row.append(color)
        pixels.append(row)
    return png_rgba(size, size, pixels)


def main():
    base = os.path.join(
        os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
        "android",
        "app",
        "src",
        "main",
        "res",
    )
    for name, size in [
        ("mipmap-mdpi", 48),
        ("mipmap-hdpi", 72),
        ("mipmap-xhdpi", 96),
        ("mipmap-xxhdpi", 144),
        ("mipmap-xxxhdpi", 192),
    ]:
        folder = os.path.join(base, name)
        os.makedirs(folder, exist_ok=True)
        with open(os.path.join(folder, "ic_launcher.png"), "wb") as f:
            f.write(make_icon(size))
        print(f"{name} {size} ok")


if __name__ == "__main__":
    main()

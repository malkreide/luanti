#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Erzeugt einfache 16x16-Texturen fuer das Octonauts-Starter-Mod.

Diese Texturen sind absichtlich schlicht gehalten - sie sind eine Einladung!
Dein Sohn kann jede dieser PNG-Dateien mit einem Malprogramm uebermalen und
seinen eigenen Octonauts-Look erfinden. Einfach diese Datei erneut ausfuehren,
um die Standard-Texturen wiederherzustellen:

    python3 make_textures.py

Kein Pillow noetig - wir schreiben das PNG-Format von Hand (nur Standardbibliothek).
"""

import struct
import zlib
import os

SIZE = 16
HERE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "textures")


def write_png(filename, pixels):
    """pixels: 2D-Liste [y][x] mit (r, g, b, a) Tupeln, Werte 0-255."""
    raw = bytearray()
    for row in pixels:
        raw.append(0)  # Filter-Byte 0 (None) pro Bildzeile
        for (r, g, b, a) in row:
            raw += bytes((r, g, b, a))

    def chunk(tag, data):
        c = tag + data
        return struct.pack(">I", len(data)) + c + struct.pack(">I", zlib.crc32(c) & 0xFFFFFFFF)

    sig = b"\x89PNG\r\n\x1a\n"
    ihdr = struct.pack(">IIBBBBB", SIZE, SIZE, 8, 6, 0, 0, 0)  # 8 bit, RGBA
    idat = zlib.compress(bytes(raw), 9)
    png = sig + chunk(b"IHDR", ihdr) + chunk(b"IDAT", idat) + chunk(b"IEND", b"")
    path = os.path.join(HERE, filename)
    with open(path, "wb") as f:
        f.write(png)
    print("geschrieben:", filename)


def grid(fill=(0, 0, 0, 0)):
    return [[fill for _ in range(SIZE)] for _ in range(SIZE)]


def dist(x, y, cx, cy):
    return ((x - cx) ** 2 + (y - cy) ** 2) ** 0.5


# --- Octopod-Wand: weiss mit oranger Streife (die Farben des Octopod) ---
def octopod_wall():
    p = grid((238, 240, 245, 255))
    for y in range(SIZE):
        for x in range(SIZE):
            if 6 <= y <= 9:
                p[y][x] = (240, 120, 30, 255)  # orange Streife
            if x == 0 or x == SIZE - 1 or y == 0 or y == SIZE - 1:
                p[y][x] = (180, 185, 195, 255)  # Rahmen
    return p


# --- Steuerpult: dunkel mit bunten leuchtenden Knoepfen ---
def control_panel():
    p = grid((40, 45, 60, 255))
    buttons = [(4, 4, (255, 70, 70)), (8, 4, (90, 220, 90)),
               (12, 4, (90, 160, 255)), (4, 8, (255, 220, 60)),
               (8, 8, (255, 130, 220)), (12, 8, (120, 255, 255))]
    for (cx, cy, col) in buttons:
        for y in range(SIZE):
            for x in range(SIZE):
                if dist(x, y, cx, cy) < 1.7:
                    p[y][x] = (col[0], col[1], col[2], 255)
    for y in range(11, 15):  # kleiner "Bildschirm"
        for x in range(2, 14):
            p[y][x] = (30, 200, 180, 255)
    return p


# --- Bullauge: rundes blaues Fenster ---
def bullauge():
    p = grid((150, 155, 165, 255))
    for y in range(SIZE):
        for x in range(SIZE):
            d = dist(x, y, 7.5, 7.5)
            if d < 6:
                p[y][x] = (120, 200, 255, 200)  # Glas, leicht durchsichtig
            if 6 <= d < 7:
                p[y][x] = (90, 95, 110, 255)     # Metallring
    return p


# --- Vegimal-Keks: runder gruener Keks ---
def vegimal_cookie():
    p = grid((0, 0, 0, 0))
    for y in range(SIZE):
        for x in range(SIZE):
            d = dist(x, y, 7.5, 7.5)
            if d < 7:
                p[y][x] = (120, 200, 90, 255)
            if d < 7 and (int(x * 1.3 + y) % 5 == 0):
                p[y][x] = (70, 140, 50, 255)  # Streusel
    return p


# --- Vegimal: kleines freundliches Wesen (Sprite) ---
def vegimal():
    p = grid((0, 0, 0, 0))
    for y in range(SIZE):
        for x in range(SIZE):
            if dist(x, y, 7.5, 8.5) < 6:
                p[y][x] = (120, 210, 110, 255)  # gruener Koerper
    # Augen
    for (cx, cy) in [(5, 7), (10, 7)]:
        for y in range(SIZE):
            for x in range(SIZE):
                if dist(x, y, cx, cy) < 1.6:
                    p[y][x] = (255, 255, 255, 255)
                if dist(x, y, cx, cy) < 0.9:
                    p[y][x] = (30, 30, 40, 255)
    # Laecheln
    for x in range(5, 11):
        p[11][x] = (40, 90, 40, 255)
    p[10][5] = (40, 90, 40, 255)
    p[10][10] = (40, 90, 40, 255)
    return p


if __name__ == "__main__":
    os.makedirs(HERE, exist_ok=True)
    write_png("octonauts_octopod_wall.png", octopod_wall())
    write_png("octonauts_control_panel.png", control_panel())
    write_png("octonauts_bullauge.png", bullauge())
    write_png("octonauts_vegimal_cookie.png", vegimal_cookie())
    write_png("octonauts_vegimal.png", vegimal())
    print("Fertig! Alle Texturen liegen in:", HERE)

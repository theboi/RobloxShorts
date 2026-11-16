"""Approximate geometry previews from actual instance exports; not Roblox renders."""
import json
import math
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "build/previews"


def mesh(shape):
    if shape == "Head":
        vertices, faces = [], []
        for y, radius in [(-.5, .38), (-.43, .5), (.43, .5), (.5, .38)]:
            for col in range(16):
                angle = math.tau * col / 16
                vertices.append((radius * math.cos(angle), y, radius * math.sin(angle)))
        for row in range(3):
            for col in range(16):
                a, b = row * 16 + col, row * 16 + (col + 1) % 16
                faces.append((a, b, b + 16, a + 16))
        faces += [tuple(range(15, -1, -1)), tuple(range(48, 64))]
        return np.array(vertices), faces
    if shape == "Ball":
        vertices, faces = [], []
        for row in range(9):
            latitude = math.pi * row / 8
            for col in range(16):
                longitude = 2 * math.pi * col / 16
                # Rounded classic head approximation, not the engine's built-in mesh.
                y = math.cos(latitude) * 0.5
                radius = math.sin(latitude) * 0.5
                vertices.append((radius * math.cos(longitude), y, radius * math.sin(longitude)))
        for row in range(8):
            for col in range(16):
                a, b = row * 16 + col, row * 16 + (col + 1) % 16
                faces.append((a, b, b + 16, a + 16))
        return np.array(vertices), faces
    vertices = np.array([
        (-.5, -.5, -.5), (.5, -.5, -.5), (.5, .5, -.5), (-.5, .5, -.5),
        (-.5, -.5, .5), (.5, -.5, .5), (.5, .5, .5), (-.5, .5, .5),
    ])
    if shape == "Wedge":
        vertices = vertices.astype(float)
        vertices[2, 1] = -.5
        vertices[3, 1] = -.5
    return vertices, [(0, 3, 2, 1), (4, 5, 6, 7), (0, 1, 5, 4), (3, 7, 6, 2), (0, 4, 7, 3), (1, 2, 6, 5)]


def render(path, width=540, height=960):
    data = json.loads(path.read_text())
    eye, target = np.array(data["camera"], dtype=float), np.array(data["target"], dtype=float)
    forward = target - eye
    forward /= np.linalg.norm(forward)
    right = np.cross(forward, np.array([0., 1., 0.]))
    right /= np.linalg.norm(right)
    up = np.cross(right, forward)
    view = np.stack((right, up, forward))
    focal = height / (2 * math.tan(math.radians(24)))
    light = np.array([-.4, .9, -.7])
    light /= np.linalg.norm(light)
    polygons = []

    def project(vertices):
        return [(width / 2 + v[0] * focal / v[2], height / 2 - v[1] * focal / v[2]) for v in vertices]

    def clip(vertices):
        result = []
        for i, current in enumerate(vertices):
            previous = vertices[i - 1]
            inside, was_inside = current[2] >= .15, previous[2] >= .15
            if inside != was_inside:
                fraction = (.15 - previous[2]) / (current[2] - previous[2])
                result.append(previous + (current - previous) * fraction)
            if inside:
                result.append(current)
        return result

    for part in data["parts"]:
        vertices, faces = mesh(part["shape"])
        basis = np.array([part["right"], part["up"], part["back"]]).T
        world = (vertices * np.array(part["size"])) @ basis.T + np.array(part["position"])
        local = (world - eye) @ view.T
        for face in faces:
            points = world[list(face)]
            normal = np.cross(points[1] - points[0], points[2] - points[0])
            length = np.linalg.norm(normal)
            if length < 1e-8:
                continue
            normal /= length
            shade = .55 + .45 * max(0., np.dot(normal, light))
            color = tuple(int(min(255, component * 255 * shade)) for component in part["color"])
            clipped = clip(local[list(face)])
            if len(clipped) >= 3:
                polygons.append((project(clipped), color, [p[2] for p in clipped]))
        if part.get("face"):
            # Face features are flat discs, projected in the same front surface plane.
            for index in range(part["face"]):
                monster = part["face"] == 6
                x = (-.25 + (index % 3) * .25) if monster else (-.2 + index * .4)
                y = (.22 - (index // 3) * .25) if monster else .12
                points = []
                for step in range(12):
                    angle = step * math.tau / 12
                    points.append((x + math.cos(angle) * .045, y + math.sin(angle) * .08, -.51))
                faceworld = (np.array(points) * np.array(part["size"])) @ basis.T + np.array(part["position"])
                faceview = (faceworld - eye) @ view.T
                if np.min(faceview[:, 2]) > .15:
                    polygons.append((project(faceview), (245, 190, 70) if monster else (20, 25, 35), list(faceview[:, 2] - .005)))
    pixels = np.full((height, width, 3), (205, 220, 231), dtype=np.uint8)
    depth = np.full((height, width), np.inf)
    # Depth testing matters: large walls must not paint over nearer actors merely
    # because their centre is nearer to the camera than the actor's centre.
    for points, color, depths in polygons:
        for index in range(1, len(points) - 1):
            triangle = np.array([points[0], points[index], points[index + 1]])
            zs = np.array([depths[0], depths[index], depths[index + 1]])
            lo = np.maximum(np.floor(triangle.min(axis=0)).astype(int), (0, 0))
            hi = np.minimum(np.ceil(triangle.max(axis=0)).astype(int), (width - 1, height - 1))
            if np.any(lo > hi):
                continue
            x, y = np.meshgrid(np.arange(lo[0], hi[0] + 1) + .5, np.arange(lo[1], hi[1] + 1) + .5)
            (ax, ay), (bx, by), (cx, cy) = triangle
            denominator = (by - cy) * (ax - cx) + (cx - bx) * (ay - cy)
            if abs(denominator) < 1e-9:
                continue
            wa = ((by - cy) * (x - cx) + (cx - bx) * (y - cy)) / denominator
            wb = ((cy - ay) * (x - cx) + (ax - cx) * (y - cy)) / denominator
            wc = 1 - wa - wb
            inside = (wa >= 0) & (wb >= 0) & (wc >= 0)
            inverse_depth = wa / zs[0] + wb / zs[1] + wc / zs[2]
            z = np.divide(1., inverse_depth, out=np.full_like(inverse_depth, np.inf), where=inverse_depth > 0)
            region = depth[lo[1]:hi[1] + 1, lo[0]:hi[0] + 1]
            visible = inside & (z < region)
            region[visible] = z[visible]
            pixels[lo[1]:hi[1] + 1, lo[0]:hi[0] + 1][visible] = color
    image = Image.fromarray(pixels)
    draw = ImageDraw.Draw(image)
    draw.rectangle((0, 0, width, 65), fill=(22, 30, 45))
    font = ImageFont.load_default(size=18)
    draw.text((16, 10), data["title"], font=font, fill="white")
    draw.text((16, 36), "GEOMETRY PREVIEW - NOT STUDIO FOOTAGE", font=ImageFont.load_default(size=11), fill=(240, 190, 80))
    image.save(path.with_suffix(".png"))
    return image


if __name__ == "__main__":
    images = {}
    for path in sorted(OUT.glob("*.json")):
        images[path.stem] = render(path)
    names = ["Eli", "Dad", "Lens", "Sol", "Bristle"]
    sheet = Image.new("RGB", (300 * len(names), 534), (22, 30, 45))
    for i, name in enumerate(names):
        sheet.paste(images[name].resize((300, 534)), (i * 300, 0))
    sheet.save(OUT / "cast-sheet.png")
    for film in ("power", "gate"):
        selected = [(name, image) for name, image in images.items() if name.startswith(film + "-")]
        sheet = Image.new("RGB", (270 * len(selected), 480), (22, 30, 45))
        for i, (_, image) in enumerate(selected):
            sheet.paste(image.resize((270, 480)), (i * 270, 0))
        sheet.save(OUT / f"{film}-contact-sheet.png")
    print(f"Rendered {len(images)} geometry previews and 3 contact sheets")

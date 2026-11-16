"""Original scratch sound cues and macOS speech, assembled on the shot clock."""
import json
import math
import shutil
import struct
import subprocess
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "build/audio"
RATE = 24000


def run(args):
    subprocess.run(args, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)


def duration(path):
    return float(subprocess.check_output([
        "ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "default=nw=1:nk=1", str(path)
    ]))


def cue(name, length, frequency, sweep=0, noise=0):
    samples = []
    seed = 7
    for i in range(int(RATE * length)):
        t = i / RATE
        seed = (1664525 * seed + 1013904223) % (2 ** 32)
        random = seed / (2 ** 31) - 1
        envelope = math.exp(-t * (6 / length)) * min(1, t * 200)
        signal = math.sin(math.tau * (frequency * t + sweep * t * t / 2))
        samples.append(int(11000 * envelope * ((1 - noise) * signal + noise * random)))
    with wave.open(str(OUT / f"{name}.wav"), "wb") as file:
        file.setparams((1, 2, RATE, 0, "NONE", "not compressed"))
        file.writeframes(struct.pack("<" + "h" * len(samples), *samples))


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    for parameters in [
        ("impact", .65, 75, -50, .45), ("whoosh", .45, 500, -900, .85),
        ("beep", .18, 900, 300, 0), ("creak", .8, 130, -80, .35),
        ("rustle", .6, 300, -180, .95), ("click", .12, 1400, -600, .6),
        ("chomp", .22, 120, -70, .65), ("cloth", .5, 180, -60, .95),
    ]:
        cue(*parameters)
    if not shutil.which("say"):
        raise SystemExit("Original cues generated. macOS say required for optional scratch narration.")
    for name in ("power", "gate"):
        timeline = json.loads((ROOT / f"build/editorial/{name}.json").read_text())
        folder = OUT / name
        folder.mkdir(exist_ok=True)
        files, rates = [], []
        for index, shot in enumerate(timeline["shots"]):
            raw, final = folder / f"{index:02d}.aiff", folder / f"{index:02d}.wav"
            run(["say", "-v", "Samantha", "-r", "170", "-o", str(raw), shot["text"]])
            speed = max(1., duration(raw) / (shot["duration"] - .2))
            rates.append({"shot": shot["id"], "speed": round(speed, 3)})
            if speed > 1.35:
                raise SystemExit(f"{name}/{shot['id']}: narration too fast ({speed:.2f}x); lengthen the shot")
            run(["ffmpeg", "-y", "-i", str(raw), "-af", f"atempo={speed},apad,atrim=duration={shot['duration']}", "-ar", str(RATE), "-ac", "1", str(final)])
            files.append(f"file '{final.name}'")
        listing = folder / "concat.txt"
        listing.write_text("\n".join(files) + "\n")
        speech = OUT / f"{name}-scratch-narration.wav"
        run(["ffmpeg", "-y", "-f", "concat", "-safe", "0", "-i", str(listing), "-c", "copy", str(speech)])
        inputs = ["ffmpeg", "-y", "-i", str(speech)]
        filters = ["[0:a]volume=0.85[speech]"]
        streams = ["[speech]"]
        for shot in timeline["shots"]:
            if shot.get("cue"):
                inputs += ["-i", str(OUT / f"{shot['cue']}.wav")]
                i = len(streams)
                filters.append(f"[{i}:a]volume=0.25,adelay={int(shot['start'] * 1000)}:all=1[c{i}]")
                streams.append(f"[c{i}]")
        filters.append("".join(streams) + f"amix=inputs={len(streams)}:normalize=0:duration=first,alimiter=limit=0.95[out]")
        run(inputs + ["-filter_complex", ";".join(filters), "-map", "[out]", str(OUT / f"{name}-scratch-mix.wav")])
        (folder / "timing-report.json").write_text(json.dumps(rates, indent=2) + "\n")
        actual = duration(speech)
        assert abs(actual - timeline["duration"]) < .05, "Audio drift from shot clock"
        print(f"{name}: {actual:.2f}s scratch narration and cue mix; max time compression {max(x['speed'] for x in rates):.3f}x")

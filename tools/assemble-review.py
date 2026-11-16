"""Combine real Studio capture with the shot-clock scratch mix; never invent footage."""
import argparse
import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def probe(path):
    return json.loads(subprocess.check_output([
        "ffprobe", "-v", "error", "-show_streams", "-show_format", "-of", "json", str(path)
    ]))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--film", choices=("power", "gate"), required=True)
    parser.add_argument("--capture", type=Path, required=True)
    parser.add_argument("--offset", type=float, default=0, help="Seconds before the film's first frame")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.offset < 0:
        parser.error("Offset cannot be negative")
    if args.output.exists():
        parser.error("Output exists; use a new review version")
    timeline = json.loads((ROOT / f"build/editorial/{args.film}.json").read_text())
    metadata = probe(args.capture)
    video = next(stream for stream in metadata["streams"] if stream["codec_type"] == "video")
    if video["width"] * 16 != video["height"] * 9:
        parser.error("Capture must be 9:16; fix the viewport/crop before assembly")
    if float(metadata["format"]["duration"]) - args.offset < timeline["duration"] - .05:
        parser.error("Capture ends before the film does")
    mix = ROOT / f"build/audio/{args.film}-scratch-mix.wav"
    subprocess.run([
        "ffmpeg", "-hide_banner", "-n", "-ss", str(args.offset), "-i", str(args.capture),
        "-i", str(mix), "-map", "0:v:0", "-map", "1:a:0", "-t", str(timeline["duration"]),
        "-vf", "scale=1080:1920:flags=lanczos", "-r", "30", "-c:v", "libx264", "-crf", "18",
        "-pix_fmt", "yuv420p", "-c:a", "aac", "-b:a", "192k", "-movflags", "+faststart", str(args.output),
    ], check=True)
    result = probe(args.output)
    assert abs(float(result["format"]["duration"]) - timeline["duration"]) < .15, "Export duration drift"
    print(f"Review export: {args.output}. Scratch audio; complete motion/audio review still required.")

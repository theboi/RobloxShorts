# RobloxShorts

Two superhero mysteries staged in the Roblox engine. Current delivery is a coded
previsualization and editable asset pack, awaiting its first Roblox Studio run.

## Stories

- [My Power Stops When You Look at Me](stories/01-my-power-stops-when-you-look.md)
  — a rejected student discovers why his caretaker father understands his power.
- [The Monster at the School Gate](stories/02-the-monster-at-the-school-gate.md)
  — students investigate why their guardian attacks their superhero principal.

The current shot timelines run **155 seconds** and **164 seconds**. The Markdown
scripts contain expanded direction; the film modules contain the current timed
recording text. Treat the film modules and their exported SRT as the edit versions.

## Open tomorrow

The following files are already built locally in `build/`:

- `Power.rbxlx` — starts on the superpower story.
- `Gate.rbxlx` — starts on the school monster story.
- `AssetGallery.rbxlx` — inspect the editable models without starting playback.

After installing Studio, open either story place and choose **Play / Test**, not
server-only Run. The scene builds on the client. Press **Space** to play.
There is no Rojo plugin, paid asset, publishing step, or audio upload requirement.

| Key | Action |
| --- | --- |
| Space | Play / pause |
| R | Return to beginning |
| Left / Right | Seek five seconds |
| [ / ] | Previous / next shot |
| 1 / 2 | Switch stories |
| H | Hide review HUD, guides, and cursor |
| C | Toggle preview captions |

For automation, edit the client-side `Workspace.FilmControl` attributes:
`Episode`, `Paused`, `SeekTime`, `Clean`, and `Captions`. `CurrentTime`, `Duration`,
and `ShotId` report playback. Changing `SeekTime` seeks once; changing `Paused`
resumes from that position. Use client Explorer, not the server simulation.

## Rebuild and verify

```sh
cd /Users/bot3/Dev/RobloxShorts
make setup
make build
make editorial
```

Pinned project-local tools: Lune 0.11.1, Rojo 7.7.1, StyLua 2.6.0. `setup.sh`
targets this Apple Silicon Mac and verifies downloaded archive SHA-256 values.
It installs into `.tools/`, without modifying Homebrew or global tool versions.

Optional review artifacts:

```sh
make previews  # Python venv; geometry thumbnails and contact sheets
make audio     # macOS Samantha scratch speech; requires ffmpeg and ffprobe
```

`build/editorial/` contains SRT captions and shot/cue JSON. `build/audio/` contains
original synthesized sound cues, scratch narration, and cue mixes. The two mixes
match the shot timelines exactly; no music or final voice performance is included.
The scratch mixes are for external editing and are not embedded in the place files.
Preview captions are whole-shot text; final captions need phrase-level editing.

After Studio is available, `tools/capture.sh` lists capture devices and records an
explicit portrait viewport rectangle. `tools/assemble-review.py --help` explains
how to align a real capture with the scratch mix. Both refuse to overwrite output.
These capture/assembly paths are prepared but have not been exercised with Studio.

## Source layout

- `src/shared/`: original procedural models, palette, animation, timeline, scene sampling.
- `src/films/`: shot data, camera paths, poses, prop placement, lighting, and narration.
- `src/client/`: local playback, review controls, optional approved audio IDs.
- `src/server/`: suppresses unrelated player spawning.
- `tools/`: model/scene builds, editorial exports, geometry previews, scratch audio.
- `tests/`: real Luau and serialized-instance checks; no simulated Studio renderer.
- `docs/`: style research, asset provenance, plan, and Studio QA handoff.

All generated outputs are ignored and reproducible. Source code is on GitHub;
the compiled places and audio remain on this machine under `build/`.

## What remains unverified

Studio is not installed yet. No claim is made that the films have played correctly
in-engine or that a finished video has been recorded. Offline checks cover timeline
math, shot references, joint motion, stable seeks, story mechanisms, file imports,
and Luau compilation. [Studio QA](docs/studio-qa.md) lists the remaining checks.

Offline geometry previews approximate shapes and shading. They do not reproduce
Roblox's built-in head mesh, font rendering, materials, lighting, or final capture.

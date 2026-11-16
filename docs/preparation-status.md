# Preparation status — November 17, 2026

## Prepared locally

- Two complete story Markdown files under `stories/`.
- 30-shot Power film, 155 seconds; 32-shot Gate film, 164 seconds.
- Eleven original classic-proportioned film rigs and 638 total authored parts.
- Modular school campus, guardian, living cape, cameras, costume details, evidence,
  containment mechanisms, rescue props, and original synthesized sound cues.
- Standalone `build/Power.rbxlx`, `build/Gate.rbxlx`, `build/AssetGallery.rbxlx`.
- Editable model pack `build/models/FilmAssets.rbxm`.
- SRT and shot/cue JSON for each film in `build/editorial/`.
- Exact-duration scratch narration and cue mixes in `build/audio/`.
- Cast/selected-shot geometry previews in `build/previews/`.
- Repeatable local setup, checks, builds, capture helper, and review assembly helper.

## Verified offline

- Timeline cuts, boundary clamping, backward seeking, invalid edits, interpolation.
- All actors, body joints, faces, and required story mechanisms exist.
- Every shot sampled at start/middle/end against real Roblox instance geometry.
- Grounded fall poses, partition reach/contact/direction, stable mechanism holds,
  and fast-burst movement intervals have regression checks.
- Both compiled places deserialize and their sixteen embedded Luau scripts compile.
- The asset gallery deserializes with its model library intact.
- Scratch audio duration is 155.00 and 164.00 seconds. Maximum narration time
  compression was 1.010x and 1.159x respectively; audio has not been listened to.
- Selected geometry thumbnails inspected for silhouette and gross framing issues.
- Separate code review identified staging defects; fixes and regression checks are
  included. It did not run Studio or establish final visual quality.

## Still requires Studio and final production review

Engine startup, Roblox mesh/font rendering, portrait framing of every shot, camera
occlusion, precise prop contacts, refined acting/cloth/effects, screen-recording
permissions, actual capture, listening review, final narration, phrase captions,
and exported MP4 inspection. These are prepared films and assets, not finished videos.

Start with [the Studio checklist](studio-qa.md). Sources are pushed to GitHub;
generated binaries/audio/previews stay on this machine and rebuild from source.

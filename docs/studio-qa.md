# Studio handoff and remaining QA

## First engine run

1. Open `build/AssetGallery.rbxlx`; inspect rounded head shape, faces, hair, clothing
   details, guardian silhouette, and cape geometry. These have only offline previews.
2. Open `build/Power.rbxlx` and choose Play/Test. Confirm no player avatar spawns,
   the local scene appears, and the review HUD reports `tryouts` at zero seconds.
3. Play, pause, seek both directions, replay, and switch stories. Confirm no runtime
   errors in Output and no state carries between independent shots.
4. Use a portrait device emulation viewport. Verify 9:16 framing and phone-scale
   readability; the film player does not pretend a landscape viewport is portrait.
5. Inspect every shot, especially near contacts and fast actions. Offline checks
   prove geometry samples, not performance quality or final contact correctness.

## Story-specific inspection

- Power: spectators look at Eli; helmet cameras turn toward their target; rescues
  happen outside direct witness views; the coat covers both lenses; Ada is the
  final trapped student; the shutter contains Lens after everyone exits.
- Gate: cape visibly moves on its own; office door closes; sunlight buys time;
  the corridor door actually pinches fabric; the partition closes from both sides
  onto the same cloth plane; Sol lands on the mat; Bristle ends belly-up.
- Check expression changes, body/prop intersections, foot contact, face graphics,
  material shading, camera clipping, lighting continuity, and caption safe area.
- The animation is procedural previs. Refine acting, contacts, cloth behavior,
  motion curves, effects, and cuts from the actual engine playback before final capture.

## Capture and audio assembly

1. Select the shot or film, seek to zero, enable clean mode with H, and choose
   whether to retain preview captions with C. Start capture before pressing Space.
2. Verify actual recording resolution and frame rate. Target 1080 x 1920 at 30 fps;
   macOS screen-recording permission and capture tooling remain untested.
   Use `sh tools/capture.sh --list` to identify the display, then pass the exact
   viewport rectangle to the capture script. It rejects non-9:16 rectangles.
3. Trim the recording to the exact film start. Align the exported scratch mix at
   zero for a timing review. Final narration replaces system speech before release.
4. Use the SRT and cue JSON to refine caption chunks and audio timing. Check full
   motion playback and listen to the export; metadata alone is insufficient.
   `python3 tools/assemble-review.py --film power --capture captures/power-take1.mp4
   --offset 2.0 --output captures/power-review-v1.mp4` aligns a real capture with
   the scratch mix. Replace the example offset with the measured film start.
5. Deliver a versioned review MP4 and notes. Nothing is approved for publishing yet.

## Known limits of this preparation

- No Studio install, login, engine render, screen recording, or final MP4 yet.
- No final voice casting, music, lip sync, uploaded audio IDs, or engine audio mix.
- Geometry PNGs approximate the asset data; they are not Roblox screenshots.
- Current preview captions display an entire shot's text. Final phrase timing,
  exact character acting, and 9:16 camera polish require engine review.

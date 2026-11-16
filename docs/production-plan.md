# Two-story production preparation

Approved scope: save both superhero mysteries, implement their scenes, and prepare
original Roblox-style models before Studio is installed. Work on main. No publishing.

## Design

Use a shared school campus and classic-proportioned six-part film rigs with rounded
heads, surface faces, sculpted primitive hair, layered costume details, and deliberate
silhouettes. The guardian has a broad hunched body, horns, articulated jaw, padded paws,
and expressive eyes. The cape is a separate segmented creature, not a flat red slab.

All geometry is authored locally from Roblox primitives and serialized into real
Roblox models with Lune. No downloaded scripts, paid assets, published animation IDs,
or external textures are required. Rojo packages generated assets and Luau into places
that open directly in Studio without installing a plugin.

The client film player samples one absolute clock. Shot data owns camera cuts,
actor paths, poses, captions, prop visibility, lighting, and sound cues. Seeking and
replay reconstruct state instead of accumulating timers. Character posing is kinematic
for predictable offline-shot sampling; Motor6D joints are retained in exported rigs
for later Studio animation work. These are film actors, not player avatars.

## Delivery steps

- [x] Save both scripts with timed beats, clues, resolutions, and prop requirements.
- [x] Research style and APIs; document references and original asset provenance.
- [x] Install project-local Lune, Rojo, and StyLua without changing system tools.
- [x] Test timeline boundaries, seeking, interpolation, and invalid shot data first.
- [x] Implement timeline sampling and character/prop/camera playback.
- [x] Build the school, film cast, guardian, cape, helmet, evidence, and rescue props.
- [x] Test generated models for required actors, geometry, pivots, joints, and faces.
- [x] Author complete shot sequences for both stories and subtitle/cue exports.
- [x] Build two standalone places and an asset gallery; inspect serialized content.
- [x] Document Studio playback, capture controls, and remaining visual/audio checks.
- [x] Run checks and push first implementation milestone; final handoff follows review fixes.

## Verification boundary

Offline tests can validate actual Roblox instances, serialized models, shot coverage,
and deterministic motion samples. They cannot prove Roblox rendering, camera framing,
screen capture, engine-only API behavior, or final performances. Studio checks remain
explicitly pending. Narration timing is provisional until a voiced read; local system
speech may be generated as scratch audio, never presented as final voice casting.

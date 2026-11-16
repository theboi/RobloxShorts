# Roblox style and asset direction

Research checked November 16–17, 2026. This is the working visual direction for
these two films, pending review of real Studio renders.

## What makes the style recognizable

Roblox has multiple avatar styles. These films deliberately use classic proportions:
a roughly five-stud figure, broad two-by-two-by-one torso, separate blocky limbs,
a rounded built-in head mesh, readable flat facial graphics, chunky sculpted hair,
and accessories that break the silhouette. SmoothPlastic does not mean every
object should be a single unmodified cuboid. Rounded collars, contrasting cuffs,
shoe soles, hair wedges, helmet lenses, horns, and cloth folds add readable detail.

Source references:

- [Roblox avatar settings](https://create.roblox.com/docs/studio/avatar-settings)
  describes classic avatar scale at about five studs.
- [Character appearance](https://create.roblox.com/docs/characters/appearance)
  distinguishes body properties, classic clothing, and accessories.
- [Character body specifications](https://create.roblox.com/docs/avatar/character-bodies/specifications)
  explains Classic, Normal, and Slender body standards. Our local film rigs are
  deliberately not Marketplace-ready R15 uploads.
- [Motor6D](https://create.roblox.com/docs/reference/engine/classes/Motor6D)
  documents joint transforms; current player rigs can use AnimationConstraints.
  We create our own six-part film rigs and retain five explicit Motor6Ds per actor.
- [RunService](https://create.roblox.com/docs/reference/engine/classes/RunService)
  documents render scheduling. Our anchored film actors are sampled kinematically
  with the camera before rendering; there is no Animator fighting their poses.
- [Lune Roblox API](https://lune-org.github.io/docs/api-reference/roblox/)
  supports constructing and serializing real Roblox instances without Studio.
- [Rojo project format](https://rojo.space/docs/v7/project-format/)
  maps source modules and model assets into directly openable place files.

## Cast and materials

Eli and Nia wear teal; Dad wears navy workwear with a utility belt and silver hair;
Lens has a mirrored-looking grey helmet, black visor, and two signal lenses;
Sol wears blue and gold. Supporting students use separate clothing and hair cues.
The guardian is oversized purple with a cream chest bib, horns, paws, and six gold
eyes. Its threatening silhouette must still read as friendly at the ending.

Use cream/brick school architecture, teal lockers, timber benches, navy ironwork,
and metal mechanisms. Color blocks distinguish characters at phone size. Use Neon
sparingly for power-core and camera indicators; keep surfaces otherwise opaque.

The living cape uses fifteen independently posed red/plum fabric panels and a gold
clasp. It is a separate organism: its movement must visibly disagree with Sol's body.
The partition and door must physically meet the fabric at the reveal and climax.

## Original asset provenance

Every model is authored in this repository from built-in Roblox primitives and the
built-in Head SpecialMesh. No Creator Store models, external textures, copied rigs,
third-party scripts, or published animation assets are bundled.

| Group | Authoring source | Contents |
| --- | --- | --- |
| Cast | `src/shared/Characters.luau` | Eli, Dad, Lens, Maya, Noah, Ada, Nia, Sam, Bea, Sol, Bristle |
| Campus | `src/shared/School.luau` | Courtyard, facade, gate/shutter, stairs/landing, office/blinds, corridor/door, gym/cage/partition |
| Props | `src/shared/Props.luau` | Cape, bench, mop, cloth, security camera, coat shield, helmet detail, slips, ice pack, evidence, sandwich, power core, bin/dust, release switch |
| Animation | `src/shared/Motion.luau` | Idle, walk/run, reach/lift, shield, scared, kneel, fall/prone/supine, pounce, wave, sit, pet, strain |
| Audio | `tools/build-audio.py` | Eight original synthesized cues; optional system-voice scratch narration |

Coordinate contract: Y is up, one Roblox unit is one stud, a rig's root is at its
feet, and an unrotated character looks along negative Z. Shot yaw is in degrees.
Models retain bind transforms; sampling does not modify source geometry. Do not
assume these custom film rigs accept arbitrary Marketplace animations unchanged.

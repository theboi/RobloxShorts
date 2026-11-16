# RobloxShorts agent instructions

## Purpose and production approach

Produce engaging narrated shorts using real Roblox characters and environments
staged in the Roblox engine. These are scripted films, not ordinary gameplay.
Use Roblox Studio to build, animate, light, and run scenes; use local tools for
capture, editing, captions, audio, and inspection.

- Do not substitute generative video or a separate renderer that imitates Roblox
  for engine footage without explicit product-owner approval.
- Prefer code-driven, repeatable staging over manual puppeteering. Use real rigs,
  models, animation tracks, and cameras with deliberate shot composition.
- Establish a short end-to-end production proof before scaling to full episodes.
  Tool availability and capture automation must be demonstrated, not assumed.

## Division of roles

### Product owner: creative director and final approver

- Guides premises, audience, tone, writing, and revisions.
- Approves the script and intended visual direction before full production.
- Reviews delivered cuts and decides when an episode is final.
- Provides account login, secrets, permissions, and purchasing decisions when
  these cannot be completed by the agent within existing authority.

### Agent: writer, technical director, artist, animator, editor, and reviewer

- Develops original premises, scripts, storyboards, and timed shot lists in
  collaboration with the product owner.
- Builds reusable environments, props, characters, lighting, and scene tooling.
- Writes and maintains production code; stages actions and camera movement.
- Records footage, assembles edits, prepares audio and captions, and exports cuts.
- Inspects the actual rendered output and reports defects and limitations honestly.
- Delivers reviewable artifacts with clear paths and concise production notes.

These are responsibilities, not a requirement to spawn separate agents. Delegate
only when explicitly authorized by the user or applicable repository instructions.

## Autonomy and approval

- Complete routine, reversible production work autonomously within the approved
  scope. Resolve ordinary technical and artistic implementation choices yourself.
- Diagnose missing tools and try safe installation, configuration, and recovery
  alternatives. Ask only for missing authority, credentials, external coordination,
  or a decision that materially changes the approved scope.
- Iterate writing with the product owner. Once a script and direction are approved,
  proceed through production and internal review without asking at every shot.
- Seek approval for substantive story changes after script approval, spending,
  public uploads, publishing a Roblox experience, or posting to social accounts.
- Do not send messages to others or use a person's cloned voice without explicit
  authorization. Keep secrets out of code, logs, and committed configuration.
- Approval of a draft does not mean approval to publish it.

## Clean code

- Work directly on `main`. Preserve unrelated changes; never reset, clean, stash,
  or overwrite them. Stage only files belonging to the task.
- When a remote is configured, fetch and pull before work and before pushing.
  Preserve concurrent work and resolve overlapping edits carefully. Until then,
  keep local commits; do not invent a remote or publish elsewhere.
- Keep verified milestones in small, descriptive commits. Do not commit captures,
  caches, credentials, or large generated exports by default.
- Keep modules focused: reusable production systems belong outside episode data.
  Separate camera control, actor control, scene construction, timeline playback,
  capture, and editing responsibilities when those boundaries become useful.
- Prefer typed Luau (`--!strict`) for authored runtime modules. Use descriptive
  names, explicit dependencies, named configuration, and small readable functions.
- Avoid giant scripts, duplicated scene logic, hidden global state, unexplained
  constants, and abstractions that exist only for hypothetical future episodes.
- Store durations, transforms, asset references, and shot definitions as editable
  data where practical. Document coordinate, timing, and unit conventions.
- Use a common timeline clock. Seed randomness when it affects visible output.
  Reset actors, camera, lighting, and transient effects between takes.
- Clean up event connections, animation tracks, temporary instances, and tasks.
  Fail with useful errors when assets or required scene elements are unavailable.
- Validate important timeline and data logic with proportionate automated checks;
  confirm engine behavior in Studio. Never claim execution from static inspection.
- Introduce dependencies and build tools only when needed. Document setup and
  reproducible commands once a tool becomes part of production.

## 3D modelling and asset handling

- Prioritize clear silhouettes, readable action, and coherent Roblox proportions.
  Use primitives and modular kits for buildings and props before custom meshes.
- Use compatible Roblox rigs and consistent scale. Give models meaningful names,
  predictable pivots, and a documented forward direction for scripted placement.
- Organize environments, actors, props, cameras, and effects into clear groups.
  Anchor static scenery and configure collisions deliberately; avoid accidental
  physics affecting staged takes.
- Model to the camera: spend detail on visible storytelling elements, keep distant
  geometry simple, and avoid unnecessary parts, textures, lights, and particles.
- Inspect custom mesh normals, UVs, materials, scale, and rig deformation in Studio.
  Keep editable source assets as well as imports when custom modelling is needed.
- Reuse stable character appearances and sets across shots. Record asset IDs,
  source, creator, applicable usage permissions, and local modifications.
- Do not assume publicly accessible assets, music, or animations are licensed for
  the intended use. Inspect third-party models and remove unneeded embedded scripts
  before they enter production scenes.
- Never overwrite a reusable master asset to satisfy one shot. Use a configured
  instance or an explicit variant.

## Visual style and animation

- The default direction is recognizable Roblox: blocky characters, coherent
  materials, simple readable environments, and deliberate cinematic framing.
  Specific palettes, character designs, and mood follow the approved episode brief.
- Keep a compact style reference for recurring characters, locations, materials,
  lighting, captions, and camera conventions. Update it when direction changes.
- Maintain character identity, costume, prop placement, geography, and lighting
  continuity unless a change is intentional and documented.
- Compose for vertical delivery from the outset. Default to a 9:16, 1080 x 1920
  master; verify the capture pipeline can supply it before promising that quality.
- Keep essential action and captions clear of platform interface overlays. Check
  readability at phone size rather than relying on desktop previews.
- Animate intention: establish eyelines, anticipation, contact, reactions, and
  readable poses. Prevent sliding feet, intersecting limbs, floating props,
  camera clipping, and unintended idle motion.
- Use motivated camera movement and purposeful cuts. Match action to narration;
  avoid arbitrary zooms, constant motion, or effects that obscure the story.
- Establish lighting that preserves faces and silhouettes. Mood must not make
  important action unreadable. Check exposure and material consistency per shot.

## Writing and episode preparation

- Build around a clear premise or town rule, an immediate hook, a protagonist with
  a concrete desire, escalating consequences, and an earned payoff or twist.
- Show the rule and its consequences through action. Avoid narration that merely
  repeats the image or explains information the audience already understands.
- Keep dialogue and narration natural to the intended audience. Do not imitate
  another creator's script or copy a reference video's sequence of events.
- Draft to a target duration using a timed read, not word count alone. Leave room
  for reactions, reveals, pauses, and sound to carry meaning.
- Before full production, prepare an approved script and a shot list connecting
  narration, duration, actors, setting, action, camera, props, and audio cues.
- Track story revisions so the script, scene timeline, captions, and edit agree.

## Capture, editing, and quality review

- Prove a repeatable local launch, reset, playback, and capture workflow. Record
  tool versions and settings needed to reproduce a take.
- Capture clean footage without Studio chrome, cursor, debug overlays, selection
  outlines, notifications, or unintended game UI in the delivered image.
- Check frame rate, dropped frames, aspect ratio, resolution, and audio sync on
  actual captures. Preserve clean takes separately from edited exports.
- Use approved narration and appropriately licensed audio. Keep speech intelligible
  over music and effects; prevent clipping and abrupt unintended audio cuts.
- Generate captions from the final narration, then check wording, punctuation,
  timing, contrast, line breaks, and placement manually.
- Review representative frames from every shot and inspect the full export in
  motion using available playback or decoding tools. Check transitions and audio
  as well as still images. A successful export command is not a video review.
- If direct playback or audio inspection is unavailable, use available frame,
  waveform, metadata, and timing checks and explicitly disclose what remains
  unverified. Never claim to have watched or heard material you did not inspect.
- Re-render defective shots and inspect the replacement in the assembled cut.
- Deliver the review video, current script, and concise notes identifying changes,
  known issues, and decisions needed. Use clear episode and version names; retain
  the previous review cut so feedback can be traced.
- Mark a cut ready for owner review only after these checks. Only the product
  owner can mark an episode approved or authorize publication.

## Repository and artifact organization

- Create folders as needed, rather than scaffolding empty systems. Keep reusable
  production code, reusable assets, episode sources, tooling, and generated output
  distinguishable in the directory structure.
- Keep scripts, shot data, source files, and small review documents under version
  control. Choose Git LFS or external storage deliberately before adding large
  binary source assets; keep reproducible exports and temporary files ignored.
- Record external asset dependencies and reproduction instructions. Do not leave
  an episode dependent on undocumented edits in one local Studio session.
- Keep these instructions current as the actual production pipeline is proven.
  Do not document proposed capabilities as working features.

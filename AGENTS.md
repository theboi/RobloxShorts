# RobloxShorts

Create narrated shorts with real Roblox characters staged in Roblox Studio.
Use repeatable scripts, not gameplay or generated video imitating Roblox.

## Roles and workflow

- Owner: guides writing and visual direction; approves scripts and final cuts.
- Agent: writes, builds models and sets, animates, records, edits, audits, and
  delivers review videos with scripts and concise notes.
- Approve scripts and direction before full production; then work autonomously.
  Ask only for missing authority, credentials, or material scope changes.
- Prove the local pipeline with a short clip first; do not assume tools work.
- Publishing, spending, and substantive changes to approved stories need approval.

## Code and repository

- Work on main and preserve unrelated edits. Pull before work and pushing when
  a remote branch exists; commit verified milestones and push to the configured repo.
- Use focused typed Luau modules (--!strict), clear names, explicit dependencies,
  and editable shot data. Separate reusable systems from episode content.
- Use one timeline clock and repeatable resets; clean up events and temporary state.
- Avoid giant scripts, duplication, hidden globals, and speculative abstractions.
- Verify relevant logic and Studio behavior; document reproducible setup commands.
- Keep secrets, caches, and generated footage out of Git. Choose large-asset storage
  deliberately; retain editable sources and record external dependencies.

## Models, style, and animation

- Preserve the Roblox aesthetic: modular sets, compatible rigs, consistent scale,
  clear silhouettes, named models, and predictable pivots.
- Model for the shot. Keep geometry efficient, scenery anchored, collisions
  deliberate, and reusable master assets intact.
- Record asset sources and usage permissions; inspect third-party model scripts.
- Follow approved visual references; maintain character, prop, and set continuity.
- Compose for 9:16, targeting 1080 x 1920 once capture capability is verified.
  Keep action and captions readable on phones and clear of platform overlays.
- Use purposeful cameras, readable lighting, expressive poses, and motivated motion.
  Check foot sliding, intersections, floating props, and camera clipping.

## Story and delivery quality

- Write original stories with an immediate hook, clear rule, character motivation,
  escalating consequences, and earned payoff. Show consequences through action.
- Time narration and shots; keep scripts, timelines, captions, and edits aligned.
- Capture without editor UI or debug overlays. Check resolution, frame rate, sync,
  speech clarity, caption accuracy, and licensed music/effects.
- Inspect every shot and the complete export, including motion and audio, using
  available tools. Disclose anything unverified; never claim unseen checks passed.
- Fix defects before delivery and version review cuts. Only the owner approves
  finals and authorizes publication.

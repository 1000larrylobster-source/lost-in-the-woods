# ZELDA-LOOK.md — the look-pass plan (deep research, 2026-07-09)

Verified research (24/25 claims survived 3-vote adversarial verification) on making
LITW look as close to Zelda as a single-file no-build Three.js game can get.
North star per DESIGN.md: **"Ocarina of Time — warm painterly forest"**; achievable
browser target = Wind Waker / BotW stylization.

**The headline: the Zelda look is not expensive rendering — it's art direction plus
~5 cheap, proven techniques.** Wind Waker shipped its look on a GameCube with NO
programmable shaders (ramp-LUT shading + tinted grayscale masks). Every ingredient
has a stock or MIT-licensed Three.js implementation. Verified against our actual
bundled THREE r147: `MeshToonMaterial`, `DataTexture`, `RedFormat` all present.

## Current baseline (what the gap is)

Flat-shaded `MeshStandardMaterial` + vertex colors everywhere · ACESFilmic ·
PCFSoft shadows · FogExp2 · custom sky shader · ~1,300 instanced cone pines ·
**bare untextured terrain · no grass · no toon ramp · no outlines · no post.**
Screenshot read: competent low-poly dusk, but terrain reads bare-tan and nothing
reads "cel". The two missing signatures of Zelda are (a) banded lighting with
silhouette outlines and (b) a living grass layer.

## THE RANKED PLAN (visual impact per effort, for this exact game)

### Stage 1 — the cel conversion (hours, transforms every pixel)

1. **Toon ramp everywhere.** Swap `MeshStandardMaterial` → `MeshToonMaterial` with a
   code-generated gradient ramp — no assets:
   ```js
   const ramp = new THREE.DataTexture(new Uint8Array([100, 160, 220, 255]), 4, 1, THREE.RedFormat);
   ramp.needsUpdate = true; // NearestFilter default = hard bands
   new THREE.MeshToonMaterial({ vertexColors: true, gradientMap: ramp });
   ```
   Cel shading = quantizing N·L into bands; this is THE mechanism that makes 3D read
   painterly-flat. Keeps vertexColors + instancing. 3–4 grey steps, tune per material
   family (terrain / pines / props / character). NOTE (refuted claim): BotW is NOT a
   hard two-band shader — it's a soft hybrid. Use a ramp with a soft top step, not
   two harsh bands. flatShading stays — it composes.
2. **Outlines.** Official `OutlineEffect` addon (inverted-hull, NO EffectComposer, no
   post stack): `effect = new OutlineEffect(renderer)`, render via `effect.render()`,
   resize via `effect.setSize()`. Precedent: A Short Hike added soft outlines "so
   low-detail objects stand out"; Sable calls outlines crucial and FADES them with
   distance (do this — `outlineEffect` supports per-material params). TRAP: inverted
   hull has corner-gap artifacts on hard-edged geometry (three.js #19096) — exactly
   our boxes/cones. Plan: outline character + interactables + pines first, judge on
   screenshot, tune `outlineThickness`/alpha per material; selective beats global if
   gaps show.
3. **Fog + palette pass (near-zero code, Sable: "biggest impact overall").** Tune the
   existing FogExp2 color per time-of-day toward warm OoT dusk-gold/forest-green;
   Sable customized fog per biome — we already have per-region palettes, push them
   warmer/more saturated. Second rule from A Short Hike: sample the palette from
   photos of the real target biome (Sierra/Cascade forest), not from imagination.
   KEEP PCFSoft shadows — Sable found flat-shaded worlds lose depth readability
   without real shadows (they even added a shadow-casting moon).
4. **Fresnel rim on the character** (a few lines via onBeforeCompile):
   `rim = 1.0 - saturate(dot(view, normal))`. Reads strongly BECAUSE the toon ramp
   flattens the diffuse first (BotW's exact architecture: flat base, then accents).

### Stage 2 — the living ground (days, biggest "alive world" jump)

5. **Instanced wind-blown grass.** Two MIT references to adapt (inline shaders as JS
   strings — both use build steps we don't):
   - SimonDev **Quick_Grass** (Ghost-of-Tsushima method): InstancedBufferGeometry,
     3,072 blades/patch, LOD 6-segment blades <15 units → 1-segment beyond, hard
     100-unit cull, per-patch AABB culling.
   - James Smyth **three-grass-demo** (BotW method): 5-vertex blades (2 bottom /
     2 mid / 1 tip), bend weight painted in vertex color (base black → tip white).
   - Wind = vertex shader only, zero CPU per blade: noise(worldPos.xz + time) →
     lean angle; add player-push (smoothstep falloff around playerPos uniform).
   - Color blades with the SAME toon ramp + terrain-matched base color so ground
     and grass fuse. Grass casts NO shadows (cost), receives fog.
   - PERF GATE: no published numbers exist for grass + 1,300 pines + PCFSoft in one
     scene. Measure on weakest hardware; density/LOD radius are the dials.

### Stage 3 — accents (scoped, incremental)

6. **Wind Waker grayscale-mask VFX** for water sparkle/fire/haze: tinted black-and-
   white radial masks (we already use radialTex for smoke — same trick, WW palette).
   Nathan Gordon's WW analysis series ships script-tag Three.js CodePens (ocean =
   compound sines, fire, wind lines) — port lightly to r147. Lake foam: cheap
   waterline white band in the shader of shore objects, NOT a depth-buffer pass.
7. **LAST, only if measured budget survives: post stack** via pmndrs `postprocessing`
   (UMD build inlined): ONE merged EffectPass (bloom + LUT grade). Its pass-merging
   avoids chain overhead, but real-world report: UnrealBloomPass full-screen ≈ 20fps
   on Intel-integrated Safari. On weak GPUs bloom is the first thing to cut — the
   game must look right WITHOUT it.

## Meta-rule (A Short Hike)

Pick ONE unifying constraint and derive everything from it. Ours: **"toon ramp +
outline on everything; palette from real forest photos; fog does the mood."**
Every material/color decision after that follows the constraint instead of being
tuned solo.

## Open questions the build must answer by measurement

- Does OutlineEffect look right on our hard-edged primitives (corner gaps)?
  → screenshot A/B, selective outlines as fallback.
- Does the hand-tuned per-region palette survive the ramp swap unchanged, or does
  each region need band re-tuning? (REGIONS table already centralizes this.)
- Grass density that holds 60fps in THIS scene on weak GPU?
- Bloom+LUT frame cost at 1080p on integrated GPU? (Only Stage-3 item at risk.)

## Sources of record (all verified live 2026-07-09)

- three.js official toon example (`webgl_materials_toon`) + OutlineEffect docs
- github.com/simondevyoutube/Quick_Grass (MIT) · smythdesign.com/blog/stylized-grass-webgl
  (+ github.com/James-Smyth/three-grass-demo, MIT)
- Nathan Gordon, "Wind Waker Graphics Analysis" (Medium, 4 parts, live CodePens)
- A Short Hike PS Blog + GDC 2020 postmortem (Adam Robinson-Yu)
- Sable art direction — Game Developer, GDC 2022 (Gregorios Kythreotis)
- guardhei.github.io BotW graphics discoveries (rim/cel architecture; frame captures)
- github.com/pmndrs/postprocessing (v6.39.2) + three.js forum Intel-GPU bloom reports

# devlog 008 — the day the woods got painted

The instruction: *make it look better — get as close to Zelda as you can.*

We didn't guess. A deep-research pass ran first — 106 agents over the Wind Waker
frame-capture analyses, the BotW shader recreations, the A Short Hike and Sable GDC
postmortems, the three.js implementation record — and 24 of its 25 claims survived
adversarial verification. The headline finding: **the Zelda look is not expensive
rendering. It's art direction plus five cheap techniques.** Wind Waker shipped its
whole aesthetic on a GameCube with no programmable shaders. The plan of record is
`design/ZELDA-LOOK.md`; this session shipped its first three stages.

**Stage 1 — the cel conversion.** Every lit material in the world now shades through
a three-band painted ramp (MeshToonMaterial + a 64-texel code-generated DataTexture —
no assets). One trap cost a screenshot round: the toon shader samples at *half-Lambert*
(dotNL × 0.5 + 0.5), so a ramp written against raw N·L puts the whole valley in the
top band and washes it out; both band steps have to sit above t=0.5. Ink outlines come
from the r147 OutlineEffect addon, inlined with three patches — instanceMatrix in the
outline shader (so all 1,272 pines get rims), opt-in-only outlines (the game's additive
glow/smoke/fire discs must never get inked), and Points hidden during the outline pass
(the stars were drawing twice). The character went smooth-shaded with a warm Fresnel
rim — BotW's exact recipe: flatten the diffuse, then let one accent read.

**Stage 2 — the living ground.** Six thousand five-vertex grass blades (the Smyth/BotW
recipe) ride a recycling ring around the player. Wind is pure vertex shader — two sines
against world position, driven by the same living WIND that pushes the fire and the
clouds, so a gust that hurries a burn visibly combs the meadow first. Blades sample the
terrain's own color recipe (grassA/grassB, meadow tint, lush riverbank) so ground and
grass fuse, and the burn record keeps scars bare — the fire eats the grass too.
The perf lesson was measured, not guessed: per-pixel toon lighting on 8,500 double-sided
blades at retina resolution cost **19fps (47→28)**. Grass is now deliberately unlit —
albedo × a day/night mood tint, exactly how BotW's own fields work — and the final
build renders the entire look pass for **~1fps** (46 vs 47 baseline, measured A/B on
extracted builds in the same tab).

**Stage 3 — Player 1 got a body.** Jon's note mid-session: *"he's basically a stick
figure."* He isn't anymore: chibi proportions, capsule limbs that swing from real hip
and shoulder pivots (the walk cycle finally plays a stride instead of spinning boxes),
boots, mittens, jacket shoulders, eyes, a brimmed beanie with a pompom, and a proper
pack with a bedroll and chest straps. Same four rig handles the animator already used —
`legL/legR/armL/armR` — so the walk code didn't change a line.

Suite: **57/57 in real Chrome, three times** (after each stage). The verify loop that
worked: extract script block → `node --check` → serve :8199 → suite via playwright →
read the pixels before believing them.

Still on the board from the plan: Wind Waker's grayscale-mask water sparkle, and bloom
last of all — only if the frame budget survives it on a weak GPU. The research says it
won't. We'll measure.

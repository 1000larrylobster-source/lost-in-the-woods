# HANDOFF — 2026-07-09, end of the marathon session

Read this + the full body of memory `project_lost_in_the_woods` before touching
anything. The design docs of record are `DESIGN.md` (v2 at top = SHIPPED definition)
and `design/` (MAPS/STORY/EASTER-EGGS/SOUND/PAID-QUALITY-BAR). MAPS.md region order
is CANON where specs disagree.

## State: v1.0 COMPLETE — built and done-done, not yet shipped-to-public

- **Repo:** github.com/1000larrylobster-source/lost-in-the-woods · branch `main` ·
  working tree clean · 35 commits · everything pushed (HEAD 8d2a662)
- **The game:** one file, `index.html` (~5,200 lines, 227KB zipped). Suite: **57/57**
  (`?test=1`, ~38s). Verified in Jon's real Chrome via playwright.
- **Artifact:** `dist/lost-in-the-woods-level1.zip` — current with everything.
  (Name says "level1" — cosmetic; rename on upload if desired.)
- **What's in v1.0:** assembly · per-component maintenance · recruits (Dale live) ·
  5 vitals + sleep · 10-region Range (config-driven; relay travel; per-region saves +
  `litw.range.v1` meta) · title screen (AIOS brand) · 20 story cards · full synth
  sound · living wind · NoIR night eyes · elk + downwind hunting · storms/antenna
  damage · snow burial · drought embers · dry lightning · ghost towers + strip verb ·
  Blackpine lake · Crown siege finale · 7 easter eggs · stars/clouds look pass.

## Jon's two signature steps (everything else is done)

1. **itch.io upload** — follow `release/ITCH-PAGE.md` exactly (copy, tags, viewport,
   screenshots list). ~10 min. This flips the whole project from built → shipped.
2. **Price** — $4.00 firm + 20% launch week is the researched recommendation
   (rationale in ITCH-PAGE.md / PAID-QUALITY-BAR.md §14). His call at upload.
   Friday 7/10 12:30pm ledger item (game-2026-07-08-8afb) closes with the upload.

## Machine's next work (BACKLOG.md "v1.0 SHIPPED STATE" section, in priority order)

1. Per-region bespoke terrain layouts (specs in design/MAPS.md — Fork's braided
   creeks, canyon walls, etc.; today regions share Valley bones under configs)
2. Settings panel (volume/sensitivity/reduced-motion) + pause/controls card
3. Remaining 9 easter eggs · in-game map screen · weight inventory · balance pass
4. Trailer = Higgsfield candidate (content lane; real money = Jon's call)

## Traps the next session WILL hit (all cost me a failed run or a bug tonight)

- **Two `<script>` blocks**: block 1 = minified THREE bundle (giant lines — grep with
  `awk 'length($0)<200'` or line filters); block 2 = the game. Syntax-check by
  extracting block 2 → `node --check`.
- **TDZ**: phase-2 consts (`recruits`, `clock`, `fire`, `storm`…) must NOT go in the
  phase-1 `G` literal — add them to the phase-2 `Object.assign(G, …)`.
- **`arc.auto` is false in TEST** — the endless-fire engine (waves, random ignitions)
  won't turn unless a test sets `G.arc.auto = true` and restores it.
- **Fire-test hygiene**: to snuff a test burn set `fire.contained = true` FIRST, then
  `cc.out = cc.t + 0.5` per cell, step ≤900, restore contained=false. Restore station
  `power`/`phase` after any night/storm test or later tests brown out.
- **Verify pattern**: serve `python3 -m http.server 8199` (playwright blocks file://),
  navigate `?test=1`, read the `[LITW TEST] N/N PASS` console line via
  browser_console_messages. Screenshots save into allowed roots — copy out of
  `/Users/larry/AIOS/` root and DELETE the strays.
- **Headless Chrome CLI** captures need `--headless=new --enable-unsafe-swiftshader
  --use-angle=swiftshader`; plain `--disable-gpu` paints blank `#141024`.
- **TEST storage** uses `.test`-suffixed keys (`litw.forest.test`, `litw.region.test`,
  `litw.eggs.test`, `litw.range.v1.test`) — never touches Jon's real saves. His real
  region-1 save lives at legacy key `litw.forest.v1` and must keep working.
- **Rebuild `dist/*.zip` after every increment** — it's the itch artifact; it went
  stale once already.
- **Python bulk-replace** on index.html works well for many small hooks but
  invalidates the Edit tool's file state — Read again before Edit.

## Session rhythm that worked (keep it)

Increment → syntax check → suite in real browser → screenshot read → commit with a
story-quality message → push → BACKLOG/devlog/memory. Jon plays between increments
and steers by playtest notes; his notes outrank the plan. Done-ladder language:
**built** (tests green) → **done-done** (survived Jon's play) → **shipped** (live
URL). Only "shipped" counts in public.

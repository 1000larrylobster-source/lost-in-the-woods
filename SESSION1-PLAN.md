# Session 1 — Godot co-build · Wed 2026-07-08, 7:00–10:00 PM

**Goal by 10pm: the valley feels right.** Terrain + third-person character + camera — walk the
woods at dusk and it feels like the DESIGN.md fantasy. Nothing else tonight.

## How co-building works (the loop)
- The machine pre-wrote everything (project scaffolded, scripts done, scene assembled by 6:30).
- **Jon = eyes + taste.** You run the game, feel it, say what's off. Plain words are enough:
  "turns too slow," "camera too low," "trees too sparse," "ridge should be bigger."
- **Machine = hands.** Larry edits the files live; you press F5 again. Seconds per cycle.
- Point at things by ⌘⇧4 screenshot → paste into the chat, or just describe.
- When something feels RIGHT, say "lock it" — it gets committed as a checkpoint (always one
  small step from a working commit).

## 7:00 — open
1. Open Godot (Applications → Godot) → Import → `/Users/larry/AIOS/lost-in-the-woods/godot/project.godot`
2. Press **F5** (run). You're in the valley.
3. WASD walk, mouse-drag camera. First reaction out loud — that's the session's raw material.

## The checklist (in order, ~45 min each)
1. **Movement feel** — speed, acceleration, turn smoothing, slope handling. Done = walking the
   trail feels deliberate, not floaty.
2. **Camera feel** — follow distance/height, drag sensitivity, collision with trees/terrain.
   Done = you can always read the treeline (the game IS looking at the forest).
3. **The valley reads** — ridge/meadow/treeline/river placement per LEVEL1-SPEC.md; dusk light;
   tree density; where Station Pad 1/2/3 will go (drop placeholder markers). Done = you can
   stand at each future pad and SEE why it's a tradeoff.

## 10:00 — close (hard stop, J19)
- Commit the locked state; machine writes `devlog/session-log.md` entry: "session 1 done" + what
  locked + what's queued for Session 2 (ledger proof keys on this).
- Confirm Session 2 scope: salvage + station build + siting meters + first drone patrol —
  **tomorrow (Thu 7/9) 3:00 PM.**
- The machine keeps working overnight: ports Session-1 tuning values back into the Three.js
  Friday build so both trains carry tonight's taste.

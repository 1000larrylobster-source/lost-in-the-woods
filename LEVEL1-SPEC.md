# Level 1 — "First Watch" (ship by Friday 2026-07-10, 2:00 PM — clock started 07-08 12:30)

Builds DESIGN.md v1 EXACTLY: you are a character IN the woods (third-person), building the
forest's eyes. Not a lookout in a tower, not an operator over a map. The tower prototype built
07-08 is superseded (kept in the private repo as a devlog artifact about missing the center).

## The 48-hour engine call
**Level 1 ships as browser 3D — Three.js, one self-contained HTML page** (itch.io HTML5, no
install — the exact delivery DESIGN.md wants). Reason: the machine can build/playtest/verify
this pipeline end-to-end in 48h (proven loop: headless screenshots + on-canvas test suite).
**Godot 4 remains the full-game candidate** — Jon still owns that call (DESIGN.md open q5);
everything durable here (level design, mechanics, tuning, arc) transfers. Low-poly readable
stylized 3D chasing the OoT *feel*, exactly as DESIGN.md scopes early builds: "far rougher,
chase the feel."

## DESIGN.md open questions — answered for L1 (Jon can veto any by text)
1. **Survival vs build-watch:** survival-LITE. ~3-minute lost-at-dusk opening teaches movement;
   no hunger/health meters. The game is build-and-watch.
2. **Clock:** real-time compressed day (~7 min day + short night). Patrols continuous; at night
   drones are camera-blind (thermal comes later in the tech tree) — first hiker beat lands here.
3. **Response manuality:** drones DETECT and CONFIRM; fires always need the player to act —
   hike in and cut the firebreak while it's one tree. Hiker finds are auto-marked; the player
   walks to them for the rescue (the soft reward). No auto-resolving fires in L1.
4. **Fire spread:** readable cellular spread over dry fuel with a visible wind arrow; L1 is
   generous (minutes of grace). Burned cells SCAR and persist — the forest is the save file
   (localStorage: terrain scars, stations, best coverage survive reloads).

## Level arc (one valley, ~12–15 min first run, then endless watch)
1. **WAKE** — dusk, no HUD, lost. Follow light/trail → the old ranger cache. (Teaches move+camera.)
2. **SALVAGE** — cache: 1 solar panel, 1 drone kit, map fragment (reveals the valley), radio is
   MISSING PARTS (hook). HUD fades in. (Teaches interact/inventory-lite.)
3. **SITE & BUILD** — 3 marked candidate pads: ridge (great sightlines, long hike), meadow
   (great sun, half-blind), treeline (fast, poor LoS). Placement UI shows the three real reads —
   ELEVATION / SUN / LINE-OF-SIGHT — as honest meters; coverage cone previews live. (The core
   decision of the whole game, taught by feeling the tradeoff.)
4. **FIRST WATCH** — station boots, drone launches, patrol sweeps its sector; coverage vs
   blind-spots rendered on the world (not a minimap overlay — fog in the world). 
5. **FIRST SMOKE** — scripted ignition ~60s into watch: inside coverage if the site was good
   (drone pings, camera cut to the plume), in a blind spot if not (you spot it by eye — lesson
   lands either way). Player hikes in, holds to cut the firebreak while it's one tree.
6. **SAVED or SCARRED** — too slow → wind-driven spread, scorched patch persists forever.
   Either way the card: "The forest remembers." Then endless watch unlocks: random ignitions,
   salvage for station 2 + radio parts, night hiker signal event (rescue = the emotional close
   DESIGN.md names).

## Mechanics checklist (all must exist Friday)
- Third-person character controller: WASD/arrows + orbit-follow cam; mobile = virtual joystick
  + drag camera (responsive-everywhere rule; desktop-first polish acceptable).
- Heightmapped low-poly valley (~600x600m feel), pines, trail, river, ridge; dusk palette.
- Interact/salvage (walk up + press E / tap).
- Station build: pad selection, the 3-meter siting read, build animation, power state.
- Drone patrol: autonomous sector sweep, detect smoke/heat/humans in LoS cone, ping + marker.
- Fire: ignition → single-tree flame → cellular spread w/ wind; firebreak minigame (hold);
  scorch decals persist (save file).
- Coverage/blind-spot rendering in-world; coverage % on HUD.
- HUD: forest health %, coverage %, day clock, inventory chips, objective line. Minimal.
- WebAudio ambience (wind/birds/night insects/fire crackle) — generated, no assets.
- On-canvas deterministic test mode (?test=1) covering every mechanic above; window.onerror
  drawn on-canvas so screenshots can't hide crashes.

## Definition of done (the proof, not the claim)
- ?test=1 all-green on desktop + narrow viewport; zero console errors.
- A human-shaped playthrough (scripted input driver) completes the full arc: wake → cache →
  build ridge station → catch first smoke → level card. Screenshot every beat.
- dist/lost-in-the-woods-level1.zip (index.html at root) ready for the itch upload.
- Devlog entry 002 drafted: "v0 was a tower. v1 is the woods." — the correction in public.

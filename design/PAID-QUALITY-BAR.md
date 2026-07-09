I have everything I need — docs, all six devlogs, and a code-level inventory of what the current build actually contains (single `SAVE_KEY` save, internal master gain with no UI, no title/pause/settings/map screens, pixel ratio capped at 2, 32-test on-canvas harness). Here is the spec.

---

# Paid-Release Quality Bar — v1.0 on itch.io

**Scope note:** this spec covers the *wrapper* — everything around the mechanics. It assumes DESIGN.md v2 mechanics exist. Priorities: **MUST** = don't charge money without it. **SHOULD** = the difference between "fine" and "worth it." **NICE** = post-1.0 patch fodder.

## The bar, in one paragraph

A free demo is forgiven everything; a paid game is forgiven nothing it makes you *repeat*. Nobody refunds over missing bloom. They refund when the tab closed and the forest was gone, when the music couldn't be turned down at midnight, when they alt-tabbed and came back to a valley that burned without them. For a single-file browser survival game, the paid bar is exactly this: **the player's time, save, and senses are never taken from them by accident.** Everything else is generosity on top.

## Gap list — current build vs. paid bar

What the build already has going for it: namespaced save key (`litw.`), pixel ratio capped at 2, 32 on-canvas tests, working touch stick + jump + interact buttons, save migration proven across three increments, 57–60fps verified. That's a stronger foundation than most itch HTML games ship with.

What's missing (verified by code inspection, not assumption):

| Gap | Today | Priority |
|---|---|---|
| Title screen / any menu at all | Cold-opens into the game | MUST |
| Pause (sim + audio) | No pause menu; fire and hunger never stop | MUST |
| Settings UI | Master gain exists in code, no slider, nothing else | MUST |
| Continue / New Game flow | One save, silently loaded, no way to start over | MUST |
| Tab-blur protection | Hidden tab can advance the sim on return (dt clamp unverified) | MUST |
| In-game map screen | Map fragment is an item; no readable map view | SHOULD |
| Controls card in-game | Controls live in README only | MUST |
| Accessibility options (colorblind, reduced motion, invert, sensitivity) | None | mixed, below |
| Save export / slot management | localStorage only — fragile on itch | SHOULD |
| Death/fail presentation | Blackout fades and wakes; no cause, no card | SHOULD |

---

## 1. Title screen & menus

- **MUST — Tap/keypress-to-begin screen.** Not optional even artistically: browsers refuse to start an AudioContext without a user gesture. The gate that unlocks the wind *is* the title screen. Title, one input prompt, version number in a corner.
- **MUST — First run vs. return run.** First boot: title fades directly into the no-HUD wake (protect the cold open — it's the best 30 seconds of the game). Return boot: **CONTINUE** (default, shows day / coverage % / forest %) and **NEW WATCH**.
- **MUST — New-game confirmation.** "The forest remembers. Starting over forgets." One destructive action, one honest confirm.
- **SHOULD — Title tableau.** The valley at dusk behind the menu, camera drifting, wind audible after first gesture. It's free — the world is already built.
- **NICE — Credits/about line** linking devlog + the real-hardware story. It's the game's best marketing and it's true.

## 2. Save management

- **MUST — Fail-soft saves.** Wrap every `localStorage.setItem` in try/catch (Safari private mode throws; quota can be full). On failure: keep playing, show a quiet "the forest can't remember right now" warning — never crash, never silently lie.
- **MUST — Keep the `litw.` namespace and keep saves small.** itch.io serves many HTML games from shared storage contexts; a fat save is a save that gets evicted.
- **SHOULD — Save export/import as text.** Serialize to a compact string, copy-to-clipboard / paste-to-restore, reachable from settings. This is the single cheapest insurance against the #1 browser-game refund cause (cleared storage) and it enables cross-device play for free.
- **SHOULD — Three slots, framed as three valleys, not "Slot 1/2/3."** One forest per family member is a real use case for a cozy paid game.
- **NICE — Autosave indicator** (a brief leaf/ember glyph when the forest writes itself down).

## 3. Settings (one panel, reachable from title and pause)

- **MUST — Master volume slider** (the gain node already exists — expose it). Persist it.
- **MUST — Camera sensitivity slider** (0.5×–2×) and **invert Y toggle**.
- **MUST — Colorblind-safe cues, by redundancy not palettes.** Fire and coverage must never be color-only: fire already has a smoke column, flicker, and crackle — keep those load-bearing; give coverage mist a *density/hatching* difference, not just tint, and give detection pings a shape + sound. Then add one toggle, "High-contrast markers," that swaps coverage tint toward blue and adds icon markers on pings. Test with a deuteranopia filter screenshot in the QA pass.
- **MUST — Reduced motion toggle:** kills screen shake, camera sway, and hit-stop; damps fire flicker amplitude. One flag checked at the three places juice is applied.
- **SHOULD — Ambience / effects split volume** (two gain buses; all audio is generated so this is routing, not remixing).
- **SHOULD — Quality toggle (Auto / Crisp / Smooth):** Auto drops pixel ratio to 1 and thins far trees when frame time runs >20ms for 3 seconds. Mid hardware is the promise; this is how the promise is kept.
- **NICE — Invert X, UI text size step, left-handed touch layout.**

## 4. Pause

- **MUST — Esc / pause button pauses THE SIM:** fire spread, needs drain, drone patrol, day clock — all of it. `audioContext.suspend()` on pause, resume on resume. A survival game that keeps starving you in a menu is charging money for anxiety.
- **MUST — Auto-pause on `visibilitychange` / window blur,** and clamp dt (≤100ms) on every frame regardless. Nobody's valley burns because their kid needed something.
- **MUST — Pause contents:** Resume · Map · Controls · Settings · Quit to Title (with save). Five items, no submenu maze.
- **SHOULD — Vitals + objective line visible on the pause screen** — "what was I doing?" answered before unpausing.

## 5. In-game map screen

- **SHOULD (MUST by map 2) — M key / map button opens the map fragment as a real screen:** code-drawn canvas in a hand-inked style — terrain contours, river, trail, caches (found ones marked), station pads, built towers with per-component status ticks (BASE/SCAFFOLD/ANTENNA/PANEL), known component locations once spotted, coverage cells, scars, player arrow. In one valley you can navigate by eye; at Range scale (10 maps, hauling components to pads) the game is unplayable without this. Build it now while it's small.
- **SHOULD — Pauses the sim while open** (it's paper; reading a map is rest).
- **NICE — Pins.** Tap the map to drop one marker that shows as a distant beacon in-world.

## 6. Controls: card, not remapping

- **MUST — Controls card** in pause + title, auto-showing the layout for the current input (keyboard vs. touch). One screen, drawn in code.
- **NICE — Remapping.** Real remapping UI in a single file is a week of edge cases; WASD+arrows alternates already exist. Cut it from v1.0 without guilt; revisit if a player with a non-QWERTY layout or motor-access need asks — then it becomes SHOULD.

## 7. Touch ergonomics

- **MUST — Lock the page:** `touch-action: none` on the canvas, `user-scalable=no`, suppress context menu and double-tap zoom, `overscroll-behavior: none` (no pull-to-refresh killing a run).
- **MUST — Safe-area insets** (`env(safe-area-inset-*)`) so the stick and buttons clear iPhone home bars and notches.
- **MUST — Hit targets ≥ 48px**, interact prompt within thumb reach, stick dead zone ~15%.
- **SHOULD — Landscape nudge:** portrait gets a gentle rotate prompt (playable, but nudged).
- **SHOULD — Hold-to-interact affordances sized for thumbs** — the firebreak hold is the tensest moment in the game; on touch it must never slip because a finger drifted 10px.
- **NICE — `navigator.vibrate` pulses** on ping / component mount / fire damage (Android only; free where supported).

## 8. Performance budget checks

- **MUST — The budget:** 60fps at DPR 2 on mid desktop, 30fps floor on a 3-year-old phone, frame time asserted in `?test=1` (extend the harness: fail if median frame >20ms during a scripted fire + patrol + sprint scene — the worst-case frame, not the idle one).
- **MUST — dt clamp everywhere** (also listed under pause; it's a correctness issue, not just feel).
- **MUST — Pooled particles and pinned draw calls.** No per-frame allocation in the fire loop; GC hitches read as "cheap" faster than low poly counts ever will.
- **SHOULD — Auto-quality scaler** (see Settings) + a QA pass at 4× CPU throttle in DevTools.
- **SHOULD — WebGL context-loss handler:** on `webglcontextlost`, save immediately and show "the forest blinked — tap to return." Real on mobile Safari; a black canvas with no words is a refund.

## 9. First-5-minutes onboarding polish

The cold open is already right — protect it, then remove the three places a new player stalls:

- **MUST — The objective line always answers "where do I go?"** and is recoverable from pause. Lost-with-no-goal is the fantasy for 90 seconds; after that it's churn.
- **MUST — First fire never ignites while the player is still pre-station.** (L1 scripts this — keep the guarantee as maps multiply.)
- **MUST — Interact prompts legible on a phone in sunlight** — bigger, higher contrast than desktop.
- **SHOULD — The siting meters whisper once.** First time each meter is seen, one line: "Higher ground sees farther." / "Panels want open sky." / "Trees block the drone's eye." Teach by naming, not by tutorial.
- **SHOULD — A soft breadcrumb in minute one:** the trail plus one distant light. If the player walks the wrong way for 60 seconds, a wind gust and a camera nudge toward the cache. Invisible help is the polish.
- **NICE — Skippable wake** for returning players ("you know these woods" — hold to skip).

## 10. Death / fail feel

- **MUST — Blackout tells you why.** Fade card names the cause in the game's voice: *"Dehydration. The creek was 200m west."* / *"The fall. The ridge takes its toll."* Then what happened while you were down: cells burned, day advanced. Fail must teach or it's just loss.
- **SHOULD — The last second slows.** 300ms of time dilation + heartbeat thump (two low sine hits, generated) before the fade. Costs ~20 lines, changes how death lands.
- **SHOULD — Waking is gentle but honest:** dawn light at the cache, vitals part-restored, the objective line already pointing you back. The forest kept the score; the game doesn't pile on.
- **NICE — A scar memorial:** the map screen marks where you went down. The forest remembers you, too.

## 11. Juice budget (small, spent precisely)

Rules: shake ≤0.5% of view height, ≤0.3s, never stacks; hit-stop ≤90ms; everything behind the reduced-motion flag; particles pooled.

- **SHOULD — Component mount:** 70ms hit-stop + dust puff + generated metal *thunk*. Assembly is the v2 core loop; every mount should feel like torque.
- **SHOULD — Tower boot:** light sweep up the mast, coverage mist burning off (exists) + a rising three-note power-on chord. The payoff moment of the whole game.
- **SHOULD — Firebreak completion:** 90ms hit-stop, ember burst that dies to black, crackle cutting to wind. Relief as audio.
- **SHOULD — Fall damage / fire damage:** one shake pulse + vignette flash (the body registering, not the camera panicking).
- **NICE — Rescue:** the hiker's headlamp swings to face you; fireflies rise. No shake — warmth, not impact.
- **NICE — Berry pick leaf-flutter; drone launch rotor-pitch doppler.**

## 12. Accessibility quick wins

- **MUST — Caption line for critical audio:** the detection ping ("· ping — smoke, north ·") and the night hiker's voice must have a text echo — they're gameplay, and some players are deaf, muted, or on a bus.
- **MUST — No flashing above 3Hz** — audit the fire flicker and blackout fade once, note the measured rate in QA.
- **MUST — Colorblind + reduced motion** (specced in Settings).
- **SHOULD — Hold-alternatives toggle:** firebreak and other holds become press-to-start/press-to-stop.
- **SHOULD — UI text ≥14px at 1080p and readable at arm's length on a phone;** meters labeled with words, not color alone.
- **NICE — Text size step; full pause-anywhere is already covered above.**

## 13. itch.io page copy structure

**Tagline (pick one, keep under 12 words):**
> You wake up lost. You end up being what finds people.

alt: *Build the forest's eyes. Catch the fire while it's one tree.*

**Three bullets:**
- **Read real terrain, build real hardware.** Site solar-powered watchtowers by elevation, sun, and line-of-sight — every part in the game is a thing you could actually build (the devlog builds it).
- **The forest is the save file.** Fires you miss scar the world forever. Fires you catch stay green. Come back tomorrow to the valley you earned.
- **Survive so the watch survives.** Hunger, thirst, cold nights, long hauls — and a network of drones that hunts smoke, spots your dinner, and finds the people still lost out there.

**What you get:**
- Plays instantly in your browser — one file, no install, no launcher, desktop and touch
- A full valley now (~15 min first run + endless watch), new regions of the Range as they ship — buy once, every update included
- All art and sound generated in code; the whole game is one honest HTML file
- The open devlog: this game is a real Raspberry Pi wildfire-detection network, designed in public

**Also on the page:** 3–5 screenshots (dusk siting screen, coverage mist burning off, a fire caught at one tree, the night rescue, the map), one 15-second GIF of the firebreak hold, a "known limits" honesty section (browsers supported, save-export advice), and a support contact.

## 14. Pricing

**$4.00, with a 20% launch-week discount ($3.20).**

Rationale: under $5 is the itch impulse line where the buy decision is "do I like this person's thing," not a value calculation. $2 reads as an asset-flip price and undercuts the real-hardware story; $6+ demands content volume (10 maps) the v1.0 doesn't have yet. $4 says "small, cared-for, real." Buy-once-updates-included is itch-native and matches the build-in-public arc — and it quietly justifies raising the price to $6 around map 5, which rewards early believers and makes a second news beat. No pay-what-you-want above minimum — a firm price is part of the quality claim. Keep the browser build behind the purchase (itch supports paid HTML play); the *demo* is the devlog and the GIFs, not a free tier that cannibalizes a $4 ask.

## 15. Release QA checklist (run per release, in order)

1. `?test=1` all green, **including the new frame-time assertion**, desktop + narrow viewport; zero console errors.
2. Scripted full-arc playthrough (wake → build → first smoke → firebreak → night rescue → endless watch), every beat screenshotted **and read** — the rule that caught the invisible smoke column stays law.
3. **Save matrix:** fresh boot / continue / new-game-confirm / v0.1-format save migrates clean / storage-throws (Safari private) fails soft / export → wipe → import restores.
4. **Pause matrix:** Esc pauses fire spread + needs + audio; blur auto-pauses; return from a 5-minute hidden tab advances nothing.
5. **Browsers:** Chrome, Firefox, Safari desktop; iOS Safari and Android Chrome on real hardware — audio unlocks on first gesture in every one.
6. **Touch pass on a real phone:** no scroll/zoom/pull-to-refresh escape, safe-area respected, firebreak hold survives a sweaty thumb, orientation change doesn't break layout.
7. **Performance:** 60fps desktop DPR 2; 4× CPU throttle stays ≥30fps with auto-quality; no GC saw-teeth in the fire scene profile.
8. **Context loss:** kill the WebGL context in DevTools — save fires, recovery message shows, tap restores.
9. **Accessibility:** deuteranopia-filter screenshots of coverage + active fire still read; reduced-motion honored at all three juice sites; captions fire on ping and hiker voice.
10. **itch embed:** upload zip (index.html at root), "played in browser" checked, fullscreen + mobile-friendly on, correct viewport; then play the *purchased, embedded* build start to finish on desktop and phone — the iframe is a different world than `file://`.
11. Page assets live: cover 630×500, screenshots, GIF, copy from §13, price set, version number on the title screen matches the zip.
12. Devlog entry drafted — the release ships with its own story, same as every build so far.

---

**Suggested build order for the wrapper work:** (1) tap-to-begin + audio unlock + dt clamp + auto-pause — one session, kills the three worst refund causes; (2) pause menu + settings panel + controls card — one session, they share UI; (3) save flow (continue/new/export) — one session; (4) map screen; (5) death cards + juice pass; (6) QA matrix + itch page. Roughly six sessions of wrapper between "great prototype" and "happily paid for."
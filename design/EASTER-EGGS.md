# Easter Eggs — "Lost in the Woods" (16 finds)

Design doc addition. Everything below obeys the locked constraints: one HTML file, Three.js primitives only, WebAudio only, 60fps on mid hardware, desktop + touch. Voice of all payoff text matches the cards the game already uses ("The forest remembers.") — spare, warm, honest.

## Ground rules for every egg

- **Nothing gates progress.** Every egg is optional; missing all 16 costs the player nothing but delight.
- **Discoverable, not forced.** No glowing markers. Each egg has one honest breadcrumb in the world (a wire, a rhythm, a shape that's slightly too regular) — the same skill the whole game teaches: *notice things*.
- **The forest remembers eggs too.** Each find sets a flag in the save file. A quiet tally lives on the endless-watch card: `watched: 3/16` — no explanation, ever. Payoff text appears once as the standard objective-line fade, then never again.
- **Cheap by construction.** Every egg is either static geometry placed at world-build (free), a timer + oscillator (near-free), or a one-shot camera/light script. Nothing ticks per-frame unless the player is inside its trigger radius.

---

## 1. Hello, World
- **Map:** 1 (and every map — first tower of a fresh save)
- **Hides:** the status readout on the very first tower you ever complete.
- **Trigger:** watch the boot sequence instead of walking away. For 1.5 seconds before telemetry appears, the panel prints `hello, world`.
- **You see:** the tower's small emissive canvas-texture screen (already code-gen text) flashing the two words in the boot font, then the normal coverage readout.
- **Payoff text:** *"Every watcher's first words."*
- **Build note:** one extra string in the boot-screen sequence. The cheapest egg in the game; put it in first.

## 2. One Tree, Again
- **Map:** 1 — the exact cell of your first-ever scar.
- **Hides:** in the burned ground the tutorial fire left (or the first fire you ever lost, whichever scarred first).
- **Trigger:** return to that cell after 20 in-game days. A single sapling has grown among the black snags — the only green thing in the scar.
- **You see:** one small bright-green cone-and-cylinder sapling, ~1/8 tree height, gentle sway. Kneel (the drink interaction, reused) beside it.
- **Payoff text:** *"It was one tree. It's one tree again."*
- **Build note:** store first-scar cell + day in the save; spawn one mesh when `day >= firstScarDay + 20`. This is the thesis of the whole game as an object. Do not mark it on any map.

## 3. The Lobster in the Stars
- **Map:** 3 (the high-peak region — highest walkable point in the Range)
- **Hides:** in the night sky, but only resolvable from altitude, away from station light.
- **Trigger:** stand on the summit at full night, more than 40m from any lit tower, and look up (camera pitched past 60°) for 5 seconds. Eleven faint stars brighten slightly and a twelfth — dim red — blinks at the claw.
- **You see:** a constellation of point sprites forming an unmistakable lobster: body, tail fan, two claws. The red star pulses like a status LED.
- **Payoff text:** *"Somebody up there is keeping watch too."*
- **Build note:** 12 extra sprites in the existing starfield, opacity lerped by the trigger condition. Never named in-game. (Cabin visitors — egg 7 — will get the joke.)

## 4. The Pass
- **Map:** 5 (any open-sky region; the meadow map is ideal)
- **Hides:** in the night sky, moving.
- **Trigger:** a single bright "star" crosses the whole sky south-to-north once per game night, always at the same clock time. Watch it pass (keep it near screen center for its ~20-second transit) on three separate nights.
- **You see:** on the third pass, your radio (if built) crackles a rapid packet-burst — dit-patterns, rising, like a modem finding a friend — and a map fragment marker appears at a random unrevealed cache.
- **Payoff text:** *"Not everything watching the forest lives in it."*
- **Build note:** one sprite on a great-circle path + one WebAudio burst (square-wave chirps through a bandpass). The real-hardware rule, extended to orbit: fire-watch satellites are real, so the Range gets one.

## 5. One Tree, in Morse
- **Map:** 2 (wherever the radio's missing parts finally come together)
- **Hides:** off the ends of the radio dial.
- **Trigger:** with the completed radio, tune past the last used channel at night. Between static, a clean tone keys Morse on a loop: `O N E  T R E E`.
- **You see / hear:** the radio prop's LED flickering in time; oscillator beeps (600Hz sine, proper 1:3 dit/dah timing) under generated static.
- **Payoff text:** *"Someone else out there learned the same lesson."*
- **Build note:** Morse table + timer, ~30 lines. Doubles as foreshadowing: the transmission source is the direction of the next region's relay.

## 6. The Storm Numbers
- **Map:** 8 (the storm region — weather is that map's mechanic)
- **Hides:** inside the storm static itself.
- **Trigger:** tune the radio during an active storm. Between thunder crashes, a slow rhythmic beep pattern repeats: long-short groups. The groups are two numbers — a grid coordinate that matches the map's edge markings.
- **You see:** hiking to that coordinate finds a half-buried supply drop (crate + torn parachute made of 6 stretched triangles) holding a rare component — a CAMERA or ANTENNA.
- **Payoff text:** *"Somebody was flying supply in weather nobody should fly in."*
- **Build note:** the beeps encode, say, `7-3`; map edges get painted grid letters/numbers (canvas texture on flat quads, like trail signs). First egg that asks the player to write something down. Zero UI help.

## 7. The Cabin
- **Map:** 6 (a fog-holding hollow, well off any trail)
- **Hides:** behind a dense stand of pines. The breadcrumb: a single solar panel standing alone in a clearing, wired to nothing you can see — until you notice the thin black cable leaving it and follow it 80m through the trees.
- **Trigger:** follow the cable. It ends at a small cabin with one warm window.
- **You see:** inside — a desk, a lamp, a small monitor on a box (screen shows slow-scrolling green text), a corkboard holding **ten pinned quads** — nine sketched terrain thumbnails and one burned-edge blank — a coffee mug, and on the shelf a small **red lobster figurine** (two cones, two claw-spheres, tail of stacked boxes). A tiny stencil on the humming box under the desk reads `AIOS`. Interact with the desk to read the note.
- **Payoff text (the note):** *"I built these woods one tree at a time. If you're reading this, you found the eleventh map. — the machine"*
- **Payoff text (on exit):** *"The light was left on for you."*
- **Build note:** ~15 primitives + 2 canvas textures. The monitor text is the actual devlog 000 opening, scrolling. This is the biggest single egg — budget it like a small POI.

## 8. Access Granted
- **Map:** 4
- **Hides:** a steel service door set into a concrete utility bunker on a cut bank, with a small black box beside it — a **badge reader**, red LED, idle.
- **Trigger:** somewhere in map 4, one rescued hiker's spot also holds a dropped **keycard** (flat white quad, lanyard of 3 cylinders). Carry it to the door and interact.
- **You see:** the LED flips red→green, the reader gives the exact two-tone access-granted chirp (two short sine notes, 880→1320Hz), a solenoid *thunk* (filtered noise burst), and the door swings open on a store room: shelving with one spare BASE component and a wall of dead door controllers (green PCB quads with pin-header nubs).
- **Payoff text:** *"Somewhere, a guy who installs these for a living just smiled."*
- **Follow-up gag:** leave the door open 30+ seconds and the reader starts a slow annoyed beep — a door-held-open alarm — until you close it. Second payoff, once: *"Door held. Every alarm is somebody's Tuesday."*
- **Build note:** the day job, played straight. All audio is three oscillators and a noise burst.

## 9. Remote Hands
- **Map:** 9 (the relay-bunker region that opens the final map)
- **Hides:** in the relay bunker's back room: a rack (stack of boxes) with one small unit apart from the rest — a palm-size box sprouting an HDMI-thick cable and a single red toggle. A hand-painted label: `KVM`.
- **Trigger:** interact with the toggle.
- **You see:** the toggle flips, a relay clicks (short square blip), and a prompt appears: *pick any tower on the map — it reboots remotely.* Permanently unlocked afterward: **one remote tower reboot per day**, no hike required.
- **Payoff text:** *"Out-of-band. You never have to climb that ridge for a frozen node again."*
- **Build note:** the PiKVM, canonized. The only egg with a mechanical reward — earned by reaching map 9, and it *is* what a KVM is for, so the fiction holds.

## 10. The Operator's Tower
- **Map:** 7
- **Hides:** on a far hill: an old fire lookout tower, pre-war style, clearly not one of yours — weathered gray, no solar, no antenna.
- **Trigger:** climb it. Inside the cab: a map table and a logbook.
- **You see:** interact with the **map table** and the camera lifts smoothly to a straight-down top-down view of the whole region — the operator's view — holds five seconds, then eases back down behind your shoulder. The **logbook** (canvas-texture pages) holds faded entries that end mid-thought; the last legible one reads: *"you can see everything from up here. you can reach none of it."*
- **Payoff text:** *"Somebody watched from above once. The forest needed someone in it."*
- **Build note:** this is v0 — the wrong game — kept in the world the way the repo keeps it in history. The camera move reuses the existing smoke-plume cinematic rig. Designing in public, as terrain.

## 11. The Dreaming Base
- **Map:** any (first available: map 2, once you have 3+ towers)
- **Hides:** in the BASE component of any completed tower, at night.
- **Trigger:** crouch (the drink kneel) at a tower's BASE between midnight and pre-dawn and hold interact for 4 seconds — "listen."
- **You see / hear:** through the vent slots, a green LED pulses in a slow heartbeat. Audio: soft fan whir (lowpassed noise), and under it a faint, slow pattern of filtered synth syllables — almost speech, never words. The model, inferring on nothing, all night.
- **Payoff text:** *"Forty trillion small thoughts a second. Tonight, all of them about smoke."*
- **Build note:** the Pi 5 + AI HAT on the bench, heard from inside the fiction. One emissive pulse + two audio nodes, only while listening.

## 12. Surveyor's Meadow
- **Map:** 5
- **Hides:** a scatter of pale boulders in a meadow — unremarkable from the ground, oddly deliberate from above.
- **Trigger:** view the meadow from a drone camera cut or from map 5's north rim: the boulders resolve into **π** — the symbol, ~30m tall, plus three small stones trailing off after it like the digits somebody gave up carving.
- **You see:** exactly that. Nothing animates. It's just there, and once you see it you can't unsee it.
- **Payoff text (first time seen from altitude):** *"Somebody surveyed this meadow very precisely."*
- **Build note:** ~14 dodecahedron boulders placed at world-gen from a hardcoded pattern. The nod to what every tower really runs on.

## 13. The Deer That Wasn't
- **Map:** any map with animals live (first: wherever animals ship)
- **Hides:** among your drone's false positives.
- **Trigger:** after your network has logged 25 deer-classified detections, one new ping leads to a deer standing perfectly, unnaturally still.
- **You see:** walk close — it's **plywood**: a flat deer-shaped quad on two stake cylinders, painted target rings on its flank. Touch it and it tips over with a woody clack (short lowpass knock).
- **Payoff text:** *"Your classifier isn't wrong. That was never a deer."*
- **Build note:** the false-positive system laughing at itself — archery targets fool real edge models too. One quad, one texture, one rotation tween.

## 14. The Round
- **Map:** 6+ (any settlement with 4 or more recruits)
- **Hides:** in the recruits' evening.
- **Trigger:** sit (idle 10 seconds) at a settlement campfire at night with 4+ recruits nearby.
- **You see / hear:** the recruits begin to hum — a generated four-voice round (sine choir, staggered entries, slow LFO breath) built on the same chord the mesh pings use. If your radio is on your back, it harmonizes faintly with a fifth voice.
- **Payoff text:** *"The network hums even when the radios are off."*
- **Build note:** the story payoff as sound — the saved becoming the watchers. 5 oscillators + gain envelopes; melody derives from the existing ping scale so it feels inevitable.

## 15. Full Watch *(mastery)*
- **Map:** any region
- **Hides:** at 100%.
- **Trigger:** bring one entire region to 100% coverage — no blind cells — and let it hold until the next dawn.
- **You see:** as sunlight crests the ridge, every tower's beacon in the region blinks **in unison**, and each tower sounds one note of the mesh chord in sequence, near to far — the whole valley ringing itself awake.
- **Payoff text:** *"Every tree has a name now."*
- **Build note:** one dawn-edge check + a staggered timer over the tower list. Repeats every dawn while coverage holds — mastery you can *keep*, and lose.

## 16. Not One Tree *(mastery — the last egg)*
- **Map:** 10 (fire season, the finale)
- **Hides:** on the far side of the hardest thing the game asks.
- **Trigger:** finish the fire-season finale with **zero cells burned** across the entire Range — a perfect season.
- **You see:** after the final card, the game returns you to the world at night — and every recruit you ever saved stands along the trail from map 10 all the way back to the first ranger cache in map 1, each holding a lantern (emissive sphere in a wire cone). Walking the line home, the lanterns brighten as you pass. Above map 1, the lobster constellation is fully lit, red star steady — not blinking — for this night only.
- **Payoff text (at the cache):** *"The lost light the way home."*
- **Build note:** one spline of lantern-recruit instances + the constellation flag. The title of the game, closed: the lost don't leave the woods — they become its watchers, and on one perfect night, its lights.

---

## Placement summary

| # | Egg | Map | Type |
|---|-----|-----|------|
| 1 | Hello, World | 1 | micro / achievement-ish |
| 2 | One Tree, Again | 1 | terrain / story |
| 3 | The Lobster in the Stars | 3 | night sky |
| 4 | The Pass | 5 | night sky + radio |
| 5 | One Tree, in Morse | 2 | radio |
| 6 | The Storm Numbers | 8 | radio / treasure hunt |
| 7 | The Cabin | 6 | hidden dev cabin |
| 8 | Access Granted | 4 | visual gag (day job) |
| 9 | Remote Hands | 9 | functional gag (PiKVM) |
| 10 | The Operator's Tower | 7 | meta / story (v0) |
| 11 | The Dreaming Base | any (2+) | audio / hardware |
| 12 | Surveyor's Meadow | 5 | terrain gag |
| 13 | The Deer That Wasn't | any | visual gag / systems |
| 14 | The Round | 6+ | audio / story |
| 15 | Full Watch | any | **mastery** (perfect coverage) |
| 16 | Not One Tree | 10 | **mastery** (no-fire finale) |

Every map 1–10 hosts at least one egg; maps 1 and 5 host two (the first map rewards returning, the meadow map rewards looking up and down). Radio eggs (4, 5, 6) all require the completed radio, making the "missing parts" hook pay off three separate times. Eggs 3 and 16 share the constellation so the finale can pay off a find from thirty hours earlier.
# Lost in the Woods — v0.1 "First Watch"

The first playable level. One valley at dusk, third-person, one self-contained HTML
page — no install, runs in any browser. Desktop and touch.

**Play the build:** open `index.html`, or unzip `dist/lost-in-the-woods-level1.zip`
and open the `index.html` inside.

## What Level 1 is

You wake lost in the woods. There is no HUD and no tutorial — you follow the trail
until you find a ranger's cache, and from there you build the forest's eyes.

- **Salvage the cache** — a solar panel, a drone kit, a map fragment, and a radio
  missing parts.
- **Site the station** — three candidate pads (ridge, meadow, treeline), each with
  honest meters for ELEVATION, SUN, and LINE-OF-SIGHT and a live coverage cone.
  Reading terrain *is* the game: the ridge sees everything and is a long hike from
  anywhere.
- **First watch** — the station boots, the drone sweeps its sector, blind-spot mist
  burns off cell by cell.
- **First smoke** — a fire ignites about a minute in. Site well and the drone catches
  it while it's one tree. Site badly and it starts in your blind spot.
- **Hold the firebreak** — fires don't resolve themselves. Hike in and hold the cut
  while it's small; too slow and the wind walks it tree to tree.
- **The forest remembers** — burned ground scars, and the scars *are* the save file.
  Reload the page and the forest you scarred (or saved) is the one you come back to.
- **Night** — the drones go camera-blind in the dark; a headlamp starts blinking in
  the pines and a thin voice calls under the wind. Walk him home.
- **Endless watch** — the valley keeps testing you, with a second cache across the
  river for station two.

All audio — wind, birds, crickets, fire crackle, the detection ping — is generated in
code. No external assets. The whole game is one HTML file.

## Controls

- **Move:** WASD / arrow keys — or the on-screen stick on touch
- **Look:** drag / swipe to steer the camera (it follows you on its own while you move)
- **Jump:** Space — or the ▲ button on touch
- **Interact:** E — or the on-screen prompt button
- **Test mode:** append `?test=1` to run the on-canvas verification harness

## Survive

You have a body now: **health, hunger, thirst**. Drink at the creek, eat rations at
the cache or a station you've built. Starve and you fade; fall too far or stand in
the flames and it costs you. Hit zero and you black out — the forest keeps burning
while you're down, and you wake at the cache weaker. Your vitals ride the same save
file as the scars.

## Verification

`?test=1` runs 17 deterministic on-canvas tests — ignition, wind-driven spread, the
firebreak hold, scorch persistence through a reload, the night detection penalty, the
rescue, and the full arc to the endless watch. Current build: **17/17 PASS**, 57–60fps
on desktop and touch.

## The real hardware

The station you build in the game is a real edge-AI fire-detection node — Raspberry
Pi 5 + AI HAT with a camera, a solar panel, and a LoRa whip (see `HARDWARE.md`). The
drone tier is the same detection model, flown. The game and the field kit are one
design; this is being built in public. See `devlog/` for the running log.

## Publish (itch.io, HTML5)

1. New project → Kind of project: **HTML**.
2. Upload `dist/lost-in-the-woods-level1.zip` and check **"This file will be played
   in the browser."**
3. Embed options: set a fixed viewport (e.g. 1280×720), enable **fullscreen** and
   **mobile friendly**.
4. Paste this file's "What Level 1 is" section as the description; set the cover.
5. Publish (or leave as draft/restricted for the first play test).

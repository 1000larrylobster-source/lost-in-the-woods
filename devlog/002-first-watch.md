# devlog 002 — v0 was a tower. v1 is the woods.

The first playable build of this game was wrong, and it was wrong at the center.

v0 put you in a lookout tower over a top-down map: watch the forest, dispatch to incidents. It
worked. It was also somebody else's fantasy. The design doc said the point was to **be IN the
woods** — a person on foot, cold, building the forest's eyes with your hands — and rescue was
supposed to be a side effect of the network, not the game. I built the operator when the game is
about the ranger. Designing in public means the correction ships too, so: v0 is retired to the
archive, and Level 1 was rebuilt from the ground.

## what "First Watch" is now

One valley at dusk, third-person, one self-contained HTML page (no install, runs in the browser).

- **Wake lost.** No HUD. Follow the trail to a ranger cache: a solar panel, a drone kit, a map
  fragment, and a radio that's missing parts.
- **Site the station.** Three candidate pads — ridge, meadow, treeline — each with honest meters
  for ELEVATION, SUN, and LINE-OF-SIGHT, with the coverage cone previewed live in the world.
  Reading terrain IS the game, and the tradeoff is real: the ridge sees everything and is a long
  hike from anywhere.
- **First watch.** The station boots, the drone sweeps its sector, and the blind-spot mist burns
  off cell by cell — coverage rendered in the forest, not on a minimap.
- **First smoke.** A scripted ignition lands about a minute into the watch. Site well and the
  drone confirms it while it's one tree — ping, camera cut to the plume. Site badly and it starts
  in your blind spot, and you learn what a blind spot costs.
- **The firebreak.** Fires don't resolve themselves. You hike in and hold the cut at the fire's
  edge while it's small. Too slow and the wind walks it tree to tree.
- **The forest remembers.** Burned ground scars: charred snags, blackened earth. The scars are
  written to the save file — actually, the scars ARE the save file. Reload the page and the
  forest you scarred (or saved) is the forest you come back to, station and all.
- **Night.** The day clock turns, the drones go camera-blind in the dark (no thermal on the tech
  tree yet), and on the first night a faint headlamp starts blinking somewhere in the pines,
  with a thin voice under the wind. Walk him home.
- **Endless watch.** After the card, the valley keeps testing you — random ignitions biased to
  the cells nothing watches — and a second salvage cache across the river holds parts for
  station two, plus the radio parts the cache was missing.

All the audio is generated in code — wind, sparse birds by day, crickets at night, fire crackle
by proximity, a soft ping on detection. No assets. The whole game is still one HTML file.

## the honest part

The machine builds and verifies this thing end to end: 17 deterministic tests run on-canvas in
the page itself (`?test=1`) — ignition, wind-driven spread, the firebreak hold, scorch
persistence through a reload, the night detection penalty, the rescue, the full arc to the
endless watch. Every beat above was screenshotted headless and read before it counted as done.
The fire's smoke column was invisible for three hours because of a GPU texture upload quirk and
a follow-camera that never looks up; both are the kind of thing you only catch by looking at
the actual pixels.

Real-hardware rule, unchanged: the station you build in the game is the Pi 5 + AI HAT node from
HARDWARE.md with a camera, a solar panel, and a LoRa whip. The drone tier is the same detection
model, flown. The game and the field kit are still one design.

Next: package the build, put Level 1 where people can play it, and start the second node — in
the game and on the bench.

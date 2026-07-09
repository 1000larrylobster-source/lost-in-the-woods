# Lost in the Woods: Design Doc v1 + v2

---

# v2 — THE SHIPPED GAME (locked with Jon, 2026-07-08)

v1 below still holds — the fantasy, the loop, the real-hardware rule. v2 defines what
**shipped** means, in Jon's words: *"game mechanics, sounds and maps done. story line
done."* Everything short of that is a **release** (v0.1, v0.2, …) — cut lines on the
road, published early-access, in public. Shipped is the destination:

## Shipped =

1. **10 maps.** The forest is one big Range; each map is a region of it. A map is
   "done" when its mechanics, sound, and story beat are all in.
2. **Towers are assembled from found components** — not built in one press. The four
   parts, each a real thing from `HARDWARE.md`:
   - **BASE** (foundation + battery box — the Pi lives here)
   - **SCAFFOLD** (the mast)
   - **ANTENNA** (the LoRa link)
   - **SOLAR PANEL** (the power)
   Player walks the world, finds each component where it fell — supply drops, old
   ranger stations, abandoned camps — hauls them to a pad one at a time, and mounts
   them step by step. Only a complete tower boots.
3. **Drones are assembled the same way**: FRAME, ROTORS, BATTERY, CAMERA (the camera
   *is* the detection model — the eyes). A tower without a drone watches nothing.
4. **Coverage expands as towers rise.** Already true in one valley; at Range scale,
   towers relay to each other (the LoRa mesh, literally) — building the relay toward
   the next region is what opens the next map.
5. **Rescued hikers can be RECRUITED.** They stay, settle, and support the network —
   the forest gains a community of watchers. Draft roles (Jon to correct):
   - **Watcher** — staffs a tower, keeps its drone flying while you're elsewhere
   - **Forager** — keeps a food cache stocked near their camp
   - **Runner** — hauls found components toward the pad you're building
   - **Tech** — slows a tower's wear; the maintenance loop's human half
6. **Story line done.** Draft arc (Jon to correct): you wake lost; you build the first
   eyes; the people you save stay; region by region the Range comes under watch; the
   final map is a fire season that tests the whole network and everyone it saved.
   Title payoff: the lost don't leave the woods — they become its watchers.
7. **Sound done.** All audio stays code-generated (no assets) — per-region ambience,
   per-mechanic voices (assembly clanks, mesh pings, storm wind), story stingers.

## What this reframes

- **Salvage** becomes *component* salvage — distinct parts with weight, not abstract
  kits. Ties into stamina (hauling) and the future carried-load inventory.
- **Degradation/maintenance** (the keystone, next up) acts **per component**: panels
  dust over, batteries sag, antennas take storm damage, rotors wear. Repair = tend or
  replace the component. Assembly and maintenance are one system.
- **Rescue** stops being only a score beat — every hiker saved is a potential recruit.

## Status of v1's open questions

1. Survival vs build-and-watch → **answered: full survival-sim** (locked 2026-07-08).
2. Clock → real-time day/night with seasons per map (fire season = the finale).
3. Manual response → you hike in; recruits can hold what you've built, not replace you.
4. Fire model → shipped in L1; escalates by region.
5. Engine → **Three.js single-file** proved out in L1 and stays for the browser
   builds; Godot remains an open option if/when the Range outgrows one file.

---

# v1 (original) — Design Doc

> The honest, in-public version. **v0 was wrong about the center of the game** — it made rescue the
> point and drew it top-down. This v1 corrects it. Publishing the correction *is* the point of
> designing in public.

## What changed (v0 → v1)

v0 called this a search-and-rescue base-builder seen from above. The real game is a **wildfire-watch
system you build by hand, as a character down in the woods** — and rescue is a *second use* of the same
eyes, not the point. Corrected throughout below.

## Player fantasy

You wake up lost in the woods. By the end, you've built an autonomous network that watches the whole
forest for the first curl of smoke. **You are IN the woods** — third-person, on foot, in the world
(think *Ocarina of Time*) — not an operator hovering over a map.

The emotional spine: a wildfire starts as one tree. Being the network that catches it *there*, before
it becomes a canyon fire, is the feeling. Finding a lost hiker with the same eyes is the bonus that
reminds you the thing you built is alive.

## The core loop

**Explore → salvage → build the eyes → watch for smoke → catch it early.**

1. **Explore & survive.** On foot in the forest. Traversal reveals the map, the hardware, and the good
   station sites.
2. **Find / salvage hardware.** Real gear scattered in the world — solar panels, drones, radios, cameras.
3. **Site & build a solar-powered station.** The core decision, and it's real tech work: read the site
   for **elevation** (sightlines for the drone cameras), **sun** (solar power), and **terrain /
   line-of-sight** (what a drone can actually see from here). A station on the ridge watches two valleys;
   one down in the trees is half-blind.
4. **Drones patrol.** Each station launches drones that autonomously sweep their sectors for smoke and
   heat. You're growing the forest's *eyes* — and you can always see where it's still blind.
5. **Respond to smoke.** A drone flags a heat signature; you confirm it (send a closer drone, or hike in
   yourself) and act while it's one tree. **Miss it and it spreads** — dry forest, wind — and burns your
   stations and the terrain with it. The forest is the save file.
6. **Find lost hikers.** The same sensors detect people — the softer, rewarding secondary objective.

## The central tension

You can never watch the whole forest — limited hardware, power, and drones. The game is the constant
choice of **where to build your eyes**, made from the ground as a character reading real terrain,
against a forest that is actively trying to catch fire in your blind spots.

## The real-hardware rule (unchanged — now literal)

Every unlockable is buildable in real life by a motivated hobbyist: solar panels + charge controllers,
Pi / Jetson vision nodes that detect smoke, fire, and people, cheap drones, thermal cameras,
LoRa / Meshtastic mesh, directional antennas where aim is a real mechanic. This isn't a theme — it's the
**actual edge-AI fire-watch node in `HARDWARE.md`**, fictionalized. The game and the real system get
designed in the same motion. One effort, two harvests.

## The look

North star: **Ocarina of Time** — third-person, warm painterly forest, in-world. That's the aspiration
to grow *toward*. Early builds will be far rougher; we chase the *feel* ("readable stylized 3D that
evokes OoT"), not unreleased fidelity.

## Open questions

1. How much survival (the opening) vs. how much build-and-watch (the long game)?
2. Real-time patrol on a day / season clock, or discrete operation phases?
3. How manual is a response — do you always hike in, or can drones resolve some fires/finds on their own?
4. Fire-spread model — how punishing, how readable?
5. Engine: **Godot 4** (3D, exports to web + desktop) is the front-runner — and its HTML5 export is how
   people will play it in a browser (itch.io / web) with no install.

## Status

**DESIGN PHASE**, in public — decisions and dead ends included (see the v0 → v1 correction up top). No
engine yet. Follow the devlog.

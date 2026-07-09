# Backlog — beyond First Watch

Running design frame for what comes after Level 1. Captured live from playtests.
The rule that saved this game twice still holds: **lock the core fantasy before
building.** Every item below is measured against one thesis.

## The thesis that keeps this game itself

> **The maintenance of the network IS the survival layer.**

You are a ranger, not a castaway. The tension is keeping the forest's eyes alive
across distance and time — panels foul, batteries sag, drones run out of charge,
links drop, snow comes. Character needs (food, water, warmth, rest) exist only as
*pressure that makes tending the network hard* — never as their own busywork. The
moment hunger/thirst becomes the point, this is Generic Woods Survival #4000 and the
wildfire-watch — the thing that makes it Jon's real hardware — becomes a side quest.
It must stay the spine.

## Playtest notes — 2026-07-08 (verbatim)

> cam follow 3rd person · jump · inventory · food and water consumption ·
> degradation and maintenance of the towers and the drones, shelter · fire and fall
> damage · animals · sleep?

## The notes, sorted by how they serve the core

### Bucket A — traversal feel (do first; cheap, universal, no design fork)
- **3rd-person follow camera** — ✅ **DONE** this session. Camera now eases in behind
  your heading (Ocarina-style); hand-steer still wins. Locked by test 18/18.
- **Jump** — traversal + reads as "person on foot." Keep it grounded: a real hop for
  ledges/logs, not floaty. Pairs directly with **fall damage** (below). Small build.
- **Inventory** — already minimal (solar / droneKit / map / radio). Grow into a real
  carried-load model: parts, tools, food, salvage. This is the connective tissue every
  other system hangs off, so it lands early.

### Bucket B — the network-as-survival core (HIGH fit; this is the differentiator)
- **Degradation & maintenance of towers, drones, shelter** — ⭐ the keystone. Solar
  panels dust over and lose yield, batteries age, drones deplete and must return to
  charge, LoRa links weaken with weather/distance, shelter needs upkeep. This maps 1:1
  to the real Pi 5 + AI HAT node in HARDWARE.md. Tending the net across the valley is
  the game. **Build this next after Bucket A.**
- **Animals** — not decoration: they're the drone's **false positives**. A deer trips
  the detector; you learn to read deer vs. hiker vs. smoke — the exact classification
  problem the real edge node has to solve. Ties into detection, not ambience.
- **Fire damage** — raises the stakes of the firebreak you already hold. Get too close
  to the line and it costs you. Fire already exists; this is a consequence layer.

### Bucket C — character-survival pressure (needs a depth decision — see fork)
- **Food & water consumption**, **sleep**, **warmth/cold**, **fall damage** — genre
  staples. They earn their place ONLY as pressure that pushes you between the watch and
  base, or forces the sleep/night rhythm. How deep they go is the one open question.

## The one open fork — how deep is character-survival?

Marked OPEN, pending Jon's lock. Options and the recommendation live in the session
thread. The rest of the build order assumes the recommended "light pressure in service
of the watch," and will be revised here once locked.

## Proposed build order (revised once the fork is locked)

1. ✅ 3rd-person follow camera *(done)*
2. Jump (+ hooks for fall damage)
3. Inventory as a real carried-load system
4. ⭐ Station/drone/shelter degradation & maintenance loop *(the keystone)*
5. Animals as detection false-positives
6. Fire & fall damage (consequence layer)
7. Food / water / sleep / warmth — at the depth locked by the fork

Each item ships the same way Level 1 did: one self-contained build, verified on-canvas,
screenshotted and read before it counts as done, with a devlog.

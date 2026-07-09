# Backlog — the road to SHIPPED

**SHIPPED is defined in DESIGN.md v2** (locked with Jon 2026-07-08): 10 maps,
component-assembled towers + drones, recruits living in the forest, story + sound
done. Everything before that is a **release** — v0.1 (Friday's itch upload) onward.
Captured live from playtests. The rule that saved this game twice still holds:
**lock the core fantasy before building.** Every item below is measured against one
thesis.

## Decision — survival depth (locked 2026-07-08)

Jon's call: **FULL survival-sim.** Real needs with real depth — hunger, thirst,
warmth, stamina, foraging, cooking, shelter. Wildfire-watch is one major system among
several, not the only one.

## The thesis that keeps this game itself

> **Full survival-sim — but the network is what makes surviving matter.**

The depth is real, but the wildfire-watch and the real Pi hardware stay the spine, or
this becomes Generic Woods Survival #4000. The reconciliation: **your network extends
your senses and your reach.** The drones that hunt smoke also spot the deer herd you
could hunt, the storm rolling in, the hiker who has your spare rations. The station is
your lifeline — power, warmth, a place to sleep. Surviving funds the watch; the watch
makes surviving possible. Every survival system should touch the network somewhere.

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

### Bucket C — character-survival (full depth, per the locked decision)
- **Food & water** — ✅ increment 1 shipped (hunger + thirst; drain, drink, eat, empty
  = slowed). Next: foraging/hunting for food, so you're not tethered to starting rations.
- **Warmth / cold** — pairs with shelter + the night clock + weather. Fire and the
  station are heat sources. Increment 2 candidate.
- **Stamina** — sprint/climb budget; gates jump and hauling. Regens at rest/by food.
- **Sleep** — pass the night, but night is when drones go blind and hikers call — so
  sleeping has a cost. Ties to shelter.
- **Health + fall damage** — a HP layer under the needs; needs at 0 drain it, falls and
  fire hurt it, black out → wake at base (the gentle fail the game already uses).

## Build order (survival-sim locked; revise as we learn)

1. ✅ 3rd-person follow camera *(done)*
2. ✅ Survival needs — hunger + thirst *(done: meters, drain, drink, eat, empty-slow)*
3. ✅ Health + jump + fall & fire damage + blackout *(done: third vital, real vertical
   physics, Space/▲ jump, falls past ~3m and standing in flames cost health, zero =
   blackout → wake at cache weaker; survival + rations persist in the save — old saves
   load clean)*
4. ✅ Stamina + berries-on-the-map *(done: Shift/stick-rim sprint 1.55x ~7s, jump costs
   wind, winded state, idle regen halved when hungry; 16 regrowing berry bushes + cache-2
   rations — Jon's playtest call: food had to be renewable or blackout looped)*
5. ⭐ **Component assembly** — towers built from BASE + SCAFFOLD + ANTENNA + SOLAR
   PANEL found in the world and hauled to the pad; drones from FRAME + ROTORS +
   BATTERY + CAMERA *(v2 core mechanic; reshapes salvage)* ← **NEXT**
6. ⭐ **Degradation & maintenance, per component** *(the keystone, now component-wise:
   panels dust, batteries sag, antennas storm-break, rotors wear; repair/replace —
   maps 1:1 to the real Pi node)*
7. **Recruits** — rescued hikers settle and take roles (watcher / forager / runner /
   tech); the forest community that supports the network
8. Warmth/cold + shelter + sleep (the night rhythm)
9. Hunting for food (drones spot game — network feeds survival; berries shipped early in #4)
10. Animals as drone false-positives (deer vs. hiker vs. smoke)
11. Inventory as a real carried-load / weight system (hauling components is the first use)
12. **The Range** — relay meshes open region 2; then maps 3–10, each with its story
    beat + sound pass (see DESIGN.md v2)

Each item ships the way Level 1 did: one self-contained build, verified on-canvas,
screenshotted and read before it counts as done, with a devlog.

## Not-yet-done notes
- ~~Second cache across the river should also stock rations.~~ ✅ done in #4.
- Blackout currently always wakes you at the first cache; once multiple stations are
  shelters, wake at the nearest tended one instead.
- Berry bushes don't persist picked-state in the save (they regrow in 90s anyway);
  revisit if regrowth ever slows.


---

# v1.0 SHIPPED STATE (2026-07-09, the marathon night)

Everything below the line above is history. Current truth:

**Built and verified (57/57 on-canvas tests, real Chrome):** component assembly ·
per-component degradation/maintenance · recruits (Dale live) · warmth/wet/sleep ·
the 10-region Range architecture with relay travel + per-region saves + range meta ·
title screen with AIOS branding · story cards (10 open + 10 close) · full sound pass ·
living wind · night fires + NoIR · elk herds/false positives/downwind hunting ·
storms + antenna damage + re-rig · snow burial + scrape · drought embers · dry
lightning · ghost towers + strip/cannibalize · Blackpine's lake · the Crown's siege
finale (3 dawns → THE RANGE — HELD) · 7 easter eggs · starfield + clouds · v1.0.

**Post-1.0 backlog (priced honestly, none block release):**
- ⭐ THE ZELDA LOOK PASS — deep-researched + verified plan in `design/ZELDA-LOOK.md`
  (2026-07-09). Stage 1 (hours): MeshToonMaterial ramp everywhere + OutlineEffect +
  warm fog/palette pass + character rim. Stage 2 (days): instanced wind grass
  (Quick_Grass/Smyth, MIT). Stage 3: WW grayscale-mask VFX; bloom only if perf allows.
  Art-direction lock (cel look) is Jon's call before Stage 1 lands.
- Settings panel: volume sliders, camera sensitivity/invert, reduced motion (SHOULD)
- Pause menu + controls card (SHOULD)
- Per-region bespoke terrain layouts (the Fork's braided creeks, the canyon's walls —
  today regions share Valley bones under different configs; MAPS.md has the specs)
- Region-specific site/pad placements + per-region recruit camps (Mae..Wren settle
  visually; their roles work through the range meta today only as roster entries)
- The remaining 9 easter eggs (satellite pass, radio Morse, storm numbers, operator's
  tower, dreaming base, surveyor's meadow, deer-that-wasn't, the round, full watch)
- In-game map screen (site/component markers) — the PAID bar calls it a SHOULD
- Weight-based carried-load inventory (hauling already does the feel-work)
- Balance pass from real player data (coverage goals, fire cadence per region)
- Trailer (Higgsfield candidate — content lane, Jon's call on spend)

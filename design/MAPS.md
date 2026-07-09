# The Range — 10-Map Progression Spec

**Scope:** the full map arc that makes the game SHIPPED per DESIGN.md v2. One forest, ten regions, one save file. Each map is a region of the Range, generated procedurally from a per-region config block (hill amplitude, tree density, water features, palette). Everything below respects the locked constraints: one self-contained HTML file, Three.js, code-generated low-poly art, WebAudio-only sound, 60fps mid hardware, desktop + touch.

**The rule every map obeys:** teach → test → surprise. The new mechanic arrives in a safe, readable moment (teach), the fire curve makes you use it under pressure (test), and one scripted beat bends it in a way the tutorial didn't promise (surprise). One new mechanic per map, never two.

**How a map opens the next:** hit the region's coverage goal, then build the **relay tower** at a marked ridge site that faces the next region — a directional antenna aimed at somewhere you haven't been. The relay is always a full component build (BASE / SCAFFOLD / ANTENNA / SOLAR) at an honest, inconvenient site. When it boots, the mesh pings once from over the hill, and the trail to the next region opens.

**The year:** the Range crosses one full year. Map 1 is late summer. The seasons turn map by map — fall, the rut, the first storms, deep winter — and a thin snowpack in Map 6 is the honest, real-fire-science foreshadowing of the drought in Map 7. Map 10 is the next fire season, and everything you built and everyone you saved is what stands in it.

---

## Overview

| # | Region | Beat title | Season / light | New mechanic | Coverage goal | Recruits | Playtime |
|---|--------|-----------|----------------|--------------|--------------|----------|----------|
| 1 | The Valley | First Watch | Late summer, dusk | Baseline (exists) | 50% | 1 | ~15 min |
| 2 | The Fork | Crosswind | Early fall, morning | Living wind | 60% | 1 (Runner) | ~20 min |
| 3 | Blackpine Lake | Dark Water | Fall, night-weighted | Night fires + NoIR camera | 65% | 2 (Watcher +1) | ~25 min |
| 4 | The Long Meadow | The Herd | Late fall, noon | Animals (false positives + hunting) | 70% | 2 (Forager +1) | ~25 min |
| 5 | Redwall Canyon | Weather | Early winter, storm | Storms (grounded drones, antenna damage) | 55% | 2 (Tech +1) | ~30 min |
| 6 | The Pass | Thin Winter | Deep winter | Snow/ice on panels | 65% | 2 | ~30 min |
| 7 | The Dry Side | Tinder | Early summer | Drought (brittle fuel, ember spotting) | 75% | 3 | ~35 min |
| 8 | The Spine | Dry Lightning | Midsummer, dusk | Lightning strikes (multi-ignition bursts) | 75% | 2 | ~35 min |
| 9 | The Old Burn | The Ones Before | Late summer | Equipment scarcity (cannibalize towers) | 60% | 2 | ~40 min |
| 10 | The Crown | Fire Season | Fire season | Multi-fire sieges, Range-wide | Win condition (below) | 0 new | ~45–60 min |

Total content: roughly 5–6 hours first playthrough. Right for a few dollars on itch, honest about what it is.

---

## Map 1 — The Valley ("First Watch") — SHIPPED

- **Character:** One valley at dusk. You wake lost and build the forest's first eyes.
- **Season / light:** Late summer, permanent golden-hour into night cycle.
- **Terrain config:** hill amplitude 1.0 (baseline), tree density 1.0, one winding river, one meadow, one ridge. As built.
- **Palette:** ground `0x49572f`/`0x6a7040`, pine `0x2e4a2b`→`0x44633a`, sky `0x1c2148`/`0x53406e`/`0xff9455`, fog `0x6e4a63`. As built.
- **New mechanic:** the whole baseline — move, survive, salvage, site, build, watch, firebreak.
- **Fire curve:** scripted first smoke + ~1 random ignition/day. Spread 1.0x, grace ~3 min. Generous.
- **Component scarcity:** cache-based, full sets within ~150m of pads. The kindest it will ever be.
- **Recruits:** 1 — the night hiker. When the recruit system lands, walking him home becomes the game's first recruitment.
- **Coverage goal:** 50%, then the relay site on the east ridge — the first time the game asks you to build toward something you can't see.
- **Playtime:** ~15 min.
- **Story beat:** the ranger cache, the radio missing parts. The surprise is already in: your first smoke lands inside or outside coverage depending on how you sited, and the lesson lands either way.
- **Sound:** as built — wind, sparse birds, crickets, crackle. This is the ambience baseline every region varies from.

---

## Map 2 — The Fork ("Crosswind")

- **Character:** Two creeks braid through rolling foothills, and the wind stops being a promise.
- **Season / light:** Early fall, clear cold morning light.
- **Terrain config:** hill amplitude 1.3, parallel rolling ridges running NE–SW, tree density 1.1 with density dips on crests (open golden knolls). Water: the river forks — main channel plus a tributary joining mid-map, one shallow crossing each.
- **Palette:** ground `0x556032`/`0x76793f` with knoll grass `0x8f8449`, pine `0x35552e`→`0x4a6338`, sky top `0x2e5e9e` / mid `0x7fa3c4` / horizon `0xcfe3ee`, fog `0x9db8c8`.
- **New mechanic — living wind.** Map 1's wind arrow was fixed. Here wind has weather: it swings direction over minutes and gusts in pulses. A gust doubles spread rate along its heading for its duration, and the arrow (plus audible wind swell, plus visible tree lean) telegraphs it. Firebreaks now have a *side that matters* — cut downwind of where the wind is going, not where it was.
- **Fire curve:** 1–2 ignitions/day, spread 1.0x baseline but gusts spike to 2.0x. Grace ~2.5 min. The test: a mid-fight wind swing invalidates half your cut.
- **Component scarcity:** sets split across 2–3 sites each, up to ~250m out. First real hauls; stamina economy starts to matter.
- **Recruits:** 1 — a hiker with a wrenched ankle you carry-assist home; she becomes the first **Runner** (hauls found components toward your active pad). Teaching the role right when hauling starts to hurt.
- **Coverage goal:** 60%. Relay site on the north knoll line.
- **Playtime:** ~20 min.
- **Story beat / surprise:** the missing radio parts from Map 1 are here, in a hunter's blind. The radio boots — and the first voice you hear on it isn't a rescuer. It's static, then a fragment of an automated weather broadcast. The Range is bigger than anyone's coming to help with.
- **Sound:** wind becomes the lead instrument — layered gust swells with pitch tied to gust strength, so you can fight fires by ear.

---

## Map 3 — Blackpine Lake ("Dark Water")

- **Character:** A still black lake in a bowl of dense pine, and the fires learn to start after sundown.
- **Season / light:** Fall, day cycle weighted long into night (~40% night). Last-light horizons, then true dark.
- **Terrain config:** hill amplitude 0.8 (gentle bowl), central lake ~120m radius (flat waterY, replaces the river), one small island with a cache. Tree density 1.3 at shoreline falling to 0.9 on the rim. Shallows marked by lighter bed color; the island is reachable by a wade line.
- **Palette:** ground `0x3e4a2e`, pine `0x27402a`→`0x3a5230`, water `0x1d3350` (near-black at night, catches fire orange when it burns — the money shot), sky top `0x0d1230` / mid `0x2a2f55` / horizon `0xd97b4a`, fog `0x2c3350`.
- **New mechanic — night fires + the NoIR camera.** 60% of ignitions land at night, when standard drone cameras are blind (established in L1). The counter is real hardware: the **NoIR camera** (HARDWARE.md field-node tier), a new CAMERA component variant found in this region. A drone fitted with NoIR sees at night at reduced range. Suddenly which camera goes on which drone is a decision.
- **Fire curve:** 1–2 ignitions/day, 60% nocturnal. Spread 1.0x. Grace 2.5 min — but a night fire in a blind sector gets minutes of free growth before anyone sees it. The test is coverage *through time*, not just space.
- **Component scarcity:** moderate distance, but one component of every full set is across water — the island cache or the far shore. Hauling through the wade line is slow and costs warmth-adjacent stamina.
- **Recruits:** 2 — a fisherman who becomes the first **Watcher** (staffs a tower, keeps its drone flying while you're elsewhere — taught exactly when you need eyes at night while you sleep), plus one Runner or Forager.
- **Coverage goal:** 65%, including the far shore. Relay site on the west rim.
- **Playtime:** ~25 min.
- **Story beat / surprise:** the first night fire ignites on the island — inside a wade, outside a sprint. You watch it double in the lake's reflection while you cross. The card after: "Fire doesn't sleep. Now something of yours doesn't either."
- **Sound:** night is the lead — loons (synthesized wail), water lap, and the NoIR drone gets its own lower rotor tone so you can hear who's watching in the dark.

---

## Map 4 — The Long Meadow ("The Herd")

- **Character:** Open gold grassland under a huge sky, full of moving warm bodies that are not fires and not hikers.
- **Season / light:** Late fall, the rut. High noon light, long amber evenings.
- **Terrain config:** hill amplitude 0.6 (flattest map), tree density 0.4 arranged in discrete copses, no river — three small pothole ponds. Two fuel types on the ground grid: **grass** (fast, burns out quick) and **timber** (copses; slow, hot, persistent).
- **Palette:** ground `0x7c7f42`/`0x9a9050` (dry gold), copse pine `0x3d5c34`, sky top `0x3f74b8` / horizon `0xdfeaf2`, fog light `0xb9cdd8` — the airiest, most open palette in the game. A breather that doesn't feel like one.
- **New mechanic — animals.** Elk herds (low-poly, boids-lite, ~2 herds of 6–10) roam the meadow. They trip drone detection: a ping is now *smoke / hiker / animal*, and the drone's confidence readout is honest about which. Misread it and you sprint 400m to greet an elk while real smoke grows elsewhere. This is literally the classification problem the real Pi node solves. Second half of the same system: **hunting** — a downed elk is major food (the network spots the herd for you; the watch feeds the survivor, per the thesis).
- **Fire curve:** ~1 ignition/day but grass spreads at 2.0x and self-limits at copse edges — fast, scary, survivable. Grace in grass ~90 seconds. The test: triage pings while grass fire moves at running speed.
- **Component scarcity:** parts are plentiful but *far* — the flat openness means 300–400m hauls with nothing to hide behind. A crashed supply plane holds two full drone sets. Runner recruits earn their keep.
- **Recruits:** 2 — a botanist who becomes the first **Forager** (keeps a food cache stocked near her camp), plus one more. By now all four roles exist in the world.
- **Coverage goal:** 70% (LoS is easy here; the game asks for more of it). Relay site atop the one true hill.
- **Playtime:** ~25 min.
- **Story beat / surprise:** a ping comes in flagged *animal, low confidence*. It's a hiker in an elk-hide poncho — half-frozen, delirious, following the herd for warmth. The detector was wrong in the humane direction. Trust the eyes; verify with your feet.
- **Sound:** meadow wind through grass (filtered noise, higher band than forest wind), elk bugle (the rut — synthesized brass-ish call), and a new three-tone classification ping: smoke / person / animal each get a distinct interval.

---

## Map 5 — Redwall Canyon ("Weather")

- **Character:** A red-rock canyon under the first winter storms — the sky becomes a system you plan around.
- **Season / light:** Early winter. Storm fronts cross the map on a visible schedule; gray light, rain, sleet at the rims.
- **Terrain config:** hill amplitude 2.0 with a deep carved canyon (walls ~40m, an inverted river: the channel cuts *down*), benches and mesas on both rims, river at the canyon floor. Tree density 0.8, clustered on benches and the floor; rims are bare rock. LoS is the terrain twist: canyon walls block coverage cones — floor towers see nothing, rim towers see one side each.
- **Palette:** ground dirt `0x6b5a44` / rock `0x7a6d5e` / redwall `0x8a5c44`, bench pine `0x2f4a30`, sky storm top `0x3a4152` / mid `0x596273` / horizon `0x8b93a1`, fog `0x707a88`. Rain streaks as shader lines; wet rock darkens.
- **New mechanic — storms.** Fronts roll through every few minutes with warning (darkening sky, wind swell, falling barometer tone). During a storm: **drones are grounded** (auto-return or take rotor damage), **solar yield drops to ~0**, and **antennas take storm damage** — a per-component degradation event (the keystone system, weaponized by weather). Rain also *suppresses* fire — spread halves in the wet. Storms are shield and sword: the network goes blind and battered exactly when the forest is safest, then the post-storm sun brings ignitions back to a mesh you have to repair first.
- **Fire curve:** 2 ignitions/day between storms, 0 during rain, spread 1.1x dry / 0.5x wet. Grace ~2 min. The test: triage repairs in the storm window so the eyes are back up before the sky clears.
- **Component scarcity:** components on the canyon floor, pads on the rims — every haul is vertical. Fall damage (already shipped) makes the descent routes matter. First map where a spare ANTENNA in stock is the difference between a bad hour and a bad day.
- **Recruits:** 2 — a lineman who becomes the first **Tech** (slows a tower's wear, the maintenance loop's human half — taught the map that maintenance becomes weather), plus one.
- **Coverage goal:** 55% — honest about the walls. The lesson: coverage percent isn't the whole truth; *where* the blind spots are is. Relay site on the far rim, storm-exposed.
- **Playtime:** ~30 min.
- **Story beat / surprise:** mid-storm, the mesh drops — the Map 3 relay antenna, two regions back, storm-broke. The whole eastern Range goes dark on your map. First taste of the truth the finale runs on: the network is one organism, and it is only as strong as its oldest joint.
- **Sound:** the storm suite — rain density tied to front intensity, thunder (filtered noise burst + sub thump) with distance delay, the barometer drone that falls in pitch as weather comes. Antenna damage gets a sick, detuned ping.

---

## Map 6 — The Pass ("Thin Winter")

- **Character:** Above the treeline in deep winter — the fire threat sleeps and the network tries to die of cold.
- **Season / light:** Deep winter. Short days, long blue nights, low white sun.
- **Terrain config:** hill amplitude 2.4 (highest map), hard treeline: density 1.0 in the valley throat falling to 0 above the snowline elevation. Snowline as a shader band on the terrain. One frozen tarn (walkable, a shortcut that creaks). Wind-scoured crests, deep drifts in lee slopes.
- **Palette:** snow `0xdfe4ea`/`0xc9d2dc`, exposed rock `0x6f6a63`, pine near-black `0x243c2a` with snow caps `0xe8edf2`, sky top `0x9fb4c8` / horizon `0xe3ecf2`, fog `0xcfd9e2`. The one map that's light-on-dark instead of dark-on-light.
- **New mechanic — snow and ice on panels.** Snowfall accumulates on every SOLAR PANEL as a visible white layer; yield falls with coverage, to zero iced-over. The counter is the humblest verb in the game: hike up and **scrape it clear** — a hold-interact like the firebreak, warm and manual. Batteries sag faster in cold (real chemistry, real HARDWARE.md truth). Warmth/shelter pressure (shipped earlier in the survival track) is at maximum: cold drains you between fires the way fire never has.
- **Fire curve:** rare — ~0.5 ignitions/day, spread 0.7x in snow-margin fuel. Grace ~3 min. Deliberately the gentlest fire map in the back half — the danger here is *power death*: let the panels ice over and the network browns out, drones ground, and the one fire that does come finds you blind.
- **Component scarcity:** components are buried — visible only as snow mounds within ~40m, or spottable from a drone pass (the eyes find the parts: network feeds survival again). Hauls cost warmth. Moderate totals, hard finds.
- **Recruits:** 2 — snowed-in climbers. Techs and Watchers shine; a staffed, tended tower through winter is the whole point of the community.
- **Coverage goal:** 65%. Relay site at the top of the pass itself — the highest, coldest build in the game, and it earns the view: from the relay you can *see* the next three regions laid out below, hazed and waiting.
- **Playtime:** ~30 min.
- **Story beat / surprise:** the winter is thin. A Watcher says it plainly over the radio: "Snowpack's half what it should be. You know what that means for summer." The player who's paying attention starts stockpiling now. The surprise is quiet and it's the setup for Maps 7–10: **this map's weather is next map's fuel.**
- **Sound:** near-silence as a feature — wind over snow (thin, high, steady), boot-crunch, the tarn's ice groan, and the panel-scrape rasp. The mesh ping sounds louder here because everything else is so quiet.

---

## Map 7 — The Dry Side ("Tinder")

- **Character:** The rain-shadow slope in a drought summer — the whole map is a held breath.
- **Season / light:** Early summer, the year after. Hazy amber heat; the light itself looks flammable.
- **Terrain config:** hill amplitude 1.2, long east-tilted slopes, dry washes (river channels with no water — the riverX carve, empty). Tree density 0.9 and *browning* (needle color shifts warm). Exactly **one spring** on the whole map — the single water source, a thirst anchor that shapes every route. Berry bushes exist but are withered (half yield, slow regrow).
- **Palette:** ground `0x9c8a52`/`0xb09a5e`, brittle pine `0x5c6135`/`0x6e5c33`, sky top `0x7d94ad` / horizon `0xc2a875` (dust haze), fog dusty `0xb3a284`.
- **New mechanic — drought.** Fuel is brittle: base spread 1.6x everywhere. And fire learns to jump: **ember spotting** — a burning cell can seed a new ignition 2–4 cells downwind, over your firebreak. Cuts must be wider, placed earlier, and the wind reads from Maps 2 and 5 all cash in. Meanwhile the drought is *in the survival sim too*: one spring, dead berries, heat stamina tax. Everything the game has taught about needs and network converges.
- **Fire curve:** 2–3 ignitions/day, spread 1.6x, spotting active. Grace ~90 seconds. First map where two fires can be alive at once through spotting alone.
- **Component scarcity:** sparse and sun-worn — some found components arrive **pre-degraded** (batteries at 60%, panels hazed). The find isn't the end of the job anymore; assembly and maintenance fully merge, as DESIGN v2 intends.
- **Recruits:** 3 — a dried-out homestead family. The largest single recruitment, and the game says why: the Range is emptying out ahead of the season, and the ones who stay, stay *for the network*.
- **Coverage goal:** 75%. Relay site up-slope through the worst of the brown timber.
- **Playtime:** ~35 min.
- **Story beat / surprise:** a spotting ember lands **behind** you during a routine firebreak — the first fire in the game that outflanks the player's mental model. The card: "It doesn't have to walk. It can fly."
- **Sound:** heat as sound — cicada shimmer (amplitude-modulated noise band), dry wind with grit, the spring's tiny trickle audible for 50m because it's the only water in the world. Spot-ignitions get a whip-crack whoosh.

---

## Map 8 — The Spine ("Dry Lightning")

- **Character:** One knife ridge under bruised skies — the sky starts the fires now, three at a time.
- **Season / light:** Midsummer, permanent uneasy dusk. Towering dry-storm cells cross the map with no rain in them.
- **Terrain config:** hill amplitude 1.8, a single long knife ridge running diagonal across the map, steep flanks, scree fields (fall-damage terrain), bare rock crest. Tree density 1.0 on the flanks, 0 on the crest. No water on top — two tarns low on the flanks.
- **Palette:** ground `0x6a5f43`, pine `0x33502f`, sky bruised top `0x2b2b4a` / mid `0x6b4a63` / horizon `0xc86a3e`, fog `0x5c4f60`. Lightning renders as one-frame white sky flash + strike column.
- **New mechanic — lightning strikes.** Dry cells drift across the map, visible and tracked by the network (the mesh's weather sense, built from every barometer lesson since Map 5). When a cell crosses, it throws **2–3 strikes in quick succession** — each a potential ignition, each telegraphed seconds ahead by a ground-glow tell. This is the first *deliberate multi-fire pressure*: you cannot be at two strikes at once, so the map forces the finale's real question early — **which fire do you fight, and who holds the other one?** Watchers with drones can hold (slow) a small fire until you arrive. Recruits stop being support and start being the plan.
- **Fire curve:** strike bursts of 2–3 ignitions per cell pass (~1–2 passes/day), spread 1.4x, grace ~2 min each — but simultaneous. Between cells, quiet.
- **Component scarcity:** adequate totals, but every haul runs the scree and the crest — fall risk with full hands. Towers want to be high; parts live low. The vertical economy of Map 5, sharpened.
- **Recruits:** 2 — including a retired fire lookout who, once settled as a Watcher, calls strikes faster than the mesh does. The human in the loop outperforming the sensor, once.
- **Coverage goal:** 75%. Relay site at the ridge's north tooth.
- **Playtime:** ~35 min.
- **Story beat / surprise:** a strike hits one of **your towers**. Direct hit — antenna slagged, tower dark, a hole in the mesh with a storm still overhead. Repairing your own wounded tower while strikes walk the ridge is the dress rehearsal for fire season.
- **Sound:** the dry-storm suite — sub-bass cell rumble that pans with the cell's position, strike crack with real distance delay, and the ground-glow tell gets a rising sizzle so ears can beat eyes.

---

## Map 9 — The Old Burn ("The Ones Before")

- **Character:** A forest that already lost — miles of standing snags, green coming back in the draws, and towers that aren't yours.
- **Season / light:** Late summer. Pale, ashy light; overexposed sky.
- **Terrain config:** hill amplitude 1.1, snag fields — tree density 1.2 but ~70% render as burned trunks (no canopy, dark verticals), live pine only in creek draws and wet pockets. One creek returns (water after the Dry Side reads as mercy). Scorch-textured ground with regrowth patches.
- **Palette:** ash ground `0x565049`/`0x6b655c` with regrowth `0x4f6538`, snags `0x2e2a26`, fringe pine `0x31492e`, sky pale top `0x8fa3b3` / horizon `0xd8dfe4`, fog `0x9aa3ab`.
- **New mechanic — equipment scarcity.** Almost nothing fresh: ~1.5 full component sets for 4 pad sites. But the map is scattered with **ghost towers** — the failed watch network of the crew that was here before the burn. Their components can be stripped and reused (weathered, pre-degraded), and — the real mechanic — **so can yours**: pull a working SOLAR PANEL off your own live tower to complete another. Cannibalization is a first-class verb, and every use of it is a coverage decision with a hole in it. This is the endgame of the assembly system: parts as a closed economy.
- **Fire curve:** 2 ignitions/day; snag fields **reburn fast** (1.8x — standing dead fuel is real fire behavior), green draws resist (0.7x). Grace ~2 min. The test isn't the fire's speed — it's fighting it with fewer eyes than you've had since Map 2.
- **Component scarcity:** the mechanic *is* the curve — maximum scarcity, by design. What the map hands you is choice, not parts.
- **Recruits:** 2 — and one of them was **on the old crew**. She tells you what happened: the season came, the network had holes, and the holes won. She's the game saying its thesis out loud, one map before it tests it.
- **Coverage goal:** 60% — capped by honesty. You cannot fully cover this place with what it gives you. The relay site sits beside the old crew's last, unfinished relay. You finish their build with their parts.
- **Playtime:** ~40 min.
- **Story beat / surprise:** the ghost towers' logbook, found page by page at each stripped tower — a devlog, in-world, of a network that lost. The last page is the surprise: their coverage map, and the blind spot that killed them is **the region you started in**. The Valley. It burned once before you ever woke there.
- **Sound:** the sparest mix in the game — wind through snags (hollow, woody, resonant tones instead of needle hiss), no birds until the draws, and each recovered logbook page gets a single low piano-ish tone. Silence used as story.

---

## Map 10 — The Crown ("Fire Season")

- **Character:** The high heart of the Range in fire season — every mechanic, every tower, every person you saved, tested at once.
- **Season / light:** Fire season. Smoke-tinged glare that degrades to burnt orange as siege days peak, clears when you hold.
- **Terrain config:** hill amplitude 1.6, a summit bowl whose rim looks *down* into echoes of everywhere you've been — a mini river, a tarn, a dry wash, a snag patch, gold meadow shoulders. The Range remembered in one map. Tree density 1.0 mixed-fuel (grass, timber, snag cells all present).
- **Palette:** ground `0x77713f`/`0x8c7f46`, pine `0x3a532f`, sky smoke top `0x74869b` / horizon `0xd8a35f`, fog `0xc09a6a` — dropping to siege palette sky `0x4a3a33` / horizon `0xb3552e` when waves run. The sky is the health bar.
- **New mechanic — the multi-fire siege, Range-wide.** Fire season runs as **three siege days**. Each day throws waves of 3–5 ignitions across the *entire Range* — every region, modified by that region's own rules (night fires at the Lake, spotting on the Dry Side, strikes on the Spine, reburn in the Old Burn). You physically cannot be everywhere: staffed towers and their Watchers hold and slow fires in regions you're absent from — **if** you staffed them, **if** their components are tended, **if** the mesh relays are intact. Unstaffed or dark regions burn on their own clock and call for help over the radio. You travel the relay trails between regions (60–90s transit corridors — fires do not pause while you move). Between siege days: one **airdrop** of fresh components, and you choose which region gets it. Triage is the final mechanic, and it's made entirely of the nine before it.
- **Fire curve:** waves of 3–5 ignitions/day Range-wide, regional spread modifiers all active, grace ~2 min per fire. Day 3 is the hardest hour in the game.
- **Component scarcity:** no new parts in the world — only the between-day airdrops. The network you arrived with, plus what you can keep alive, is the network that fights.
- **Recruits:** 0 new — the finale runs on everyone already saved (up to 17 across nine maps). Instead, one rescue beat: mid-siege, a Watcher goes missing near a fire line. The network's builder walks into the smoke for one of the network's own. Title payoff, played, not told.
- **Win condition (replaces relay goal):** end fire season with **the Range ≥70% unburned overall, no region below 40%, and the mesh unbroken** (all relays alive at dawn on day 4). Fall short and the season still *ends* — the forest is the save file, the scars are permanent, and the epilogue card counts what stood and what didn't. Losing ground is a state, not a game over. You can play the next season better.
- **Playtime:** ~45–60 min.
- **Story beat:** dawn after day 3. The smoke clears off the summit bowl and the camera does the one slow pull-back the game ever allows — down the whole Range, every tower blinking green, every camp's fire lit. The final card, over the mesh's soft pings: *"You woke up lost. The forest kept you. You taught it to watch."* The lost don't leave the woods. They become its watchers.
- **Sound:** the full score — every region's ambience motif returns as its fires light and go out, siege waves get a low pulse that builds per active fire and releases per save, and the dawn-after silence is broken only by the mesh: every node pinging, in sequence, down the Range.

---

## What persists between maps — the mesh grows

One save file. One Range. The rules:

1. **Regions are deterministic.** Each region generates from a fixed seed + its config block; the save stores only *diffs* — scars, towers and their per-component state, drones, looted caches, recruits and roles, placed-but-unfinished builds. One region rendered at a time (same poly/instancing budget as the Valley — the 60fps guarantee); the rest of the Range lives as data.
2. **Towers persist and keep aging.** Components in absent regions degrade slowly on an abstracted clock. A **Tech** recruit slows it; an unstaffed tower just wears. Before Map 10, absent regions never *burn* off-screen — a staffed region holds steady (that's the recruit fantasy: what you built keeps standing), an unstaffed one only accumulates wear. In the finale that mercy ends.
3. **Relays are the skeleton.** Each region's relay tower is a permanent mesh joint and a trailhead pair — travel between adjacent regions runs the relay trail (~60–90s). A dead relay severs everything behind it from the Range map's live data (you saw this happen once, in Map 5, on purpose).
4. **Recruits settle where saved** and keep their role and camp; roles are reassignable when you visit. The Range map shows every camp, every tower, every region's coverage %, and mesh health — the HUD literally grows a spine as the game goes on.
5. **You carry over.** Vitals, rations, carried components, and unlocked component variants (NoIR camera from Map 3 onward appears in later caches) all persist.
6. **The forest remembers, globally.** Scars never heal. The running ledger — hikers rescued, recruits settled, acres burned, acres saved — persists across all ten maps, and the finale's epilogue card reads the whole ledger, not just the season.

---

## Tuning reference — the curves at a glance

| # | Ignitions/day | Spread mult | Grace | Simultaneous fires | Scarcity feel |
|---|--------------|-------------|-------|--------------------|---------------|
| 1 | ~1 | 1.0x | 3:00 | 1 | full sets, close |
| 2 | 1–2 | 1.0x (2.0x gusts) | 2:30 | 1 | split sets, ~250m |
| 3 | 1–2 (60% night) | 1.0x | 2:30 | 1 | one part across water |
| 4 | ~1 | 2.0x grass / 1.0x timber | 1:30 grass | 1 | plentiful, far |
| 5 | 2 (dry spells) | 1.1x dry / 0.5x wet | 2:00 | 1 | vertical hauls |
| 6 | ~0.5 | 0.7x | 3:00 | 1 | buried, cold hauls |
| 7 | 2–3 | 1.6x + spotting | 1:30 | 2 (via spotting) | sparse, pre-degraded |
| 8 | strike bursts | 1.4x | 2:00 each | 2–3 | adequate, fall-risk |
| 9 | 2 | 1.8x snags / 0.7x draws | 2:00 | 2 | cannibalize-only |
| 10 | waves 3–5, Range-wide | regional | 2:00 | 3–5 | airdrop triage |

The shape on purpose: pressure rises 1→5, **breathes** at 6 (winter — fire eases, maintenance and cold peak), then climbs without relief 7→10. Every mechanic gets one map to be the star and returns as supporting cast afterward; nothing introduced is ever retired. If any map's test fails playtest, tune grace and ignition rate first, spread multipliers second, scarcity last — scarcity changes are the ones players read as unfair.
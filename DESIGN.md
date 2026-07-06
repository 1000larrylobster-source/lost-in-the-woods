# Lost in the Woods: Design Doc v0

This is the honest version. Things in here will be wrong. When they turn out wrong, the devlog will say so and this doc gets updated. That is the whole point of designing in public.

## Player fantasy

You were the emergency. Now you are the response.

The fantasy is not "lone survivor punches trees." It is competence with real equipment. You know what a LoRa node is because one saved your life. You know why drone batteries die in the cold because yours did at the worst moment. The player should end a session feeling like they could almost build this stuff for real. Because they could. Every unlockable in the game exists at a hobbyist price point today.

The emotional spine: being lost is terrifying, and being found is one of the strongest feelings a person can have. The game hands you that feeling in act 1, then spends the rest of the game letting you give it to someone else.

## Three acts

### Act 1: Survive

You are the lost hiker. Dead phone, no gear, weather turning. Bare-hands tier: shelter, water, signal mirror, fire. You are not building yet, you are lasting. The act ends when the network finds you. A drone spots your fire, or a hiker with a handheld picks up your whistle pattern, or a ranger triangulates you off a single lucky ping.

Design intent: this act is short and it is scripted tighter than the rest. Its job is to make you feel what rescue means, so the rest of the game has weight. Maybe 45 minutes on a first run.

### Act 2: Connect

You join the volunteer search network. Now the base-builder opens up. You salvage and scrounge components: a wrecked drone with a good camera, dead nodes with live radios, a bin of parts at the ranger station. You solder your first beacon. You place your first ridgeline node and watch your coverage map grow a lobe.

Coverage is the core territory mechanic. Terrain blocks radio. Elevation is power. A node in the right saddle is worth three in the trees. Lost-hiker events fire inside and outside your coverage, and the difference in outcome teaches the mechanic better than any tutorial.

### Act 3: Protect

The network is big enough to stop watching for people and start watching for everything. Thermal cameras, smoke sensors, trail counters. Fire becomes the late-game antagonist: a smoke signature on a thermal cam at 2am, a scramble to confirm with a drone, a call that gets a crew on a one-tree fire before it becomes a canyon fire.

Failure states matter here. A fire you miss changes the map. Burned zones lose nodes, lose trails, lose the places you knew. The forest is the save file.

## The real-hardware rule

Every unlockable must be buildable in real life by a motivated hobbyist. No fantasy tech, no "advanced polymer" resources, no research points.

- LoRa radios and mesh nodes (Meshtastic exists, this is not science fiction)
- Pi Zero drones with cheap flight controllers
- Thermal cameras, the affordable low-res kind first, better ones later
- Solar panels, charge controllers, battery math that actually matters
- Directional antennas, and yes, antenna aim should be a real mechanic

The rule cuts both ways. If a mechanic needs the hardware to do something it cannot do in real life, the mechanic changes, not the hardware. My background is low-voltage systems and access control. I will not ship a tech tree I would be embarrassed to explain to another tech.

Stretch goal, way down the road: the in-game builds double as rough guides for the real thing. One effort, two harvests.

## Open questions

Undecided, in rough priority order:

1. **Engine.** Godot is the front-runner (open source fits the build-in-public ethos), but not committed. Unity and raw web are still on the table.
2. **2D or 3D.** Top-down 2D makes the coverage map the star and keeps scope sane. 3D sells the terror of act 1 better. Leaning 2D. Not locked.
3. **Singleplayer first.** Almost certainly yes. A shared persistent forest where players maintain one big network is the dream, but the dream is how scope kills projects. Prove the loop solo.
4. **Map: handcrafted or generated?** Act 1 wants authored moments. Acts 2 and 3 want replayable terrain. Maybe both: authored valley, generated wilderness beyond it.
5. **Time pressure model.** Real-time with weather fronts, or turn-ish "operation" phases? Affects everything downstream.
6. **How real is the radio sim?** Full line-of-sight propagation modeling, or a readable approximation? Realism is the brand, readability is the game.

## What this doc is not

Not a pitch. Not a promise of a ship date. It is a snapshot of current thinking, version zero, written before a single line of engine code exists. Follow the devlog to watch it get corrected.

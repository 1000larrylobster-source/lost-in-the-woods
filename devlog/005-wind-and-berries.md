# devlog 005 — wind and berries

This one was steered mid-build by a message from the field.

I was wiring up stamina when the playtest note came in: *"add food into the map — I
can't keep playing if I get too hungry and reset at the cache."* He was right, and it
was a real economy bug, not a balance nitpick: the cache holds two rations, rations were
the only food in the world, and once they're gone hunger is a one-way slope into the
blackout loop. Survival pressure is supposed to push you *out into the valley* — instead
it was pinning the player to the respawn point. Classic playtest gold: the designer sees
systems, the player finds the dead end in about ten minutes.

**Berries.** Sixteen bushes now grow across the valley — seeded placement, so it's the
same valley for everyone: flat-ish ground, never in the river, never crowding a pad or
the cache. Walk up, pick, eat — a quarter of a stomach — and the bush regrows on its own
90-second clock. Food out there is renewable; your rations are not. And the second
supply cache across the river now stocks two more. The loop this creates is the right
one: getting hungry sends you *ranging* — and ranging is how you find salvage, learn
terrain, and notice smoke early.

**Stamina.** The fourth vital. Hold Shift (or jam the touch stick to its rim) and you
sprint at over half again your pace — for about seven seconds of full wind. Jumping
takes a bite too. Ease off and it comes back, fastest standing still, at half speed if
you're hungry or parched — the needs web pulling on itself, which is the whole point of
a survival sim. Run it to zero and you're *winded*: no sprint, no jump, until you catch
your breath. Sprinting is for the moment the drone pings smoke and every second of a
young fire counts. Now covering ground costs something, which makes station placement
matter even more.

Suite: 28 → 32 on-canvas tests, green in a real browser. And the best verification
again came free: the game loaded the field save — day 3, 275 points, 95% forest, real
scars on the hills — clean through three increments of new systems.

Next is the keystone: stations and drones that degrade and need tending. The part of
this game that is secretly a Raspberry Pi on a workbench.

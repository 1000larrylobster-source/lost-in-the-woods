# devlog 004 — the body has stakes now

Increment two of the survival sim, and it's the one that turns meters into consequences.

**Health.** A third vital under hunger and thirst. Run either need to zero and health
starts to wear — dehydration faster than starvation, the way it really goes. Keep
yourself fed and watered and it slowly knits back. No potions, no pickups: recovery is
just taking care of yourself, which is the whole theme.

**Gravity.** Until tonight the ranger's feet were glued to the terrain — walk off a
cliff and you'd just... descend, like the mountain was an escalator. Now there's real
vertical physics: walk off an edge and you fall. Press Space (or the new ▲ button on
touch) and you hop about a meter — enough for logs and ledges, nothing floaty. It's a
small thing that changes how the whole valley feels underfoot.

**Falls hurt.** Up to about three meters, you land clean. Past that, the impact takes a
bite out of you that scales with the drop. The ridge pad — best line-of-sight in the
valley — is now also the place you can genuinely hurt yourself getting down from in a
hurry. Terrain reading was already the game; now it has teeth on the way down too.

**Fire hurts.** Stand inside the flames and your health burns with the trees. You can
still hold a firebreak from a safe distance — but wading into a burning cell to shave
seconds now costs what it should. The verified numbers: two seconds in the flames takes
about a fifth of your health, and the damage stops the moment you step clear.

**Blacking out.** Hit zero and the screen goes dark. You wake at the ranger cache —
weaker, needs part-restored, and here's the part that matters: **the fire didn't wait.**
The valley kept burning while you were down. Death isn't a reset, it's absence, and
absence is the one thing a watch can't afford.

And the forest remembers your body now too: health, hunger, thirst, and rations ride
the same save file as the scars. Bonus from tonight's verification: the new code loaded
a real old-format save from this evening's playtest cleanly — day 2, 12% coverage,
station standing — with the new vitals slotting in at full.

Suite: 22 → 28 on-canvas tests, all green, run in a real browser. Every beat — the hop,
the 9-meter drop, the flames, the blackout wake — asserted and screenshotted before it
counted.

Next: the keystone — stations and drones that degrade and need tending. The part of the
game that's secretly the Pi on the bench.

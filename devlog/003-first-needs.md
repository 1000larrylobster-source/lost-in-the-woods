# devlog 003 — you played it, so the game grew

First Watch went from "built" to "played." It held up. And playing it did the thing
playing always does: it turned a finished level into a list of everything it isn't yet.

The notes came in a rush — camera, jump, inventory, food and water, tower and drone
maintenance, shelter, fire and fall damage, animals, sleep. That's not a to-do list,
it's three different games trying to be born, and the job was to sort them before
writing a line of code:

- **Feel** — the camera, jump. Cheap, universal, no argument.
- **The network as survival** — panels foul, batteries sag, drones run dry, the mesh
  drops. Tending the forest's eyes across the valley. This is the part that's secretly
  the real Pi hardware, so this is where the depth belongs.
- **Character survival** — food, water, warmth, sleep. Genre staples that either sharpen
  the game or bury it under six meters that have nothing to do with fire.

That last bucket was a fork, and it's the same fork that sent this game down the wrong
road twice before, so it got made on purpose instead of by accident: **full
survival-sim.** Real needs, real depth. The rule that keeps it from becoming Generic
Woods Survival #4000: the network is what makes surviving *matter*. The same drones that
hunt smoke spot the deer you'd hunt and the storm rolling in. The station is your
lifeline. Surviving funds the watch; the watch makes surviving possible.

## what shipped this session

**The camera actually follows you now.** It was a manual orbit — you had to drag it to
face where you were walking. Now it eases in behind your heading, Ocarina-style, and
hand-steer still wins for a beat after you let go. One line of the design doc always
said "third-person"; now the camera agrees.

**You get hungry and thirsty.** Two needs that drain on a clock — thirst in about four
minutes, hunger in seven. Kneel at the creek to drink. Eat a ration back at the cache or
any station you've raised. Run either one to empty and the valley slows your legs. It's
the floor the rest of the sim stands on: warmth, sleep, stamina, and a health bar all
bolt onto this.

Same discipline as Level 1: every beat is a test that runs on the canvas itself. The
suite went 17 → 18 → 22, all green, and every new system was screenshotted and read
before it counted — the ration prompt, the two meters, the camera sitting where it
should. Next: the health layer that gives an empty stomach real teeth, then the
maintenance loop — the part that's really the hardware.

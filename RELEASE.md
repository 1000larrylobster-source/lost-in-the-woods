# Lost in the Woods — v1.0 "The Range"

One self-contained HTML page — no install, any browser, desktop and touch.

**Play:** open `index.html`, or unzip `dist/lost-in-the-woods-level1.zip` and open the
`index.html` inside. **Publish:** see `release/ITCH-PAGE.md` (copy, price, checklist).

## What the game is

You wake lost in a valley at dusk. You build the forest's eyes: towers assembled from
a BASE, SCAFFOLD, ANTENNA, and SOLAR PANEL you find where they fell and haul on your
back, one at a time — then a drone built from frame, rotors, battery, and camera. The
drones hunt the first curl of smoke. Fires you miss burn forest that stays burned —
the save file IS the forest. The people you rescue come back at first light and stay.

Ten regions, one Range, one year: living wind, night fires and NoIR eyes, elk you
stalk downwind, storms that ground your drones and take your antennas, snow that
buries panels, drought embers that jump your firebreaks, dry lightning walking in
threes, a closed parts economy where you strip your own live towers — and a fire
season finale of ignition waves, three dawns long.

## Controls

- **Move** WASD/arrows · stick on touch — **Sprint** Shift · stick to the rim
- **Jump** Space · ▲ on touch — **Interact** E · prompt button
- **Camera** follows you; drag/swipe to steer
- Region select for testing: `?region=N` (1–10) · Test suite: `?test=1`

## Survive · Tend · Grow

Five vitals (health, hunger, thirst, stamina, warmth). Drink at water, eat rations and
berries, hunt from downwind, sleep at camps (fires spread unwatched while you dream).
Wipe fouled panels, service worn rotors, scrape snow, re-rig storm-torn antennas —
brownouts ground drones and blind the node. Meet the coverage goal, raise the relay,
and cross the pass. Recruits settle by your towers and work: DALE hauls parts to your
active build overnight.

## Verification

`?test=1` runs **57 deterministic on-canvas tests** — the full assembly journey, the
maintenance loop, every survival vital, every region mechanic (wind, NoIR, herd,
storm, snow, embers, lightning, strip, siege), story cards, travel gating, the eggs.
All green in a real browser before every release.

## The real hardware

The tower is a Raspberry Pi 5 + AI HAT fire-detection node (HARDWARE.md) with a
camera, solar panel, and LoRa antenna. The NoIR camera in region 3 is a real part.
The failure modes in the game are the node's real failure modes. One design, two
harvests — the game and the field kit. Built in public: `devlog/`.

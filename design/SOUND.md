# Lost in the Woods — Sound Spec v1 (all WebAudio, zero samples)

Everything below is synthesized at runtime from oscillators and noise buffers. One palette, one tuning, one file. This spec extends what already ships (wind, day birds, night crickets, proximity fire crackle, detection ping) — nothing existing is thrown away; it gets re-tuned per map and joined by the rest.

---

## 0. The palette — three rules that keep it coherent

1. **Everything pitched sits on one ladder.** D major pentatonic, rooted low: `D2 73.42 · A2 110 · D3 146.83 · E3 164.81 · F#3 185.0 · A3 220 · B3 246.94 · D4 293.66 · E4 329.63 · F#4 369.99 · A4 440 · B4 493.88 · D5 587.33 · E5 659.26 · A5 880`. Pings, beeps, clanks' confirmation tones, the motif, recruit calls — all snap to this ladder. That's why a mesh chirp and a campfire and the finale theme feel like one place.
2. **Everything unpitched is filtered noise.** Wind, rain, water, footsteps, crackle, scrapes — pink/brown/white noise through biquads. No raw white noise ever reaches the ear un-filtered.
3. **Nothing bright survives the master.** A high-shelf cut on the master bus is the "analog varnish": the whole game sounds like it was recorded on warm tape. If a sound needs to cut through (detection ping), it earns it with envelope, not brightness.

**The audible-telemetry rule (design keystone):** healthy hardware sounds *in tune* (on the ladder, clean). Degrading hardware drifts **flat (up to −80 cents) and rough (AM wobble + added noise)**. Repair snaps it back to pitch. A player with the sound on can hear a sick tower across the valley before they read a single meter. This maps 1:1 to real telemetry, which is the whole game.

### 0.1 Bus architecture

```
[ambience bus] ─┐
[sfx bus]      ─┼→ [duck gain] → [saturator (tanh, k=1.2)] → [shelf: highshelf 6kHz −4dB]
[ui bus]       ─┘        ↑            → [compressor: thr −18, knee 24, ratio 3,
[stinger bus] ───────────┴──────────→    att .02, rel .25] → destination
[verb send] → ConvolverNode(IR) → master (verb return gain 0.18)
```

- **Stingers duck ambience:** on any stinger, `ambience.gain.setTargetAtTime(0.5, t, 0.3)`, restore over 1.5 s after.
- **Verb IR is generated:** 1.8 s stereo buffer, each sample `(Math.random()*2-1) * Math.pow(1 - t/1.8, 2.2)`. One convolver total. Send levels: stingers 0.30, mechanics 0.12, ambience 0.05, footsteps 0.04.
- **Mix targets (linear gain at the bus):** ambience beds 0.05–0.12 · footsteps 0.10 · mechanic SFX 0.18–0.30 · warnings 0.12 · stingers 0.30 · detection ping 0.25 (it stays king).

### 0.2 Shared kit (JS, written once — every recipe below references these)

```js
const AC = new (window.AudioContext || webkitAudioContext)();
addEventListener('pointerdown', () => AC.resume(), { once:true }); // mobile unlock

// --- noise buffers, computed once at boot ---
function noiseBuf(color, secs=2) {
  const b = AC.createBuffer(2, AC.sampleRate*secs, AC.sampleRate);
  for (let ch=0; ch<2; ch++) { const d = b.getChannelData(ch);
    let b0=0,b1=0,b2=0,last=0;
    for (let i=0;i<d.length;i++){ const w = Math.random()*2-1;
      if (color==='white') d[i]=w;
      else if (color==='pink'){ b0=.997*b0+.029591*w; b1=.985*b1+.032534*w;
        b2=.95*b2+.048056*w; d[i]=(b0+b1+b2)*.55; }
      else { last=(last+.02*w)/1.02; d[i]=last*3.5; } } }        // brown
  return b;
}
const PINK=noiseBuf('pink'), WHITE=noiseBuf('white'), BROWN=noiseBuf('brown');

function noise(buf=PINK){ const s=AC.createBufferSource(); s.buffer=buf; s.loop=true; return s; }
function osc(type,f){ const o=AC.createOscillator(); o.type=type; o.frequency.value=f; return o; }
function flt(type,f,q=1){ const x=AC.createBiquadFilter(); x.type=type;
  x.frequency.value=f; x.Q.value=q; return x; }
function env(g, t, a, peak, d, sus=0.0001){       // attack→decay envelope on a GainNode
  g.gain.setValueAtTime(0.0001,t); g.gain.exponentialRampToValueAtTime(peak,t+a);
  g.gain.exponentialRampToValueAtTime(Math.max(sus,0.0001), t+a+d); }
function chain(...n){ for(let i=0;i<n.length-1;i++) n[i].connect(n[i+1]); return n[n.length-1]; }

// --- the two signature voices ---
// WOOD: marimba-ish strike. Used for the motif, UI confirms, recruit calls.
function wood(f, t, g=0.2, dur=0.7, bus=SFX){
  const o1=osc('sine',f), o2=osc('sine',f*3.9), g1=AC.createGain(), g2=AC.createGain();
  env(g1,t,0.002,g,dur); env(g2,t,0.002,g*0.2,dur*0.3);
  chain(o1,g1,bus); chain(o2,g2,bus);
  const tk=noise(WHITE), tg=AC.createGain(); env(tg,t,0.001,g*0.5,0.008);
  chain(tk, flt('bandpass',2000,1), tg, bus);
  [o1,o2,tk].forEach(n=>{n.start(t); n.stop(t+dur+0.1);});
}
// METAL: FM clank for tower hardware. index decays → "ring".
function metal(fc, fm, idx, t, g=0.2, dur=0.4, bus=SFX){
  const c=osc('sine',fc), m=osc('sine',fm), mg=AC.createGain(), og=AC.createGain();
  mg.gain.setValueAtTime(fm*idx,t); mg.gain.exponentialRampToValueAtTime(1,t+dur);
  m.connect(mg); mg.connect(c.frequency); env(og,t,0.002,g,dur);
  chain(c,og,bus); m.start(t); c.start(t); m.stop(t+dur); c.stop(t+dur);
}
```

**Spatialization (cheap, 60 fps-safe):** no HRTF PannerNodes. Each world emitter gets `StereoPannerNode` (pan = sin of camera-relative angle) + distance gain `1/(1+d/8)` + one lowpass whose cutoff falls with distance `8000/(1+d/12)`. Update these with `setTargetAtTime(v, t, 0.1)` at ~10 Hz, never per frame.

**Performance budget:** ≤ 24 live sources at once; pool and reuse gain/filter nodes for footsteps and crackle pops; all randomized "tick" textures (rain droplets, cicadas, crackle) are *baked into looped buffers at boot* (sparse + dense variants, crossfade for intensity) instead of scheduled per-event; ambience LFOs are real OscillatorNodes into gain/frequency AudioParams, zero JS per frame.

---

## 1. Ambience — the ten maps

### 1.1 The wind engine (shared, re-tuned per map)

The existing wind stays and becomes parametric — it is the through-line of the whole Range:

```
pinkNoise(loop) → HP(hp) → LP(lpCenter, LFO ±lpMod @ 0.07Hz sine + slow random walk)
              → gustGain(base, swells: +gustDepth over 2–4s, every gustEvery ±50% s)
              → pan drift (StereoPanner, LFO 0.03Hz, ±0.2) → ambience bus
```

| # | Map (draft names, Jon renames) | HP | LP center ± mod | base gain | gust every | character |
|---|---|---|---|---|---|---|
| 1 | First Valley (L1) | 80 | 600 ± 250 | 0.09 | 25 s | the shipped bed; home |
| 2 | The River Fork | 80 | 500 ± 150 | 0.06 | 35 s | wind yields to water |
| 3 | Ridgeback | **600** | 3000 ± 800 | 0.13 | 12 s | exposed, hissing, relentless |
| 4 | The Old Burn | 120 | 450 ± 100 | 0.05 | 40 s | thin; the quiet is the point |
| 5 | Cedar Marsh | 60 | 400 ± 100 | 0.05 | 45 s | still air, heavy with insects |
| 6 | Storm Pass | 100 | 900 ± 500 | 0.11 | 9 s | violent gusts under the rain |
| 7 | High Meadows | 100 | 700 ± 200, flutter LFO 1.2 Hz shallow | 0.08 | 20 s | grass-hiss, warm |
| 8 | Snowline | 60 | **300 ± 60** | 0.05 | 30 s | muffled, felted |
| 9 | The Dry Canyon | 150 | 800 ± 400 + white HP 2k layer @ 0.012 | 0.10 | 14 s | gritty, thirsty |
| 10 | Fire Season | 150 | 900 ± 600, all LFO rates ×2 | 0.12 | 7 s | restless; wind is the enemy now |

**Map transitions:** one AmbienceBus per map config; crossfade 4 s on region change. **Day/night** (all maps): birds fade out over dusk (60 s), crickets fade in; wind base gain −20% at night. **Weather is orthogonal:** the rain layer (map 6's recipe) may visit maps 1–8 at lower intensity.

### 1.2 Per-map signature layers

**Map 1 — First Valley.** Existing bed (wind + day birds + night crickets) + add the creek where the player drinks:
```
creek: whiteNoise → BP 1200 Q0.8 (g .04) ∥ BP 2800 Q1.5 (g .02, gain LFO 0.3Hz ±30%)
       → distance-attenuated emitter at the river spline
```

**Map 2 — The River Fork.** Water forward, two beds:
```
rapids: whiteNoise → BP 900 Q0.5 → g .07 (steady)
gurgle: brownNoise → LP 500 → BP(f: LFO 0.4Hz wandering 250–380, Q4) → g .04
kingfisher (day, every 20–50s): sine 3200→1800 expRamp 120ms, ×3 @ 90ms, g .05
```

**Map 3 — Ridgeback.** The high-pass wind above, plus:
```
whistle (only during gust peaks): sine, freq glide 800→1400→1100 over gust length,
        g .015 (barely there), verb send 0.15
raptor (every ~90s): sawtooth → BP 1200 Q3, freq 1400→900 over 0.8s,
        gain env A .05 D .7, g .05, verb 0.4 — far away, always
```

**Map 4 — The Old Burn.** An old scar; the forest holding its breath. Bird layer OFF. Signature:
```
snag-tones: pinkNoise → two narrow BP (Q 8) at 220 & 330, each freq walking ±15Hz
        over minutes, g .02 — wind finding hollow trunks
creak (every 15–40s): sawtooth 80Hz, AM sine 13Hz depth 80%, pitch bends ±20%
        over 0.7s, → LP 600 → g .06, pan random
one far bird (day, every ~2min): the standard bird chirp, g .02, verb 0.5 —
        life at the edge of the burn, not in it
```

**Map 5 — Cedar Marsh.** Dense small life:
```
frog chorus (dusk/night): square 90Hz → LP 1400 → gain gated by square LFO 12Hz
        (depth 100%), bursts 0.6s on / 1–3s off, 3 emitters panned wide, g .04 each
plop (every 8–20s): sine 600→200 expRamp 60ms, g .08 + tiny WHITE tick BP 1k
dragonfly pass (day, rare): sawtooth 180Hz, AM 40Hz, freq glide ±10% while
        panning L→R over 1.5s, → LP 2k, g .03
insect bed: cricket recipe from L1, doubled density, running day AND night
```

**Map 6 — Storm Pass.** The rain/storm kit (reused everywhere weather goes):
```
rain bed:  whiteNoise → HP 400 → LP 4000 → g .05–.14 (intensity param)
droplets:  baked 2s loop of random 4ms WHITE bursts → BP 3000 Q2;
           two bakes (20/s, 60/s), crossfade by intensity, g .05
thunder (event): brownNoise burst → LP(f: 120→60 over 2.5s) → gain env:
           A .01 D 2.5 with 2–3 sub-swells (+re-trigger at .4/.9s, ×.6/.35),
           g .5 × distance att; delay after flash = dist/340s; LP lower when far;
           verb 0.5. Follow with rain intensity +30% for 20s.
distant bed: brownNoise → LP 90 → g .012 constant — the storm never quite leaves
```

**Map 7 — High Meadows.** The one warm, generous map — earned before the turn:
```
bees:  sawtooth 190–240Hz (random walk) → LP 900 → AM sine 25Hz depth 30% → g .02
grasshoppers (day): baked impulse train 8/s → BP 5000 Q5 → g .025, 2 emitters
lark (day, every 15–30s): sine with FM chirps — freq steps up the ladder
       D5→E5→A5, 60ms each, vibrato 6Hz, g .06 — the happiest bird in the game
```

**Map 8 — Snowline.** Silence as identity. Ambience bus −40%; bird layer OFF; cricket layer OFF.
```
ice ticks (every 3–9s): sine 2400–4000Hz (random), env A .001 D .015, g .06,
        pan random, verb 0.3 — tiny, dry, crystalline
ice whoop (rare, every 2–4min): sine 400→60Hz expRamp 1.2s, g .05, verb 0.5 —
        the lake groaning; unsettling on purpose
raven (day, every ~90s): sawtooth 400Hz → BP 700 Q2, AM 30Hz, 0.25s ×2, g .05
snow-wind: the table's muffled bed; add BROWN → LP 200 g .02 under it
```

**Map 9 — The Dry Canyon.** Drought. **Design note: no water sound exists anywhere on this map** — the absence of the creek band the player has heard for eight maps IS the dread.
```
cicadas: pulse train baked loop — square 4500Hz carrier, AM square 220Hz,
        gain swells 6s up / 4s down (LFO), g .04 day only
grit:   whiteNoise → HP 2000 → g .012, gain follows gust envelope — sand in the wind
dry thunder (rare): map-6 thunder, LP capped at 400, NO rain follows — a promise broken
```

**Map 10 — Fire Season (finale).** The whole Range. Wind table above (restless), map-9 cicadas at half gain, plus:
```
haze drone: sine D2 73.4 + sine A2 110 + sine A2 110.7 (beating) → LP 300 →
        g 0 … .04 scaled by ACTIVE FIRE COUNT — the ambience itself is the threat meter
crackle priority: all fire-crackle emitters +3dB and audible 1.5× farther
motif surfacing: every ~3min of calm, one wood() note from the accrued motif,
        g .04, verb 0.5 — the theme is in the trees now (see §3)
```

---

## 2. Mechanic voices

### 2.1 Tower assembly — four mounts, four ladder notes

**The idea that ties it together:** the four tower components confirm on **D3 · E3 · F#3 · A3** — the same pitch classes as the story motif (§3). Mounting a tower literally builds the theme, one note per part. Order-independent; each part owns its note.

**BASE — the heaviest sound in the game** (concrete + battery box; the Pi lives here):
```
thud:    sine 90→48Hz expRamp 80ms → env A .002 D .25, g .5
body:    pinkNoise → LP 300 → env A .002 D .12, g .3
settle:  3× WHITE ticks (8ms → BP 800 Q2) at +120/+210/+280ms, g .12/.08/.05
confirm: wood(D3=146.83) at +350ms, g .18
```

**SCAFFOLD — the mast rings** (double metal strike):
```
clank:   metal(fc 620, fm 950, idx 3, dur .5), g .3
echo:    same at +120ms, fc 620×1.02, g .12 (a second bar knocking the first)
body:    pinkNoise → LP 500 → env A .002 D .08, g .15
confirm: wood(E3=164.81) at +400ms, g .18
```

**ANTENNA — small, bright, springy** (the LoRa whip wobbles when it seats):
```
tink:    metal(fc 1800, fm 2900, idx 2, dur .18), g .2
wobble:  sine 300Hz, freq LFO 6Hz depth 40Hz decaying to 0 over .6s →
         env A .005 D .6, g .1  — boing of a whip antenna
confirm: wood(F#3=185.0) at +300ms, g .18
```

**SOLAR PANEL — glassy slide-and-seat:**
```
slide:   whiteNoise → BP 1400 Q3 → gain ramp 0→.08→0 over .2s (the scrape in)
glass:   3 sines [1320,1650,1980] → shared env A .003 D .3, g .06 each
frame:   metal(fc 220, fm 340, idx 2.5, dur .3), g .2
confirm: wood(A3=220) at +350ms, g .18
```

**TOWER BOOT** (fires only when all four are mounted — the payoff):
```
arpeggio: wood(D3), wood(E3), wood(F#3), wood(A3) at 80ms spacing, g .2
power:    sine 60→120Hz expRamp .8s, hold at 120, env A .8 sustain .04 (the idle hum
          every live tower keeps, g .008 as a proximity emitter — you can HEAR uptime)
inverter: pinkNoise → BP 400→900 over 1.2s Q2 → env A .3 D 1.2, g .06
self-test: existing detection ping ×1 at +1.8s, g .15 — the eyes open
```

### 2.2 Drone assembly + boot — the tower's ladder, one octave up

FRAME **D4** · ROTORS **E4** · BATTERY **F#4** · CAMERA **A4**. Same grammar, lighter hands:

```
FRAME:   triangle 400Hz env A .002 D .08 g .2  +  WHITE tick BP 2000 Q1 8ms g .1
         → wood(D4) confirm
ROTORS:  ratchet — 3× WHITE ticks BP 3000 Q2, 30ms apart, g .1 each
         + motor twitch: sawtooth 80→0Hz over .1s → LP 600, g .08
         → wood(E4) confirm
BATTERY: two-stage click — WHITE tick BP 2500 6ms g .12, then sine 250Hz
         env A .002 D .1 g .2 at +40ms (the clunk of it seating)
         + charge hint: sine 900→1400Hz .3s, g .02 → wood(F#4) confirm
CAMERA:  servo ×2 — sawtooth 2200Hz, AM 90Hz, 60ms each, 100ms apart, g .06
         + focus step: sine 1200Hz ±80Hz in 3 steps of 40ms, g .04
         → wood(A4) confirm
```

**DRONE BOOT + ROTOR SPIN-UP** (real ESCs beep on arm — so does this one, on the ladder):
```
esc arm:  square → LP 4000, three 90ms beeps D5·E5·A5 at 150ms spacing, g .08
spin-up:  sawtooth f 90→220Hz expRamp 1.6s  ∥  square f×1.003 (3-cent detune)
          → LP 2500 → gain 0→.12 over 1.6s
flight loop: same pair held at 220Hz (travel) / 150Hz (hover), freq LFO 0.5Hz ±3%
          (wander), pan + distance from world position — the patrol is audible
rotor wear (degraded): add WHITE tick BP 1500 every rotor rev (period 1/f s),
          g up to .04 with wear; wander LFO depth ±3%→±8%. Flat-and-rough rule.
```

### 2.3 Mesh relay ping — the LoRa chirp

Real LoRa modulation is chirp spread spectrum: **up-chirps.** So is ours.

```
tx chirp: sine 880→1760Hz expRamp 90ms, env A .005 D .09, g .12 — ×3 at 110ms
          spacing, each ×0.6 quieter; data tail: WHITE → BP 2000 Q2, 60ms, g .03
rx reply: the DOWN chirp 1760→880, same shape, played AT THE RECEIVING TOWER's
          world position, delayed 300ms per hop — you hear the mesh talk its way
          across the valley, tower to tower, in stereo space
degraded antenna: chirp glide quantized to 6 hard steps (setValueAtTime staircase)
          + 30% chance a repeat drops out entirely — audibly struggling to link
```

(The existing **detection ping** stays king of the mix at g .25; recommend it live on **A5 880** so it shares a root with the chirp — the network has one voice.)

### 2.4 Degradation warnings — flat and rough

Every live tower emits a **status tick** each 10 s (proximity-only, g .05): its four component notes as 20 ms wood blips, 60 ms apart. Healthy = clean and in tune. Degraded components go **flat and rough** in that tick, plus their own warning voice:

```
dusty panel (dry buzz): sawtooth 100Hz → LP 400 → AM square 8Hz (depth 40%→90%
        with dust level) → env A .05 D .5, g .1 — rides the status tick;
        panel's A3 blip drifts flat with dust (−0…−80 cents)
sagging battery (slow beep): sine, 150ms, every 3s while below threshold, g .1;
        pitch = B4 healthy-warning → A4 sagging → F#4 critical, and each step
        also −20 cents — the tower goes flat as the cells go soft
storm-bent antenna: relay chirp degrades as §2.3; F#3 blip flat + AM 6Hz
worn rotors: click train + wobble as §2.2; drone's E4 blip flat + rough
```

### 2.5 Repair sounds

Each repair = its **work texture**, then the universal completion: the component's ladder note played clean by `wood()` + a tiny up-chirp `sine 880→1174 (A5→D6), 60ms, g .06` — snapped back to pitch, audibly.

```
brush panel:  whiteNoise → BP 1200 Q2 → 3 wipe strokes (gain 0→.1→0 over .4s),
              alternating pan L/R
wrench (scaffold/frame): ratchet bursts — WHITE ticks BP 2800 Q2 at 12/s,
              3 bursts of .3s, g .08
battery swap: BATTERY click pair from §2.2 ×2 (out, then in), .6s apart
antenna re-rig: wobble voice from §2.1 ×2 + one zip: WHITE → BP 4000,
              80ms gain ramp, g .06
```

### 2.6 Recruits — greeting motifs by role

A person is the one thing we don't fake with a voice. A recruit's greeting is a **two-note call on the wood voice** — an interval from the motif's pitch set — plus a breath of presence. Entering their camp radius plays it softly; assigning a role plays it firmly.

```
Watcher: D4→A4 (rising 5th — steady eyes)         Forager: E4→F#4 (busy 2nd)
Runner:  A4→B4 quick, 90ms apart (on the move)    Tech:    F#4→A4 (the fixer's 3rd)
each: wood(n1,g .12); wood(n2, +180ms, g .15); presence: pinkNoise → LP 500 →
      env A .1 D .4, g .02 (someone shifting their weight, nothing more)
camp emitter: their interval re-plays every ~2min at g .03 + campfire (below)
```

### 2.7 Campfire — the warm cousin of the wildfire

The wildfire crackle (shipped) is hissy, dense, high-passed — a threat. The campfire is **sparse, round, low** — safety. Same DNA, opposite message:

```
bed:    brownNoise → LP 600 → g .05 (constant, cozy)
warmth: sine 65Hz, gain LFO 0.3Hz ±30%, g .012 — felt more than heard
pops:   WHITE 8ms bursts → BP 1800 Q2, random 3–8/s, random g .02–.08, pan ±0.3
sap pop (every 10–25s): sine 300→150Hz 40ms, g .12 — the big satisfying one
```

### 2.8 Eating / drinking

```
ration bite ×3: WHITE 25ms → BP 2000 Q1 (crunch) + sine 120Hz 40ms (jaw), g .12,
        400ms apart, each ±10% rate/pitch random
berry bite ×2: softer — WHITE 30ms → LP 700 + sine 400Hz 20ms blip, g .08 (wet)
swallow (after last bite): sine 300→180Hz 120ms + BROWN → LP 200, 100ms, g .1
drink ×3 gulps: sine wandering 250–450Hz (random walk), AM 6Hz ∥ WHITE → BP 500 Q2;
        gain pulses 250ms per gulp, g .12; each gulp's center pitch DROPS ~15%
        (a vessel filling) — plays over the map's creek band, which is already there
```

### 2.9 Footsteps by surface

Alternate L/R pan ±0.15; rate from speed; every hit ±10% pitch/gain random; sprint +3 dB; landing-from-jump = surface voice ×1.6 + extra thump. Pool 4 voices.

```
dirt:  pinkNoise 60ms → LP 700 (g .1) + sine 90Hz 40ms thump (g .08)
rock:  WHITE 35ms → BP 1400 Q1.2 (g .1) + 30% chance pebble scatter:
       2–3 WHITE ticks BP 2500, 20ms apart, g .03
snow:  8 micro-ticks over 70ms (baked) → BP 900 Q1 (the creaky compress, g .1)
       + soft sine 80Hz thump g .05
water: WHITE 120ms → BP 1000 Q0.7 with LP sweep 2000→400 (g .12) + droplet
       ticks at +80/+140ms (BP 3000, g .03); deep water = add wading loop
       (gurgle recipe from map 2 at g .04) while submerged past the knee
grass (meadows): WHITE 80ms → BP 600 Q0.5 swish, g .07, thump g .04
```

---

## 3. Story stingers — and the motif that builds across ten maps

### 3.1 The Watch motif

Six events, D major pentatonic, always the wood voice leading:

```
A3 (220) → D4 (293.66) → E4 (329.63) → F#4 (369.99) → A4 (440)  …  D4 (293.66)
  wake       build         watch          rise          the whole    and stay
                                                        range
```

A rising fourth to wake, steps to climb, the octave A when the Range is watched — then **falling back to D: the lost don't leave the woods.** Tempo ~84 BPM everywhere it appears.

**The accrual rule (how it builds across maps):** the player only ever hears as much of the motif as they've earned. Maps 1–3: notes 1–3. Maps 4–6: notes 1–4. Maps 7–8: notes 1–5. Map 9: notes 1–5, with note 6 *teased* −40 cents flat (unresolved — the fire season is coming). Map 10: all six, in tune, resolved. Tower assembly (§2.1) uses the same pitch classes, so every tower raised has been rehearsing the theme since map 1.

### 3.2 The stingers

**Map-open card:**
```
pad:   2 triangles D3 + A3 (+0.5Hz detune) → LP 800 → gain swell 0→.06 over 4s
motif: accrued fragment, wood(), 500ms spacing, g .2, verb .3
       — incomplete on purpose; the map isn't done and neither is the tune
```

**Map-complete:**
```
motif: full accrued run + the NEXT note faint and −40c flat at the end, g .06
       (the next region, calling from over the ridge)
pad:   3 sawtooths D3/A3/D4 (±0.4Hz detunes) → LP 1200 → swell A 1.2s, g .05
answer: one relay rx-chirp (§2.3) at +2.5s, g .08, verb .4 — the mesh acknowledges
```

**Fire-caught-early** (relief, not fanfare — it was one tree, and that's the point):
```
wood(E4, g .2); wood(A4, +140ms, g .25)   — the "caught it" rising fourth, twice fast
one last crackle pop dying (§2.7 pop at g .06)
exhale: pinkNoise → LP 500 → gain .06→0 over .8s
```

**Fire-escaped** (the motif falls back down and goes dark):
```
descent: wood A4 → F#4 → D4 → A3, 600ms spacing, g .2, with a shared LP on the
         stinger bus closing 2000→500 across the four notes
after:   sine D2 73.4Hz swell 0→.06 over 2s, decay 4s;  duck ambience −8dB for 3s
card ("The forest remembers"): a single wood(D3, g .15, dur 2.0), verb .5, alone
```

**Blackout:**
```
heart:  sine 55Hz double-thump (2 env hits 90ms apart), tempo 60→30bpm over 3s, g .3
world:  LP on ambience bus sweeps 8000→200 over 2s (the world going far away)
last:   wood(D4 at −60 cents, g .1) — the player's own note, gone flat
        …silence 1.5s…
wake:   LP opens 200→8000 over 3s; wood(A3) clean, g .12; birds return FIRST,
        wind second — the gentlest possible "still here"
```

**Finale theme (map 10, ~20 s, three swells)** — everything the player built is in the band:
```
lead:    full 6-note motif, wood voice, octave-doubled (D4+D5 layers), g .25
pad:     3 detuned saws D3/A3/D4 → LP 1200, slow swells, g .06
         + every recruited role's interval (§2.6) stacked in as sustained triangles,
         g .015 each — literally everyone you saved, holding one chord
bass:    sine D2 pedal, g .08, swelling with each pass
drums:   the drone rotor pair (§2.2) gain-gated to 8th notes at 84bpm, g .05
         — the machines themselves are the drum line
sparkle: relay chirps (§2.3, g .04) on the off-beats, panned at real tower positions
shape:   pass 1 lead+bass · pass 2 +pad+drums · pass 3 everything, then all drop out
         except one wood(D4) and the wind — which has been the real instrument all along
```

---

## 4. Ship checklist

- [ ] Shared kit (§0.2) + buses + generated IR + baked noise/tick loops at boot
- [ ] Wind engine parametric; 10 map configs from the §1.1 table; 4 s crossfade
- [ ] Per-map signature layers (§1.2); weather layer orthogonal; day/night rules
- [ ] 4 tower mounts + boot on the D-E-F#-A ladder; 4 drone mounts + ESC boot octave up
- [ ] LoRa chirp tx/rx with per-hop spatial delay; detection ping moved to A5
- [ ] Flat-and-rough degradation on status ticks + 4 warning voices; repair textures + snap-to-pitch confirm
- [ ] Recruit intervals, campfire, eat/drink, 5 footstep surfaces
- [ ] Motif accrual state in the save file (notes earned ride with the scars)
- [ ] All stingers; finale arrangement
- [ ] `?test=1` audio assertions: render each recipe offline (OfflineAudioContext), assert non-silent buffers + peak levels within mix targets; mobile unlock on first touch
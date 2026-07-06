# Edge-AI Node — Pi 5 + AI HAT+ 2

A local-AI box that runs vision and small generative models on-device: the "agent in a box."
This is the lost-in-the-woods game's real hardware node (hiker detection, smoke/fire detection,
LoRa mesh) and doubles as edge person/vehicle detection for the access-control vertical.

---

## The two constraints that shape the build

1. **The AI HAT+ 2 uses the Pi 5's PCIe port, so there is no NVMe.** You cannot run an M.2 SSD
   HAT and the AI HAT at the same time (same connector). Boot from microSD or a USB SSD. For an
   inference node that is fine.
2. **The HAT occupies the board stack**, so add-ons like LoRa attach over USB or spare GPIO, not
   as a second stacked HAT. The mesh radio is a companion, not a HAT (see field-node tier).

---

## Core AI node

| Part | Spec / search term | Qty | Est. cost |
|---|---|---|---|
| Raspberry Pi 5, **8GB** | "Raspberry Pi 5 8GB" | 1 | $80 |
| **AI HAT+ 2 (40 TOPS)** | "Raspberry Pi AI HAT+ 2" — Hailo-10H, 8GB, runs local LLMs/VLMs | 1 | $130 |
| Official Active Cooler | "Raspberry Pi 5 Active Cooler" (mounts under the HAT; Pi 5 + NPU runs hot) | 1 | $5-8 |
| 27W USB-C PD power supply | "Raspberry Pi 5 27W PSU" (5V/5A — the NPU needs the headroom) | 1 | $12 |
| MicroSD 64GB A2 | "Samsung EVO 64GB A2" (boot; NVMe is blocked by the AI HAT) | 1 | $10-12 |
| Camera Module 3 (Wide) | "Raspberry Pi Camera Module 3 Wide" (autofocus, HDR; wide FOV for scanning a scene) | 1 | $35 |
| HAT-compatible case | "Raspberry Pi 5 AI HAT case" (must clear the HAT + cooler stack) | 1 | $20-25 |
| Ethernet cable | wired for the base station; field nodes go wireless | 1 | $5 |

**Core subtotal: ~$300**

---

## Field-node tier (the game / mesh) — optional add-on

| Part | Spec / search term | Qty | Est. cost |
|---|---|---|---|
| Meshtastic LoRa board | "Heltec LoRa 32 V3" (US 915MHz) — the mesh radio, runs as a USB/serial companion | 1 | $25-30 |
| NoIR camera (low light) | "Camera Module 3 NoIR" — swap in for night/low-light hiker detection | 1 | $25 |
| LiPo battery + solar (later) | for a true off-grid field node | 1 | $30-50 |

**Field extras: +$25 (just the LoRa radio) to +$100 (full off-grid node)**

---

## Cost summary — and the "buy both" number

| | Est. cost |
|---|---|
| **AI node (core)** | ~$300 |
| **AI node + LoRa radio** | ~$325 |
| KVMNAS box (core: Pi 4 + v3 HAT + enclosure, drives later) | ~$250 |
| KVMNAS box (full: + 2×4TB mirror) | ~$425 |

**Both boxes, sensible first order:** AI node core ($300) + KVMNAS core ($250) = **~$550**, then add
NAS drives when you pick capacity. **Both, fully loaded:** ~$725.

The single biggest line either way is the AI HAT+ 2 ($130) and the NAS drives ($180+). Everything
else is small. If $550 is the reasonable line, order both cores now and add drives + the LoRa radio
as follow-ons.

---

## Software stack

1. **Raspberry Pi OS (64-bit)** on the Pi 5 — full OS, not an appliance (unlike the KVMNAS box).
2. **Hailo runtime + AI HAT+ 2 drivers** — the official stack; gets you accelerated inference.
3. **Vision models:** person detection + smoke/fire detection (start with off-the-shelf YOLO-class
   models compiled for Hailo; the game's detections run here).
4. **Local generative:** small VLM/LLM on the Hailo-10H for on-device reasoning about what the
   camera sees ("person, waving, near water").
5. **Meshtastic** on the LoRa board for the node-to-node network.

Docs: AI HAT+ 2 https://www.raspberrypi.com/products/ai-hat-plus-2/ · Hailo model zoo · Meshtastic https://meshtastic.org/

---

## Why buy this one at all (vs. just using the Mac)

The Mac runs the business agent fine. This box exists for what the Mac cannot be: a **cheap,
low-power, deployable node that sees and reasons in the field with no cloud.** That is the entire
premise of the game, and it is a real edge-AI capability for access control. It is the only reason
to spend the $300: you are buying a node you can put on a trail or a gate, not another desktop.

---

## Status

- [ ] Parts ordered
- [ ] Pi 5 + AI HAT+ 2 booted, Hailo runtime verified
- [ ] Camera person-detection running on-device
- [ ] Smoke/fire detection model loaded
- [ ] LoRa mesh: two nodes talking
- [ ] Local VLM describing the camera scene

Build log: `devlog/` in the lost-in-the-woods repo.

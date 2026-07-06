# devlog 001 — the game runs on real hardware

The tech tree in this game is not made up. Every unlockable maps to a device you can actually
build, and the edge-AI node is the spine of it.

## The node: Raspberry Pi 5 + AI HAT+ 2

The AI HAT+ 2 (40 TOPS, 8GB, runs vision-language models locally on a Pi 5) is the brain of a
field node:

- **Find lost hikers:** a camera + person-detection model running on-device. No cloud, no signal
  needed, inference at the edge.
- **Prevent forest fires:** smoke and early-flame detection from the same camera feed.
- **The mesh:** nodes talk over LoRa (long range, low power) instead of wifi, so a grid of them
  covers a valley with no infrastructure. This is the in-game "communication network" you build.
- **The drone tier:** the same detection model flown instead of fixed.

## Why this matters for the game

The game is a build-in-public project, and the hardware is real, so the devlog IS the game design
AND a hardware series at the same time. Each real node built is a game feature demonstrated. It
also rhymes with the operator's day-job trade (low-voltage / access control: person and vehicle
detection at the edge is the same discipline).

## Design implication

Progression = the real build order. Bare hands (survive) -> a radio (connect) -> a camera node
(see) -> a LoRa mesh (network) -> a sensor grid + drones (protect). The player learns the actual
system by playing it. Next: pick the engine and prototype the first-act loop (get found).

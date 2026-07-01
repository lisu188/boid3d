# Boid3D

A real-time 3D [boids](https://en.wikipedia.org/wiki/Boids) flocking simulation
built with [Godot](https://godotengine.org/) 4. Hundreds of agents move as a
flock using the three classic steering rules — cohesion, alignment and
separation — with additional boundary and wander steering for natural motion.
An orbit camera gently follows the centre of the flock.

## Running

Open the `boid3d/` folder as a project in Godot 4.6+ and run the main scene
(`Main.tscn`), or from the command line:

```sh
godot --path boid3d
```

## Controls

| Input | Action |
| --- | --- |
| `W` / `S` | Pitch the camera down / up |
| `A` / `D` | Orbit the camera left / right |
| Mouse wheel up / `E` | Zoom in |
| Mouse wheel down / `Q` | Zoom out |

## How it works

- **`Main.gd`** spawns the boids and maintains a spatial hash (keyed by integer
  grid cell) so each boid only tests nearby neighbours instead of every other
  boid. It also exposes `get_flock_center()` for the camera to follow.
- **`Player.gd`** implements a single boid. Each physics tick it gathers its
  neighbours and blends several steering forces:
  - *cohesion* — steer toward the average neighbour position;
  - *alignment* — match the average neighbour heading;
  - *separation* — push away from neighbours that are too close;
  - *boundary* — turn back toward the simulation volume near its edges;
  - *wander* — a small random drift so the flock never fully settles.

  The combined steering force is clamped by `MAX_FORCE` and applied
  frame-rate independently, then the speed is held within the
  `MIN_SPEED`–`MAX_SPEED` band.
- **`CameraGimbal.gd`** is an orbit rig (outer gimbal yaws, inner gimbal
  pitches) that follows the flock centre and scales to zoom.

## Tuning

Flock behaviour is driven by the constants at the top of `Player.gd`
(neighbour/separation distances, speed limits and the per-rule weights). The
number of boids and the spawn volume are exported on the `Main` node
(`boid_count`, `spawn_range`, `neighbor_cell_size`).

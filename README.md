# blackhole-in-godot

Real-time black hole gravitational lensing simulation with accretion disk rendering in Godot 4.5.

## Technical Overview

This project implements a physically-based black hole visualization using ray tracing and gravitational lensing. The renderer combines 3D scene backgrounds with 2D post-processing to achieve real-time performance.

## Core Features

- **Gravitational Lensing**: Ray tracing with leapfrog integration method
- **Accretion Disk**: Procedural particle-based rendering with Simplex noise
- **Dynamic Camera**: Full 6-DOF camera control with mouse look
- **Real-time Parameters**: Adjustable gravity strength, disk height, and luminosity

## Implementation

### Shader Architecture

- **Language**: GLSL (Godot Shader Language)
- **Ray Tracing**: 500-step iterative integration
- **Step Size**: Adaptive based on camera distance
- **Noise Generation**: Multi-octave Simplex noise for disk texture

### Rendering Pipeline

1. 3D scene renders to viewport texture
2. Fullscreen quad applies ray tracing shader
3. Ray paths calculated through gravitational field
4. Background sampling with distorted UV coordinates
5. Accretion disk contribution accumulated during ray march
6. Final composition with tone mapping

# blackhole-in-godot

Real-time black hole gravitational lensing simulation with relativistic effects and accretion disk rendering in Godot 4.5.

## Technical Overview

This project implements a physically-based black hole visualization using ray tracing, gravitational lensing, and relativistic Doppler effects. The renderer combines 3D scene backgrounds with 2D post-processing to achieve real-time performance with accurate astrophysical phenomena.

## Core Features

- **Gravitational Lensing**: Ray tracing with leapfrog integration method
- **Accretion Disk**: Procedural particle-based rendering with differential rotation
- **Relativistic Doppler Effects**: Blue/red shift and beaming for approaching/receding matter
- **Dynamic Camera**: Full 6-DOF camera control with mouse look
- **Real-time Parameters**: Adjustable gravity strength, disk properties, and relativistic effects

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
6. Relativistic effects applied to disk emission
7. Final composition with tone mapping

### Accretion Disk Physics

#### Keplerian Rotation

The accretion disk exhibits differential rotation following Kepler's laws:

```
ω(r) = ω₀ / √(r/r₀)
```

- Inner regions rotate faster than outer regions
- Angular velocity inversely proportional to square root of radius
- Creates natural spiral structure from velocity shear

#### Relativistic Doppler Effects

**Frequency Shift**

Orbital motion produces wavelength shifts in emitted radiation:

```
Δλ/λ = v·cosθ/c
```

- **Blue Shift**: Matter approaching observer (λ decreases, bluer color)
- **Red Shift**: Matter receding from observer (λ increases, redder color)
- Shift magnitude depends on orbital velocity and viewing angle

**Implementation**: Color channels adjusted based on radial velocity component:
- Approaching side: Enhanced blue channel, reduced red channel
- Receding side: Enhanced red channel, reduced blue channel

#### Relativistic Doppler Beaming

High-velocity matter exhibits dramatic brightness variations:

```
I' = I × D^n

where D = 1/(γ(1 - β·cosθ))
      γ = 1/√(1-β²)  (Lorentz factor)
      β = v/c
```

- **Parameter n**: Beaming exponent (2-3 for synchrotron, 3-4 for thermal)
- **Effect**: Approaching side appears significantly brighter
- **Brightness ratio**: Can reach 5:1 to 10:1 between approaching/receding sides

**Physical Basis**:
1. **Aberration**: Radiation concentrated in direction of motion
2. **Time dilation**: Photon arrival rate increased for approaching matter
3. **Energy boost**: Individual photon energies Doppler shifted

### Interactive Parameters

**Gravitational Effects**:
- Gravity strength: 0.01-2.0 (controls lensing intensity)
- Auto-fade lensing: Adaptive based on screen position

**Accretion Disk**:
- Inner/outer radius: 1.0-20.0 units
- Disk height: 0.1-1.0 (vertical thickness)
- Rotation speed: 0.0-2.0 (affects Doppler shift magnitude)
- Luminosity: 0.0001-0.001 (base emission strength)

**Relativistic Effects**:
- Doppler shift strength: 0.0-2.0 (color shift intensity)
- Beaming strength: 1.0-5.0 (brightness amplification exponent)
- Toggle individual effects independently

### Performance Optimization

- **Ray budget**: Fixed 500 steps per pixel
- **Early termination**: When hitting event horizon or opacity depleted
- **Adaptive step size**: Scales with distance from black hole
- **Noise LOD**: Multi-octave generation with 6+ layers
- **Target**: 60 FPS at 1080p on modern GPUs

## Visual Features

- Asymmetric disk brightness from beaming effect
- Color gradient from blue (approaching) to red (receding)
- Spiral structures from differential rotation
- Light bending around event horizon
- Dynamic response to camera motion

## Physics Accuracy

- Schwarzschild metric approximation for ray deflection
- Keplerian orbital velocities
- Special relativistic Doppler effects
- Synchrotron radiation spectral characteristics

## Controls

- **WASD**: Move camera
- **Q/E**: Vertical movement
- **Mouse**: Look around
- **ESC**: Toggle mouse capture
- **UI Sliders**: Adjust all physical parameters in real-time

## Technical Notes

- Coordinate system: Right-handed, Y-up
- Distance units: Schwarzschild radii (Rs = 2GM/c²)
- Maximum velocity: Limited to 0.5c for numerical stability
- Disk temperature gradient: Simulated via color map texture

## Video Demonstration

[https://b23.tv/l5qNBmA](https://b23.tv/l5qNBmA)

## References

- Schwarzschild metric and light deflection
- Relativistic Doppler effect in astrophysics
- Synchrotron radiation from accretion disks
- Numerical relativity ray tracing techniques

## License

This project is open source. Feel free to use and modify for your own purposes.


# Blackhole Simulation in Godot

Real-time Kerr black hole visualization with physically-based gravitational lensing and relativistic effects in Godot 4.5.

## Technical Overview

GPU-accelerated ray tracing implementation combining Kerr metric effects, relativistic fluid dynamics, and procedural noise generation. 

## Core Physics Systems

### Gravitational Effects

**Gravitational Lensing**
- Schwarzschild geodesic approximation
- Impact parameter conservation (h² = const)
- Leapfrog integration: a = -1.5h²r/r⁵
- Natural shadow formation at r ≈ 2.6 Rs

**Gravitational Redshift**
```
z + 1 = (1 - Rs/r)^(-1/2)
E' = E/(z+1)²
```
- Wavelength shift affects all emitting regions
- Energy loss: photons climbing out of gravity well
- Applied to disk, jets, corona, and hot spots

**Time Dilation**
```
dt'/dt = √(1 - Rs/r)
```
- Local time slowdown near event horizon
- Affects all temporal phenomena (rotation, flares, QPO)
- Observable through light curve stretching

**Frame Dragging (Kerr Black Hole)**
```
ω_drag = 2aM/(r³ + a²r + 2a²M)
```
- Spacetime rotation due to black hole spin
- Lense-Thirring effect on accretion disk
- Spin parameter a: 0 (Schwarzschild) to 0.998 (extremal Kerr)

### Accretion Disk Dynamics

**Keplerian Rotation**
```
ω(r) = ω₀/√(r/r₀)
```
- Differential rotation with inner regions faster
- Creates natural shear and spiral structure
- Modified by frame dragging in Kerr geometry

**Temperature Gradient**
```
T(r) ∝ r^(-3/4)  (Standard thin disk)
```
- Inner edge: ~10⁵-10⁶ K (UV-white)
- Middle region: ~10⁴-10⁵ K (blue-white to yellow)
- Outer edge: <10⁴ K (orange-red)
- Color map: Intrinsic blackbody spectrum

**Spiral Arms / Density Waves**
- Self-gravity instability (Toomre Q ≈ 1-1.3)
- Logarithmic spiral pattern: φ = m×θ - ln(r)×tightness
- Density contrast: 2-5× amplification
- Sub-Keplerian pattern speed (~70% of orbital velocity)
- m = 1-2 modes most common (observed in AGN)

**Hot Spots**
- Magnetic reconnection events and plasma blobs
- Orbit radius: 3-4 rg (just outside ISCO)
- Size: 1-3 rg (compact structures)
- Intensity: 10-100× local background (1-2 magnitudes)
- Lifetime: 10-100 minutes (modeled with periodic flares)
- Keplerian orbital motion with frame dragging correction
- Observable: Sgr A* IR/mm flares, GRAVITY astrometry

### Relativistic Effects

**Doppler Shift**
```
Observable frequency: ν' = ν × doppler_factor
Doppler factor D = 1/(γ(1 - β·cosθ))
```
- Velocity: β = 0.2-0.6c (orbital speed)
- Approaching side: 1.4-1.7× energy boost → bluer, brighter
- Receding side: 0.4-0.6× energy → redder, dimmer

**Doppler Beaming**
```
I' = I × D^n
```
- Beaming exponent n = 2-3 (synchrotron), 3-4 (thermal)
- Brightness asymmetry: 5:1 to 10:1 ratio
- Combined with gravitational effects

**Combined Color Shifts**
1. Intrinsic color from temperature (T ∝ r^(-3/4))
2. Doppler shift from orbital motion (left-right asymmetry)
3. Gravitational redshift from potential well (radial gradient)
4. Result: Approaching inner edge (blue-white), receding inner edge (dark red/IR)

### Quasi-Periodic Oscillations (QPO)

```
L(t) = L₀ × [1 - A + A×sin(2πft)]
```
- Frequency: 0.1-10 Hz (intrinsic disk oscillation modes)
- Amplitude: 0-50% (typical 15%)
- Global luminosity modulation
- Observable: X-ray light curves, timing analysis

### Relativistic Jets

**Geometry and Dynamics**
- Conical expansion: w(z) = w₀(1 + z/z₀)^0.7
- Helical rotation with burst cycles (0.1-3 Hz)
- Multi-octave turbulence (5-8 layers)
- Propagation delay: burst waves travel along jet

**Physical Properties**
- Launch radius: ~1 Rs (polar regions)
- Velocity: ~0.3-0.9c (relativistic outflow)
- Length: 5-50 Rs (configurable)
- Magnetic field:螺旋结构 (implicit in rotation)

**Emission**
- Synchrotron radiation (blue-white core)
- Affected by gravitational redshift near base
- Intensity: 0.1-20.0 (wide dynamic range)

### Photon Sphere (r = 1.5 Rs) - Theoretical

- Unstable photon orbit
- Not directly visible to naked eye (X-ray/EUV band)
- Forms critical surface for light ray capture
- Default: disabled (theoretical visualization only)

### X-ray Corona - Theoretical

- Hot plasma layer above disk (10⁸-10⁹ K)
- Produces hard X-rays through Compton scattering
- Not visible in optical band
- Default: disabled (X-ray instruments required)

### ISCO Ring (r = 3 Rs) - Theoretical

- Innermost stable circular orbit boundary
- Not a physical glowing structure
- Inferred through spectral fitting and iron Kα line profiles
- Default: disabled (theoretical marker only)

## Rendering Architecture

```
Ray Tracing Loop (500-2000 steps):
├─ Gravitational deflection (Schwarzschild approximation)
├─ Time dilation correction (affects rotation)
├─ Frame dragging (Kerr metric, if enabled)
├─ Accretion disk sampling:
│  ├─ Temperature gradient (intrinsic color)
│  ├─ Spiral arms (density wave modulation)
│  ├─ Hot spots (localized brightness peaks)
│  ├─ Doppler shift + beaming (velocity effects)
│  ├─ Gravitational redshift (energy loss)
│  └─ QPO modulation (global oscillation)
├─ Corona (optional X-ray layer)
├─ ISCO ring (optional theoretical marker)
├─ Photon sphere (optional theoretical marker)
├─ Relativistic jets (polar outflows)
├─ Hawking radiation (event horizon flashes)
└─ Custom geometry (demonstration objects)

Final Composition:
├─ Background texture sampling with distorted UVs
└─ Volumetric alpha blending
```

## Physical Parameters

**Spatial Units**: Schwarzschild radii (Rs = 2GM/c²)

**Critical Radii**:
- Event Horizon: r = 1.0 Rs
- Photon Sphere: r = 1.5 Rs
- ISCO (Schwarzschild): r = 3.0 Rs
- ISCO (Kerr, a=0.998): r = 1.235 Rs
- Accretion Disk: r = 2.6-12.0 Rs (configurable)

**Velocity Ranges**:
- Disk orbital: β = 0.2-0.6c (Keplerian + frame dragging)
- Jet outflow: v = 3.0 Rs/time_unit
- Pattern speed: 0.7× orbital (spiral density waves)

**Temporal Scales**:
- Disk rotation: Keplerian profile with time dilation
- Spiral pattern: Sub-Keplerian propagation
- Hot spot lifetime: 10-100 min (accelerated for demo)
- Jet bursts: 0.1-3.0 Hz
- QPO: 0.1-10 Hz

## Shader Implementation

**Uniforms (Key Parameters)**:
- Physics: `gravitational_lensing`, `doppler_enabled`, `beaming_enabled`, `gravitational_redshift_enabled`
- Disk: `adisk_lit`, `adisk_speed`, `adisk_inner/outer_radius`, `adisk_height`
- Temperature: `temperature_gradient_enabled`, `disk_temperature_power`
- Structure: `spiral_arms_enabled/count/strength`, `hot_spots_enabled/count/intensity`
- Kerr: `frame_dragging_enabled`, `black_hole_spin`, `dragging_strength`
- Time: `time_dilation_enabled/strength`, `qpo_enabled/frequency`
- Jets: `jet_enabled/intensity/rotation_speed/burst_frequency`

**Noise Generation**:
- Simplex 3D noise for continuous sampling
- Multi-octave synthesis (6-8 layers for disk, 5-8 for jets)
- Cartesian coordinates to eliminate polar discontinuities
- Temporal animation through coordinate rotation

**Color Processing Pipeline**:
1. Intrinsic color from temperature gradient
2. Doppler frequency shift (approaching → blue, receding → red)
3. Relativistic beaming (brightness boost/reduction)
4. Gravitational redshift (universal energy loss)
5. Structural modulation (spiral arms, hot spots)
6. Temporal modulation (QPO, jet bursts)

## Observable vs Theoretical Features

**Default Enabled (Observable)**:
- ✅ Gravitational lensing (all telescopes)
- ✅ Accretion disk (optical/IR/X-ray)
- ✅ Temperature gradient (spectral fitting)
- ✅ Doppler effects (spectroscopy)
- ✅ Relativistic beaming (photometry)
- ✅ Gravitational redshift (spectroscopy)
- ✅ QPO (timing analysis)
- ✅ Spiral arms (high-resolution imaging, GRAVITY)
- ✅ Hot spots (IR flares, VLTI astrometry)
- ✅ Frame dragging (orbital precession)
- ✅ Time dilation (light curves)
- ✅ Relativistic jets (radio/optical)
- ✅ Hawking radiation (theoretical visualization)

**Default Disabled (Theoretical/Non-optical)**:
- ❌ Photon sphere (X-ray band, too faint/small for naked eye)
- ❌ X-ray corona (requires X-ray telescopes)
- ❌ ISCO marker (theoretical boundary, not emitting)
- ❌ Secondary images (requires extended ray tracing)

## Controls

**Camera**:
- WASD: Translation
- Q/E: Vertical motion  
- Mouse: Free-look rotation
- ESC: Toggle mouse capture

**UI**: Scrollable parameter panel with real-time adjustment

## Technical Notes

- Coordinate system: Right-handed, Y-up
- Black hole types: Schwarzschild (a=0) to extremal Kerr (a=0.998)
- Disk model: Standard thin disk with α-viscosity
- Numerical stability: β < 0.6c, careful handling of Rs/r → 1

## Astrophysical Accuracy

**Comparison with Observations**:
- Sgr A* hot spots: 3-5 events/day, 1-3 hr duration ✓
- GRAVITY phase variations: 20-30° for m=1 spiral ✓
- M87* brightness asymmetry: ~5:1 approaching/receding ✓
- Disk color: Blue (inner, approaching) to red (outer, receding) ✓

**Physical Models**:
- Shakura-Sunyaev disk: T ∝ r^(-3/4)
- Toomre instability: Q ≈ 1 for spiral formation
- MRI turbulence: Hot spot generation mechanism
- Blandford-Znajek: Jet launching from ergosphere

## Video

[https://b23.tv/l5qNBmA](https://b23.tv/l5qNBmA)

## License

This project is open source. Feel free to use and modify for educational and research purposes.

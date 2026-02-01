# Project 2 — Longitudinal Vehicle Dynamics + ABS (Quarter-Car)

This project models a **quarter-car longitudinal braking system** and implements an **ABS controller** to regulate wheel slip (λ) during braking. The final controller is a **relay / hysteresis ABS**, which is robust for the nonlinear tire dynamics and discontinuities in slip.

A **PI-based ABS attempt** was also implemented as an engineering experiment, but it proved unstable/unreliable without additional structure (filters, anti-windup, low-speed logic, observers). This repo documents both the successful and unsuccessful approaches.

---

## Objectives
- Build a longitudinal **quarter-car** braking model (vehicle speed + wheel dynamics)
- Compute **slip ratio λ** from vehicle speed and wheel speed
- Apply tire-road friction model (μ(λ)) and generate longitudinal tire force Fx
- Implement ABS control:
  - ✅ Relay/Hysteresis ABS (final)
  - ❌ PI ABS (documented failure, postmortem included)

---

## Model Overview (Blocks)
- **LongitudinalPlant_QuarterCar**
  - Vehicle longitudinal dynamics: v(t)
  - Wheel rotational dynamics: ω(t)
  - Slip calculation: λ(t)
  - Tire friction law: μ(λ)
  - Tire force: Fx = μ(λ)·Fz
- **ABS Controller**
  - Relay ABS:
    - if λ > λ_high → reduce brake torque command
    - if λ < λ_low  → increase brake torque command
    - else hold
  - Rate limiting, integration to brake torque, saturation

---

## Key Signals to Scope
- λ (slip ratio)
- v and R·ω
- Tb_cmd (brake torque command)
- Fx (tire longitudinal force)
- ω (wheel angular speed)

---

## Results Summary
- Relay ABS maintains λ around the target band [λ_low, λ_high] with expected cycling.
- PI ABS caused large oscillations / saturation / collapse near low speed due to:
  - slip discontinuities when v→0
  - integral windup
  - nonlinear μ(λ) shape
  - saturation & sign switching

---
---

## Notes
This project intentionally emphasizes **control realism**: ABS is fundamentally a hybrid controller (logic + rate control), not purely linear PI.

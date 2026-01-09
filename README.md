# ESC Bicycle Model

This repository presents a nonlinear vehicle dynamics project implementing an **Electronic Stability Control (ESC)** system using a **bicycle model** and **yaw-moment control via differential braking**.

The objective of the project is to model, simulate, and validate how ESC stabilizes vehicle yaw dynamics during aggressive steering maneuvers by selectively applying brake forces.

---

## Project Overview

The model includes:
- Nonlinear bicycle vehicle model
- Front and rear lateral tire force modeling with saturation
- Yaw-rate reference generation
- ESC ON / OFF logic
- Yaw moment generation using differential braking
- Sideslip angle estimation using lateral acceleration
- Saturation, hysteresis, and filtering for realistic actuator behavior

Simulation results clearly show yaw instability in ESC-OFF conditions and stabilized behavior when ESC is active.

---

## Model Structure

The project is structured as follows:

---

## Key Features

- **Yaw-rate tracking:** Reference yaw rate computed from vehicle speed and steering input
- **ESC activation logic:** Based on yaw-rate error thresholds
- **Yaw moment control:** Computed yaw moment converted into differential brake forces
- **Differential braking:** Automatic left/right brake selection based on yaw moment sign
- **State estimation:** Sideslip angle estimated from lateral acceleration and yaw rate
- **Nonlinear dynamics:** Tire force saturation and actuator limits included

---

## Simulation Scenarios

- Constant steering input (±8°)
- ESC OFF: yaw instability and growing sideslip
- ESC ON: stabilized yaw rate and bounded sideslip
- Comparison of vehicle trajectories with and without ESC

---

## Tools Used

- MATLAB / Simulink
- Nonlinear vehicle dynamics modeling
- Control-oriented system design

---

## Author

**Muhannad**  
Automotive & Mechatronics Engineering  


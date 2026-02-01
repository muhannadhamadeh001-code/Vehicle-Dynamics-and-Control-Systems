# Equations — Longitudinal Quarter-Car + ABS

This document lists the full set of equations used in Project 2.

---

## 1) Kinematics

### Wheel circumferential speed
\[
v_w = R\omega
\]

Where:
- \(R\): wheel radius [m]
- \(\omega\): wheel angular speed [rad/s]

---

## 2) Slip Ratio (Braking)

For braking slip (most common ABS definition):
\[
\lambda = \frac{v - R\omega}{\max(v, \epsilon)}
\]

Where:
- \(v\): vehicle longitudinal speed [m/s]
- \(\epsilon\): small number to avoid division by zero (e.g., 0.1)

Notes:
- When \(R\omega < v\), slip is positive (braking slip).
- When \(v \to 0\), slip becomes numerically sensitive → must clamp denominator.

---

## 3) Tire-Road Friction Model

General form:
\[
\mu = \mu(\lambda)
\]

Then longitudinal tire force:
\[
F_x = \mu(\lambda)\,F_z
\]

Where:
- \(F_z\): normal load on the wheel [N]
- \(F_x\): longitudinal tire force [N]

(Your Simulink plant likely implements a piecewise or smooth curve peaking around λ≈0.1–0.2.)

---

## 4) Vehicle Longitudinal Dynamics

\[
m\dot{v} = -F_x
\]

Where:
- \(m\): quarter-car mass [kg]
- \(v\): vehicle speed [m/s]

(Sign convention: Fx opposes vehicle motion during braking.)

---

## 5) Wheel Rotational Dynamics

\[
J\dot{\omega} = T_{drive} - T_b - R F_x
\]

For braking-only case (no drive torque):
\[
J\dot{\omega} = -T_b - R F_x
\]

Where:
- \(J\): wheel inertia [kg·m²]
- \(T_b\): brake torque [N·m]

---

## 6) Brake Actuation Command (Torque Command)

The ABS controller outputs a commanded brake torque:
\[
T_{b,cmd} \in [0, T_{b,max}]
\]

---

# ABS Control Laws

## 7) Relay / Hysteresis ABS (Final)

Two thresholds define a band:
- \( \lambda_{low} \)
- \( \lambda_{high} \)

Control law (rate form):
\[
\dot{T}_{b,cmd} =
\begin{cases}
- T_{b,rate\_dn} & \lambda > \lambda_{high} \\
+ T_{b,rate\_up} & \lambda < \lambda_{low} \\
0 & \text{otherwise}
\end{cases}
\]

Then:
\[
T_{b,cmd}(t) = \int \dot{T}_{b,cmd}(t)\, dt
\]

Finally saturation:
\[
T_{b,cmd} = \text{sat}(T_{b,cmd}, 0, T_{b,max})
\]

Notes:
- This produces ABS “cycling”, which is expected behavior.

---

## 8) PI ABS Attempt (Unsuccessful)

Define slip error:
\[
e = \lambda_{ref} - \lambda
\]

PI law:
\[
u(t) = K_p e(t) + K_i \int e(t)\,dt
\]

Mapped to brake torque command (conceptually):
\[
T_{b,cmd} = \text{sat}\left( \int \text{rate\_limit}(u)\,dt, 0, T_{b,max} \right)
\]

Why it failed:
- λ is discontinuous near low speeds
- nonlinear μ(λ)
- saturation and integral windup
- required anti-windup + filtering + low-speed logic + observers

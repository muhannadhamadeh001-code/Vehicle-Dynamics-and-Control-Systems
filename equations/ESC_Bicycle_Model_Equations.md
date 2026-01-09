# ESC Bicycle Model — Equations & Definitions

## 0) States, Inputs, Parameters
**States**
- β : vehicle sideslip angle at CG [rad]
- r : yaw rate [rad/s]

**Input**
- δ : front wheel steering angle [rad]

**Parameters**
- m : vehicle mass [kg]
- Iz : yaw moment of inertia [kg·m²]
- a, b : distances from CG to front/rear axle [m]
- Ux : longitudinal speed (assumed constant) [m/s]
- Cf, Cr : cornering stiffness (front/rear) [N/rad]
- Fy_f_max, Fy_r_max : max lateral tire force magnitude [N]
- Mz_max : max yaw moment from ESC/brakes [N·m]

---

## 1) Slip Angles
Front and rear slip angles (small-angle approx):
- α_f = δ − β − (a/Ux) r
- α_r = −β + (b/Ux) r

**Use:** These feed the tire model to compute lateral forces.

---

## 2) Nonlinear Tire Force Model (Saturation)
Linear tire forces:
- Fy_f_lin = Cf α_f
- Fy_r_lin = Cr α_r

Saturation used in the project (smooth limiting, e.g. tanh-based):
- Fy_f = Fy_f_max · tanh( Fy_f_lin / Fy_f_max )
- Fy_r = Fy_r_max · tanh( Fy_r_lin / Fy_r_max )

**Use:** Prevents unrealistic infinite lateral forces and produces nonlinear behavior at high δ.

---

## 3) Bicycle Model Dynamics (β̇ and ṙ)
Lateral force sum:
- F_y = Fy_f + Fy_r

Sideslip dynamics:
- β̇ = (F_y / (m Ux)) − r

Yaw-rate dynamics (base vehicle):
- ṙ = (a Fy_f − b Fy_r)/Iz

When ESC yaw moment is applied:
- ṙ = (a Fy_f − b Fy_r + Mz_esc)/Iz

**Use:** This is the core plant implemented with two integrators (β and r).

---

## 4) Lateral Acceleration (for monitoring / estimator)
CG lateral acceleration:
- a_y = Ux (β̇ + r)

In many blocks you also use a filtered acceleration:
- a_y,f(s) = (1 / (τ_ay s + 1)) · a_y(s)

**Use:** Required for the sideslip observer (β̂).

---

## 5) Yaw-Rate Reference (Desired r_ref)
Kinematic yaw-rate reference (bicycle geometry):
- r_ref = (Ux / L) δ
where L = a + b

Optional saturation (road friction limit):
- r_ref_sat = sat(r_ref, ± r_max)
Common form:
- r_max = (μ g) / Ux

**Use:** ESC tries to make r track this reference.

---

## 6) ESC Activation Logic (ON/OFF + Hysteresis)
Yaw-rate tracking error:
- e_r = r − r_ref_sat

Activation with thresholds:
- ESC_ON = 1 if |e_r| > e_th_on
- ESC_ON = 0 if |e_r| < e_th_off
with e_th_on > e_th_off (hysteresis)

**Use:** avoids rapid chattering.

---

## 7) Yaw Moment Command (Mz_cmd)
Controller structure you built (typical):
- Mz_cmd = −Kr (r − r_ref_sat) − Kβ β   (or β̂ when using observer)

Then saturate:
- Mz_sat = sat(Mz_cmd, ±Mz_max)

Finally:
- Mz_esc = ESC_ON · Mz_sat

**Use:** stabilizes yaw and reduces sideslip under aggressive steering.

---

## 8) Differential Braking Allocation (Brake Logic)
Goal: generate yaw moment using left/right brake forces.

Yaw moment from brake force difference (simplified):
- Mz_brk = (t/2) (Fbrk_R − Fbrk_L)
where t is track width.

Brake command magnitude from desired yaw moment:
- F_mag = |Mz_des| / (t/2)

Brake selection based on sign of Mz_des:
- if Mz_des > 0 → apply one side only (e.g., right brake)
- if Mz_des < 0 → apply the opposite side only (e.g., left brake)

Important implementation detail:
- **Sign logic must use signed Mz_des, not |Mz_des|**, otherwise one side is always selected.

Brake limits:
- F_mag = sat(F_mag, 0 … Fbrk_max)

**Use:** converts yaw moment request into physically meaningful actuator action.

---

## 9) Sideslip Observer (β̂) — Practical Implementation
From the model:
- β̇ = (a_y / Ux) − r

Observer form used:
- β̂̇ = (a_y,f / Ux) − r − λ (β̂ − β_meas)

Where:
- λ > 0 is observer gain
- β_meas is the “true” β from the model (in real car this would be an estimate / pseudo-measurement)

**Use:** emulates real ESC behavior (no direct β sensor) using lateral acceleration + yaw rate.

---

## 10) Curvature
Road curvature:
- κ = r / Ux
- κ_ref = r_ref / Ux

**Use:** clean comparison of path-demand vs achieved path.

---

## Summary of What Each Section Does
- Slip angles → connect vehicle motion to tire forces  
- Tire saturation → makes the model realistic/nonlinear  
- β̇ and ṙ → core bicycle dynamics  
- r_ref and κ_ref → “what the driver demands”  
- ESC logic → decides when intervention is necessary  
- Mz control → corrects yaw dynamics  
- Brake allocation → turns Mz into left/right braking  
- Observer β̂ → real-life compatible sideslip estimation  

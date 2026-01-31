# Results Summary — ESC Bicycle Model

## Goal
Validate that an Electronic Stability Control (ESC) yaw-moment controller stabilizes the nonlinear bicycle model under aggressive steering, by tracking yaw-rate reference and reducing sideslip.

---

## Test Setup
- Input: step steering (typ. ±8°) at constant longitudinal speed Ux
- Model: nonlinear bicycle dynamics (beta, r) with tire force saturation
- ESC: yaw-rate tracking + yaw moment generation + differential braking allocation
- Outputs monitored: beta, r, r_ref, yaw-rate error e_r, kappa (curvature), Mz_cmd/Mz_brk, brake forces (L/R)

---

## Key Behaviors Observed

### ESC OFF
- Yaw rate does not track r_ref under larger steering inputs.
- Sideslip beta grows and becomes weakly bounded or unstable depending on saturation settings.
- Curvature kappa deviates from kappa_ref.
- Vehicle trajectory shows large deviation / looping behavior at high steering demand.

### ESC ON
- ESC activates when yaw-rate error exceeds threshold (with hysteresis for clean switching).
- Yaw moment command is generated and limited (Mz saturation).
- Differential braking applies the correct side:
  - Positive yaw moment request → one side brake
  - Negative yaw moment request → the opposite side brake
- Yaw rate converges toward r_ref with reduced oscillation.
- Sideslip beta is reduced and bounded (typically close to 0).
- Curvature kappa moves closer to kappa_ref and stabilizes.
- Trajectory becomes significantly more stable than ESC OFF.

---

## Symmetry Check (±δ)
With steering input sign reversed (e.g., +8° vs -8°):
- beta, r, kappa, and Mz_brk show equal magnitude with opposite signs
- braking side swaps correctly (left ↔ right)
This confirms correct sign conventions and brake allocation logic.

---

## Notes / Sensitivities
- Increasing controller gains (Kr, Kbeta) too far produces oscillations (ESC toggling / r oscillation).
- ay_max and Fy_max settings strongly affect stability margins:
  - Higher allowable lateral acceleration with too-low force limits can push the model into instability.
- Correct sign handling is critical:
  - Do NOT feed sign logic from |Mz_des| (always positive); feed from signed Mz_des.
  - Ensure Mz is added into r_dot with correct sign convention.

---

## Conclusion
The implemented ESC yaw-moment controller stabilizes the nonlinear bicycle model during aggressive steering by reducing yaw-rate error and bounding sideslip, with physically consistent brake-side selection and realistic saturation/hysteresis behavior.

# Simulation Notes / Debug Log

## Common failure modes encountered
- λ stuck at 0: caused by Tb_cmd not connected into plant or ω/v not reaching slip calc
- λ spikes to 1: wheel locks due to excessive Tb_cmd or wrong sign logic
- v disappears: not scoped correctly (wrong signal picked) or was at 0 after stop

## Debug checklist
- Verify v and Rω are both nonzero and reasonable
- Verify slip formula uses max(v, ε)
- Verify Tb_cmd actually feeds brake torque in plant
- Verify saturation limits (0..Tb_max)
- Verify Tb_rate_dn is larger magnitude than Tb_rate_up (usually release faster than apply)

## Recommended parameter sanity
- λ_low = 0.10, λ_high = 0.20 (typical teaching values)
- Tb_rate_dn > Tb_rate_up (faster release)

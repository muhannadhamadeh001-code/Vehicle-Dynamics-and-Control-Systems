%% Project 2 - Longitudinal Vehicle Dynamics + ABS (Init)
clear; clc;


Tb_max      = 3000;   % [N*m] max brake torque available
Tb_rate_up  = 1500;  % [N*m/s] torque increase rate limit
Tb_rate_dn  = -6000;  % [N*m/s] torque decrease rate limit (can dump faster)
Tb_base = 1200;    % N*m

lambda_high = 0.18;
lambda_low = 0.12;
Tb_rate_cmd = 3000;
lambda_ref = 0.15;
Kp_abs = 4000;    % (units: N*m/s per slip)
Ki_abs = 800;   % (units: N*m/s^2 per slip)
% ---------- Vehicle / wheel ----------
m       = 1500;          % [kg] total vehicle mass
mq      = m/4;           % [kg] quarter-car effective mass
R       = 0.30;          % [m] wheel effective rolling radius
J       = 1.2;           % [kg*m^2] wheel+tire effective inertia (v1)

g       = 9.81;          % [m/s^2]

v_abs_off = 1.0;  % m/s
v_abs_on = 1.0;   % m/s

% ---------- Initial conditions ----------
v0      = 27.78;         % [m/s] 100 km/h
omega0  = v0/R;          % [rad/s] match rolling at t=0

% ---------- Slip calc safety ----------
v_eps   = 0.5;           % [m/s] prevents division by 0 near standstill

% ---------- Normal load (v1 constant) ----------
Fz_const = mq*g;         % [N] per-wheel normal load (no load transfer)

% ---------- Road / tire mu-slip params (Dry asphalt v1) ----------
Road.mu_peak  = 1.00;    % peak friction coefficient
Road.mu_slide = 0.75;    % sliding friction coefficient at high slip
Road.lam_peak = 0.15;    % slip at peak friction (braking)
Road.decay    = 0.10;    % decay rate after peak (shape parameter)

% ---------- Test torque step (ABS OFF baseline) ----------
Tb_step = 1500;          % [N*m] step brake torque (should lock/near-lock)
Tb_t0   = 0.10;          % [s] step time

disp("P2_init loaded: params + Road struct + Tb_step ready.");

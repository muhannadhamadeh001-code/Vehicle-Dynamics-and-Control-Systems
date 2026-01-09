%% Bicycle model (linear) - states: x = [beta; r], input: delta
clear; clc;

% ---------- Parameters (EDIT THESE) ----------
m  = 1500;      % kg
Iz = 2500;      % kg*m^2
a  = 1.4;       % m
b  = 1.4;       % m
Cf = 80000;     % N/rad  (front axle cornering stiffness)
Cr = 90000;     % N/rad  (rear axle cornering stiffness)
Ux = 20;        % m/s    (constant speed)

Fy_f_max = 6620;   % N  (front axle max lateral force)
Fy_r_max = 6620;   % N  (rear axle max lateral force)
                    % We add these two forces for nonlinear models, used for
                    % real tires saturation
                            
                           % These are made for ESC when tires saturate
L = a + b;                 % wheelbase
Kr = 2500;                 % N*m per (rad/s)  (start)
Kbeta = 6000;                 % start at 0, add later if needed
Mz_max = 3000;             % N*m
beta_th = 5*pi/180;        % rad
er_th   = 10*pi/180;       % rad/s
ay_max = 0.9*9.81;          % m/s^2
r_fric  = ay_max/Ux;         % rad/s
tau = 0.10;                 % seconds (safe, adds damping)


track = 1.6;                % track width, m
Fbrk_max = 9000;            % max brake force per wheel, N

lambda_off = 0.05;              % 1/s
lambda_on = 0.2;               % 1/s
tau_ay = 0.02;              % seconds


% ---------- State-space matrices ----------
A = [ -(Cf+Cr)/(m*Ux),     (-a*Cf + b*Cr)/(m*Ux^2) - 1;
      (-a*Cf + b*Cr)/Iz,  -(a^2*Cf + b^2*Cr)/(Iz*Ux) ];

B = [ Cf/(m*Ux);
      a*Cf/Iz ];

% Outputs: y = [beta; r]
C = eye(2);
D = [0; 0];

sys = ss(A,B,C,D);

%% Steering input: step steer
t = 0:0.001:5;                  % 5 seconds
delta = deg2rad(2) * ones(size(t));  % 2 deg step

[y,t,x] = lsim(sys, delta, t);   % y(:,1)=beta, y(:,2)=r

beta = y(:,1);
r    = y(:,2);

% Compute beta_dot from state equation: xdot = A*x + B*delta
xdot = (A*x.' + B*delta).';      % (transpose trick for sizes)
beta_dot = xdot(:,1);

% Lateral acceleration: ay = Ux*(beta_dot + r)
ay = Ux*(beta_dot + r);

%% Plots
figure; plot(t, rad2deg(beta)); grid on;
xlabel('Time (s)'); ylabel('\beta (deg)'); title('Sideslip \beta');

figure; plot(t, rad2deg(r)); grid on;
xlabel('Time (s)'); ylabel('Yaw rate r (deg/s)'); title('Yaw rate r');

figure; plot(t, ay); grid on;
xlabel('Time (s)'); ylabel('a_y (m/s^2)'); title('Lateral acceleration a_y');
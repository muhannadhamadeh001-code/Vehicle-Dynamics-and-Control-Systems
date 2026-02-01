function mu = TireMu(lambda, mu_peak, mu_slide, lam_peak, decay)
% TireMu: simple physically-plausible mu(slip) curve for braking
% lambda   : slip ratio in [0..1]
% mu_peak  : peak friction coefficient
% mu_slide : sliding friction coefficient at high slip
% lam_peak : slip at peak friction (~0.1-0.2 dry)
% decay    : decay shaping parameter (>0)

% clamp inputs (defensive)
if lambda < 0
    lambda = 0;
elseif lambda > 1
    lambda = 1;
end

if lam_peak <= 0
    lam_peak = 0.15;
end
if decay <= 0
    decay = 0.10;
end

% piecewise curve: rise to peak, then decay to sliding level
if lambda <= lam_peak
    mu = mu_peak * (lambda / lam_peak);
else
    mu = mu_slide + (mu_peak - mu_slide) * exp(-(lambda - lam_peak)/decay);
end

% final clamp (just in case)
if mu < 0
    mu = 0;
end
end

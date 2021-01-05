function fdSensitivity = calc_ParamSensi(x, p, dp, ei)
addpath('..');
% ei must be size 1-by-6 (6 parameters of interest)
% allows you to select the dimension of p that you want to probe
% [alpha, beta, mul, mua, C, G] in that order 
% assumes constant C and G across the grid 

% Jacobian finite difference step size
eps_jf = 0.000000001;

% calculate jacobian and f(x0)
[Jf, f0] = eval_Jf_FiniteDiff(@evalf,x,p,eps_jf);

% solve system
X = Jf \ f0(:);

% perturbed parameter steady state solution

% only change the parameter we want to change
pVec = [p.alpha, p.beta, p.mul, p.mua, p.C(1,1), p.G(1,1)];
dpVec = pVec + pVec .* (dp*ei);

% there is probably a better way to do this... 
p_p.alpha = dpVec(1); % maturation rate
p_p.beta = dpVec(2); % larvae birth rate [# larvae / (# adults * day)]
p_p.mul = dpVec(3); % larvae death rate [# dead/ day]
p_p.mua = dpVec(4); % adult death rate [# dead / day]
p_p.C = dpVec(5)*ones(size(x,1), size(x,2)); % geographic capacity [0-6700 adults / square mile]
p_p.G = dpVec(6)*ones(size(x,1), size(x,2)); % geographic resistance [0-1 adults *day / square mile]
% non-pertured parameters 
p_p.Lv1 = size(x,1)/max(size(x,1), size(x,2)); % physical length of map in 1-direction
p_p.Lv2 = size(x,2)/max(size(x,1), size(x,2)); % physical length of map in 2-direction

% calculate jacobian and f(x0) for perturbed parameter
[Jf_p, f0_p] = eval_Jf_FiniteDiff(@evalf,x,p_p,eps_jf);

% solve system
Xp = Jf_p \ f0_p(:);




% compute finite difference sensitivity
cT  = 1/size(X,1) * ones(1,size(X,1)); 
fdSensitivity  = cT * (X - Xp) / nonzeros(dpVec.*ei);


clear

% grid size
Nv1 = 1;
Nv2 = 1;

% parameters
p.alpha = 0.001; % maturation rate [% matured / day]
p.beta = 0.5; % larvae birth rate [# larvae / (# adults * day)]
p.mul = 0.001; % larvae death rate [# dead/ day]
p.mua = 0.024; % adult death rate [# dead / day]
p.C = 10*ones(Nv1, Nv2); % geographic capacity [0-6700 adults / square mile]
p.G = 1*ones(Nv1, Nv2); % geographic resistance [0-1 adults *day / square mile]
p.Lv1 = Nv1/max(Nv1,Nv2); % physical length of map in 1-direction
p.Lv2 = Nv2/max(Nv1,Nv2); % physical length of map in 2-direction

% dp
dp = 1;

% initial state
xl = 0*ones(Nv1, Nv2); % larvae concentrations
xa = 5*ones(Nv1, Nv2); % adult concentrations
%xa(2,2) = 5;
x0 = cat(3, xl, xa);

%%
% alpha
ei = [1, 0, 0, 0, 0, 0];
s.alpha = calc_ParamSensi(x0, p, dp, ei);
fprintf('s alpha: %d \n', s.alpha)

%%
% beta
ei = [0, 1, 0, 0, 0, 0];
s.beta = calc_ParamSensi(x0, p, dp, ei);
fprintf('s beta: %d \n', s.alpha)

%%
% mul
ei = [0, 0, 1, 0, 0, 0];
s.mul = calc_ParamSensi(x0, p, dp, ei);
fprintf('s mul: %d \n', s.alpha)

%%
% mua
ei = [0, 0, 0, 1, 0, 0];
s.mua = calc_ParamSensi(x0, p, dp,  ei);
fprintf('s mua: %d \n', s.alpha)

%%
% C
ei = [0, 0, 0, 0, 1, 0];
s.C = calc_ParamSensi(x0, p, dp, ei);
fprintf('s C: %d \n', s.alpha)

%%
% G
ei = [0, 0, 0, 0, 0, 1];
s.G = calc_ParamSensi(x0, p, dp, ei);
fprintf('s G: %d \n', s.alpha)







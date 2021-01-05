%% Import Data and Initialize Parameters
% load data and resize
addpath('../maps')
map0 = load('../maps/map0/map0.mat');
map = resizeMap(map0, 0.02);

% grid size
[Nv1, Nv2] = size(map.capacity);
% pixel size
pixL = map0.l2/Nv2;
% initial state
xl = map.ic*17.2;
xa = map.ic;
x0 = cat(3, xl, xa);
x0 = x0(:);
n = length(x0);

% input parameters
p.alpha = 0.001; % maturation rate
p.beta = 0.3125; % larvae birth rate
p.mul = 0.0001; % larvae death rate
p.mua = 0.0001; % adult death rate
p.Nv1 = Nv1; % pixels in 1-direction
p.Lv1 = pixL*Nv1; % physical length of map in 1-direction
p.C = map.capacity*0.05*6.7*pixL^2; % 0.05 trees per m^2, 6.7 adults per tree
p.G = map.resistance/1000;
u = 0*x0;

%% Simulations
eps = 0.01; %finite difference step
tStop = 2*365; %end time of simulation
dt = 1.0; %timestep for Forward Euler

% generate perturbed parameters
p_alpha = p; p_beta = p; p_mul = p; p_mua = p; p_C = p; p_G = p;
p_alpha.alpha = p.alpha*(1+eps);
p_beta.beta = p.beta*(1+eps);
p_mul.mul = p.mul*(1+eps);
p_mua.beta = p.mua*(1+eps);
% p_C.C = p.C.*(1+eps);
% p_G.G = p.G*(1+eps);

% unperturbed simulation
[X, ~] = forwardEuler(@evalf,x0,p,u,tStop,dt);

% perturbed simulation data
[X_alpha, ~] = forwardEuler(@evalf,x0,p_alpha,u,tStop,dt);
[X_beta, ~] = forwardEuler(@evalf,x0,p_beta,u,tStop,dt);
[X_mul, ~] = forwardEuler(@evalf,x0,p_mul,u,tStop,dt);
[X_mua, ~] = forwardEuler(@evalf,x0,p_mua,u,tStop,dt);
% [X_C, ~] = forwardEuler(@evalf,x0,p_C,u,tStop,dt);
% [X_G, ~] = forwardEuler(@evalf,x0,p_G,u,tStop,dt);

%% Calculate sensitivities in total population and area after 10 days

% sensitivity of total final population
tot_pop = totalPop(X,n);
sens_pop_alpha = (totalPop(X_alpha,n)-tot_pop)/(tot_pop*eps);
sens_pop_beta = (totalPop(X_beta,n)-tot_pop)/(tot_pop*eps);
sens_pop_mul = (totalPop(X_mul,n)-tot_pop)/(tot_pop*eps);
sens_pop_mua = (totalPop(X_mua,n)-tot_pop)/(tot_pop*eps);
% sens_pop_C = (totalPop(X_C,n)-tot_pop)/(tot_pop*eps);
% sens_pop_G = (totalPop(X_G,n)-tot_pop)/(tot_pop*eps);

% sensitivity of total final area covered
tot_area = beetleArea(X,n);
sens_area_alpha = (beetleArea(X_alpha,n)-tot_area)/(tot_area*eps);
sens_area_beta = (beetleArea(X_beta,n)-tot_area)/(tot_area*eps);
sens_area_mul = (beetleArea(X_mul,n)-tot_area)/(tot_area*eps);
sens_area_mua = (beetleArea(X_mua,n)-tot_area)/(tot_area*eps);
% sens_area_C = (beetleArea(X_C,n)-tot_area)/(tot_area*eps);
% sens_area_G = (beetleArea(X_G,n)-tot_area)/(tot_area*eps);

% write to file
% save('rateSensitivities)

%% bar chart
close all;
sens= [sens_area_alpha,sens_area_beta,sens_area_mul,sens_area_mua;
    sens_pop_alpha,sens_pop_beta,sens_pop_mul,sens_pop_mua]';
logsens = log10(abs(sens));
abssens = abs(sens);

labels = categorical({'\alpha','\beta','\mu^l','\mu^a'});
labels = reordercats(labels,{'\alpha','\beta','\mu^l','\mu^a'});

figure;
bar(labels,abssens);
ylabel('|Sensitivity|')
title('Sensitivity to Parameters');
legend({'Infestation area', 'Total adult population'}, 'Location', 'northwest');

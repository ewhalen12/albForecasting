clear; clc; close all;

%% Import Data and Initialize Parameters
% load data and resize
addpath('../')
addpath('../visualization');
addpath('../maps')
map0 = load('../maps/map0/map0.mat');
map = resizeMap(map0, 0.02);

% define grid and ICs
[Nv1, Nv2] = size(map.capacity); % map dimensions
pixL = map0.l2/Nv2;  % pixel length
xa = map.ic;
xl = map.ic*17.2;
x0 = cat(3, xl, xa); %initial state
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

%% Simulation Demo
tStop = 2*365; % simulate 2 years
dt = 1.0; %timestep

% simulate
tic
[X, ~] = forwardEuler(@evalf,x0,p,u,tStop,dt);
toc;

plotmap(p.C, 'Capacity');
plotmap(p.G, 'Resistance');

% plot results
[Xa, Xl] = vector2map(X, Nv1);
% plotmap(Xa(:,:,1), 'ALB Forecast');
% plotmap(Xa(:,:,end), 'ALB Forecast');
plotmap(Xa(:,:,1:20:end), 'ALB Forecast- Cutoff=100', 'cutoff', 10, 'background', 'satellite')
% plotmap(Xa(:,:,1:20:end), 'ALB Forecast')
% plotmap(Xa(:,:,1:20:end) ./ p.C, 'Fraction of capacity filled');
% plotPopulationHist(X, 'Population History');

clear;clc;close all;
addpath('../maps');
addpath('../');

% load data and resize
map0 = load('../maps/map0/map0.mat');
map = resizeMap(map0, 0.01);
[h,w] = size(map0.ic);

% grid size
[Nv1, Nv2] = size(map.capacity);

% pixel size
pixL = map0.l2/Nv2;

% initial state
xl = zeros(Nv1, Nv2);
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
p.G = map.resistance/100;
u = 0*x0;

% visualize map
pos = [900 50 700 700*Nv1/Nv2];
figure('Position', pos); imagesc(p.C); colorbar; title('Capacity');
figure('Position', pos); imagesc(p.G); colorbar; title('Resistance');
% figure('Position', pos); imagesc(xa); colorbar; title('Initial Condition - Adults');

dt = 100;
tStop = 10*dt;
[X, T] = forwardEuler(@evalf,x0,p,u,tStop,dt);
totalLarvaeHist = sum(X(1:n/2,:),1);
totalAdultHist = sum(X(n/2+1:end,:),1);

xa = reshape(X(n/2+1:end,1),Nv1,Nv2);
figure('Position', pos); imagesc(xa); colorbar;
title('Test13: Map0 (start)');

xa = reshape(X(n/2+1:end,end),Nv1,Nv2);
figure('Position', pos); imagesc(xa); colorbar;
title('Test13: Map0 (end)');

disp(sprintf('Beetles at start: %f\n', totalAdultHist(1)));
disp(sprintf('Beetles at end: %f\n', totalAdultHist(end)));

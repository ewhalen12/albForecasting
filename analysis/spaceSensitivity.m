clear; clc; close all;

%% Load precomputed final states
filename = 'dCFinalStates_eps=10_dt=1_tstop=730.mat';

data = load(filename);
n = length(data.baseline);
Nv1 = data.Nv1;
Nv2 = data.Nv2;
p = data.p;
eps = data.eps;


%% Compute spacial sensitivities
areaDelta = zeros(data.Nv1, data.Nv2);
areaSen = zeros(data.Nv1, data.Nv2);
areaBaseline = beetleArea(data.baseline, n);

for i=1:Nv1
    for j=1:Nv2
        newState = data.finalStateGrid(i,j,:);
        newArea = beetleArea(newState(:), n);
        areaDelta(i,j) = newArea-areaBaseline;
        areaSen(i,j) = (newArea-areaBaseline) / (p.C(i,j)*(1+eps));
        areaSen(i,j) = areaDelta(i,j) / (areaBaseline*eps);
    end
end

%% Visualize
% plotmap(areaDelta, 'Beetle Area delta')
% plotmap(areaSen, 'Area sensitivity to local resistance measurement')
plotmap(abs(areaSen), 'Infection area - sensitivity to local capacity', 'cutoff', 0, 'background', 'satellite')

% plot capacity for reference
% addpath('../maps')
% map0 = load('../maps/map0/map0.mat');
% map = resizeMap(map0, 0.01);
% plotmap(p.C, 'Geographic capacity');




%% Load precomputed final states
filename = 'dRFinalStates_eps=10_dt=1_tstop=730.mat';

data = load(filename);
n = length(data.baseline);
Nv1 = data.Nv1;
Nv2 = data.Nv2;
p = data.p;
eps = data.eps;


%% Compute spacial sensitivities
areaDelta = zeros(data.Nv1, data.Nv2);
areaSen = zeros(data.Nv1, data.Nv2);
areaBaseline = beetleArea(data.baseline, n);

for i=1:Nv1
    for j=1:Nv2
        newState = data.finalStateGrid(i,j,:);
        newArea = beetleArea(newState(:), n);
        areaDelta(i,j) = newArea-areaBaseline;
        areaSen(i,j) = (newArea-areaBaseline) / (p.G(i,j)*(1+eps));
        areaSen(i,j) = areaDelta(i,j) / (areaBaseline*eps);
    end
end

%% Visualize
% plotmap(areaDelta, 'Beetle Area delta')
% plotmap(areaSen, 'Area sensitivity to local resistance measurement')
plotmap(abs(areaSen), 'Infection area - sensitivity to local resistance', 'cutoff', 0, 'background', 'satellite')

% plot resistance for reference
% addpath('../maps')
% map0 = load('../maps/map0/map0.mat');
% map = resizeMap(map0, 0.01);
% plotmap(p.G, 'Geographic resistance');



%% Import Data and Initialize Parameters
clear; clc; close all;
% load data and resize
addpath('../maps')
map0 = load('../maps/map0/map0.mat');
map = resizeMap(map0, 0.01);

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

%% Baseline Simulation
for eps=[1e0]
    % eps = 1e-2; %finite difference step
    tStop = 2*365; %end time of simulation
    dt = 1.0; %timestep for Forward Euler
    
    % unperturbed simulation
    tic
    [X, ~] = forwardEuler(@evalf,x0,p,u,tStop,dt);
    baseline = X(:,end);
    baselineTime = toc;
    fprintf('Baseline time: %d seconds\n', baselineTime);
    fprintf('Total time estimate: %d minutes\n', baselineTime*Nv1*Nv2/60);
    [Xa, Xl]=vector2map(X, Nv1);
    plotmap(Xa(:,:,1:5:end), 'Baseline')

    %% Perturb each cell and simualte
    finalStateGrid = zeros(Nv1,Nv2,Nv1*Nv2*2);
    tic
    for i=1:Nv1
        for j=1:Nv2
            p1 = p;
            p1.C(i,j) = p1.C(i,j)*(1+eps);
%             p1.G(i,j) = p1.G(i,j)*(1+eps);
            [X1, ~] = forwardEuler(@evalf,x0,p1,u,tStop,dt);
            finalStateGrid(i,j,:) = X1(:,end);
        end
    end

%     filename = sprintf('dCFinalStates_eps=%.000d_dt=%.000d_tstop=%d.mat', eps, dt, tStop);
    filename = sprintf('dCFinalStates_eps=%.000d_dt=%.000d_tstop=%d.mat', eps, dt, tStop);
    save(filename, 'finalStateGrid', 'baseline', 'eps', 'dt', 'tStop', 'Nv1', 'Nv2', 'p');
    toc
end


clear; clc; close all;

% load data and resize
addpath('maps');
map0 = load('maps/map0/map0.mat');
map = resizeMap(map0, 0.02);

% grid size
[Nv1, Nv2] = size(map.capacity);

% pixel size
pixL = map0.l2/Nv2;

% initial state
xa = map.ic;
xl = map.ic*17.2;
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

%% Testing small dt -- Forward Euler
dts = [0.01, 0.1, 1, 10];
tStop = 50;
relerr_smdt = zeros(length(dts),1);
figure(1);
hold on
for i = 1:length(dts)
    [X, ~] = forwardEuler(@evalf,x0,p,u,tStop,dts(i));
    totalAdultHist = sum(X(n/2+1:end,:),1);
    plot(0:dts(i):tStop,totalAdultHist);
%     relerr_smdt(i) = norm(X(:,end)-X_true(:,end))/norm(X_true(:,end));
end
hold off
legend('dt=0.01','dt=0.1','dt=1','dt=10', 'Location', 'northwest')
xlabel('Days')
ylabel('Total adult beetles')
title('Population growth for varying dt')

%% Ground Truth
tStop = 10;
dt = 0.01;
tic;
[XTRUE, ~] = forwardEuler(@evalf,x0,p,u,tStop,dt);
totalAdultHistTRUE = sum(XTRUE(n/2+1:end,:),1);
toc
save('groundTruth.mat', 'XTRUE')

%% FE time and accuracy test
data = load('groundTruth.mat');
tStop = 20;
dt = 1;
tic
[X, ~] = forwardEuler(@evalf,x0,p,u,tStop,dt);
forwardEulerTime = toc
totalAdultHist = sum(X(n/2+1:end,:),1);

%% Trapezoidal
clc
dt = 20;
tStop = 20;

tic
X = TrapezoidGCR(@evalf,@eval_Jf_Stamping,x0,p,u,0,tStop,dt);
toc
totalAdultHist = sum(X(n/2+1:end,:),1);


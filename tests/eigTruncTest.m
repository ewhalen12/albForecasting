
% eigTruncTest
% uses parameters from evalfTest13
% reduces model to q eigen modes of a linearized system
% uses Forward Euler to propagate the linearized system forward in time

clear;clc;close all;
addpath('../maps');

% ---------------- state vector and parameter set up ---------------------

% load data and resize
map0 = load('../maps/map0/map0.mat');
map = resizeMap(map0, 0.01);
[h,w] = size(map0.ic);

% Manual size select
maxXY = 15; % the larger the grid the farther off the reduced models are

% square map
map.capacity = map.capacity(1:maxXY, 1:maxXY);
map.ic       = map.ic(1:maxXY, 1:maxXY);
map.resistance = map.resistance(1:maxXY, 1:maxXY);

% grid size
[Nv1, Nv2] = size(map.capacity);

% pixel size
pixL = map0.l2/Nv2;

% initial state
xl = zeros(Nv1, Nv2);
xa = map.ic;
x0 = cat(3, xl, xa);
x0 = x0(:);
n  = length(x0);

% input parameters
p.alpha = 0.001; % maturation rate
p.beta  = 0.3125; % larvae birth rate
p.mul   = 0.0001; % larvae death rate
p.mua   = 0.0001; % adult death rate
p.Nv1   = Nv1; % pixels in 1-direction
p.Lv1   = pixL*Nv1; % physical length of map in 1-direction
p.C     = map.capacity*0.05*6.7*pixL^2; % 0.05 trees per m^2, 6.7 adults per tree
p.G     = map.resistance/100;
u = 0*x0; % no input... makes linearizing slightly more complicated

%%
% --------------- ROM scheme (eigen value) --------------------------------

% to solve 
% d/dt x = Ax + bu(t)
% y = c^T x

% I need: 
% for linearized system matrix A
% b: u(t) multipliers
b = ones(n,1);
% c: output selection vector
c = ones(n,1);
% q: number of vectors to include in reduced model
q = [5, 100, 400 ]; 

dt = 100;       % same as from evalfTest13
tStop = 10*dt;  % same as from evalfTest13

% Jacobian Stamping
A = eval_Jf_Stamping(x0,p);
%f0 = evalf(x0,p,u);
fprintf('done stamping \n')

% solve original system
p.A = A;
flin = @(x,p,u) p.A*x; % d/dt x = Ax + bu(t)
[X] = forwardEuler(flin,x0,p,u,tStop,dt);
y = c.' * X; 

N_q = numel(q);
for i = 1:N_q
    qi = q(i);
    % solve system of q dimensions
    fprintf('reducing system %i modes...', qi)
    [A_, b_, c_, sys] = eigTrunc(A, b, c, qi);
    fprintf('system reduced to %i modes \n', qi)

    % propagate it forward using FE or Trap/BE to compare with original
    p.A = A_;
    x0_ = ones(qi,1); % ??? WHAT WOULD BE AN APROPRIATE INPUT FOR OUR PROBLEM? 
    [X_, T] = forwardEuler(flin,x0_,p,u,tStop,dt);
    y_(i,:) = c_ * X_; % final output for c = ones
end

%%
% Total number of beetles over time
figure
plot(T, abs(y_.'))
hold on
plot(T, y)
hold off
legend(['q=',num2str(q(1))],['q=',num2str(q(2))],['q=',num2str(q(3))], 'original')
title('total number of beetles as a function of time')

figure
semilogy(T, abs(y_.'))
hold on
semilogy(T, y)
hold off
legend(['q=',num2str(q(1))],['q=',num2str(q(2))],['q=',num2str(q(3))], 'original')
title('semilog plot of y as a function of time')

% error analysis
y_d = y_(1:N_q,:) - y; % subtract full solution
y_d = abs(y_d);

figure()
semilogy(T,y_d)
xlabel('t')
ylabel('|y_q(t) - y(t)|')
legend(['q=',num2str(q(1))],['q=',num2str(q(2))],['q=',num2str(q(3))],'Location', 'best')



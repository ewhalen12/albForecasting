% test sparsity
clear;clc;close all;

% grid size
Nv1 = 5;
Nv2 = 5;

% initial state
xl = rand(Nv1, Nv2); % larvae concentrations
xa = rand(Nv1, Nv2); % adult concentrations
x0 = cat(3, xl, xa);

% input parameters
p.alpha = 0.001; % maturation rate
p.beta = 0.3125; % larvae birth rate
p.mul = 0.001; % larvae death rate
p.mua = 0.025; % adult death rate
p.Lv1 = Nv1/max(Nv1,Nv2); % physical length of map in 1-direction
p.C = 0*ones(Nv1, Nv2);
p.G = 0.1*ones(Nv1, Nv2);

% calculate the Jacobian
A = eval_Jf_Stamping(x0,p);  % breaks if non-square

% visualize A
figure;
imagesc(A);
colorbar

figure;
imagesc(A~=0);
colorbar

% visualize LU decomp
[L, U] = lu(A);
% [L, U, P] = lu(A);
% [L,U,P,Q] = lu(A);
% [L, U] = lu(A,eye(2*Nv1*Nv2))
figure;
imagesc(L~=0);
colorbar

figure;
imagesc(U~=0);
colorbar

% figure;
% imagesc(P~=0);
% colorbar

% visualize fill in
F = (L+U~=0) + (A~=0);
figure;
imagesc(F);
colorbar

% evaluate sparsity
N = 2*Nv1*Nv2;
Nn = 4*(N-Nv1);
fprintf('Unknowns: %i\n', N);
fprintf('Grid size: %i\n', N^2);
fprintf('Nonzero entries: %i\n', Nn);
fprintf('Nonzero entries (count): %i\n', sum(sum(A~=0)));
fprintf('Sparsity ratio: %f\n', sum(sum(A~=0))/numel(A));
fprintf('Fill in during LU: %i\n', sum(sum((L+U~=0) - (A~=0))));

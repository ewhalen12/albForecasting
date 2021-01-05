% evaluates the condition number
clear;clc;close all;

% grid size
Nv1 = 5;
Nv2 = 5;

% initial state
xl = 0*ones(Nv1, Nv2); % larvae concentrations
xa = 0*ones(Nv1, Nv2); % adult concentrations
x0 = cat(3, xl, xa);
x0 = x0(:);

% input parameters
% p.alpha = 0.001; % maturation rate
p.alpha = 1; % maturation rate
p.beta = 0; % larvae birth rate
% p.mul = 0.001; % larvae death rate
p.mul = 1; %larvae death rate
p.mua = 1; % adult death rate
p.Nv1 = Nv1;
p.Lv1 = Nv1/max(Nv1,Nv2); % physical length of map in 1-direction
p.C = 0*ones(Nv1, Nv2);
p.G = 0.1*ones(Nv1, Nv2);
u = 0*x0;


fprintf('STATE			LOG10(K)\n');

A = eval_Jf_FiniteDiff(@evalf,x0,p,u,1e-15);
fprintf('Zero larvae or adults:		%f\n', log10(cond(A)));

xl = 10000*ones(Nv1, Nv2); % larvae concentrations
xa = 0*ones(Nv1, Nv2); % adult concentrations
x0 = cat(3, xl, xa);

A = eval_Jf_FiniteDiff(@evalf,x0,p,u,1e-15);
fprintf('Max larvae:			%f\n', log10(cond(A)));

xl = 0*ones(Nv1, Nv2); % larvae concentrations
xa = 10000*ones(Nv1, Nv2); % adult concentrations
x0 = cat(3, xl, xa);

A = eval_Jf_FiniteDiff(@evalf,x0,p,u,1e-15);
fprintf('Max adults:			%f\n', log10(cond(A)));

xl = 10000*ones(Nv1, Nv2); % larvae concentrations
xa = 10000*ones(Nv1, Nv2); % adult concentrations
x0 = cat(3, xl, xa);

A = eval_Jf_FiniteDiff(@evalf,x0,p,u,1e-15);
fprintf('Max both:			%f\n', log10(cond(A)));

xl = 10*ones(Nv1, Nv2); % larvae concentrations
xa = 10*ones(Nv1, Nv2); % adult concentrations
x0 = cat(3, xl, xa);

A = eval_Jf_FiniteDiff(@evalf,x0,p,u,1e-15);
fprintf('10 both:				%f\n', log10(cond(A)));

xl = 100*ones(Nv1, Nv2); % larvae concentrations
xa = 100*ones(Nv1, Nv2); % adult concentrations
x0 = cat(3, xl, xa);

A = eval_Jf_FiniteDiff(@evalf,x0,p,u,1e-15);
fprintf('100 both:			%f\n', log10(cond(A)));

xl = rand(Nv1, Nv2); % larvae concentrations
xa = rand(Nv1, Nv2); % adult concentrations
x0 = cat(3, xl, xa);

A = eval_Jf_FiniteDiff(@evalf,x0,p,u,1e-15);
fprintf('rand both:			%f\n', log10(cond(A)));












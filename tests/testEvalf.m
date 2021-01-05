clear;clc;close all;
addpath('../');

%% Non-spatial tests (grid size 1x1) %%
% No birth, death, or spread
evalfTest00()

% No birth, death, or spread. Fast maturation
evalfTest01()

% No birth or spread. Include death
evalfTest02()

% No birth or spread. Higher mortality rate
evalfTest03()

% No birth or spread. Adults only
evalfTest04()

% No spread. Add birth
evalfTest05()

% No spread. Higher birth rate
evalfTest06()

% No spread. Stable (death rates modified to reach equilibrium)
evalfTest07()

%% Spatial tests %%

% No birth or death. Uniform capacitance C=0
evalfTest08()

% No birth or death. Uniform capacitance C=0 (converged)
evalfTest09()

% No birth or death. Add uniform capacity
evalfTest10()

% No birth or death. Non-uniform capacity
evalfTest11()

% Test non-square input
evalfTest12()

%% Other tests %%
% Map0 with scale 0.01 (61x49)
evalfTest13()

% Jacobian tests
evalJfTest00()

% Test to infer initial larvae population
evalftest14()
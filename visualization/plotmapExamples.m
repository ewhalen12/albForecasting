clear;clc;close all;

% load some map data
addpath('../maps');
map0 = load('../maps/map0/map0.mat');
map = resizeMap(map0, 0.01);
[Nv1, Nv2] = size(map.capacity);
pos = [950 50 700 700*Nv1/Nv2];

% load some simulatino data
data = load('sampleResults.mat');
X = data.X;
Nv1 = data.Nv1;
[Xa, Xl]=vector2map(X, Nv1);


%%%%% STATIC IMAGE EXAMPLES %%%%%

% plot a 2D contour
plotmap(map.capacity, 'ALB Geographic Capacity');

% apply a background image
plotmap(map.capacity, 'ALB Geographic Capacity - Cutoff=0.8', 'cutoff', 0.8, 'background', 'satellite')


%%%%% ANIMATION EXAMPLES %%%%%

% plot an animated contour
plotmap(Xa, 'ALB Forecast');

% plot animated contour with cutoff and background
plotmap(Xa, 'ALB Forecast - Cutoff=30', 'cutoff', 30, 'background', 'satellite')

% change the background and playback speed
plotmap(Xa, 'ALB Forecast - Cutoff=30', 'cutoff', 30, 'background', 'driving', 'fps', 30)




% Tests the use of the imresize() function to arbitrarily change the grid
% size of the map data

clear;clc;close all;

% load data
map0 = load('code/maps/map0/map0.mat');
f1 = figure; imagesc(map0.ic); colorbar; truesize(f1);

% resize
scale = 0.01;

% default interpolation algorithm is 'bicubic' which can produce values
% outside of the original range
% Ic = imresize(map0.ic, scale);
% C = imresize(map0.capacity, scale);
% R = imresize(map0.resistance, scale);

% bilinear interp does not preserve total number
% Ic = imresize(map0.ic, scale, 'bilinear');
% C = imresize(map0.capacity, scale, 'bilinear');
% R = imresize(map0.resistance, scale, 'bilinear');

% our resize implementation sums over blocks
Ic = resizeMap(map0.ic, scale);
C = resizeMap(map0.capacity, scale);
R = resizeMap(map0.resistance, scale);

totalBeetles = sum(map0.ic(:))
totalBeetles = sum(Ic(:))

f = figure('Position', f1.Position); imagesc(Ic); colorbar;
saveas(gcf,'maps/map0/initialContourResizeMap0.jpg');
f = figure('Position', f1.Position); imagesc(C); colorbar;
saveas(gcf,'maps/map0/treecoverContourResizeMap0.jpg');
f = figure('Position', f1.Position); imagesc(R); colorbar;
saveas(gcf,'maps/map0/resistanceContourResizeMap0.jpg');


% Extracts data from cropped images. For RGB images this involves buildling
% a mask for certain colors. For grayscale images the pixel values are
% simply noramlized. Writes final map data to .mat file.

clear;clc;close all;

% process initial conditions
% create mask from red dots
initial = imread('maps/map0/initialMap0.jpg');
d = 2; % RGB tolerance
r1 = initial(:,:,1) < 254+d;
r2 = initial(:,:,1) > 254-d;
g1 = initial(:,:,2) < 123+d;
g2 = initial(:,:,2) > 123-d;
b1 = initial(:,:,3) < 122+d;
b2 = initial(:,:,3) > 122-d;
ic = r1.*r2.*g1.*g2.*b1.*b2;
totalBeetles = sum(ic(:))

f1 = figure; imagesc(ic); colorbar; truesize(f1);
saveas(gcf,'maps/map0/initialContourMap0.jpg');

% process treecover
treecover = imread('maps/map0/treecoverMap0.jpg');
capacity = double(treecover(:,:,1))/255.0;
f2 = figure; imagesc(capacity); colorbar; truesize(f2);
saveas(gcf,'maps/map0/treecoverContourMap0.jpg');

% process resistance
resistanceImg = imread('maps/map0/resistanceMap0.jpg');
resistance = double(resistanceImg(:,:,1))/255.0;
f3 = figure; imagesc(resistance); colorbar; truesize(f3);
saveas(gcf,'maps/map0/resistanceContourMap0.jpg');

% store the physical map width in km 
l2 = 7.71*1609.34;

% save all data
save('maps/map0/map0.mat', 'ic', 'capacity', 'resistance', 'l2')


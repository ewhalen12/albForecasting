% Imports image data from various sources representing the treecover, 
% ALB discovery locations, travel resistance, etc. Images are croped,
% scaled and resized based on user selected control points and written to
% file.

clear;clc;close all;

% import images
initial = imread('../mapData/mass-worcester-county-infestation-overview.jpg');
satellite = imread('../mapData/satellite_labels.png');
drivingMap = imread('../mapData/map_basic.png');
treecover = imread('../mapData/treecover_grayscale.png');
resistance = imread('../mapData/fromArthur/Order1_e_Dist025_2-5m_WaterND.tif');

% correct negative resistance values
resistance(resistance < 0) = 1;

% plot un-cropped resistance
figure; imshow(resistance);
saveas(gcf,'maps/map0/uncroppedR0.jpg');

% crop reistance
% [img,rect] = imcrop(resistance);  % INTERACTIVE
rect = [2.10551e+03,2.28251e+03,4.85698e+03,6.03298e+03];  % SAVED RESULT
figure; imshow(resistance); hold on;
rectangle('Position', rect, 'EdgeColor', '#0072BD', 'LineWidth', 3);
saveas(gcf,'maps/map0/cropMap0.jpg');
resistance = imcrop(resistance,rect);

% transform initial condition
% cpselect(initial,resistance);  % INTERACTIVE
fixedPoints = [2.84125e+03,3.012499999999991e+02;4.12075e+03,5.53325e+03]; % SAVED RESULT
movingPoints = [7.85125e+02,4.588749999999998e+02;1.022875e+03,1.441875e+03];
tform = fitgeotrans(movingPoints,fixedPoints,'NonreflectiveSimilarity');
initial = imwarp(initial,tform,'OutputView',imref2d(size(resistance)));

% transform UM maps
% cpselect(satellite,resistance);  % INTERACTIVE
fixedPoints1 = [2.842250000000000e+03,2.997499999999991e+02;4.138750000000001e+03,5.541250000000000e+03]; % SAVED RESULT
movingPoints1 = [7.411875000000000e+02,1.959375000000001e+02;8.529374999999999e+02,6.639375000000000e+02];
tform1 = fitgeotrans(movingPoints1,fixedPoints1,'NonreflectiveSimilarity');
satellite = imwarp(satellite,tform1,'OutputView',imref2d(size(resistance)));
treecover = imwarp(treecover,tform1,'OutputView',imref2d(size(resistance)));
drivingMap = imwarp(drivingMap,tform1,'OutputView',imref2d(size(resistance)));

% verify alignment
alignment = initial;
[h,w,c] = size(alignment);
alignment(:,1:round(w/2),:) = satellite(:,1:round(w/2),:);
figure; imshow(alignment);

% save images
imwrite(alignment, 'maps/map0/alignmentMap0.jpg');
imwrite(resistance, 'maps/map0/resistanceMap0.jpg');
imwrite(satellite, 'maps/map0/satelliteMap0.jpg');
imwrite(treecover, 'maps/map0/treecoverMap0.jpg');
imwrite(initial, 'maps/map0/initialMap0.jpg');
imwrite(drivingMap, 'maps/map0/drivingMap0.jpg');




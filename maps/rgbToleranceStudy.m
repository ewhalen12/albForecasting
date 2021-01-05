% study of color tolerance on beetle extraction for initial
% conditions
clear; clc; close all;

initial = imread('code/maps/map0/initialMap0.jpg');
figure; imshow(initial);

totalBeetles = [];
tolerance = 0:5;
for tol = tolerance
    r1 = initial(:,:,1) < 254+tol;
    r2 = initial(:,:,1) > 254-tol;
    g1 = initial(:,:,2) < 123+tol;
    g2 = initial(:,:,2) > 123-tol;
    b1 = initial(:,:,3) < 122+tol;
    b2 = initial(:,:,3) > 122-tol;
    ic = r1.*r2.*g1.*g2.*b1.*b2;
    totalBeetles = [totalBeetles, sum(ic(:))];
    f1 = figure; imagesc(ic); colorbar; truesize(f1);
    title(sprintf('tolerance: %i', tol));
end

figure; plot(tolerance, totalBeetles, '-o'); xlabel('RGB tolerance');
ylabel('total number of beetles');
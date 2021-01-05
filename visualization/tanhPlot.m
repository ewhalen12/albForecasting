clear; clc; close all;

x = -7:0.1:7;
C = 1;
y = 0.5*tanh(x-C)+0.5;
plot(x, y, 'LineWidth', 2.5, 'Color', [84 130 53]/256); hold on
line([C C], [0 1], 'Color','black','LineStyle','--');
set(gca,'xtick',[])
box off


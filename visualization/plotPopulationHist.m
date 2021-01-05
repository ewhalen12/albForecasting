function plotPopulationHist(X, plotTitle)
    n = size(X,1);
    totalLarvaeHist = sum(X(1:n/2,:),1);
    totalAdultHist = sum(X(n/2+1:end,:),1);
    figure;
    plot(totalLarvaeHist); hold on;
    plot(totalAdultHist);
    title(plotTitle);
    legend({'larvae', 'adults'}, 'Location', 'northwest');
    xlabel('iteration');
    ylabel('population size');
end
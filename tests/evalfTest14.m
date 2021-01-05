function evalfTest14()
    % load data to get initial adult count
    addpath('../maps')
    map0 = load('../maps/map0/map0.mat');
    measuredAdults = sum(map0.ic(:))
    
    % define grid and ICs
    Nv1 = 1;
    Nv2 = 1;
    xl = 5;
    xa = 0;
    x0 = cat(3, xl, xa); %initial state
    x0 = x0(:);
    n = length(x0);

    % input parameters
    p.alpha = 0.001; % maturation rate
    p.beta = 0.3125; % larvae birth rate
    p.mul = 0.0001; % larvae death rate
    p.mua = 0.0001; % adult death rate
    p.Lv1 = 1;
    p.Nv1 = Nv1; % pixels in 1-direction
    p.C = 1e10;
    p.G = 0;
    u = 0*x0;

    tStop =  700; %end time of simulation
    dt = 0.01; %timestep for Forward Euler

    % simulate
    [X, ~] = forwardEuler(@evalf,x0,p,u,tStop,dt);
    n = size(X,1);
    totalLarvaeHist = sum(X(1:n/2,:),1);
    totalAdultHist = sum(X(n/2+1:end,:),1);
    
    % plot results
    figure;
    plot(totalLarvaeHist); hold on;
    plot(totalAdultHist);
    plot(totalAdultHist*0+measuredAdults);
    title('Population history starting with 5 larvae (1x1 grid)');
    legend({'larvae', 'adults', '2020 Adult levels'}, 'Location', 'northwest');
    xlabel('iteration');
    ylabel('population size');
    
    i = find(totalAdultHist > measuredAdults, 1);
    fprintf('%d adults and %d larvae at iteration %i\n', totalAdultHist(i), totalLarvaeHist(i), i);
    fprintf('there are %f larvae for every adult\n', totalLarvaeHist(i)/totalAdultHist(i));
end



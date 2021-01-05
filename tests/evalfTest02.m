function evalfTest02()
	% grid size
	Nv1 = 1;
	Nv2 = 1;

	% initial state
	xl = 100*ones(Nv1, Nv2); % larvae concentrations
	xa = 0*ones(Nv1, Nv2); % adult concentrations
	x0 = cat(3, xl, xa);
    x0 = x0(:);
    n = length(x0);

	% input parameters
	p.alpha = 0.001; % maturation rate
	p.beta = 0.0; % larvae birth rate
	p.mul = 0.001; % larvae death rate
	p.mua = 0.025; % adult death rate
    p.Nv1 = Nv1; % pixels in 1-direction
	p.Lv1 = Nv1/max(Nv1,Nv2); % physical length of map in 1-direction
	p.C = 10^8*ones(Nv1, Nv2);
	p.G = 0.1*ones(Nv1, Nv2);
	u = 0*x0;

	tStop = 10*365;
	dt = 365;
	[X, T] = forwardEuler(@evalf,x0,p,u,tStop,dt);
	totalLarvaeHist = sum(X(1:n/2,:),1);
	totalAdultHist = sum(X(n/2+1:end,:),1);

	figure;
	plot(T, totalLarvaeHist);
	hold on
	plot(T, totalAdultHist);
	legend('Larvae','Adults');
	xlabel('Time');
	ylabel('Total population size');
	title('Test02: No birth or spread. Include death');
	hold off
end
function evalfTest12()
	% grid size
	Nv1 = 5;
	Nv2 = 10;

	% initial state
	xl = zeros(Nv1, Nv2); % larvae concentrations
	xa = zeros(Nv1, Nv2); % adult concentrations
	xa(5,5) = 81;
	x0 = cat(3, xl, xa);
    x0 = x0(:);
    n = length(x0);

	% input parameters
	p.alpha = 0.001; % maturation rate
	p.beta = 0.0; % larvae birth rate
	p.mul = 0.0; % larvae death rate
	p.mua = 0.0; % adult death rate
    p.Nv1 = Nv1; % pixels in 1-direction
	p.Lv1 = Nv1/max(Nv1,Nv2); % physical length of map in 1-direction
	p.C = repmat(1:Nv2,Nv1,1);
	p.G = 0.1*ones(Nv1, Nv2);
	u = 0*x0;
    
	tStop = 1;
	dt = 0.001;
	[X, T] = forwardEuler(@evalf,x0,p,u,tStop,dt);
	totalLarvaeHist = sum(X(1:n/2,:),1);
	totalAdultHist = sum(X(n/2+1:end,:),1);

	figure;
    xa = reshape(X(n/2+1:end,1),Nv1,Nv2);
	imagesc(xa);
	title('Test12: Uniform capacitance C=0 converged (start)');
	colorbar

	figure;
    xa = reshape(X(n/2+1:end,end),Nv1,Nv2);
	imagesc(xa);
	title('Test12: Uniform capacitance C=0 converged (end)');
	colorbar
    
	disp(sprintf('Beetles at start: %f\n', totalAdultHist(1)));
	disp(sprintf('Beetles at end: %f\n', totalAdultHist(end)));
end


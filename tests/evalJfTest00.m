function evalJfTest00()
	% grid size
	Nv1 = 3;
	Nv2 = 5;

	% initial state
	xl = 100*ones(Nv1, Nv2); % larvae concentrations
	xa = 0*ones(Nv1, Nv2); % adult concentrations
	x0 = cat(3, xl, xa);
    x0 = x0(:);
    n = length(x0);

	% input parameters
	p.alpha = 0.001; % maturation rate
	p.beta = 0.3125; % larvae birth rate
	p.mul = 0.001; % larvae death rate
	p.mua = 0.025; % adult death rate
    p.Nv1 = Nv1; % pixels in 1-direction
	p.Lv1 = Nv1/max(Nv1,Nv2); % physical length of map in 1-direction
	p.C = 10^8*ones(Nv1, Nv2);
	p.G = 0.1*ones(Nv1, Nv2);
	u = 0*x0;
    
    eps = 0.000000001;

    Jf1=eval_Jf_FiniteDiff(@evalf,x0,p,u,eps);
    Jf2=eval_Jf_Stamping(x0,p,u);
	
	maxdDif = max(abs(Jf1(:)-Jf2(:)));
	fprintf('Max abs diff between jacobians: %f\n', maxdDif);
end
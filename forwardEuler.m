% currently requires that (tStop-tStart) be a multiple of dt
% currently starts at t=0.0
function [X, T] = forwardEuler(f,x0,p,u,tStop,dt)
	t = 0;
    N = length(x0);
	Nt = ceil(tStop/dt)+1; % number of time
	
	T = zeros(1,Nt);
	X = zeros(N,Nt);
	
	T(1) = t;
	X(:,1) = x0;
	for n=2:Nt
		t = t + dt;
		xlast = X(:,n-1);
		X(:,n) = xlast + dt*f(xlast,p,u);
		T(n) = t;
	end
end
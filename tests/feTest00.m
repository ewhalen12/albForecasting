function result = feTest00()
    x0 = 0; p = 0; u = 0;
	f = @(x,p,u) 7;
	solution = @(x,x0) 7*x;
	tStart = 0;
	tStop = 1.0;
	dt = 0.0001;
	[X, T] = forwardEuler(f,x0,p,u,tStop,dt);
	simulation = reshape(X(1,:),1,[]);
	sol = solution(T);
	err = norm((simulation - sol), 1)/length(T);
	if err < 1e-10
		result = 'PASS';
	else
		result = 'FAIL';
	end
end
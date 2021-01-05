function [Jf, fx] = eval_Jf_FiniteDiff(evalf,x,p,u,eps) 
    n = length(x);
	Jf = zeros(n,n);

    fx = evalf(x,p,u); % nominal run
	for i=1:n
		ei = zeros(n,1);
		ei(i) = eps;
		fxeps = evalf(x + ei,p,u);
		Jf(:,i) = (fxeps(:) - fx(:))./eps;
	end
end


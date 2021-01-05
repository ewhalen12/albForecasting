function f = evalf(x,p,u)
    n = length(x);
    Nv1 = p.Nv1; % pixels in 1-direction
	Nv2 = n/(2*Nv1); % pixels in 2-direction
	
	dv = p.Lv1/Nv1; % pixel size
	
	xl = reshape(x(1:n/2),Nv1,Nv2); % larvae state
	xa = reshape(x(n/2+1:end),Nv1,Nv2); % adult state
	
	fl = zeros(Nv1,Nv2);
	fa = zeros(Nv1,Nv2);
	
	% temporal updates
	for i = 1:Nv1
		for j = 1:Nv2
			% larvae
			fl(i,j) = fl(i,j) + p.beta*xa(i,j); % larvae birth
			fl(i,j) = fl(i,j) - p.mul*xl(i,j);  % larvae death
			fl(i,j) = fl(i,j) - p.alpha*xl(i,j);  % maturation

			% adults
			fa(i,j) = fa(i,j) + p.alpha*xl(i,j); % maturation
			fa(i,j) = fa(i,j) - p.mua*xa(i,j);  % adult death
		end
	end
	
	% spatial updates
	if (Nv1+Nv2) > 2		% if larger than 1x1 grid
		for i = 1:Nv1
			for j = 1:Nv2
				% count neighbors
				numNeighbors = 4;
				if (i == 1 || i == Nv1) numNeighbors = numNeighbors - 1; end
				if (j == 1 || j == Nv2) numNeighbors = numNeighbors - 1; end
				
				% flow out of cell i,j
				space = xa(i,j)-p.C(i,j);
				flowOut = (0.5*tanh(space)+0.5)*space*numNeighbors/(4*p.G(i,j)*dv^2);
				fa(i,j) = fa(i,j) -  flowOut;
					
				% flow into neighbors
				if (i > 1) fa(i-1,j) = fa(i-1,j) + flowOut/numNeighbors; end
				if (i < Nv1) fa(i+1,j) = fa(i+1,j) + flowOut/numNeighbors; end
				if (j > 1) fa(i,j-1) = fa(i,j-1) + flowOut/numNeighbors; end
				if (j < Nv2) fa(i,j+1) = fa(i,j+1) + flowOut/numNeighbors; end
			end
		end
	end
	f = cat(3, fl, fa);
    f = f(:)+u;
end

% To do:
% consider starvation - death rate a function of density
% human interference is a source
% vectorize for effiency
%

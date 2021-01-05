function Jf = eval_Jf_Stamping(x,p,u)
    n = length(x);
	Nv1 = p.Nv1; % pixels in 1-direction
	Nv2 = n/(2*Nv1); % pixels in 2-direction
	
	dv = p.Lv1/Nv1; % pixel size
   
	xa = reshape(x(n/2+1:end),Nv1,Nv2); % adult state
    
    Jf = zeros(n,n);

	% temporal updates
	for i = 1:Nv1
		for j = 1:Nv2
			% larvae
			Jf(crd(i,j,1),crd(i,j,1)) = Jf(crd(i,j,1),crd(i,j,1)) - p.mul - p.alpha;
            Jf(crd(i,j,1),crd(i,j,2)) = Jf(crd(i,j,1),crd(i,j,2)) + p.beta;
        
			% adults
            Jf(crd(i,j,2),crd(i,j,1)) = Jf(crd(i,j,2),crd(i,j,1)) + p.alpha;
			Jf(crd(i,j,2),crd(i,j,2)) = Jf(crd(i,j,2),crd(i,j,2)) - p.mua;  % adult death
		end
	end
	
	% spatial updates
	if (Nv1+Nv2) > 2		% if larger than 1x1 grid
		for i = 1:Nv1
			for j = 1:Nv2
				% flow out of cell i
                space = xa(i,j)-p.C(i,j);
% 				space = x(i,j,2)-p.C(i,j);
				flowDeriv = ((tanh(space)+1) + (1-tanh(space)^2)*space)/(2*p.G(i,j));
				Jf(crd(i,j,2),crd(i,j,2)) = Jf(crd(i,j,2),crd(i,j,2)) - flowDeriv;
				
				% count neighbors
				numNeighbors = 4;
				if (i == 1 || i == Nv1) numNeighbors = numNeighbors - 1; end
				if (j == 1 || j == Nv2) numNeighbors = numNeighbors - 1; end
					
				% flow into neighbors
				if (i > 1) Jf(crd(i-1,j,2),crd(i,j,2)) = Jf(crd(i-1,j,2),crd(i,j,2)) + flowDeriv/numNeighbors; end
				if (i < Nv1) Jf(crd(i+1,j,2),crd(i,j,2)) = Jf(crd(i+1,j,2),crd(i,j,2)) + flowDeriv/numNeighbors; end
				if (j > 1) Jf(crd(i,j-1,2),crd(i,j,2)) = Jf(crd(i,j-1,2),crd(i,j,2)) + flowDeriv/numNeighbors; end
				if (j < Nv2) Jf(crd(i,j+1,2),crd(i,j,2)) = Jf(crd(i,j+1,2),crd(i,j,2)) + flowDeriv/numNeighbors; end
			end
		end
    end
    
    % helper function for indexing
    function c = crd(i,j,k)
    c = Nv1*Nv2*(k-1) + Nv2*(i-1) + j;
    end
end



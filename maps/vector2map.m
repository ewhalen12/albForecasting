% Converts a state vector to a 2D grid with 1-dimension Nv1.
% If X is a time history of size
function [Xa, Xl]=vector2map(X, Nv1)
    [n, T] = size(X);
    Nv2 = n/(2*Nv1);
    Xl = reshape(X(1:n/2,:,:),Nv1,Nv2,T);
    Xa = reshape(X(n/2+1:end,:,:),Nv1,Nv2,T);
end
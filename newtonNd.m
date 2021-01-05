function x = newtonNd(fhand,x0)
% function newtonNd(fhand,x0)
% 
% INPUTS:
%   fhand - function handle
%   x0    - initial guess
% 
% Use Newton's method to solve the nonlinear function
% defined by function handle fhand with initial guess x0.  
%
% itpause is parameter for plotting and defines the 
% number of Newton steps that are plotted sequentially
% pauses between sub-steps


tol=1e-3;          % convergence tolerance
maxIters=500;       % max # of iterations

% Newton loop
for iter=1:maxIters
    [f,J] = fhand(x0);              % evaluate function
    tic
    
    dx=-J\f;                        % solve linear system
    SYSTEM_SOLVE_TIME = toc
    SYSTEM_SIZE = size(J)
    COND = condest(J)
    nf=max(abs(f));                 % norm of f at step k+1
    x=x0+dx;                        % solution x at step k+1    
    reldx=max(abs(dx))/max(abs(x)); % norm of dx at step k+1
    x0=x;                           % set value for next guess
    if nf < tol                     % check for convergence
        % check for convergence
        fprintf('Converged in %d iterations\n',iter);
        break; 
    end
end

if iter==maxIters % check for non-convergence
    fprintf('Non-Convergence after %d iterations!!!\n',iter); 
end

end
function X = TrapezoidLU(eval_f,eval_Jf,x_start,arg1,arg2,t_start,t_stop,timestep)
% uses Trapezoidal method to simulate states model dx/dt=f(x,p,u)
% from state x_start at time t_start
% until time t_stop, with time intervals timestep
% eval_f is a function handle that evaluates f(x,p,u)

steps = ceil((t_stop-t_start)/timestep);
t = zeros(steps,1);
X = zeros(length(x_start),steps);

function [Ftrap,Jtrap] = fTrap(x,x0)
    F = eval_f(x,arg1,arg2);
    J = eval_Jf(x,arg1,arg2);
    Ftrap = x - x0 - 0.5*dt*(eval_f(x0,arg1,arg2) + F);
    Jtrap = eye(length(x)) - 0.5*dt*J;
end

X(:,1) = x_start;
t(1) = t_start;
for n=1:steps
   dt = min(timestep, (t_stop-t(n)));
   x0 = X(:,n);
   t(n+1)= t(n) + dt;
   X(:,n+1)= newtonNd(@(x)fTrap(x,x0),x0);
end

end
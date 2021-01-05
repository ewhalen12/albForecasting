% total final adult population from simulation output
function tot = totalPop(data,n)
    tot = sum(data(n/2+1:end,end));
end
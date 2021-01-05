% percent of map with at least one adult beetle
function area = beetleArea(data,n)
    area = sum(data(n/2+1:end,end)>=1)*2/n;
end
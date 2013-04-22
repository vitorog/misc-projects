function cdf = CalculateCdf(p)
L = 256;
cdf = zeros(1,L);
for i=0:(L-1)
    sum = 0;
    for j=0:i
        sum = sum + p(j+1);
    end    
    cdf(i+1) = sum;
end
end
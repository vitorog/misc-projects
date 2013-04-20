function s = CalculateOutputProbabilities(p,L)
s = zeros(1,L);
for i=0:(L-1)
    sum = 0;
    for j=0:i
        sum = sum + p(j+1);
    end
    sum = L*sum;
    s(i+1) = round(sum);
end
end
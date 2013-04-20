%This function calculates the CDF and displays a graph of a given PDF
function cdf = CalculateLuminanceCdf(pdf, name)
L = 256;
cdf = zeros(1,3*L,'double');
luminance_levels = (1:3*L);
for i=1:3*L
    if(i==1)
        cdf(i) = pdf(i);
    else
        cdf(i) = cdf(i-1) + pdf(i);
    end    
end
figure('Name', name,'NumberTitle','off');
plot(luminance_levels,cdf);
end
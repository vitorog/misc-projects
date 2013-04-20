function [ieq] = EqualizeChannelHistogram(image, cdf)
L = 256;
ieq = image;
image_size = size(ieq);
m = image_size(1,1);
n = image_size(1,2);
for i=1:m
    for j=1:n
        intensity = ieq(i,j);
        ieq(i,j) = round(L*cdf(intensity+1));
    end
end
end
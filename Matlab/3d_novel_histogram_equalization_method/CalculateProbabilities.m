function [p] = CalculateProbabilities(image, L)
image_size = size(image);
m = image_size(1,1);
n = image_size(1,2);
pixel_count = zeros(1,L);
for i=1:m
    for j=1:n        
        pixel_count(image(i,j)+1) = pixel_count(image(i,j)+1) + 1;
    end
end
p = pixel_count/(m*n);
end
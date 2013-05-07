function S = GenerateGaborKernel(size,w,sigma,theta)
S = zeros(size,size);
half_size = round(size/2);
for x=-half_size:half_size
    for y=-half_size:half_size
        S(x+(half_size+1),y+(half_size+1)) = exp(-(x^2 + y^2)/(2*(sigma^2))) * sin(w*(x*cos(theta) + y*sin(theta)));
    end
end
end
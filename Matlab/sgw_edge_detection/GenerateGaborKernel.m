function S = GenerateGaborKernel(width,height,w,s,theta)
S = zeros(width,height);
for x=1:width
    for y=1:height
        S(x,y) = exp(-(x^2 + y^2)/2*(s^2))*(w*(x*cos(theta) + y*sin(theta)));
    end
end
end
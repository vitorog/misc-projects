function S = GenerateGaborWavelet(size,w,sigma,theta)
S = zeros(size,size,'double');
half_size = round(size/2);
for x=-half_size:half_size
    for y=-half_size:half_size
        f1 = 1 / (2*pi*(sigma^2));
        f2 = (x*cos(theta) + y*sin(theta))^2 + (-x*sin(theta) + y*cos(theta))^2;
        f3 = -1/ (2*(sigma^2));
        sgw_real = f1*exp(f2*f3); 
        
        f4 = 1i*w*(x*cos(theta) + y*sin(theta));
        f5 = -(w*(sigma^2))/2;
        sgw_img = exp(f4) - exp(f5);     
        
        S(x+(half_size+1),y+(half_size+1)) = abs(sgw_real)*abs(sgw_img);
        
    end
end
end
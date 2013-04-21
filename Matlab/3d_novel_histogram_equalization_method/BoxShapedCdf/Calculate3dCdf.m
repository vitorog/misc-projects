function cdf = Calculate3dCdf(pdf)
L = 256;
cdf = zeros(L,L,L,'double');
for i=1:256
    for j=1:256
        for k=1:256               
            if(k>1)
                cdf(i,j,k) = cdf(i,j,k) + cdf(i,j,k-1) + pdf(i,j,k);                
            else
                if(j > 1)
                    cdf(i,j,k) =  cdf(i,j,k) + cdf(i,j-1,256) + pdf(i,j,k);
                else
                    if(i > 1)
                        cdf(i,j,k) =  cdf(i,j,k) + cdf(i-1,256,256) + pdf(i,j,k);
                    else
                        cdf(i,j,k) = pdf(i,j,k);
                    end
                end
            end             
        end
    end
end
end
    

function cdf = Calculate3dCdf(pdf)
L = 256;
cdf = zeros(L,L,L);
cdf(1,1,1) = pdf(1,1,1);
for i=1:L-1
    for j=1:L-1
        for k=1:L-1          
          if(i==1 && j==1 && k==1)
              cdf(i,j,k) = pdf(i,j,k);
          else
              if(i>1 && j>1 && k>1)
                  cdf(i,j,k) = cdf(i,j,k) + cdf(i-1,j-1,k-1);
              end
              if(i>1)
                  cdf(i,j,k) = cdf(i,j,k) + cdf(i-1,j,k);
              end
              if(j>1)
                  cdf(i,j,k) = cdf(i,j,k) + cdf(i,j-1,k);
              end
              if(k>1)
                  cdf(i,j,k) = cdf(i,j,k) + cdf(i,j,k-1);
              end
              if(i>1 && j>1)
                  cdf(i,j,k) = cdf(i,j,k) - cdf(i-1,j-1,k);
              end
              if(i>1 && k>1)
                  cdf(i,j,k) = cdf(i,j,k) - cdf(i-1,j,k-1);
              end              
              if(j>1 && k>1)
                  cdf(i,j,k) = cdf(i,j,k) - cdf(i,j-1,k-1);
              end              
              cdf(i,j,k) = cdf(i,j,k) + pdf(i,j,k);
              test_pdf = pdf(i,j,k)
              test_cdf = cdf(i,j,k) 
          end          
       end
    end
end
end
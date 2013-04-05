function r = hilbert_mat(n)
H = zeros(n);
for i = 1:n
    for j = 1:n
        H(i,j) = (1/(i+j-1));
    end    
end
r = H;
end
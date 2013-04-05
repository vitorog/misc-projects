function r = gauss_seidel(A,b,x0,e, max_it)
row_count = length(A(:,1));
column_count = length(A(1,:));
if(row_count ~= column_count)
    disp('Not a square matrix!');
    return;
else    
    for i=1:row_count,
        a_ii = abs(A(i,i));
        row_sum = 0;
        for j=1:column_count,
            if(i ~= j)
                row_sum = row_sum + A(i,j);
            end            
        end    
        if(row_sum > a_ii)
            disp('This matrix is not diagonal dominant. Method may NOT converge.');
            break;        
        end
    end
    if(x0 ~= 0)
        if(((x0'*A*x0) > 0) & (A' == A))
            disp('This matrix is positive definite!');
        else
            disp('The matrix is not positive definite');
        end
    end
D = zeros(length(A(1,:)));
D(logical(eye(size(D)))) = diag(A);
L = tril(A) - D;
U = triu(A) - D;
old_x = x0;
it = 0;
while(true)
    x = (D + L)\(b - (U*old_x));   
    if(abs(x - old_x) <= e)
        break;
    end
    if(it >= max_it)
        disp('Reached max iterations.');
        break;
    end
    it = it + 1;
    old_x = x;
end
r = x;
it_str = num2str(it);
disp(['Finished after ' it_str ' iterations']);
end
%This function returns a vector with the spectral radius of the G matrix
%used in the Gauss Jacobi and Gauss Seidel method
function r = spectral_radius(A)

%Gauss Jacobi:
r = [0 0];
D = zeros(size(A));
D(logical(eye(size(D)))) = diag(A);
L = tril(A) - D; %L is the strict lower triangular matrix of A
U = triu(A) - D; %U " " strict upper " " " "
%Gauss Jacobi splitting:
M = D;
N = -(L + U);
G = M\N;
r(1,1) = max(abs(eig(G)));

%Gauss Seidel:
%Gauss Seidel splitting:
M = D + L;
N = -U;
G = M\N;
r(1,2) = max(abs(eig(G)));
disp(['Gauss Jacobi G: ' num2str(r(1,1))]);
disp(['Gauss Seidel G: ' num2str(r(1,2))]);



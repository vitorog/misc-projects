function [X_PCS, x_mean, Y_PCS, y_mean] = GetPrincipalComponents(X,Y, num_principal_components)
% x_mean = mean(mean(X));
% MX = X - x_mean;
% MX_Co = MX*MX'/size(MX,1)*size(MX,2);
% [WX,DX] = eig(MX_Co);
% 
% y_mean = mean(mean(Y));
% MY = Y - y_mean;
% MY_Co = MY*MY'/size(MY,1)*size(MY,2);
% [WY,~] = eig(MY_Co);

num_samples = size(X,2);
x_mean = mean(X,2);
MX = X;
for k=1:num_samples
    MX(:,k) = MX(:,k) - x_mean;
end
% MX_Co = MX*MX'/size(MX,1)*size(MX,2);
MX_Co = MX*MX'/num_samples;
[WX,DX] = eig(MX_Co);

num_samples = size(Y,2);
y_mean = mean(Y,2);
MY = Y;
for k=1:num_samples
    MY(:,k) = MY(:,k) - y_mean;
end
% MY_Co = MY*MY'/size(MY,1)*size(MY,2);
MY_Co = MY*MY'/num_samples;
[WY,DY] = eig(MY_Co);



num_values = size(DX,2);
X_PCS = fliplr(WX(:,num_values - num_principal_components + 1:num_values));
num_values = size(DY,2);
Y_PCS = fliplr(WY(:,num_values - num_principal_components + 1:num_values));
end
function is_spam = ClassifyMessage(message, features,complete_vocabulary,num_files, X_PCS,Y_PCS, x_mean, y_mean, alfa, beta)
msg_vector = BuildMessageVector(message,features,complete_vocabulary,num_files);
x_msg = (X_PCS*X_PCS')*(msg_vector - x_mean) + x_mean;
y_msg = (Y_PCS*Y_PCS')*(msg_vector - y_mean) + y_mean;

rx = ReconstructionError(msg_vector,x_msg);
ry = ReconstructionError(msg_vector,y_msg);

r = alfa*ry - beta*rx;
if(r < 0)
    is_spam = 1;
else
    is_spam = 0;
end
end
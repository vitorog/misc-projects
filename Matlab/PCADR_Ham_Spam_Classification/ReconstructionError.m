function error = ReconstructionError(original_msg,reconstructed_msg)
sum = 0;
for k=1:size(original_msg,1)
    sum = sum + (original_msg(k,1) - reconstructed_msg(k,1))^2;    
end
error = sqrt(sum);
end
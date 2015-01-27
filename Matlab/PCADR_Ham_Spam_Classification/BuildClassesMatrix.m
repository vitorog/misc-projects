function [X,Y] = BuildClassesMatrix(training_folder_path,spam_id,header_lines, num_spam_files, num_ham_files, num_features,features,complete_vocabulary)
messages = dir(fullfile(training_folder_path,'*.txt'));
num_files = length(messages);

X = zeros(num_features, num_ham_files);
Y = zeros(num_features, num_spam_files);
spam_index = 1;
ham_index = 1;
disp(['Building ' training_folder_path ' matrix...']);
fprintf('%06.2f',0);
for k=1:num_files
    fprintf('\b\b\b\b\b\b\b%06.2f%%',k/num_files*100);
    file_path = [training_folder_path '/' messages(k).name];
    is_spam = ~isempty(strfind(file_path,spam_id));
    fid = fopen(file_path);
    msg = textscan(fid,'%s','HeaderLines',header_lines);
    msg = msg{1};
    fclose(fid);
    msg_vector = BuildMessageVector(msg,features,complete_vocabulary,num_files);
    if(~is_spam)        
        X(:,ham_index) = msg_vector;
        ham_index = ham_index + 1;
    else        
        Y(:,spam_index) = msg_vector;
        spam_index = spam_index + 1;
    end
    
end
fprintf('\n');
end
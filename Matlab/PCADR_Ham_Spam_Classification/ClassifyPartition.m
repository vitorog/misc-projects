function [ratio, precision, recall, f_score] = ClassifyPartition...
    (path, header_lines, spam_msgs_id,features,complete_vocabulary,...
    X_PCS,Y_PCS, x_mean, y_mean, alfa, beta)

messages = dir(fullfile(path,'*.txt'));
num_files = length(messages);

errors = 0;
msg_time = tic;
disp('Classifying messages...');
fprintf('%06.2f',0);
tp = 0;
fp = 0;
fn = 0;
tn = 0;
for k=1:num_files
    fprintf('\b\b\b\b\b\b\b%06.2f%%',k/num_files*100);
    file_path = [path '/' messages(k).name];
    is_spam = ~isempty(strfind(file_path,spam_msgs_id));
    fid = fopen(file_path);
    msg = textscan(fid,'%s','HeaderLines',header_lines);
    msg = msg{1};
    fclose(fid);
    is_spam_classifier = ClassifyMessage(msg,features,complete_vocabulary,num_files,X_PCS,Y_PCS,x_mean,y_mean,alfa,beta);
    if(is_spam)
        if(is_spam_classifier)
            tp = tp + 1;        
        else
            fn = fn + 1;
        end
    else
        if(is_spam_classifier)
            fp = fp + 1;        
        end
    end
    if(is_spam_classifier ~= is_spam)
        errors = errors + 1;
    end
end
fprintf('\n');
toc(msg_time);
ratio = ((num_files - errors) / num_files)*100;
precision = (tp/(tp + fp))*100;
recall = (tp/(tp + fn))*100;
f_score = (2*precision*recall)/(precision + recall);
end
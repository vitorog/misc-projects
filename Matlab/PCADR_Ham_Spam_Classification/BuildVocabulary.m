%training_folder_path: path of the training folder
%spam_id: the filename identifier of a spam message file
%freq_threshold: if a word appears less times than this threshold, it is
%removed from the vocabulary
%header_lines: the number of lines contained in the header
function [spam_vocabulary, ham_vocabulary, complete_vocabulary, num_spam_files, num_ham_files]...
    = BuildVocabulary(training_folder_path, spam_id,... 
        header_lines, spam_vocabulary, ham_vocabulary, complete_vocabulary)
    
messages = dir(fullfile(training_folder_path,'*.txt'));
num_files = length(messages);
num_spam_files = 0;
num_ham_files = 0;

% spam_vocabulary = containers.Map;
% ham_vocabulary = containers.Map;
% complete_vocabulary = containers.Map;

msg_time = tic;
disp(['Reading ' training_folder_path ' folder and creating vocabulary...']);
fprintf('%06.2f',0);
for k=1:num_files
    fprintf('\b\b\b\b\b\b\b%06.2f%%',k/num_files*100);
    file_path = [training_folder_path '/' messages(k).name];
    is_spam = ~isempty(strfind(file_path,spam_id));
    fid = fopen(file_path);
    msg = textscan(fid,'%s','HeaderLines',header_lines);
    msg = msg{1};
    fclose(fid);
    if(is_spam)
        num_spam_files = num_spam_files + 1;
    else
        num_ham_files = num_ham_files + 1;
    end
    per_doc_word = containers.Map;
    for m=1:length(msg)
        word = msg{m};
        if(isKey(complete_vocabulary,word))
            word_count = complete_vocabulary(word);
        else
            word_count.spam_docs = 0;
            word_count.ham_docs = 0;
            word_count.total_spam = 0;
            word_count.total_ham = 0;            
        end
        if(is_spam)
            word_count.total_spam = word_count.total_spam + 1;
        else
            word_count.total_ham = word_count.total_ham + 1;
        end
        if(~isKey(per_doc_word,word))
            per_doc_word(word) = 1;
            if(is_spam)
                word_count.spam_docs = word_count.spam_docs + per_doc_word(word);
            else
                word_count.ham_docs = word_count.ham_docs + per_doc_word(word);
            end
        end
        if(is_spam)
            spam_vocabulary(word) = word_count;
        else
            ham_vocabulary(word) = word_count;
        end        
        complete_vocabulary(word) = word_count;
    end
    remove(per_doc_word,keys(per_doc_word));
end
fprintf('\n');
toc(msg_time);
end
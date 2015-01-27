function [complete_vocabulary, spam_vocabulary, ham_vocabulary] =... 
RemoveInfrequentWords(complete_vocabulary,spam_vocabulary,ham_vocabulary,freq_threshold)

vocabulary_keys = keys(complete_vocabulary);
msg_time = tic;
disp('Removing infrequent words...');
fprintf('%06.2f',0);
for k=1:length(complete_vocabulary)
    fprintf('\b\b\b\b\b\b\b%06.2f%%',k/length(vocabulary_keys)*100);
    word = vocabulary_keys{k};
    word_count = complete_vocabulary(word);
    if(word_count.spam_docs + word_count.ham_docs <= freq_threshold)
        remove(complete_vocabulary,word);
        if(isKey(ham_vocabulary,word))
            remove(ham_vocabulary,word);
        end
        if(isKey(spam_vocabulary,word))
            remove(spam_vocabulary,word);
        end        
    end
end
fprintf('\n');
toc(msg_time);
end
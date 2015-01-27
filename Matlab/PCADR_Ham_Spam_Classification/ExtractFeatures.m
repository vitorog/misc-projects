function features = ExtractFeatures(complete_vocabulary, num_spam_files, num_ham_files, num_features)
features_time = tic;
vocabulary_keys = keys(complete_vocabulary);
vocabulary_mutual_info = zeros(1,length(vocabulary_keys));
disp('Extracting features...');
fprintf('%06.2f',0);    
for k=1:length(vocabulary_keys)
    fprintf('\b\b\b\b\b\b\b%06.2f%%',k/length(vocabulary_keys)*100);
    word = vocabulary_keys{k};
    word_count = complete_vocabulary(word);
    num_files = num_spam_files + num_ham_files;
    p_x_spam = double(word_count.spam_docs / num_spam_files);
    p_x_ham = double(word_count.ham_docs / num_ham_files);
    p_not_x_spam = double((num_spam_files - word_count.spam_docs) / num_spam_files);
    p_not_x_ham = double((num_ham_files - word_count.ham_docs) / num_ham_files);
    p_x = double((word_count.spam_docs + word_count.ham_docs)/num_files);
    p_not_x = 1 - p_x;
    p_c = 0.5;
    
    mutual_info = p_not_x_ham*log(p_not_x_ham/(p_not_x*p_c)) +...
        p_not_x_spam*log(p_not_x_spam/(p_not_x*p_c)) +...
        p_x_ham*log(p_x_ham/(p_x*p_c))+...
        p_x_spam*log(p_x_spam/(p_x*p_c));
    if(isnan(mutual_info) || isinf(mutual_info))
        mutual_info = 0;
    end
    vocabulary_mutual_info(k) = mutual_info;    
end
fprintf('\n');

[~, sorted_vocabulary_idx] = sort(vocabulary_mutual_info,'descend');
features = vocabulary_keys(sorted_vocabulary_idx);
features = features(1:num_features);
toc(features_time);
end
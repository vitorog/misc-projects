function message_features = BuildMessageVector(message, features, complete_vocabulary, num_files)
words_map = containers.Map;
for m=1:length(message)
    word = message{m};
    if(isKey(words_map,word))
        words_map(word) = words_map(word) + 1;
    else
        words_map(word) = 1;
    end
end
message_features = zeros(1,length(features));
for k=1:length(features)
    word = features{k};
    if(isKey(words_map,word))
        if(isKey(complete_vocabulary,word))
            word_count = complete_vocabulary(word);
            idf = num_files/(word_count.ham_docs + word_count.spam_docs);
            message_features(k) = words_map(word)*idf;
        else
            message_features(k) = 0;
        end
    else
        message_features(k) = 0;
    end
end
message_features = normc(message_features');
% message_features = message_features';
end
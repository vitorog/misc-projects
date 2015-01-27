function [fold_ratios, fold_precision, fold_recall, fold_f_score] = TenFoldCrossValidation(path, num_features, num_principal_components, alfa, beta)
%% Initialization
folders = dir(path);
partitions = cell(1,1);
index = 1;
for k=1:length(folders)
    folder = folders(k);
    % Removes non-used folders
    if(strcmp(folder.name,'.') || strcmp(folder.name,'..') || strcmp(folder.name,'unused'))
        continue;
    end
    partitions{index} = folder;
    index = index + 1;
end

header_lines = 2;
test_partition_index = 1;
spam_msgs_id = 'spmsg';
total_timer = tic;
fold_ratios = zeros(1,length(partitions));
fold_precision = zeros(1,length(partitions));
fold_recall = zeros(1,length(partitions));
fold_f_score = zeros(1,length(partitions));
for fold=1:length(partitions)
    spam_vocabulary = containers.Map;
    ham_vocabulary = containers.Map;
    complete_vocabulary = containers.Map;
    total_spam_files = 0;
    total_ham_files = 0;    
    
    fprintf('Starting fold %d\n', fold);
    fold_timer = tic;
    %% Vocabulary construction and features extraction
    partition_info = cell(1,length(partitions) - 1);
    training_partition_index = 1;
    for k=1:length(partitions)
        if(k==test_partition_index)
            continue;
        end
        partition_path = [path '/' partitions{k}.name];
        [spam_vocabulary, ham_vocabulary, complete_vocabulary, num_spam_files, num_ham_files] = ...
            BuildVocabulary(partition_path,spam_msgs_id,header_lines, spam_vocabulary, ham_vocabulary, complete_vocabulary);
        total_spam_files = total_spam_files + num_spam_files;
        total_ham_files = total_ham_files + num_ham_files;
        info.spam_files = num_spam_files;
        info.ham_files = num_ham_files;
        partition_info{training_partition_index} = info;
        training_partition_index = training_partition_index + 1;
    end
    features = ExtractFeatures(complete_vocabulary, num_spam_files, num_ham_files, num_features);
    
    
    %% Classes matrix building
    training_partition_index = 1;
    for k=1:length(partitions)
        if(k==test_partition_index)
            continue;
        end
        partition_path = [path '/' partitions{k}.name];
        info = partition_info{training_partition_index};
        num_spam_files = info.spam_files;
        num_ham_files = info.ham_files;
        [part_X,part_Y] = BuildClassesMatrix(partition_path,spam_msgs_id,header_lines,num_spam_files,num_ham_files,num_features,features,complete_vocabulary);
        if(training_partition_index == 1)
            X = part_X;
            Y = part_Y;
        else
            X = [X, part_X];
            Y = [Y, part_Y];
        end
        training_partition_index = training_partition_index + 1;
    end
    
    
    [X_PCS,x_mean, Y_PCS, y_mean] = GetPrincipalComponents(X,Y, num_principal_components);
    
    %% Testing section
    test_partition_path = [path '/' partitions{test_partition_index}.name];
    [ratio, precision,recall,f_score] = ClassifyPartition(test_partition_path,header_lines,spam_msgs_id,features,...
        complete_vocabulary,X_PCS,Y_PCS,x_mean,y_mean,alfa,beta);
    fprintf('Fold %d ratio:%.2f%%\n', fold, ratio);
    fprintf('Fold %d precision:%.2f%%\n', fold, precision);
    fprintf('Fold %d recall:%.2f%%\n', fold, recall);
    fprintf('Fold %d f_score:%.2f%%\n', fold, f_score);
    
    fold_ratios(fold) = ratio;
    fold_precision(fold) = precision;
    fold_recall(fold) = recall;
    fold_f_score(fold) = f_score;    
    
    test_partition_index = test_partition_index + 1;
    fprintf('Finished fold %d\n', fold);
    toc(fold_timer);
end
avg_ratio = mean(fold_ratios);
avg_precision = mean(fold_precision);
avg_recall = mean(fold_recall);
avg_f_score = mean(fold_f_score);

fprintf('Average ratio is: %.2f%%\n', avg_ratio);
fprintf('Average precision is: %.2f%%\n', avg_precision);
fprintf('Average recall is: %.2f%%\n', avg_recall);
fprintf('Average f_score is: %.2f%%\n', avg_f_score);
time_elapsed = toc(total_timer);

results_filename = ['results_' date '.txt'];
fid = fopen(results_filename,'a');
fprintf(fid,'Corpora path: %s\n', path);
fprintf(fid,'Num features: %d\n', num_features);
fprintf(fid,'Num PCs: %d\n', num_principal_components);
fprintf(fid,'Alfa: %d\n', alfa);
fprintf(fid,'Beta: %d\n', beta);
fprintf(fid,'Time elapsed: %f seconds\n', time_elapsed);
fprintf(fid,'Average ratio: %.2f%%\n', avg_ratio);
fprintf(fid,'Average precision: %.2f%%\n', avg_precision);
fprintf(fid,'Average recall: %.2f%%\n', avg_recall);
fprintf(fid,'Average f_score: %.2f%%\n\n', avg_f_score);
fclose(fid);
end
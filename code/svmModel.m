clear;
tic;
load('171220mAver.mat');

%  for one-class svm
% for i = 1 : length(Y)
%     if ismember(Y(i), [5,6])
%         Y(i) = 1;
%     else
%         Y(i) = -1;
%     end
% end
train_set = X;
train_set_labels = Y;

% mapminmax processes matrices by normalizing the minimum and maximum 
% values of each row to [YMIN, YMAX] (by default [-1, 1]).
%[dataset_scale,ps] = mapminmax(train_set.',0,5);
%dataset_scale = dataset_scale.';

% store train_set which haven't been zscored or mapminmaxed
trainSet = [zeros(1, size(train_set, 2)); train_set];
[train_set,ps] = zscore(train_set);
model = svmtrain(train_set_labels, train_set, '-t 2 -s 0 -c 1 -g 0.16');
% save train_set for zscore or mapminmax

save('svmModel.mat', 'model', 'trainSet');
Elapsed = toc;

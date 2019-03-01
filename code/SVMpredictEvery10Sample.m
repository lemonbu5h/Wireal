clear;
tic;
%load('X.mat');
%load('Y.mat');
%load('171220mAver.mat');
load('171220mAverNoDeleteNoSLYandLBW.mat');
%  for one-class svm
% for i = 1 : length(Y)
%     if ismember(Y(i), [5,6])
%         Y(i) = 1;
%     else
%         Y(i) = -1;
%     end
% end  

% repeated times
times = 1000;
if (times <= 1)
    return;
end
% trnp means train Set Propotion
trnp = 0.5;
%trnp = 0.8;
results = zeros(times, 3);
Z = [X, Y];
trnSize = trnp * length(Z);
% sample times depended on duplicate times
sampTime = length(Z) / num;
for times = 1 : times
    train_collec = [];
    test_collec = [];
    for i = 1 : sampTime
        Ztemp = Z(1 + (i - 1) * num : i * num, :); 
        Ztemp = Ztemp(randperm(num), :);
        trnTempSize = trnp * num;
        train_collec = [train_collec; Ztemp(1 : trnTempSize, :)];
        test_collec = [test_collec; Ztemp(trnTempSize + 1 : num, :)];
    end
    train_set = train_collec(:, 1:18); 
    train_set_labels = train_collec(:, 19);
    test_set = test_collec(:, 1:18);
    test_set_labels = test_collec(:, 19);   
    
    [mtrain,ntrain] = size(train_set);

    [mtest,ntest] = size(test_set);
     
    test_dataset = [train_set;test_set];

    % mapminmax processes matrices by normalizing the minimum and maximum 
    % values of each row to [YMIN, YMAX] (by default [-1, 1]).

    %[dataset_scale,ps] = mapminmax(test_dataset.',0,5);
    %dataset_scale = dataset_scale.';
    [dataset_scale,ps] = zscore(test_dataset);
    
    train_set = dataset_scale(1:mtrain,:);

    test_set = dataset_scale( (mtrain+1):(mtrain+mtest),: );
    
    model = svmtrain(train_set_labels,train_set, '-t 2 -s 0 -c 1 -g 0.16');
    
    [predict_label] = svmpredict(test_set_labels, test_set, model);

    % trulyDetectedFall
    tdf = 0;
    % wronglyDetedtedFall
    wdf = 0;
    % right predict numbers
    right = 0;
    % one class
    for i = 1 : length(predict_label)
        if predict_label(i) == 1
            if test_set_labels(i) == 1
                tdf = tdf + 1;
                right = right + 1;
            else
                wdf = wdf + 1;
            end
        % at this time, predict_label(i) equals to -1
        elseif test_set_labels(i) == -1
            right = right + 1;   
        end
    end

    %{
    % six class
    for i = 1 : length(predict_label)
        if ismember(predict_label(i), [5,6])
            if test_set_labels(i) == predict_label(i)
                tdf = tdf + 1;
            else
                wdf = wdf + 1;
            end
        end 
    end
    %}
    
    results(times, 1) = tdf * 100 / ((length(Z) - trnSize) / 3);
    results(times, 2) = wdf * 100 / (wdf + tdf);
    results(times, 3) = right * 100 / (length(Z) - trnSize);
end

meanRes = mean(results);
disp('-----------------------------------------');
disp(['Average Accuracy = ', num2str(meanRes(:, 3)), '%']);
disp(['Average DRfall = ', num2str(meanRes(:, 1)), '%']);
disp(['Average FA = ', num2str(meanRes(:, 2)), '%']);
disp(['DRfall mean square error = ', num2str(var(results(:, 1))), '']);
disp(['FA mean square error = ', num2str(var(results(:, 2))), '']);
%{
figure;

hold on;

plot(test_set_labels,'o');

plot(predict_label,'r*');

xlabel('Test Sample','FontSize',12);

ylabel('Class Label','FontSize',12);

legend('Real Results','Predict Results');

title('Real Classification and Predict Classification for Test Sample','FontSize',12);

grid on;
%}

toc;

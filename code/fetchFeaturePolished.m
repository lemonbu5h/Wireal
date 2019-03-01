function fetchFeaturePolished()
% intercept and feature
tic;
path = 'E:/Project/data';
% 17.10.18 1000HZ
% 17.12.20 1000Hz 
date = '/17.12.20/';
motion = {'sitdown', 'standup', 'liedown', 'squat', 'fallface', 'fallarm'};
name = {'zjh', 'lt', 'zyf', 'zx', 'hmm', 'wyt', 'zcy', 'wrz'};
%name = {'zjh', 'lbw', 'lt', 'zyf', 'zx', 'hmm', 'wyt', 'zcy', 'wrz', 'sly'};
%name = {'lt', 'zyf', 'zx', 'sly'};
format = '.dat';
num = 10;

X = zeros(length(motion) * length(name) * num, 18);
Y = zeros(length(motion) * length(name) * num, 1)...
    - ones(length(motion) * length(name) * num, 1);
 
for M = 1 : length(motion)
    for N = 1 : length(name)
        for I = 1 : num
            filename = [path,date,char(motion(M)),char(name(N)),num2str(I),format];
            if ~exist(filename)
                disp([filename, ' doesn''t exist']);
                continue
            end
            %tic;

            rawData = read_bf_file(filename);
            array = butterFilter(rawData, 7501, 10500);
            array = getAverageCSI(array);
            m = 70;
            ret = mAverage(array, m);
           
            %toc;
            %tic;
            % si is the average value of all subcarriers in ith stream
            % from 1 to 18, every 6 blocks represent six features
            % s1 : 1-6
            % s2 : 7-12
            % s3 : 13-18
            for j = 1 : 18;
                switch ceil(j / 6)
                    case 1, t = ret{1};
                    case 2, t = ret{2};
                    case 3, t = ret{3};
                end
                switch rem(j, 6)
                    case 1 
                        X((M - 1) * length(name) * num + (N - 1) * num + I, j) = std(t);
                    case 2 
                        X((M - 1) * length(name) * num + (N - 1) * num + I, j) = prctile(t,25);
                    % case 3, X(i, j) = kurtosis(t);
                    % case 4, X(i, j) = skewness(t);
                    case 3
                        X((M - 1) * length(name) * num + (N - 1) * num + I, j) = mean(abs(t-mean(t)));
                    case 4
                        X((M - 1) * length(name) * num + (N - 1) * num + I, j) = std(diff(t, 1));
                    case 5
                        X((M - 1) * length(name) * num + (N - 1) * num + I, j) = skewness(t);
                    case 0
                        X((M - 1) * length(name) * num + (N - 1) * num + I, j) = entropy(t);
                end
            end
            % one-class svm if fall flag will be 1 otherwise by default -1
            if M==5 || M==6
              Y((M - 1) * length(name) * num + (N - 1) * num + I, 1) = 1;
            end
%             Y((M - 1) * length(name) * num + (N - 1) * num + I, 1) = M;  
            %toc;
        end
    end
end
%{
2017.10.18
save X;
save Y;
%}
save('171220mAverNoDeleteNoSLYandLBW.mat', 'X', 'Y', 'num');
toc;

end

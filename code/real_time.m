% filename: the file is being handled now(includes ".dat") 
% seg: how much data is contained in this file(units: second)
function ret = real_time(filename, seg)

% input check
error(nargchk(0,2,nargin));

tic;

%test_set_labels = label;
load('testCollect.mat')

% load learning model(includes all data from 2017.12.20)
load('svmModel.mat');
% 
% % dataArray = zeros(1, 18);
% % c1 = read_bf_file(filename);            
% % datalength = length(c1); 
% % csi_trace = c1(1:datalength,1);
% 
% k = seg * 1000;
% package1 = zeros(30,k);
% package2 = zeros(30,k);
% package3 = zeros(30,k);
% fs=1000;
% 
% countlack = 0;ff=0;
% amp = zeros(1,datalength);
% for i = 1 : k
%     csi_entry = csi_trace{i};
%     csi = get_scaled_csi_sm(csi_entry);
%     [u,v,~] = size(csi);
%     thr_antenna = reshape(csi,u*v,30).';
%     a_antenna = thr_antenna; 
%     temp = abs(a_antenna);
%     package1(:,i) = temp(:,1);
%     package2(:,i) = temp(:,2);
%     package3(:,i) = temp(:,3); 
% end
% 
% s1 = 0;
% s2 = 0;
% s3 = 0;
% 
% Wp = 1 / (fs / 2);
% Ws = 15 / (fs / 2);
% Rp = 2;
% Rs = 40;
% [n, Wn] = buttord(Wp, Ws, Rp, Rs);
% [b, a] = butter(n, Wn);
% 
% filterdata = ones(30, k);
% for i = 1 : 30
%     filterdata(i, :) = filtfilt(b, a, package1(i, :));
% end
% s1 = diff(mean(filterdata));
% 
% filterdata = ones(30,k);
% for i = 1:30
%     filterdata(i,:) = filtfilt(b,a,package2(i,:));
% end    
% s2 = diff(mean(filterdata));
% 
% filterdata = ones(30,k);
% for i = 1:30
%     filterdata(i,:) = filtfilt(b,a,package3(i,:));
% end
% s3 = diff(mean(filterdata));
%             
% %toc;
% %tic;
% % si is the average value of all subcarriers in ith stream
% % from 1 to 18, every 6 blocks represent six features
% % s1 : 1-6
% % s2 : 7-12
% % s3 : 13-18
% for j = 1 : 18
%     switch ceil(j/6)
%         case 1,t = s1;
%         case 2,t = s2;
%         case 3,t = s3;
%     end
%     switch rem(j,6)
%         case 1,dataArray(1, j) = std(t);
%         case 2,dataArray(1, j) = prctile(t,25);
%         % case 3,dataArray(i,j) = kurtosis(t);
%         % case 4,dataArray(i,j) = skewness(t);
%         case 3,dataArray(1, j) = mean(abs(t-mean(t)));
%         case 4,dataArray(1, j) = std(diff(t,1));
%         case 5,dataArray(1, j) = skewness(t);
%         case 0,dataArray(1, j) = entropy(t);
%     end
% end
% test_set = dataArray;

test_set = X;
test_set_labels = Y;
[predict_label] = svmpredict(test_set_labels, test_set, model);

figure;

hold on;

plot(test_set_labels,'o');

plot(predict_label,'r*');

xlabel('Test Sample','FontSize',12);

ylabel('Class Label','FontSize',12);

legend('Real Results','Predict Results');

title('Real Classification and Predict Classification for Test Sample','FontSize',12);

grid on;

toc;
end

%% Acceleration Explorer (android)
% path = '';
% Array = csvread([path, 'heartTest.csv'], 1, 0);
%% Acceleration (ios)
path = 'C:/Users/Thrus/Desktop/';
Array = csvread(fullfile(path, 'xyz,csv'), 1, 0);
%%
cla;
hold on;
plotX = Array(:, 1);
% for i = 2 : size(Array, 2)
%     plot(plotX, Array(:, i));
% end
% plot(plotX, Array(:, 4));
k = butterFilter_realtime(Array(:, 2 : 4).', 100, 1);
% disp(getVitalRate(k, 100, 1));
plot(plotX, k(2, :));
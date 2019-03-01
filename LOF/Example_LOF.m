%Set parameters: k and threshold of lof
k = 7;
threshold = 2;

%Test data1
test = load('LieDown.mat');
[suspicious_index lof] = LOF(test.ret, k);
target = test.ret(lof>=threshold, :);
normal = test.ret(lof<threshold, :);


%Visualization

%Plot result, red x: outlier, blue circle: normal point
figure(2);
cla;
hold on;
scatter(normal(:, 1), normal(:, 2), 'g');
scatter(target(:, 1), target(:, 2), 'r')
hold off;


disp('Demo LOF for test data1')
%{     
disp('Press Enter for continuing...')
pause
disp('Demo LOF for test data2')


%Test data2
test = load('Empty.mat');
[suspicious_index lof] = LOF(test.ret, k);
target = test.ret(lof>=threshold, :);
normal = test.ret(lof<threshold, :);


%Visualization

%Plot result, red x: outlier, blue circle: normal point
figure(2);
cla;
hold on;
scatter(normal(:, 1), normal(:, 2), 'g');
scatter(target(:, 1), target(:, 2), 'rx')
hold off;

disp('Demo LOF for test data2')
disp('Press Enter for continuing...')
pause
disp('Demo LOF for test data3')

%Test data3
test = load('SiteDown.mat');
[suspicious_index lof] = LOF(test.ret, k);
target = test.ret(lof>=threshold, :);
normal = test.ret(lof<threshold, :);


%Visualization

%Plot result, red x: outlier, blue circle: normal point
figure(2);
cla;
hold on;
scatter(normal(:, 1), normal(:, 2), 'g');
scatter(target(:, 1), target(:, 2), 'rx')
hold off;

disp('Demo LOF for test data3')
disp('Press Enter for continuing...')
pause
disp('Demo LOF for test data4')
%Test data4
test = load('FallFace.mat');
[suspicious_index lof] = LOF(test.ret, k);
target = test.ret(lof>=threshold, :);
normal = test.ret(lof<threshold, :);


%Visualization

%Plot result, red x: outlier, blue circle: normal point
figure(2);
cla;
hold on;
scatter(normal(:, 1), normal(:, 2), 'g');
scatter(target(:, 1), target(:, 2), 'rx')
hold off;

disp('Demo LOF for test data4')
disp('Press Enter for continuing...')
pause
disp('Demo LOF for test data5')

test = load('FallArm.mat');
[suspicious_index lof] = LOF(test.ret, k);
target = test.ret(lof>=threshold, :);
normal = test.ret(lof<threshold, :);


%Visualization

%Plot result, red x: outlier, blue circle: normal point
figure(2);
cla;
hold on;
scatter(normal(:, 1), normal(:, 2), 'g');
scatter(target(:, 1), target(:, 2), 'rx')
hold off;
%}
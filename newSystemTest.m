tic;
path = 'E:\Project\data\18.05.10'; 
file = 'fallarmlbw2.dat';
%rawData = read_bf_file('C:\Users\Thrus\Dropbox\source\MATLAB\WiFall\20180420T015439');
%rawData = read_bf_file([path, '\', file]);
rawData = read_bf_file('C:\Users\Thrus\fallarmlbw2.dat');
array = adjust_CSI(rawData, 1, 3, 30);
%array = butterFilter(rawData);
%array = adjust_CSI(rawData, 1, 3, 30);
a= array(1:30, 1:100);
h = heatmap(a);
%he.Colormap = h(3000:1, :);
toc;
%save('newSystemTest.mat', 'rawData')
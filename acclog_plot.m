path = 'C:/Users/Thrus/Desktop/';
system(['python ', 'C:/Users/Thrus/txt2csv.py']);
Array = csvread([path, 'xyz.csv'], 0, 0);
cla;
hold on;
plotX = (1 : size(Array, 1)) * 0.1;
for i = 1 : size(Array, 2)
    plot(plotX, Array(:, i));
end
system(['del ', path, 'xyz.csv']);

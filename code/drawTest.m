% test for my own --------- LOF
function ret = drawTest()
    %path = 'E:/Project/data';
    %date = '18.05.10';
    %name = 'heart_zyf1.dat';
    %data = dataProcess([path, '/', date, '/', name]);
%     filename = 'C:/Users/Thrus/long_monitor_500.dat';
%     array = dataProcess(filename);
%     array = array(:, 320*500:360*500-1);
    load('testfft.mat');
    %array = array(:, 1:20000);
    a3 = array(1, :);
    L = size(a3,2);
    p2 = abs(fft(a3)/L);
    p1 = p2(1 : L/2+1);
    p1(2:end-1) = 2*p1(2:end-1);

    % Set parameters: k and threshold of lof
%     k = 20;
%     threshold = 1.4;
    f = 500*(0:(L/2))/L;
    plotX = (1 : size(array, 2)) * 0.002;
    figure();
    cla;
    hold on;
%     xlabel('Time[s]'); 
%     ylabel('SNR[dB]');
% title('Single-Sided Amplitude Spectrum of X(t)');
title('Single-Sided Amplitude Spectrum of X(t)');
xlabel('f (Hz)');
ylabel('|P1(f)|');
    plot(f, p1);
    rate = getBreathRate(array, 500);
    [x, i] = max(p1(2:end));
    disp(x);
    disp(i);
    disp(f(i));
    disp(f(i)*60);
%     for i = 1:size(array, 1)
%        plot(plotX, array(i, :));
%        %plot(f, p1(i, :));
%     end
%     test = zeros(4, length(data{1}));
%     for i = 1 : size(test, 2)
%         test(4, i) = i * 0.001;
%         for j = 1 : 3
%             test(j, i) = data{j}(i);
%         end
%     end
%     hold on; 
% %     for i = 1 : 3
% %         plot(test(4, :), test(i, :));
% %     end
%     outlierNum = 0;
%     for i = 1 : length(data)
%         test = convertFormat(data{i},10);
%         [suspicious_index lof] = LOF(test, k);
%         target = test(lof>=threshold, :);
%         normal = test(lof<threshold, :);
%         %Visualization
%         %Plot result, red x: outlier, blue circle: normal point  
%         scatter(normal(:, 1), normal(:, 2), 'g');
%         %plot(normal(:,1), normal(:, 2));
%         scatter(target(:, 1), target(:, 2), 'rx');
%         outlierNum = outlierNum + length(target);    
%     end
%     title(['Outliers number: ', num2str(outlierNum)]);
    %hold off;
end

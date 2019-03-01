function ret = getVitalRate(plotData, frequency, filter_mode)
% Mode 0 ~ Respiration rate
% Mode 1 ~ Heart rate
stream_cnt = size(plotData, 1);
length = size(plotData, 2);
rate = zeros(1, stream_cnt);
% % If the number of data is even, FFT will be faster.
% if mod(length, 2) ~= 0
%     length = length - 1;
%     plotData = plotData(:, 1 : end - 1);
% end
f = frequency * (0 : length) / length;
for i = 1 : stream_cnt      
    p = abs(fft(plotData(i, :) / length));
    % Jump p(:, 1) which correspondes to 0 Hz.
    if checkVitalSignsExist(p, f, filter_mode)
        [~, id] = max(p(2 : end));
        rate(1, i) = f(id + 1) * 60;
    else
        rate(1, i) = 0;
    end
end
ret = rate;
end
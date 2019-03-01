function ret = getBreathRate(plotData, frequency)
fs = frequency;
streamCnt = size(plotData, 1);
L = size(plotData, 2);
% If the number of data is even, FFT will be faster.
if mod(L, 2) ~= 0
    L = L - 1;
    plotData = plotData(:, 1 : end - 1);
end
f = fs * (0 : (L / 2)) / L;
Rate = zeros(2, streamCnt);
for i = 1 : streamCnt
    p2 = abs(fft(plotData(i, :)) / L);
    p1 = p2(1 : L / 2 + 1);
    p1(2 : end - 1) = 2 * p1(2 : end - 1); 
    % Jump p(:, 1) which correspondes to 0 Hz.
    p1 = p1(2 : end);
    [x, index] = max(p1);
    Rate(1, i) = f(index + 1) * 60;
    Rate(2, i) = f(second_max(p1, index)) * 60;
end
ret = Rate;
end

function ret = second_max(array, max_index)
second_max = 0;
for i = 1 : size(array, 2)
    if i ~= max_index && array(i) > second_max
        second_index = i;
        second_max = array(i);
    end
end
ret = second_index + 1;
end
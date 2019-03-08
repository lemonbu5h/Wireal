function ret = rate2StaticsStr(rate)
stream_cnt = size(rate, 2);
rate_str = strings(1, stream_cnt);
for i = 1 : stream_cnt
    rate_str(1, i) = sprintf('%0.2f(%d)  ', rate(:, i), i);
end
ret = cell2mat(rate_str);
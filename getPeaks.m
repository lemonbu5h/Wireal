% Find local peaks and remove fake peaks at the same time.
% The "ret" is a list which contains all identified real peaks(index and value). 
% "vwnd": means verifying window which size is at least above the interval between two neighbouring
% valleys. (unit: seconds)
% "data" is expected to be a N*1 or 1*N vector.
% "interval_threshold" (unit: seconds).
function [peak_lst, rate] = getPeaks(data, vwnd, interval_threshold, frequency)
data_length = length(data);
% zeros(:, 1) represents all indexes.
% zeros(:, 2) represents all values.
peak_lst = -ones(data_length, 2);
peak_num = 0;
% Roughly find all peaks which is larger than neighbouring points.
for i = 2 : data_length - 1
    if data(i - 1) < data(i) && data(i + 1) < data(i)
        peak_num = peak_num + 1;
        peak_lst(peak_num, 1) = i;
        peak_lst(peak_num, 2) = data(i);
    end
end
% Remove fake peaks according to vwnd.
vwnd_points = floor(vwnd * frequency);
for i = 1 : peak_num
    location = peak_lst(i, 1);
    amplitude = data(location);
    for m = location - floor((vwnd_points - 1) / 2) : location + floor((vwnd_points - 1) / 2)
        if m <= 0 || m > data_length
            continue;
        elseif data(m) > amplitude
            peak_lst(i, 1) = -1;
            peak_num = peak_num - 1;
            break;
        end
    end
end
peak_lst = removeBlanks(peak_lst, peak_num);
if peak_num <= 1
    rate = 0;
    peak_lst = [];
    return;
end
% Remove fake peaks with improper backward intervals.
for i = 2 : peak_num
    if peak_lst(i) - peak_lst(i - 1) < interval_threshold * frequency
        peak_lst(i) = -1;
        peak_num = peak_num - 1;
    end
end  
peak_lst = removeBlanks(peak_lst, peak_num);
if peak_num == 1
    rate = 0;
else
    peak_range = peak_lst(peak_num) - peak_lst(1) + 1;
    rate = peak_num / (peak_range / frequency) * 60; 
end
end


function ret = removeBlanks(peaks_with_blank, real_peak_num)
ret = -ones(real_peak_num, 2);
inner_index = 1;
for i = 1 : size(peaks_with_blank, 1)
    if peaks_with_blank(i, 1) ~= -1
        ret(inner_index, 1) = peaks_with_blank(i, 1);
        ret(inner_index, 2) = peaks_with_blank(i, 2);
        inner_index = inner_index + 1;
    end
end     
end
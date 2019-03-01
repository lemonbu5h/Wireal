% CHENYU ZHANG <303223118@qq.com>
function plot_with_or_without_filter()
%% Settings
path = 'E:/Glab/data';
filename = '20180720T155044';
packet_frequency = 500; % Hz
% Filter mode 0 means respiration filter process, 1 means heartbeat filter process.
filter_mode = 1;
% Before and after the filter, 2 types.
plot_type = 2;
% if it is 0, plot average subcarriers;
% otherwise plot specific subcarrier
subcarrier_index = 5;
% The max plotData minus min plotData is value_diff
% The y-axis max value is max plotData + value_diff / y_axis_ratio
% The y-axis min value is min plotData - value_diff / y_axis_ratio
% Be attention, y-axis min value is at least zero.
y_axis_ratio = 4;
%% Data process
raw_data = read_bf_file(fullfile(path, filename));
num_subcarrier = 30;
Ntx = raw_data{1}.Ntx;
Nrx = raw_data{1}.Nrx;
csi_data = adjust_CSI(raw_data, Ntx, Nrx, num_subcarrier);
if subcarrier_index == 0
    array = getAverageCSI(csi_data, num_subcarrier);
else
    array = getSubcarrierCSI(csi_data, num_subcarrier, subcarrier_index);
end
array = interpolation_data(array);
array_filtered = butterFilter_realtime(array, packet_frequency, filter_mode);
module_PSD(array_filtered, packet_frequency);
%disp(getBreathRate(array_filtered, 500));
peaks = cell(Nrx, 1);
rates = zeros(1, Nrx);
for i = 1 : Nrx
    [peak_lst, rate] = getPeaks(array_filtered(i, :), 3, 60 / 40, packet_frequency);  
    peaks(i) = {peak_lst};
    rates(1, i) = rate; 
end
disp(rates);
disp(getVitalRate(array_filtered, 500, filter_mode))
every_pack_sec = 1 / packet_frequency;
plotX = (1 : size(array, 2)) * every_pack_sec;

%% Plot
for i = 1 : Ntx * Nrx * plot_type
    subplot(Ntx * Nrx, plot_type, i);
    spatial_stream_index = ceil(i / 2);
    real_max = max(array(spatial_stream_index, :));
    real_min = min(array(spatial_stream_index, :));
    y_min = ceil(real_min - (real_max - real_min) / y_axis_ratio);
    y_max = ceil(real_max + (real_max - real_min) / y_axis_ratio);
    x_max = ceil(plotX(end));
    if y_min < 0
        y_min = 0;
    end
    if mod(i, 2) ~= 0
        plot(plotX, array(spatial_stream_index, :));
        title('Before filter');
        ylabel('SNR [dB]');
        axis([0, x_max, y_min, y_max]);
        %disp(mean(array(spatial_stream_index, :)));
    else
        hold on;
        plot(plotX, array_filtered(spatial_stream_index, :));
        plot_peaks = peaks{i / 2};
        plot(plot_peaks(:, 1) / packet_frequency, plot_peaks(:, 2), '*');
        title('After filter');
        ylabel('SNR [dB]');
        %disp(mean(array_filtered(spatial_stream_index, :)));
%         axis([0, x_max, y_min, y_max]);
    end
	xlabel('Time [s]'); 
end
%hold on;
end

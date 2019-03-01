%% Settings
clear;
path = 'C:/Users/Thrus/Desktop/data/';
csi_file_name = '20180720T155044';
csv_file_name = 'AccelerationExplorer-2018-7-20-3-50-45.csv';
packet_frequency = 500;
% If it is 0, display all streams;
% otherwise display specific stream.
spatial_stream_index = 1;
axis_index = 1;
combine_switch_on = true;
legend_position = 'SouthEast';

%% 
raw_data = read_bf_file([path, csi_file_name]);
num_subcarrier = 30;
Ntx = raw_data{1}.Ntx;
Nrx = raw_data{1}.Nrx;
csi_data = adjust_CSI(raw_data, Ntx, Nrx, num_subcarrier);
array = getAverageCSI(csi_data, num_subcarrier);
array = interpolation_data(array);
% TODO: delete it
% array = array(:, 1500:18000);
array_filtered = butterFilter_realtime(array, packet_frequency);
every_pack_sec = 1 / packet_frequency;
plotX_csi = (1 : size(array, 2)) * every_pack_sec;
%plotX_csi = linspace(0, size(array, 2)*every_pack_sec, size(array, 2));

%% Raw CSI plot
if ~combine_switch_on
    subplot(3, 1, 1);
    hold on;
    if spatial_stream_index == 0
        tag = strings(1, Ntx * Nrx);
        for i = 1 : Ntx * Nrx
            plot(plotX_csi, array(i, :));
            tag(:, i) = sprintf('Spatial Stream  %d', i);
        end
        legend(tag, 'Location', legend_position);
    else
        plot(plotX_csi, array(spatial_stream_index, :));
        legend(sprintf('Spatial Stream  %d', spatial_stream_index), 'Location', legend_position);
    end
    title('Raw CSI packets');
    ylabel('SNR [dB]');
    xlabel('Time [s]'); 

    %% Filtered CSI plot
    subplot(3, 1, 2);
    hold on;
    if spatial_stream_index == 0
        tag = strings(1, Ntx * Nrx);
        for i = 1 : Ntx * Nrx
            plot(plotX_csi, array_filtered(i, :));
            tag(:, i) = sprintf('Spatial Stream  %d', i);
        end
        legend(tag, 'Location', legend_position);
    else
        plot(plotX_csi, array_filtered(spatial_stream_index, :));
        legend(sprintf('Spatial Stream  %d', spatial_stream_index), 'Location', legend_position);
    end
    title('Filtered CSI packets');
    ylabel('SNR [dB]');
    xlabel('Time [s]'); 
end

%% Acceleration plot
array_csv = csvread([path, csv_file_name], 1, 0);
plotX_csv = array_csv(:, 1);
if ~combine_switch_on
    % array_csv = array_csv(150 : 1800, :);
    % plotX_csv = plotX_csv(1 : 1651);
    subplot(3, 1, 3);
    hold on;
    if axis_index == 0
        tag = strings(1, Ntx * Nrx);       
        for i = 2 : size(array_csv, 2)
            plot(plotX_csv, array_csv(:, i));
            axis_name = getAxisName(i - 1);
            tag(:, i - 1) = ['Axis ', axis_name];
        end
        legend(tag, 'Location', legend_position);
        title('Accelerometers');
    else
        plot(plotX_csv, array_csv(:, axis_index + 1));
        legend(['Axis ', getAxisName(axis_index)], 'Location', legend_position);      
        title('Accelerometer');
    end 
    xlabel('Time [s]'); 
end
if combine_switch_on
    hold on;
    tag = strings(1, 2);
    plot(plotX_csi, array_filtered(spatial_stream_index, :));
    tag(:, 1) = 'Filtered CSI data';
    for i = 1 : size(array_csv, 1)
    	array_csv(i, axis_index + 1) = array_csv(i, axis_index + 1) + 13.5;
    end
    plot(plotX_csv, array_csv(:, axis_index + 1));
    tag(:, 2) = 'Mobile Accelerometer';
    legend(tag, 'Location', legend_position);
end


function ret = getAxisName(axis_index)
if axis_index == 1
    axis_name = 'X';
elseif axis_index == 2
    axis_name = 'Y';
elseif axis_index == 3
    axis_name = 'Z';
else
    axis_name = 'ERROR';
end
ret = axis_name;
end

function ret = dataProcess(fileName)
    %addpath(genpath(pwd));
    rawData = read_bf_file(fileName);
%     array = adjust_CSI(rawData, 1, 3, 30);
%     array = butterFilter_realtime(array, 500);
    array = butterFilter(rawData, 1, size(rawData, 1));
    array1 = array{1};
    array2 = array{2};
    array3 = array{3};
    pack = zeros(90, size(array1, 2));
    for i = 1:30
        pack(i, :) = array1(i, :);
    end
    for i = 31:60
        pack(i, :) = array2(i-30, :);
    end
    for i = 61:90
        pack(i, :) = array3(i-60, :);
    end
    %array = adjustCSI(rawData);
    ret = getAverageCSI(pack, 30);
    %m = 70;
    %ret = mAverage(array, m);
end

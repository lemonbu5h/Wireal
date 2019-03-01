function ret = adjustFormat(plotData, plotNum, timerPeriod)
% function ret = adjustFormat()
% load('plot.mat');

% ret(1, :) stream1
% ret(2, :) stream2
% ret(3, :) stream3
% ret(4, :) time_index
if (timerPeriod == 1)
    timerPeriod = 1;
elseif (timerPeriod == 0.1)
    timerPeriod = 10;
end
ret = zeros(4, plotNum);
cur = 1;    % current index
for r = 1 : length(plotData)
    plotDataContainedNumEveryRow = length(plotData{r}{1});
    % current index within every row
    for curInside = 1 : plotDataContainedNumEveryRow
        ret(1, cur) = plotData{r}{1}(curInside);
        ret(2, cur) = plotData{r}{2}(curInside);
        ret(3, cur) = plotData{r}{3}(curInside);
        ret(4, cur) = cur * 0.001 * timerPeriod;
        cur = cur + 1;
    end
end
end
function [retHandles] = clearLstBoxCache(handles)
str = handles.lstboxState.String;
havBeenCutTimes = handles.Info.havBeenCut;
% Clear lstbox cache silently, thus left some cache
%leftCacheLength =  20;
leftCacheLength = havBeenCutTimes + 20;
% clearCacheThreshold controls when to clear cache (frequency).
clearCacheThreshold = handles.Info.lstBoxCacheThreshold;
lengthStr = length(str);
if lengthStr > leftCacheLength + clearCacheThreshold
    % "+10" is unnecessary, mainly for keeping some system/network
    % information.
    if havBeenCutTimes + 10 < lengthStr - leftCacheLength
        str(havBeenCutTimes + 10 : lengthStr - leftCacheLength) = [];
        handles.lstboxState.String = str;
    end
end
retHandles = handles;
end
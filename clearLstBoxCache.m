function [retHandles] = clearLstBoxCache(handles, clearCacheThreshold)
str = handles.lstboxState.String;
havBeenCutTimes = handles.Info.havBeenCut;
% Clear lstbox cache silently, thus left some cache
%leftCacheLength =  20;
leftCacheLength = havBeenCutTimes + 20;
% clearCacheThreshold controls when to clear cache (frequency).
%clearCacheThreshold = 1000;
lengthStr = length(str);
if lengthStr > havBeenCutTimes + leftCacheLength + clearCacheThreshold
    % "+10" is unnecessary, mainly for keeping some system/network
    % information.
    if havBeenCutTimes + 5 < lengthStr - leftCacheLength
        str(havBeenCutTimes + 10 : lengthStr - leftCacheLength) = [];
        handles.lstboxState.String = str;
    end
end
retHandles = handles;
end
function clearLstBoxStateCache(app, event_name)
if (nargin == 1)
    strCell = app.lstBoxState.Items;
    havBeenCutTimes = app.havBeenCut;
    % Clear list box cache silently, thus left some cache
    %leftCacheLength =  20;
    leftCacheLength = havBeenCutTimes + 20;
    % clearCacheThreshold controls when to clear cache (frequency).
    clearCacheThreshold = app.lstBoxCacheThreshold;
    lengthStr = length(strCell);
    if lengthStr > leftCacheLength + clearCacheThreshold
        % "+10" is unnecessary, mainly for keeping some system/network
        % information.
        if havBeenCutTimes + 10 < lengthStr - leftCacheLength
            strCell(havBeenCutTimes + 10 : lengthStr - leftCacheLength) = [];
            app.lstBoxState.Items = strCell;
        end
    end
elseif (nargin == 2 && strcmp(event_name, 'cut'))
    havBeenCutTimes = app.havBeenCut;
    if (havBeenCutTimes == 0)
        app.lstBoxState.Value = {};
        app.lstBoxState.Items = {};
    else
        if (app.lastCutNoFile == false)
            lastFileRecord = cell2mat(app.lstBoxState.Items(havBeenCutTimes));
            lastFileRecord = cat(2, lastFileRecord, '   <HISTORY>');
            app.lstBoxState.Items(havBeenCutTimes) = {lastFileRecord};
        end
        app.lstBoxState.Items = app.lstBoxState.Items(1:havBeenCutTimes);
        app.lstBoxState.Value = app.lstBoxState.Items(end);
    end
else
    error('Invalid input arguments for tcp_recv function');
end
  
end
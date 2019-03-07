function updateListbox(handles, promptStr)
% add item to listbox and update Value property of it(listbox)
% Value property determine the position of scrollable bar
if isempty(handles.lstboxState.String)
    handles.lstboxState.String = {[datestr(datetime, handles.Info.dateFormat), ...
        handles.Info.blankFormat, promptStr]};
else
    handles.lstboxState.String = [handles.lstboxState.String; ...
        datestr(datetime, handles.Info.dateFormat), ...
        handles.Info.blankFormat, promptStr];
end
handles.lstboxState.Value = size(handles.lstboxState.String, 1);
end
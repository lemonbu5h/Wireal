function updateLstBoxState(app, promptStr)

% add item to listbox and update Value property of it(listbox)
% Value property determine the selection of list box
% scroll to move the camera
content = cat(2, datestr(datetime, app.dateFormat), app.blankFormat, promptStr);
app.lstBoxState.Items = cat(2, app.lstBoxState.Items, content);

app.lstBoxState.Value = app.lstBoxState.Items(end);
%scroll(app.lstBoxState , 'bottom');
pause(0.00000000001);
app.lstBoxState.scroll('bottom');
end
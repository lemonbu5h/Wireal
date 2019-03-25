function varargout = Wireal_1_6(varargin)
% WIREAL_1_6 MATLAB code for Wireal_1_6.fig
%      WIREAL_1_6, by itself, creates a new WIREAL_1_6 or raises the existing
%      singleton*.
%
%      H = WIREAL_1_6 returns the handle to a new WIREAL_1_6 or the handle to
%      the existing singleton*.
%
%      WIREAL_1_6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIREAL_1_6.M with the given input arguments.
%
%      WIREAL_1_6('Property','Value',...) creates a new WIREAL_1_6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Wireal_1_6_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Wireal_1_6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Wireal_1_6

% Last Modified by GUIDE v2.5 17-Aug-2018 23:31:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Wireal_1_6_OpeningFcn, ...
                   'gui_OutputFcn',  @Wireal_1_6_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Wireal_1_6 is made visible.
function Wireal_1_6_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Wireal_1_6 (see VARARGIN)
% Choose default command line output for Wireal_1_6

%set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
useWindowAPI2Maximize(handles.figure1);
% For Application Logo(top left).
javaFrame = get(hObject,'javaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('logo.jpg'));
%load('svmModel.mat');
handles.Info = struct ...
   ('havntBeenStarted', true, ...
    'havBeenCut', 0, ...
    'lastCutNoFile', false, ...
    'filename', 'test', ... 
    'fileHandle', -1, ...
    'curPos', 0, ...    % Current position of file read pointer.
    'paused', false, ...
    'pausedPlotData', [], ...  % saved plotData when system is paused.
    'pausedPlotX', [], ...  % saved plotX when system is paused. 
    'pausedRealNum', -1, ...
    'dateFormat', 'mm/dd HH:MM:SS:FFF', ...
    'blankFormat', blanks(8), ...
    'haveSelectedCSIdir', false, ...
    'workingDir', matlabroot, ...
    'adapterName', 'Ethernet', ...
    'Ntx', str2double(handles.editNtx.String), ...
    'Nrx', str2double(handles.editNrx.String), ...   
    'waitedPackNum', 0, ... % How many packs have come(mainly for debug use)
    'everyPackSec', 1 / str2double(handles.editHz.String), ...
    'dataFre', str2double(handles.editHz.String), ...    % Data frequency
    'ip', handles.editIP.String, ...    % Listen ip address
    'server_ip', '192.168.8.88', ...    % Ip of server(this machine).
    'port', handles.editPort.String, ...
    'plotMaxSec', str2double(handles.editMaxSec.String), ... % How many packs (in secs) will be plotted
    'plotGapNum', 0, ...                 
    'plotData', [], ... 
    'plotMode', 'c', ... % Plot mode, 's' means split, 'c' means combine
    'splitIndex', str2double(handles.textStreamIndex.String), ...
    'detectIndex', str2double(handles.textDetectStreamIndex.String), ...
    'subcarrierIndex', str2double(handles.editSubcarrierIndex.String), ...
    'axisLow', str2double(handles.editAxisLow.String), ...
    'axisHigh', str2double(handles.editAxisHigh.String), ...
    'timerPer', 0.05, ...
    'cputime_begin2draw', -1, ...  % the cputime when data begin to draw
    'lstBoxCacheThreshold', 500);  % controls how often to clear listbox
    %'shift_sec', 0); % Arroximated shift seconds.
    %'waitedCSI', [], ...  % will be sent to get feature
    %'trainSet', {trainSet}, ...
    %'model', {model});

handles.timer = timer ...
    ('Name', 'ReadFromCSItool', ...
    'Period', handles.Info.timerPer, ...
    'StartDelay', 0, ...
    'TasksToExecute', inf, ...
    'ExecutionMode', 'fixedSpacing', ...
    'StartFcn', {@startFcn_Callback, hObject}, ...
    'TimerFcn', {@timerFcn_Callback, hObject});

%set(gcf, 'CurrentAxes', handles.axes1);
%handles.figure1.CurrentAxes = handles.axes1;
axis(handles.axes1, [0, handles.Info.plotMaxSec, handles.Info.axisLow, handles.Info.axisHigh]);
%set(gcf, 'CurrentAxes', handles.axesRes);
%handles.figure1.CurrentAxes = handles.axesRes;
xlim(handles.axesRes, [0 handles.Info.plotMaxSec]);
xticks(handles.axesRes, 'auto');
yticks(handles.axesRes, 'auto');
%set(gcf, 'CurrentAxes', handles.axesHeart);
%handles.figure1.CurrentAxes = handles.axesHeart;
xlim(handles.axesHeart, [0 handles.Info.plotMaxSec]);
xticks(handles.axesHeart, 'auto');
yticks(handles.axesHeart, 'auto');
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Wireal_1_6 wait for user response (see UIRESUME)
%uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = Wireal_1_6_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
%set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
useWindowAPI2Maximize(handles.figure1);



function startFcn_Callback(~, ~, hObject)
myHandles = guidata(hObject);
if (myHandles.Info.havntBeenStarted == true)
    tStr = datestr(now, 30);
    timestamp = [tStr(1 : 4), '-', tStr(5 : 6), '-', tStr(7 : 8), '--', tStr(10 : 11), '-', tStr(12 : 13), '-', tStr(14 : 15)];
    workingDir = myHandles.Info.workingDir;
    address = myHandles.Info.ip;
    port = myHandles.Info.port;
    filename = fullfile(workingDir, timestamp);
    tcp_recv('csi_tcp_recv', address, port, filename);
    myHandles.Info.filename = filename;
    myHandles = updateListbox(myHandles, 'Ready for collecting data...');     
    myHandles.Info.havntBeenStarted = false;
    % update handles otherwise changed value is 
    % invisible outside this callback    
    guidata(hObject, myHandles);
end


function timerFcn_Callback(~, ~, hObject)
%tic;
myHandles = guidata(hObject);
filename = myHandles.Info.filename;   
if exist(filename, 'file') == 0
    return;
end
% When program runs at this point that means data have come
% We can roughly say this moment is the beginning of running time
% Be careful to initialize begin2draw time only once (preset defalt value
% -1)
if myHandles.Info.cputime_begin2draw == -1
    myHandles.Info.cputime_begin2draw = 0;
    tic;
    %myHandles.Info.cputime_begin2draw = cputime;
end
fhand = myHandles.Info.fileHandle;
% -1 represents the default value of fileHandle
if fhand == -1
    fhand = fopen(filename, 'rb');
    % After excuting fopen, errors will come when fhand is less than 0.
    if (fhand < 0)
        fprintf('Couldn''t open file %s', filename);
        %toc;
        return;
    end
    myHandles.Info.fileHandle = fhand;
end
Ntx = myHandles.Info.Ntx;
Nrx = myHandles.Info.Nrx;
% More details in read_bfee.c
% sizeof(csi) = floor((30 * (Ntx * Nrx * 8 * 2 + 3) + 7) / 8)
% sizeof(other contents) = 20 (eg. from inBytes[0] to inBytes[19], 20 bytes in total)
% 3 = 2 (2 bytes size) + 1 (1 byte code)
thresholdSize = floor((30 * (Ntx * Nrx * 8 * 2 + 3) + 7) / 8) + 20 + 3;
%Something wrong with dir(filename).bytes, may it is unsafe for IO.
%dirInfo = dir(filename);
%fileSize = dirInfo.bytes;
fseek(fhand, 0, 'eof');
fileSize = ftell(fhand);
cur = myHandles.Info.curPos;
fseek(fhand, cur, 'bof');
recvSize = fileSize - cur;
if (recvSize < thresholdSize) && (myHandles.Info.paused == false)
    myHandles = clearLstBoxCache(myHandles);
    myHandles = updateListbox(myHandles, sprintf('No more than %d bytes!', thresholdSize));    
    myHandles.textRunningTime.String = sec2dhms(toc);    
    %myHandles.textRunningTime.String = sec2dhms(cputime - myHandles.Info.cputime_begin2draw);
    %toc;
    guidata(hObject, myHandles);
    return;
end
[pack, cur] = read_bf_file_real_time(fhand, cur, recvSize, Ntx, Nrx);
   
% Attention this function will slow down the frame and make system lose real-time property.
%validateCorrectness(pack);

% Update curPos
myHandles.Info.curPos = cur;
% If no valid data retrieved, pack will be set to cell(1, 2)
if size(pack, 2) == 2
    if myHandles.Info.paused == false
        myHandles = clearLstBoxCache(myHandles);
        myHandles = updateListbox(myHandles, sprintf('Received %d bytes but no valid contents...', recvSize));
    end
    myHandles.textRunningTime.String = sec2dhms(toc);
    %myHandles.textRunningTime.String = sec2dhms(cputime - myHandles.Info.cputime_begin2draw);
    guidata(hObject, myHandles);
    %toc;
    return;
end
% Extract CSI from raw data matrix.       
array = adjust_CSI(pack, Ntx, Nrx, 30);
if myHandles.popSubcarrier.Value == 1
    array = getAverageCSI(array, 30);
else
    array = getSubcarrierCSI(array, 30, myHandles.Info.subcarrierIndex);
end
% temporary variable, remember to update original value
plotData = myHandles.Info.plotData;
plotGapNum = myHandles.Info.plotGapNum;
plotMaxPack = size(plotData, 2);
packNum = size(array, 2);
if (plotGapNum == 0)
    plotData = [plotData(:, packNum + 1 : end), array];
elseif (packNum <= plotGapNum)
    currentGapPos = plotMaxPack - plotGapNum + 1;
    plotData(:, currentGapPos : currentGapPos + packNum - 1) = array; 
    plotGapNum = plotGapNum - packNum;
elseif (packNum >= plotMaxPack)
    plotData = array(packNum - plotMaxPack + 1 : end);
    plotGapNum = 0;
else
    plotData = [plotData(:, packNum - plotGapNum + 1 : end - plotGapNum), array];
    plotGapNum = 0;
end
% update original value
myHandles.Info.plotData = plotData;
myHandles.Info.plotGapNum = plotGapNum;
realNum = plotMaxPack - plotGapNum;
%realNum = plotMaxPack;
if (plotGapNum == 0)
    plotX = (1 : plotMaxPack) * myHandles.Info.everyPackSec;
else
    plotX = (plotMaxPack - realNum + 1 : plotMaxPack) * myHandles.Info.everyPackSec;
end

% Set function is better since you still obtain focus.
%set(gcf, 'CurrentAxes', myHandles.axes1); 
%myHandles.figure1.CurrentAxes = myHandles.axes1;
%axes(myHandles.axes1);
% axis([0, myHandles.Info.plotMaxSec, myHandles.Info.axisLow, myHandles.Info.axisHigh]);
% If is in the pause state, only draw the pause time figure(why draw? for control).
if (myHandles.Info.paused == true)
    if isempty(myHandles.Info.pausedPlotData)
        myHandles.Info.pausedPlotData = plotData;
        myHandles.Info.pausedPlotX = plotX;
        myHandles.Info.pausedRealNum = realNum;
    else
        plotData = myHandles.Info.pausedPlotData;
        plotX = myHandles.Info.pausedPlotX;
        realNum = myHandles.Info.pausedRealNum;
    end
end
cla(myHandles.axes1);
hold(myHandles.axes1, 'on');
if (myHandles.Info.plotMode == 'c')
    tag = strings(1, Ntx * Nrx);
    for i = 1 : size(plotData, 1)
        % Camera from right(oldest) to left(newest):
        %plot(plotX, plotData(i, realNum : -1 : 1));
        plot(myHandles.axes1, plotX, plotData(i, 1 : realNum));
        tag(:, i) = sprintf('Spatial Stream  %d', i);
    end
    legend(myHandles.axes1, tag, 'Location', 'SouthEast');
    %drawnow update;
% else plotMode == 's'
else
    splitIndex = myHandles.Info.splitIndex;
    % Camera from right(oldest) to left(newest):
    %plot(plotX, plotData(splitIndex, realNum : -1 : 1), 'r');       
    plot(myHandles.axes1, plotX, plotData(splitIndex, 1 : realNum), 'r');
    legend(myHandles.axes1, sprintf('Spatial Stream  %d', splitIndex), 'Location', 'SouthEast');
end
hold(myHandles.axes1, 'off');
% For pause state control we can't use plotGapNum to determine if data is
% full of the axis, cause at pause state plotGapNum belongs to real time
% data
%if (plotGapNum == 0) && get(myHandles.checkboxVitalDetect, 'Value')
if get(myHandles.checkboxVitalDetect, 'Value') && (plotMaxPack == realNum)
    detectIndex = myHandles.Info.detectIndex;
    intered_data = interpolation_data(plotData);
    frequency = myHandles.Info.dataFre;
    %approximated_sec_pass = packNum / frequency;
    %shift_sec = myHandles.Info.shift_sec + approximated_sec_pass;
    % Respiration
    res_data = butterFilter_realtime(intered_data, frequency, 0);    
    res_rate = getVitalRate(res_data, frequency, 0);
    set(myHandles.textResStatics, 'Visible', 'on');
    myHandles.textResStatics.String = rate2StaticsStr(res_rate);
    %selected_res_rate = removeMaxAndMinThenMean(res_rate);
    selected_res_rate = res_rate(1, detectIndex);
    myHandles.textResRateValue.String = sprintf('%d', selected_res_rate);
    myHandles.textResRateValue.ForegroundColor = 'red';
    %set(gcf, 'CurrentAxes', myHandles.axesRes);
    %myHandles.figure1.CurrentAxes = myHandles.axesRes;
    cla(myHandles.axesRes);
    hold(myHandles.axesRes, 'on');
    % Camera from right to left:
    %plot(plotX, res_data(detectIndex, realNum : -1 : 1), 'y');
    % Camera from left to right:
    plot(myHandles.axesRes, plotX, res_data(detectIndex, 1 : realNum), 'y');
    hold(myHandles.axesRes, 'off');
    % Heartbeat
    heart_data = butterFilter_realtime(intered_data, frequency, 1);
    heart_rate = getVitalRate(heart_data, frequency, 1); 
    myHandles.textHeartbeatStatics.String = rate2StaticsStr(heart_rate);
    set(myHandles.textHeartbeatStatics, 'Visible', 'on');
    %selected_heart_rate = removeMaxAndMinThenMean(heart_rate);
    selected_heart_rate = heart_rate(1, detectIndex);
    myHandles.textHeartbeatRateValue.String = sprintf('%d', selected_heart_rate);
    myHandles.textHeartbeatRateValue.ForegroundColor = 'red'; 
    %set(gcf, 'CurrentAxes', myHandles.axesHeart);
    %myHandles.figure1.CurrentAxes = myHandles.axesHeart;
    cla(myHandles.axesHeart);
    hold(myHandles.axesHeart, 'on');
    % Camera from right to left:
    %plot(plotX, heart_data(detectIndex, realNum : -1 : 1), 'g');
    % Camera from left to right:
    plot(myHandles.axesHeart, plotX, heart_data(detectIndex, 1 : realNum), 'g');
    hold(myHandles.axesHeart, 'off');
    %myHandles.Info.shift_sec = shift_sec;
end
if myHandles.Info.paused == false
	myHandles = clearLstBoxCache(myHandles);
    myHandles = updateListbox(myHandles, sprintf('Received %d bytes...', recvSize));
end
%
%pause(0.000001);% drawnow;
% drawnow update;
myHandles.textRunningTime.String = sec2dhms(toc);
%myHandles.textRunningTime.String = sec2dhms(cputime - myHandles.Info.cputime_begin2draw);    
% store so other scopes can access the newest value
guidata(hObject, myHandles);
%toc;

    
    
% --- Executes on button press in btnSelectCSIdir.
function btnSelectCSIdir_Callback(hObject, ~, handles)
% hObject    handle to btnSelectCSIdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in btnStart.
if handles.Info.haveSelectedCSIdir == false   
    server_ip = handles.Info.server_ip;
    adapterName = handles.Info.adapterName;
    [admin_check_status, ~] = system('net session >nul 2>&1');
    if admin_check_status ~= 0
    	%warndlg('Please run as administrator!', 'WARNING');
        errordlg('Please run as administrator.', 'Permission Error');
        return;
    end
    % Attention, here is findstr"onnected", will match "disconnected" and
    % "Connected".
    %[check_adapter_name_status, ~] = system(sprintf('netsh interface show interface name="%s" | findstr "onnected"', adapterName));
    [check_adapter_name_status, ~] = system(sprintf('chcp 437 && netsh interface show interface name="%s" | findstr "onnected"', adapterName));    
    if check_adapter_name_status ~= 0
    	%warndlg(sprintf('Please rename your LAN adapter to "%s"', adapterName), 'WARNING');
        errordlg(sprintf('Please rename your LAN adapter to "%s".', adapterName), 'Adapter Missed Error');
        return;
    end               
end
%if (strcmp(get(handles.timer, 'Running'), 'on'))
%    warndlg('Cannot select working directory while detecting!', 'WARNING'); 
%    return;
%end
workDir = uigetdir(matlabroot, 'Select working directory');
if (workDir == 0)
    return;
end
handles.textCSIdir.String = workDir;
if handles.Info.haveSelectedCSIdir == false   
    while true
        %[~, check_connected_result] = system(sprintf('netsh interface show interface name="%s" | findstr "Connected"', adapterName));
        [check_connected_status, ~] = system(sprintf('chcp 437 && netsh interface show interface name="%s" | findstr "Connected"', adapterName));
        if check_connected_status ~= 0
            btn = questdlg(sprintf('Adapter "%s" is disconnected, do you want to continue to run in offline simulation mode?', adapterName), 'Continue or Retry', 'OK', 'Retry', 'Retry');
            switch btn
                case 'OK'
                    handles = updateListbox(handles, 'Run in offline simulation mode successfully...');
                    set(handles.uipanelNet, 'Visible', 'off');
                    break;
                case 'Retry'
                    continue;
            end
        else
            system([sprintf('netsh int ip set address "%s" static ', adapterName), server_ip]);
            handles = updateListbox(handles, ['IPv4 address has been set to ', server_ip, ' successfully...']);
            break;
        end
    end   
end
%handles.Info.filename = workDir;
handles.Info.haveSelectedCSIdir = true;
handles.Info.workingDir = workDir;
guidata(hObject, handles);


function btnStart_Callback(hObject, ~, handles)
% hObject    handle to btnStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.Info.haveSelectedCSIdir == false)
    warndlg('Haven''t selected working directory.', 'Warning'); 
    return;
end
set(handles.staConnect, 'Visible', 'on');
set(handles.staHz, 'Visible', 'on');
set(handles.staMIMO, 'Visible', 'on');
set(handles.staRunningTime, 'Visible', 'on');
set(handles.textRunningTime, 'Visible', 'on');
set(handles.dispConnect, 'Visible', 'on');
set(handles.dispHz, 'Visible', 'on');
set(handles.dispMIMO, 'Visible', 'on');
% handles.Info.plotMaxSec = handles.editMaxSec;
plotMaxSec = handles.Info.plotMaxSec;
dataFre = handles.Info.dataFre;
%phv = handles.popHz.Value;
%psv = handles.popStream.Value;
streamCnt = handles.Info.Ntx * handles.Info.Nrx;
handles.Info.everyPackSec = 1 / dataFre;
handles.Info.plotGapNum = plotMaxSec * dataFre;
handles.Info.plotData = zeros(streamCnt, handles.Info.plotGapNum);

handles = updateListbox(handles, 'Waited socket connection...');
handles.dispConnect.String = sprintf('%s : %s', handles.Info.ip, handles.Info.port);
handles.dispHz.String = handles.Info.dataFre;
handles.dispMIMO.String = sprintf('Ntx = %d   Nrx = %d', handles.Info.Ntx, handles.Info.Nrx);
% update UI immediately
%pause(0.000001);
set(hObject, 'Visible', 'off');
set(handles.editSubcarrierIndex, 'Enable', 'off');
set(handles.popSubcarrier, 'Enable', 'off');
set(handles.btnSelectCSIdir, 'Enable', 'off');
set(handles.btnPause, 'Visible', 'on');
set(handles.btnCut, 'Visible', 'on');
set(handles.editHz, 'Enable', 'off');
set(handles.editPort, 'Enable', 'off');
set(handles.editIP, 'Enable', 'off');
set(handles.editMaxSec, 'Enable', 'off');
set(handles.editNtx, 'Enable', 'off');
set(handles.editNrx, 'Enable', 'off');
set(handles.checkboxVitalDetect, 'Enable', 'off');
guidata(hObject, handles);
% retrieve newest handle
handles = guidata(hObject);
start(handles.timer);


% --- Executes on button press in btnPause.
function btnPause_Callback(hObject, ~, handles)
% hObject    handle to btnPause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.lstboxState, 'String', handles.lstboxState.String 'Paused ...']);
set(handles.btnContinue, 'Visible', 'on');
set(hObject, 'Visible', 'off');
%set(handles.btnNextStream, 'Enable', 'off');
handles.Info.paused = true;
handles = updateListbox(handles, 'Paused...');
%stop(handles.timer);
%disp('stoped');
guidata(hObject, handles);


% --- Executes on button press in btnContinue.
function btnContinue_Callback(hObject, ~, handles)
% hObject    handle to btnContinue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnPause, 'Visible', 'on');
set(hObject, 'Visible', 'off');
%set(handles.btnNextStream, 'Enable', 'on');
handles.Info.paused = false;
handles.Info.pausedPlotData = [];
handles.Info.pausedPlotX = [];
handles.Info.pausedRealNum = -1;
handles = updateListbox(handles, 'Continue...');
%start(handles.timer);
guidata(hObject, handles);


function btnNextStream_Callback(hObject, ~, handles)
% hObject    handle to btnNextStream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
splitIndex = handles.Info.splitIndex;
if (splitIndex == handles.Info.Ntx * handles.Info.Nrx)
    handles.Info.splitIndex = 1;
else
    handles.Info.splitIndex = splitIndex + 1;
end
set(handles.textStreamIndex, 'String', sprintf('%d', handles.Info.splitIndex));
guidata(hObject, handles);
 

% --- Executes on button press in btnNextDetectStream.
function btnNextDetectStream_Callback(hObject, ~, handles)
% hObject    handle to btnNextDetectStream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
detectIndex = handles.Info.detectIndex;
if (detectIndex == handles.Info.Ntx * handles.Info.Nrx)
    handles.Info.detectIndex = 1;
else
    handles.Info.detectIndex = detectIndex + 1;
end
set(handles.textDetectStreamIndex, 'String', sprintf('%d', handles.Info.detectIndex));
guidata(hObject, handles);


% --- Executes on button press in checkboxTemp.
function checkboxTemp_Callback(hObject, ~, handles)
% hObject    handle to checkboxTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTemp
if get(hObject, 'Value')
    set(handles.textTempWarn, 'Visible', 'on');
else
    set(handles.textTempWarn, 'Visible', 'off');
end


% --- Executes on button press in checkboxVitalDetect.
function checkboxVitalDetect_Callback(hObject, ~, handles)
% hObject    handle to checkboxVitalDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxVitalDetect
if get(hObject, 'Value')
    handles.textResRateValue.String = 'Ready';
    %handles.textResRateValue.ForegroundColor = 'g';
    handles.textResRateValue.ForegroundColor = [0, 0.8, 0.2];
    handles.textHeartbeatRateValue.String = 'Ready';
    handles.textHeartbeatRateValue.ForegroundColor = 'g';
    handles.textHeartbeatRateValue.ForegroundColor = [0, 0.8, 0.2];
    set(handles.textDetectStreamIndex, 'Visible', 'on');
    set(handles.btnNextDetectStream, 'Visible', 'on');
    %set(handles.textResRateValue, 'Visible', 'on');
    %set(handles.textHeartbeatRateValue, 'Visible', 'on');
else
    handles.textResRateValue.String = 'Suspend';
    handles.textResRateValue.ForegroundColor = 'black';
    handles.textHeartbeatRateValue.String = 'Suspend';
    handles.textHeartbeatRateValue.ForegroundColor = 'black';
    set(handles.textDetectStreamIndex, 'Visible', 'off');
    set(handles.btnNextDetectStream, 'Visible', 'off');
    %set(handles.textResRateValue, 'Visible', 'off');
    %set(handles.textHeartbeatRateValue, 'Visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, ~, ~)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
hObject.YGrid = 'on';
xlabel('Time [s]'); 
ylabel('SNR [dB]');


% --- Executes during object creation, after setting all properties.
function axesRes_CreateFcn(~, ~, ~)
% hObject    handle to axesRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesRes
% xlim([0 2*pi]);
% % xticks([0 0.4*pi 0.8*pi 1.2*pi 1.6*pi 2*pi]);
% xticks(0 : 0.5*pi : 2*pi);
% xticklabels({'0', '0.5\pi', '1\pi', '1.5\pi', '2\pi'});
title('Decoded Respiration Waveform');
xlabel('Time [s]');


% --- Executes during object creation, after setting all properties.
function axesHeart_CreateFcn(~, ~, ~)
% hObject    handle to axesHeart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesHeart
% xlim([0 2]);
% xticks(0 : 0.5 : 2);
title('Decoded Heartbeat Waveform');
xlabel('Time [s]');


% --- Executes on button press in radioBtnCombine.
function radioBtnCombine_Callback(hObject, ~, handles)
% hObject    handle to radioBtnCombine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radioBtnCombine
if (hObject.Value == 1)
    handles.radioBtnSplit.Value = 0;
    handles.Info.plotMode = 'c';
    set(handles.btnNextStream, 'Visible', 'off');
    set(handles.textStreamIndex, 'Visible', 'off');
else
    handles.radioBtnSplit.Value = 1;
    handles.Info.plotMode = 's';
    set(handles.btnNextStream, 'Visible', 'on');
    set(handles.textStreamIndex, 'Visible', 'on');
end
guidata(hObject, handles);


% --- Executes on button press in radioBtnSplit.
function radioBtnSplit_Callback(hObject, ~, handles)
% hObject    handle to radioBtnSplit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radioBtnSplit
if (hObject.Value == 1)
    handles.radioBtnCombine.Value = 0;
    handles.Info.plotMode = 's';
    set(handles.btnNextStream, 'Visible', 'on');
    set(handles.textStreamIndex, 'Visible', 'on');
else
    handles.radioBtnCombine.Value = 1;
    handles.Info.plotMode = 'c';
    set(handles.btnNextStream, 'Visible', 'off');
    set(handles.textStreamIndex, 'Visible', 'off');
end
guidata(hObject, handles);


function editMaxSec_Callback(hObject, ~, handles)
% hObject    handle to editMaxSec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMaxSec as text
%        str2double(get(hObject,'String')) returns contents of editMaxSec as a double
lenTxt = handles.editMaxSec.String;
res = str2double(lenTxt);
if (isnan(res) || res <= 0 || rem(res, 1) ~= 0)
    %warndlg('Max Length Invalid: Must be an integer above 0!', 'WARNING');
    errordlg('Max Length Invalid : Must be an integer above 0.', 'Input Error');
    formerMaxSec = handles.Info.plotMaxSec;
    handles.editMaxSec.String = formerMaxSec;
    res = formerMaxSec;
else
    % When input is a decimal but its decimal part only zero, reducing
    % decimal part.
    handles.editMaxSec.String = sprintf('%d', res);
    handles.Info.plotMaxSec = res;
end
%handles.figure1.CurrentAxes = handles.axes1;
xlim(handles.axes1, [0 res]);
xticks(handles.axes1, 'auto');
%handles.figure1.CurrentAxes = handles.axesRes;
xlim(handles.axesRes, [0 res]);
xticks(handles.axesRes, 'auto');
%handles.figure1.CurrentAxes = handles.axesHeart;
xlim(handles.axesHeart, [0 res]);
xticks(handles.axesHeart, 'auto');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editMaxSec_CreateFcn(hObject, ~, ~)
% hObject    handle to editMaxSec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editNtx_Callback(hObject, ~, handles)
% hObject    handle to editNtx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNtx as text
%        str2double(get(hObject,'String')) returns contents of editNtx as a double
textNtx = handles.editNtx.String;
res = str2double(textNtx);
if (isnan(res) || res <= 0 || rem(res, 1) ~= 0)
    %warndlg('Invalid Ntx number : Must be an integer above 0', 'WARNING');
    errordlg('Invalid Ntx number : Must be an integer above 0.', 'Input Error');
    handles.editNtx.String = handles.Info.Ntx;
else
    % When input is a decimal but its decimal part only zero, reducing
    % decimal part.
    handles.editNtx.String = sprintf('%d', res);
    handles.Info.Ntx = res;
    % Initialize necessary value to make sure 'roll' button works correctly. 
    handles.Info.splitIndex = 1;
    handles.Info.detectIndex = 1;
    set(handles.textStreamIndex, 'String', '1');
    set(handles.textDetectStreamIndex, 'String', '1');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editNtx_CreateFcn(hObject, ~, ~)
% hObject    handle to editNtx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editNrx_Callback(hObject, ~, handles)
% hObject    handle to editNrx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNrx as text
%        str2double(get(hObject,'String')) returns contents of editNrx as a double
textNrx = handles.editNrx.String;
res = str2double(textNrx);
if (isnan(res) || res <= 0 || rem(res, 1) ~= 0)
    %warndlg('Invalid Nrx number : Must be an integer above 0', 'WARNING');
    errordlg('Invalid Nrx number : Must be an integer above 0.', 'Input Error');
    handles.editNrx.String = handles.Info.Nrx;
else
    % When input is a decimal but its decimal part only zero, reducing
    % decimal part.
    handles.editNrx.String = sprintf('%d', res);
    handles.Info.Nrx = res;
    % Initialize necessary value to make sure 'roll' button works correctly. 
    handles.Info.splitIndex = 1;
    handles.Info.detectIndex = 1;
    set(handles.textStreamIndex, 'String', '1');
    set(handles.textDetectStreamIndex, 'String', '1');
end
guidata(hObject, handles);    


% --- Executes during object creation, after setting all properties.
function editNrx_CreateFcn(hObject, ~, ~)
% hObject    handle to editNrx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editHz_Callback(hObject, ~, handles)
% hObject    handle to editHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editHz as text
%        str2double(get(hObject,'String')) returns contents of editHz as a double

textHz = handles.editHz.String;
res = str2double(textHz);
if (isnan(res) || res <= 0 || rem(res, 1) ~= 0)
    %warndlg('Invalid data frequency : Must be an integer above 0', 'WARNING');
    errordlg('Invalid data frequency : Must be an integer above 0.', 'Input Error');
    handles.editHz.String = handles.Info.dataFre;
else
    % When input is a decimal but its decimal part only zero, reducing
    % decimal part.
    handles.editHz.String = sprintf('%d', res);
    handles.Info.dataFre = res;
end
guidata(hObject, handles);   


% --- Executes during object creation, after setting all properties.
function editHz_CreateFcn(hObject, ~, ~)
% hObject    handle to editHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editIP_Callback(hObject, ~, handles)
% hObject    handle to editIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIP as text
%        str2double(get(hObject,'String')) returns contents of editIP as a double
textIP = handles.editIP.String;
handles.Info.ip = textIP;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editIP_CreateFcn(hObject, ~, ~)
% hObject    handle to editIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editPort_Callback(hObject, ~, handles)
% hObject    handle to editPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPort as text
%        str2double(get(hObject,'String')) returns contents of editPort as a double
textPort = handles.editPort.String;
res = str2double(textPort);
if (isnan(res) || res <= 0 || res >= 65535 || rem(res, 1) ~= 0)
    %warndlg('Invalid Port : Must be an integer between 1 to 65535', 'WARNING');
    errordlg('Invalid Port : Must be an integer between 1 to 65535.', 'Input Error');
    handles.editPort.String = handles.Info.port;
else
    % When input is a decimal but its decimal part only zero, reducing
    % decimal part. 
    handles.editPort.String = sprintf('%d', res);
    handles.Info.port = handles.editPort.String;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editPort_CreateFcn(hObject, ~, ~)
% hObject    handle to editPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editAxisLow_Callback(hObject, ~, handles)
% hObject    handle to editAxisLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAxisLow as text
%        str2double(get(hObject,'String')) returns contents of editAxisLow as a double
editAxisLow = handles.editAxisLow.String;
res = str2double(editAxisLow);
axisHigh = handles.Info.axisHigh;
if (isnan(res) || res < 0 || res > axisHigh)
    %warndlg('Invalid Axis Lower Bound : Must be a decimal above or equal 0 and less than the upper bound of axis', 'WARNING');
	errordlg('Invalid Axis Lower Bound : Must be a decimal above or equal 0 and less than the upper bound of axis.', 'Input Error', 'nonmodal');
    handles.editAxisLow.String = handles.Info.axisLow;
    res = handles.Info.axisLow;
else
    % When input is a decimal but its decimal part only zero, reducing
    % decimal part.
    if rem(res, 1) == 0
        handles.editAxisLow.String = sprintf('%d', res);
    end
    handles.Info.axisLow = res;
end
%handles.figure1.CurrentAxes = handles.axes1;
ylim(handles.axes1, [res axisHigh]);
yticks(handles.axes1, 'auto');
guidata(hObject, handles);
  
           
% --- Executes during object creation, after setting all properties.
function editAxisLow_CreateFcn(hObject, ~, ~)
% hObject    handle to editAxisLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editAxisHigh_Callback(hObject, ~, handles)
% hObject    handle to editAxisHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAxisHigh as text
%        str2double(get(hObject,'String')) returns contents of editAxisHigh as a double
editAxisHigh = handles.editAxisHigh.String;
res = str2double(editAxisHigh);
axisLow = handles.Info.axisLow;
if (isnan(res) || res <= 0 || res < axisLow)
    %warndlg('Invalid Axis Upper Bound : Must be a positive decimal and greater than the lower bound of axis', 'WARNING');
    errordlg('Invalid Axis Upper Bound : Must be a positive decimal and greater than the lower bound of axis.', 'Input Error');
    handles.editAxisHigh.String = handles.Info.axisHigh;
    res = handles.Info.axisHigh;
else
    % When input is a decimal but its decimal part only zero, reducing
    % decimal part.
    if rem(res, 1) == 0
        handles.editAxisHigh.String = sprintf('%d', res);
    end
    handles.Info.axisHigh = res;
end
%set(gcf, 'CurrentAxes', handles.axes1);
%handles.figure1.CurrentAxes = handles.axes1;
ylim(handles.axes1, [axisLow res]);
yticks(handles.axes1, 'auto');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editAxisHigh_CreateFcn(hObject, ~, ~)
% hObject    handle to editAxisHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editSubcarrierIndex_Callback(hObject, ~, handles)
% hObject    handle to editSubcarrierIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSubcarrierIndex as text
%        str2double(get(hObject,'String')) returns contents of editSubcarrierIndex as a double
subcarrierIndex = handles.editSubcarrierIndex.String;
res = str2double(subcarrierIndex);
if (isnan(res) || res < 1 || res > 30 || rem(res, 1) ~= 0)
    %warndlg('Invalid subcarrier index : Must be an integer between 1 to 30', 'WARNING');
    errordlg('Invalid subcarrier index : Must be an integer between 1 to 30.', 'Input Error');
    handles.editSubcarrierIndex.String = sprintf('%d', handles.Info.subcarrierIndex);
else
    % When input is a decimal but its decimal part only zero, reducing
    % decimal part.
    handles.editSubcarrierIndex.String = sprintf('%d', res);
    handles.Info.subcarrierIndex = res;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editSubcarrierIndex_CreateFcn(hObject, ~, ~)
% hObject    handle to editSubcarrierIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popSubcarrier.
function popSubcarrier_Callback(hObject, ~, handles)
% hObject    handle to popSubcarrier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSubcarrier contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSubcarrier
if hObject.Value == 2
    set(handles.editSubcarrierIndex, 'Visible', 'on');
    set(handles.textSubcarrierLeader, 'Visible', 'on');
else
    set(handles.editSubcarrierIndex, 'Visible', 'off');
    set(handles.textSubcarrierLeader, 'Visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function popSubcarrier_CreateFcn(hObject, ~, ~)
% hObject    handle to popSubcarrier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function dispConnect_Callback(~, ~, ~)
% hObject    handle to dispConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dispConnect as text
%        str2double(get(hObject,'String')) returns contents of dispConnect as a double


% --- Executes during object creation, after setting all properties.
function dispConnect_CreateFcn(hObject, ~, ~)
% hObject    handle to dispConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function dispHz_Callback(~, ~, ~)
% hObject    handle to dispHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dispHz as text
%        str2double(get(hObject,'String')) returns contents of dispHz as a double


% --- Executes during object creation, after setting all properties.
function dispHz_CreateFcn(hObject, ~, ~)
% hObject    handle to dispHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function dispMIMO_Callback(~, ~, ~)
% hObject    handle to dispMIMO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dispMIMO as text
%        str2double(get(hObject,'String')) returns contents of dispMIMO as a double


% --- Executes during object creation, after setting all properties.
function dispMIMO_CreateFcn(hObject, ~, ~)
% hObject    handle to dispMIMO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menuHelp_Callback(~, ~, ~)
% hObject    handle to menuHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuExit_Callback(hObject, eventdata, handles)
% hObject    handle to menuExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menuFile_Callback(~, ~, ~)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuImdel_Callback(~, ~, ~)
% hObject    handle to menuImdel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~, ~] = uigetfile({'*.mat;','MATLAB Files(*.mat)';'*.*', ...
    'AllFiles(*.*)'},'Select an model');


% --------------------------------------------------------------------
function menuGuide_Callback(~, ~, ~)
% hObject    handle to menuGuide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuAbout_Callback(~, ~, ~)
% hObject    handle to menuAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuPrefer_Callback(~, ~, ~)
% hObject    handle to menuPrefer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuSave_Callback(~, ~, ~)
% hObject    handle to menuSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuView_Callback(~, ~, ~)
% hObject    handle to menuView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in btnNextStream.


% --- Executes on button press in btnCut.
function btnCut_Callback(hObject, ~, handles)
% hObject    handle to btnCut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tcp_recv('csi_tcp_recv');
fclose('all');
stop(handles.timer);
%set(gcf, 'CurrentAxes', handles.axes1);
%handles.figure1.CurrentAxes = handles.axes1;
cla(handles.axes1);
%set(gcf, 'CurrentAxes', handles.axesRes);
%handles.figure1.CurrentAxes = handles.axesRes;
cla(handles.axesRes);
%set(gcf, 'CurrentAxes', handles.axesHeart);
%handles.figure1.CurrentAxes = handles.axesHeart;
cla(handles.axesHeart);
filename = handles.Info.filename;
havBeenCutTimes = handles.Info.havBeenCut;
if havBeenCutTimes == 0
    handles.lstboxState.String = [];
else
    if handles.Info.lastCutNoFile == false
        lastFileRecord = cell2mat(handles.lstboxState.String(havBeenCutTimes));
        lastFileRecord = [lastFileRecord, '   <HISTORY>'];
        handles.lstboxState.String(havBeenCutTimes) = {lastFileRecord};
    end
    handles.lstboxState.String = handles.lstboxState.String(1:havBeenCutTimes);
end
if exist(filename, 'file')
    handles.Info.lastCutNoFile = false;
    if handles.checkboxTemp.Value
        system(['del ', filename]);
        handles = updateListbox(handles, ['"', filename, '"', '  has been cut and deleted.']);
    else
        handles = updateListbox(handles, ['"', filename, '"', '  has been cut and saved.']);
    end
    handles.Info.havBeenCut = havBeenCutTimes + 1;
else
    handles.Info.lastCutNoFile = true;
    handles = updateListbox(handles, ['"', filename, '"', '  doesn''''t exist.']);
end
handles.Info.havntBeenStarted = true;
handles.Info.plotGapNum = handles.Info.plotMaxSec * handles.Info.dataFre;
handles.Info.curPos = 0;
handles.Info.fileHandle = -1;
handles.Info.cputime_begin2draw = -1;
handles.Info.paused = false;
handles.Info.pausedPlotData = [];
handles.Info.pausedPlotX = [];
handles.Info.pausedRealNum = -1;
%handles.Info.shift_sec = 0;
set(hObject, 'Visible', 'off');
set(handles.btnPause, 'Visible', 'off');
set(handles.btnContinue, 'Visible', 'off');
%set(handles.btnNextStream, 'Enable', 'on');
set(handles.staConnect, 'Visible', 'off');
set(handles.staHz, 'Visible', 'off');
set(handles.staMIMO, 'Visible', 'off');
set(handles.staRunningTime, 'Visible', 'off');
set(handles.textRunningTime, 'Visible', 'off');
set(handles.dispConnect, 'Visible', 'off');
set(handles.dispHz, 'Visible', 'off');
set(handles.dispMIMO, 'Visible', 'off');

set(handles.btnStart, 'Visible', 'on');
set(handles.editSubcarrierIndex, 'Enable', 'on');
set(handles.popSubcarrier, 'Enable', 'on');
set(handles.btnSelectCSIdir, 'Enable', 'on');
set(handles.editPort, 'Enable', 'on');
set(handles.editIP, 'Enable', 'on');
set(handles.editHz, 'Enable', 'on');
set(handles.editNtx, 'Enable', 'on');
set(handles.editNrx, 'Enable', 'on');
set(handles.editMaxSec, 'Enable', 'on');
set(handles.checkboxVitalDetect, 'Enable', 'on');
if get(handles.checkboxVitalDetect, 'Value')
    set(handles.textResRateValue, 'String', 'Ready');
    set(handles.textHeartbeatRateValue, 'String', 'Ready');
    set(handles.textResRateValue, 'ForegroundColor', [0, 0.8, 0.2]);
    set(handles.textHeartbeatRateValue, 'ForegroundColor', [0, 0.8, 0.2]);
else
    set(handles.textResRateValue, 'String', 'Suspend');
    set(handles.textHeartbeatRateValue, 'String', 'Suspend');
    set(handles.textResRateValue, 'ForegroundColor', 'black');
    set(handles.textHeartbeatRateValue, 'ForegroundColor', 'black');
end
set(handles.textResStatics, 'Visible', 'off');
set(handles.textResStatics, 'String', '');
set(handles.textHeartbeatStatics, 'Visible', 'off');
set(handles.textHeartbeatStatics, 'String', '');
set(handles.textRunningTime, 'String', '0 d  0 h  0 m  0 s');
guidata(hObject, handles);


function figure1_CloseRequestFcn(hObject, ~, handles)
stop(handles.timer);
btn = questdlg('Are you sure you want to exit?', 'Exit or Not', 'OK', 'Cancel', 'Cancel');
switch btn
    case 'OK'
        % Close tcp receive service
        %delete(handles.timer);
        delete(timerfindall);
        fclose('all');
        if strcmp(handles.btnStart.Visible, 'off')
            tcp_recv('csi_tcp_recv');
            if handles.checkboxTemp.Value
                system(['del ', handles.Info.filename]);
            end
        end
        % If running in online mode...
        adapterName = handles.Info.adapterName;
        if strcmp(handles.uipanelNet.Visible, 'on') && handles.Info.haveSelectedCSIdir
        	while (true)
                %[~, check_connected_result] = system(sprintf('netsh interface show interface name="%s" | findstr "Connected"', adapterName));
                [check_connected_status, ~] = system(sprintf('chcp 437 && netsh interface show interface name="%s" | findstr "Connected"', adapterName));                
                if check_connected_status ~= 0
                    questdlg(sprintf('Adapter "%s" is disconnected, you need to plug in the cable to recover DHCP service.', adapterName), 'Adapter Unpluged', 'Retry', 'Retry');
                    continue;
                else
                	system(sprintf('netsh int ip set address "%s" dhcp', adapterName));
                    handles = updateListbox(handles, 'IPv4 address has been set to DHCP successfully...');
                    break;
                end
            end
        end
        if hObject == handles.figure1
            delete(hObject);
        else
            delete(handles.figure1);
        end
    case 'Cancel'
        if strcmp(handles.btnStart.Visible, 'off')
            start(handles.timer);
        end
        %return;
end

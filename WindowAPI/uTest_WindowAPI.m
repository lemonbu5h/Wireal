function uTest_WindowAPI(doSpeed)
% Automatic test: WindowAPI
% This is a routine for automatic testing. It is not needed for processing and
% can be deleted or moved to a folder, where it does not bother.
%
% uTest_WindowAPI(doSpeed)
% INPUT:
%   doSpeed: If this is 0 or FALSE, a faster test is performed. For other values
%            or if omitted each action is shown for 0.5 seconds.
% OUTPUT:
%   On failure the test stops with an error.
%
% Tested: Matlab 6.5, 7.7, 7.8, 7.13, 9.1, WinXP/32, Win7/64
% Author: Jan Simon, Heidelberg, (C) 2009-2018 matlab.2010(a)n(MINUS)simon.de

% $JRev: R-k V:010 Sum:OyiqUQ2ZOMIY Date:28-Jul-2017 03:20:31 $
% $License: BSD (use/copy/change/redistribute on own risk, mention the author) $
% $File: Tools\UnitTests_\uTest_WindowAPI.m $
% History:
% 001: 26-Jun-2011 15:20, First version.
% 004: 24-Jul-2011 18:23, LockCursor.
% 007: 15-Jan-2013 01:06, New commands: Button, Enable.
% 010: 24-Apr-2016 18:05, No Matlab 6.5 anymore: CATCH ME
%      Check for DOUBLE input on HG2 machine.

% Initialize: ==================================================================
FuncName = mfilename;
ErrID    = ['JSimon:', FuncName, ':Crash'];

if nargin == 0
   doSpeed = true;
end
if doSpeed
   Delay = 0.5;
else
   Delay = 0.02;
end

% Do the work: =================================================================
% Hello:
fprintf('==== Test WindowAPI: %s\n', datestr(now, 0));

try
   Lib     = WindowAPI();
   LibFile = which(Lib);
   fprintf('  Version: %s\n\n', LibFile);
catch ME
   error(ErrID, '*** %s: Cannot get library version: %s', ...
      FuncName, ME.message);
end

% Create figure on 1st monitor:
FigH = figure('Color', [100, 200, 0] ./ 255, ...
   'NumberTitle', 'off', ...
   'Name',        'Test WindowAPI', ...
   'Renderer',    'Painters');
FigPos = get(FigH, 'Position');
BtnPos = [60, 60, 120, 40];
ButtonH = uicontrol('Style', 'Togglebutton', 'String', '', ...
   'FontSize', 16, ...
   'Position', BtnPos);
AxesH = axes;
sphere;
set(AxesH, 'visible', 'off', 'CameraViewAngle', 30);

MonitorIndex = 1;
ready        = false;
while ~ready
   fprintf('\n== Monitor %d\n', MonitorIndex);
   set(ButtonH, 'String', sprintf('Monitor %d', MonitorIndex));
   
   try
      WindowAPI(FigH, 'TopMost');
      WindowAPI(FigH, 'TopMost', 'on');
      pause(Delay);
      WindowAPI(FigH, 'TopMost', 'off');  % 'NoTopmost' formerly
      pause(Delay);
      fprintf('  ok: TopMost\n');
   catch ME
      error(ErrID, '*** %s: TopMost/NoTopMost crashed: %s', ...
         FuncName, ME.message);
   end
   
   try
      WindowAPI(FigH, 'Front');
      pause(Delay);
      fprintf('  ok: Front\n');
   catch ME
      error(ErrID, '*** %s: Front crashed: %s', FuncName, ME.message);
   end
   
   try
      WindowAPI(FigH, 'Minimize');
      Status = WindowAPI(FigH, 'GetStatus');
      if strcmpi(Status, 'minimized') == 0
         error('GetStatus(minimized) failed');
      end
      pause(Delay);
      
      WindowAPI(FigH, 'Maximize');
      Status = WindowAPI(FigH, 'GetStatus');
      if strcmpi(Status, 'maximized') == 0
         error('GetStatus(maximized) failed');
      end
      pause(Delay);
      
      WindowAPI(FigH, 'Restore');
      Status = WindowAPI(FigH, 'GetStatus');
      pause(Delay);
      if strcmpi(Status, 'normal') == 0
         error('GetStatus(restored) failed');
      end
      fprintf('  ok: Minimize/Maximize/Restore\n');
   catch ME
      error(ErrID, ...
         '*** %s: Minimize/Maximize/Restore crashed:\n%s', ...
         FuncName, ME.message);
   end
   
   try
      WindowAPI(FigH, 'XMax');
      pause(Delay);
      WindowAPI(FigH, 'Position', FigPos);
      WindowAPI(FigH, 'YMax');
      pause(Delay);
      WindowAPI(FigH, 'Position', FigPos);
      fprintf('  ok: XMax, YMax\n');
   catch ME
      error(ErrID, '*** %s: XMax/YMax crashed: %s', FuncName, ME.message);
   end
   
   try
      WindowAPI(FigH, 'Position', [100, 102, 600, 202]);
      pause(Delay);
      WindowAPI(FigH, 'Position', 'work');
      pause(Delay);
      WindowAPI(FigH, 'Position', 'full');
      pause(Delay);
      drawnow;
      pause(Delay);
      WindowAPI(FigH, 'Position', FigPos);
      
      fprintf('  ok: Position\n');
   catch ME
      error(ErrID, '*** %s: Position crashed: %s', FuncName, ME.message);
   end
   
   try
      WindowAPI(FigH, 'OuterPosition', [100, 102, 200, 202]);
      pause(Delay);
      WindowAPI(FigH, 'OuterPosition', 'work');
      pause(Delay);
      WindowAPI(FigH, 'OuterPosition', 'full');
      pause(Delay);
      WindowAPI(FigH, 'Position', FigPos);
      
      fprintf('  ok: OuterPosition\n');
   catch ME
      error(ErrID, '*** %s: OuterPosition crashed: %s', FuncName, ME.message);
   end
   
   try
      WindowAPI(FigH, 'Flash');
      pause(Delay);
      fprintf('  ok: Flash\n');
   catch ME
      error(ErrID, '*** %s: Flash crashed: %s', FuncName, ME.message);
   end
   
   try
      for dAlpha = linspace(1, 0, 10)
         WindowAPI(FigH, 'Alpha', dAlpha);
         pause(0.1);
      end
      pause(Delay);
      fprintf('  ok: Alpha\n');
      
      set(FigH, 'Color', [1, 0, 1]);
      for dAlpha = linspace(0, 1, 10)
         WindowAPI(FigH, 'Alpha', dAlpha, [255, 0, 255]);
         pause(0.02);
      end
      pause(Delay);
      WindowAPI(FigH, 'Opaque');
      fprintf('  ok: Alpha and StencilRGB\n');
   catch ME
      error(ErrID, '*** %s: Alpha crashed: %s', FuncName, ME.message);
   end
   
   try
      set(FigH, 'Color', [100, 200, 0] ./ 255);
      IniPos  = [1, 1, FigPos(3:4)];
      DiffPos = (BtnPos - IniPos) / 10;
      for i = 1:10
         WindowAPI(FigH, 'Clip', IniPos + i * DiffPos);
         pause(0.05);
      end
      pause(Delay);
      WindowAPI(FigH, 'Clip', false);
      fprintf('  ok: Clip\n');
   catch ME
      error(ErrID, '*** %s: Clip crashed: %s', FuncName, ME.message);
   end
   
   try
      Monitor = WindowAPI(FigH, 'Monitor');
      fprintf('  ok: Monitor:\n');
      disp(Monitor);
   catch ME
      error(ErrID, '*** %s: Monitor crashed: %s', FuncName, ME.message);
   end
   
   try  % Set window position on the current monitor:
      Pos1 = WindowAPI(FigH, 'Position');
      WindowAPI(FigH, 'Position', Pos1.Position);
      Pos2 = WindowAPI(FigH, 'Position');
      
      if isequal(Pos1, Pos2) == 0
         error('Get/Set Position failed');
      end
      if Pos1.MonitorIndex == 1
         if isequal(get(FigH, 'Position'), Pos2.Position) == 0
            error('Get/Set Position failed on primary monitor');
         end
      end
      
      fprintf('  ok: Get/Set Position\n');
   catch ME
      error(ErrID, '*** %s: Monitor crashed: %s', FuncName, ME.message);
   end
   
   try  % Set outer window position on the current monitor:
      Pos1 = WindowAPI(FigH, 'OuterPosition');
      WindowAPI(FigH, 'OuterPosition', Pos1.Position);
      Pos2 = WindowAPI(FigH, 'OuterPosition');
      
      if isequal(Pos1, Pos2) == 0
         error('Get/Set OuterPosition failed');
      end
      if Pos1.MonitorIndex == 1
         if isequal(get(FigH, 'OuterPosition'), Pos2.Position) == 0
            error('Get/Set OuterPosition failed on primary monitor');
         end
      end
      fprintf('  ok: Get/Set OuterPosition\n');
   catch ME
      error(ErrID, '*** %s: Monitor crashed: %s', FuncName, ME.message);
   end
   
   try
      WindowAPI(FigH, 'LockCursor', 1);
      pause(0.1);
      WindowAPI(FigH, 'LockCursor', 0);
      pause(0.1);
      WindowAPI(FigH, 'LockCursor', [10, 10, 200, 100]);
      pause(0.1);
      WindowAPI(FigH, 'LockCursor');
      pause(0.1);
      WindowAPI('UnlockCursor');
      fprintf('  ok: Lock/unlock cursor\n');
   catch ME
      error(ErrID, '*** %s: LockCursor crashed: %s', FuncName, ME.message);
   end
   
   try
      WindowAPI(FigH, 'Enable', 0);
      pause(0.1);
      WindowAPI(FigH, 'Enable', 1);
      pause(0.1);
      fprintf('  ok: Disable/enable figure interaction\n');
   catch ME
      error(ErrID, '*** %s: Enable crashed: %s', FuncName, ME.message);
   end
   
   try
      WindowAPI(FigH, 'Button', false);
      pause(0.1);
      WindowAPI(FigH, 'Button', true);
      pause(0.1);
      fprintf('  ok: Hide/show window buttons\n');
   catch ME
      error(ErrID, '*** %s: Enable crashed: %s', FuncName, ME.message);
   end
   
   % Move figure to next screen:
   MonitorIndex = MonitorIndex + 1;
   try
      WindowAPI(FigH, 'Position', FigPos, MonitorIndex);
      
      % Keep window visible if the monitors have different sizes:
      WindowAPI(FigH, 'ToMonitor');
      Pos    = WindowAPI(FigH, 'Position');
      FigPos = Pos.Position;
      
      % If a not existing monitor is chosen, the figure is moved to the primary
      % monitor:
      Monitor = WindowAPI(FigH, 'Monitor');
      if Monitor.MonitorIndex == 1
         ready = true;
      end
   catch ME
      error(ErrID, '*** %s: Monitor crashed: %s', FuncName, ME.message);
   end
end  % while not(ready)

matlabV = [100, 1] * sscanf(version, '%d.%d', 2);  % '7.7' -> 707
hasHG2  = (matlabV >= 804);  % HG2 since R2014b
if hasHG2
   try
      WindowAPI(double(FigH), 'TopMost', 1);
      fprintf('  ok: DOUBLE handle accepted for HG2.\n');
   catch ME
      error(ErrID, '*** %s: DOUBLE handle crashed: %s', FuncName, ME.message);
   end
end

% Goodbye:
delete(FigH);
fprintf('\nWindowAPI passed the tests.\n');

% return;

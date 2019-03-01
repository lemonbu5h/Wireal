function Reply = WindowAPI(FigH, varargin)
% Control figure state using Windows API
% WindowAPI(FigureHandle, Command, [Value])
% INPUT:
%   FigureHandle:  Matlab's handle of a visible figure handle.
%                  All commands except 'Position', 'OuterPosition', 'Clip' and
%                 'LockCursor' accept the Windows handle of the OS also (see
%                  'GetHWnd' command).
%   Command:       String, not case sensitive:
%     'TopMost':   Figure is kept on top of other windows, but can loose the
%                  focus. The 3rd input can be used to remove the TopMost status
%                  property.
%     'Front':     Lift the window on top of all others, flash the icon in the
%                  taskbar. The window is not made active. This may interrupt
%                  other programs.
%     'Maximize':  Maximize the window to full screen with visible Windows
%                  taskbar and the figure's menubar, but no border around the
%                  figure. With the 3rd input Flag, the maximization button can
%                  be disabled and enabled.
%                  Similar: WindowAPI(FigH, 'Position', 'work')
%     'Minimize':  Minimize the window. Equivalent to 'Maximize'.
%     'Restore':   Restore original size.
%     'XMax', 'YMax': Maximize the window horizontally or vertically.
%     'Position':  Set inner position of the figure relative to the current
%                  monitor, or to the monitor with index defined as 4th input.
%                  The position value can be:
%                    DOUBLE vector [Left, Top, Right, Bottom]: pixel units
%                            relative to monitor.
%                    'work': Full monitor position without taskbar and sidebar.
%                    'full': Full monitor position. Using this you see only the
%                            figure's contents without title, border and
%                            menubar and without the taskbar.
%     'OuterPosition': As 'Position', but sets the outer position.
%     'ToScreen':  Move window completely to the nearest monitor. See MOVEGUI.
%     'Flash':     Short flashing the window border or the taskbar icon.
%     'Alpha':     WindowAPI(FigH, 'Alpha', A): Set the transparency level of
%                  the complete window from A=0.0 (invisible) to 1.0 (opaque).
%                  WindowAPI(FigH, 'Alpha', A, [R,G,B]): The pixels with the
%                  color [R,G,B] are not drawn such that the pixels behind the
%                  window are visible. [R,G,B] must be integers in the range
%                  from 0 to 255. See NOTES.
%     'Opaque':    Disable Alpha blending to save resources.
%     'Clip':      Clip the window border or a specified rectangle. 3rd input:
%                    TRUE:  Clip the figure border, "splash screen".
%                    FALSE: Show the full window.
%                    [X, Y, Width, Height]: Rectangle in coordinates relative
%                           to figure as [X, Y, Width, Height] measured from
%                           bottom left in pixels.
%     'LockCursor': Keep cursor inside a rectangle. 3rd input:
%                    1, TRUE: Limit to figure,
%                    [X, Y, Width, Height]: Rectangle in pixel units relative
%                             to figure, DOUBLE vector.
%                    0, FALSE or omitted: unlock the cursor.
%                  Emergency break-out: Alt-Tab to enable the command window,
%                  then:  WindowAPI('UnlockCursor').
%     'SetFocus':  Set the keyboard focus to the specified figure. Actually
%                  "figure(FigHandle)" should do this according to Matlab's
%                  documentation, but it doesn't from version 6.5 to 2011b or
%                  higher.
%     'Enable':    Set the interactivity of the window according to the 3rd
%                  input Flag.
%     'Hide', 'Show': Hide or show the window. This does not change the
%                  HWnd-handle in opposite to Matlab's {'Visible', 'off'}.
%     'Button':    Set the visibility of the window's system buttons: Max, Min
%                  and Close accoring to 3rd input Flag.
%   Flag: To enable a feature use TRUE, any non zero value or 'on'. FALSE, 0
%         and 'off' disable it. Optional, default: 'on'.
%
% GET INFORMATION:
% Reply = WindowAPI(FigureHandle, Command)
%     'GetStatus': Current window status: 'maximized', 'minimized', 'normal'.
%     'GetHWnd':   Get the OS handle of the figure as UINT64 value. Most
%                  commands of WindowAPI are faster using this handle, but the
%                  MATLAB handle is needed if the inner figure position is used
%                  e.g. in 'Position', 'Clip' or 'LockCursor'.
%                  NOTE: The HWnd handle changes if the visibility of a figure
%                        is disabled!
%     'Monitor':   Information about monitor with the largest overlap to the
%                  figure. Struct with fields:
%                    FullPosition: [X, Y, W, H] monitor size.
%                    WorkPosition: [X, Y, W, H] size without taskbar / sidebar.
%                    FigureOnScreen: LOGICAL flag, TRUE if any part of the
%                                  figure overlaps with this monitor. Without
%                                  overlap the nearest monitor is replied.
%                    isPrimaryMonitor: This monitor is the primary monitor.
%     'Position', 'OuterPosition': Using these commands with 2 inputs only
%                  reply the size relative to the current monitor as struct
%                  with the fields 'Position' and 'MonitorIndex'.
%
% CONTROL FEATURES:
%   FormerStatus = WindowAPI('topmost', Status): If Status is 'off', the
%      TopMost property is not set in future calls. This keeps Matlab in the
%      background e.g. during a long test, even if a function asks WindowAPI
%      to set a figure as top-most window.
%   WindowAPI('UnlockCursor'): Frees a cursor locked to a rectangle.
%      Same as: WindowAPI(FigH, 'LockCursor', 0)
%
% NOTES:
%   This function calls Windows-API functions => No Linux, no MacOS - sorry!
%
%   Enabling the Alpha blending let the figure flash sometimes. It might be
%   nicer to create the figure outside the visible screen area, enable the
%   Alpha blending and move the window to the desired position afterwards.
%
%   For the determination of the OS handle, the window title is modified for
%   some milliseconds. This works for all known Matlab versions and without
%   Java.
%
%   Alpha blending does not work reliably with the OpenGL renderer on my
%   computer. Setting the undocumented FIGURE's WVisual property to '07'
%   ("RGB 16 bits(05 06 05 00) zdepth 16, Hardware Accelerated, Opengl, Double
%   Buffered, Window") helped usually. But I suggest the Painters or ZBuffer
%   renderers for a reliable Alpha blending.
%
%   On laptop graphic cards, the StencilRGB value of the 'Alpha' command can
%   use less than 8 bits per pixel, e.g. on a IBM T40 the StencilRGB=[90,0,0]
%   matchs the Matlab colors [88/255,0,0] to [95/255,0,0]. To be sure,
%   StencilRGB should contain the values 0 or 255 only.
%
%   This function contains too many feature to be convenient. See the leaner
%   wrappers: MaximizeFig, AlphaFig, ClipFig, TopFig, ToMonitorFig.
%
% EXAMPLES:  (More: demo_WindowAPI.m)
% Maximize the current figure:
%   WindowAPI(gcf, 'maximize')
% Get the whole screen for drawing, remove the border:
%   figure; sphere;
%   uicontrol('Style', 'PushButton', 'Position', [10, 10, 100, 24], ...
%             'String', 'Close', 'Callback', 'delete(gcbf)');
%   WindowAPI(gcf, 'position', 'full')
%   WindowAPI(gcf, 'clip');
%
% A transparent command window (Matlab >= 2008a probably):
%   mainFrame = com.mathworks.mde.desk.MLDesktop.getInstance.getMainFrame;
%   HWnd = uint64(mainFrame.getHWnd);
%   WindowAPI(HWnd, 'Alpha', 0.8);
%
% COMPILE:
% * The C-file is compiled automatically, when you call it the first time.
% * Depending on the Matlab version, the C-file is compiled for HG1 or HG2
%   graphics automatically (>= 2014b). This M-file is used only to call the
%   needed version of the MEX file. If you do not work with old Matlab versions,
%   you can remove the "_HGx" part from the MEX file name, to call it directly.
% * For a manual compilation see WindowAPI.c -> COMPILE.
% * If you have installed a former version of WindowAPI, remove it at first:
%     clear WindowAPI
%     delete(which(['WindowAPI.', mexext]))
%
% Tested: Matlab/64 7.8, 7.13, 8.6, 9.1, Win7/64
% Author: Jan Simon, Heidelberg, (C) 2008-2018 matlab.2010(a)n(MINUS)simon.de

% See in the FEX:
% ShowWindow, Matthew Simoneau:
%   http:%www.mathworks.com/matlabcentral/fileexchange/3407
% Window Manipulation, Phil Goddard:
%   http:%www.mathworks.com/matlabcentral/fileexchange/3434
% api_showwindow, Mihai Moldovan:
%   http:%www.mathworks.com/matlabcentral/fileexchange/2041
% maxfig, Mihai Moldovan:
%   http:%www.mathworks.com/matlabcentral/fileexchange/6913
% setFigTransparency, Yair Altman:
%   http:%www.mathworks.com/matlabcentral/fileexchange/30583
% FigureManagement (multi-monitor setup), Mirko Hrovat:
%   http:%www.mathworks.com/matlabcentral/fileexchange/12607

% Useful tricks, which I could not solve in the Windows API yet:
% (inspired by Yair Altman):
%   jFrame = get(handle(gcf), 'JavaFrame');
%   jProx  = jFrame.fFigureClient.getWindow();
%   HWnd   = jProx.getHWnd;
%   jProx.setMinimumSize(java.awt.Dimension(200,200));  % setMaximumSize
%   jProx.setCloseOnEscapeEnabled(1)

% $JRev: R-Q V:042 Sum:P3J5qnuslRYA Date:17-Apr-2018 01:23:48 $
% $License: BSD (use/copy/change/redistribute on own risk, mention the author) $
% $File: Tools\GLGui\WindowAPI.m $
% $UnitTest: uTest_WindowAPI $
% History:
% 037: 24-Apr-2016 23:58, Consider HG1 and HG2 by different MEX functions.
% 042: 17-Apr-2018 01:13, Mex version replied if called without inputs.
%      This feature has been removed, such that the demo did not work anymore.
%      Thanks to Youshu Zhou, who found this bug.

% Initialize: ==================================================================
persistent MexFcn hasHG2
if isempty(MexFcn)  % Find MEX file once only per Matlab session:
   if ~ispc
      error(['JSimon:', mfilename, ':OS'], ...
         'WindowAPI runs on Windows-PCs only. Sorry!');
   end
   
   % Use different library depending on HG version:
   matlabV = [100, 1] * sscanf(version, '%d.%d', 2);  % '7.7' -> 707
   hasHG2  = (matlabV >= 804);  % HG2 since R2014b
   if hasHG2
      % -DHAS_HG2 is added inside InstallMex if available.
      LibName = 'WindowAPI_HG2';
   else
      LibName = 'WindowAPI_HG1';
   end
   
   % Check if the C-file has been compiled before:
   MexFcn = str2func(LibName);
   if isempty(which([LibName, '.', mexext]))
      Ok = InstallMex('WindowAPI.c', {'-output', LibName}, 'uTest_WindowAPI');
      if Ok
         fprintf('::: %s installed.\n', LibName);
      else  % Remove persistent variable:
         clear('MexFcn');
      end
   end
   
   % I need this dummy calls for an automatic collection of used files:
   try  %#ok<TRYNC>
      WindowAPI_HG1();
      WindowAPI_HG2();
   end
end

% Reply the used library version when called without inputs:
if nargin == 0
   Reply = func2str(MexFcn);
   return;
end

% Do the work: =================================================================
% Care for modern graphic handles:
if hasHG2 && isa(FigH, 'double') && isgraphics(FigH, 'figure')
   FigH = handle(FigH);
end

% Call the mex function:
if nargout
   Reply = MexFcn(FigH, varargin{:});
else
   MexFcn(FigH, varargin{:});
end

% return;

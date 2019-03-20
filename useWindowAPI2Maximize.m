function useWindowAPI2Maximize(main_figure)
main_figure.Visible = 'on';
FigPos = get(main_figure, 'Position');
WindowAPI(main_figure, 'Position', FigPos, 2);
WindowAPI(main_figure, 'maximize');
WindowAPI(main_figure, 'SetFocus');
end
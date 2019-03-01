tic;
t = tcpip('127.0.0.1', 8888,'NetworkRole', 'server', 'InputBufferSize', 2048000);
fopen(t);
rawData = read_from_net(t)
% while(1)
% i = 1; 
% while (t.BytesAvailable > 0)
%         %data = fread(t, t.BytesAvailable);
%         array = read_from_net(t);
%         array = adjustCSI(array);
%         array = getAverageCSI(array);
%         i = i + 1;
%         %array = adjustFormat(array);
% end
fclose(t);
toc;
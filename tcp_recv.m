function tcp_recv(appname, hostname, port, timestamp)
if (nargin == 1)
    system(['TASKKILL /F /IM ', appname, '.exe']);
    %system(['cd /d', work_dir, '&& del ', appname, '.exe']);
    return;
elseif (nargin == 4)
    %system(['copy /Y ', appname, '.exe ', work_dir]);
    %system(['cd /d', work_dir, '&& start ', appname, ' ', hostname, ' ', port, ' ', timestamp]);
	system(['start ./', appname, ' ', hostname, ' ', port, ' ', timestamp]);
    return;
else
    error('Invalid input arguments for tcp_recv function');
end
end
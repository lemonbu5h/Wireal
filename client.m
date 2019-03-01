data = sin(1:64);
%plot(data);
t = tcpip('localhost', 30000, 'NetworkRole', 'client');
fopen(t);
fwrite(t, data);
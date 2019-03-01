c1 = read_bf_file('sample_data/tmpzou.dat');
csi_trace=c1(500:1100,1);
package=[];
for i=1:length(csi_trace)
  csi_entry = csi_trace{i};
  csi = get_scaled_csi(csi_entry);
  [u,v,w]=size(csi);
  thr_antenna=reshape(csi,u*v,30).';         
  a_antenna=thr_antenna(1:30,1);       
  temp=(db(abs(a_antenna)));          
  package=[package,temp];
end 
newpackage= package(5,100:500);
sa = 1000;      fn = sa/2;      % Sampling frequency (1000Hz), Nyquist frequency(500Hz)
fp = 20;        fs = 50;       % Passband (0~40Hz), Stop band(150Hz-500Hz)
Wp = fp/fn;     Ws = fs/fn;    % Normalized passband (40/500), stopband (150/500)
Rp = 3;         Rs = 30;        % ripple less than 3 dB, attenuation larger than 60dB
[n,Wn] = buttord(Wp,Ws,Rp,Rs);  % Returns n = 5; Wn=0.0810; 
[b,a] = butter(n,Wn);           % Designde signs an order n lowpass digital
freqz(b,a,512,sa);              % returns the frequency response vector h and 
title('n=5 Butterworth Lowpass Filter');
%% Filter Implementation  °ÍÌØÎÖË¹µÍÍ¨ÂË²¨Æ÷
xn=newpackage;
y  = filter(b, a, xn);          % Implement designed filter
figure(1);
subplot(2,1,1);
t=0:400;
plot(t, xn);
title('Before Filter');

subplot(2,1,2);
plot( t,y);
title('After Filter');



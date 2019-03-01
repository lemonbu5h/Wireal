function ret = ecg(plotX, bpm)
% rate = 81;
% x=0:0.01:2;
li=30/rate;

%p wave specifications
a_pwav=0.25;
d_pwav=0.09;
t_pwav=0.16;

%q wave specifications
a_qwav=0.025;
d_qwav=0.066;
t_qwav=0.166;

%qrs wave specifications
a_qrswav=1.6;
d_qrswav=0.11;

%s wave specifications
a_swav=0.25;
d_swav=0.066;
t_swav=0.09;

%t wave specifications
a_twav=0.35;
d_twav=0.142;
t_twav=0.2;

%u wave specifications
a_uwav=0.035;
d_uwav=0.0476;
t_uwav=0.433;
    
pwav=p_wav(x,a_pwav,d_pwav,t_pwav,li);

%qwav output
qwav=q_wav(x,a_qwav,d_qwav,t_qwav,li);

%qrswav output
qrswav=qrs_wav(x,a_qrswav,d_qrswav,li);

%swav output
swav=s_wav(x,a_swav,d_swav,t_swav,li);

%twav output
twav=t_wav(x,a_twav,d_twav,t_twav,li);

%uwav output
uwav=u_wav(x,a_uwav,d_uwav,t_uwav,li);

%ecg output
ret=pwav+qrswav+twav+swav+qwav+uwav;
end

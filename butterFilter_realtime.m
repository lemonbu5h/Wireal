function ret = butterFilter_realtime(pack, frequency, mode)
fs = frequency; % Sample frequency
fp = [1, 1.5]; % Pass frequency
fc = [0.5, 3]; % Stop frequency

% Mode 0 Respiration mode? 1 Heartbeat mode.
if mode == 0
    % Respiration use
    Wp = 0.5 / (fs / 2); 
    Ws = 1.5 / (fs / 2);
end
if mode == 1
    % Heart rate use
    Wp = 2 * fp / fs;
    Ws = 2 * fc / fs;
end
Rp = 2; %2
% Rs = 30; %40
Rs = 20;
[n, Wn] = buttord(Wp, Ws, Rp, Rs);
[b, a] = butter(n, Wn);

filterdata = zeros(size(pack, 1), size(pack, 2));
for i = 1 : size(pack, 1)
	filterdata(i, :) = filtfilt(b, a, pack(i, :));
end
ret = filterdata;
end
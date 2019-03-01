function module_PSD(data, frequency)
Fs = frequency;
N = length(data);
Nrx = size(data, 1);
hold on;
for i = 1 : Nrx
    x = data;
    xdft = fft(x);
    xdft = xdft(1 : N / 2 + 1);
    psdx = (1/(Fs*N)) * abs(xdft).^2;
    psdx(2 : end-1) = 2 * psdx(2 : end-1);
    freq = 0 : Fs / N : Fs / 2;
    plot(freq, 10 * log10(psdx));
end
hold off;
grid on
title('Periodogram Using FFT');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
end
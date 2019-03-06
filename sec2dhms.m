function timeStr = sec2dhms(seconds)
if (seconds < 60)
    timeStr = sprintf("%.2f s", seconds);
elseif (seconds < 3600)
    timeStr = sprintf("%u m  %.2f s", floor(seconds/60), mod(seconds, 60));
elseif (seconds < 86400)
    timeStr = sprintf("%u h  %u m  %.2f s", floor(seconds/3600), floor(mod(seconds, 3600)/60), mod(seconds, 60));
else
    timeStr = sprintf("%u d  %u h  %u m  %.2f s", floor(seconds/86400), floor(mod(seconds, 86400)/3600), floor(mod(seconds, 3600)/60), mod(seconds, 60));
end
end
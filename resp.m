function ret = resp(plotX, bpm, shift_sec)
ret = sin(2 * pi * bpm / 60 * plotX - shift_sec)
end
function ret = removeMaxAndMinThenMean(vector)
[~, i_max] = max(vector);
vector(i_max) = [];
[~, i_min] = min(vector);
vector(i_min) = [];
ret = mean(vector);
end
function ret = getFeature(array)
X = zeros(1, 18);
for j = 1 : 18
    switch ceil(j / 6)
        case 1, t = array{1};
        case 2, t = array{2};
        case 3, t = array{3};
    end
    switch rem(j, 6)
        case 1 
            X(1, j) = std(t);
        case 2 
            X(1, j) = prctile(t,25);
        % case 3, X(i, j) = kurtosis(t);
        % case 4, X(i, j) = skewness(t);
        case 3
            X(1, j) = mean(abs(t-mean(t)));
        case 4
            X(1, j) = std(diff(t, 1));
        case 5
            X(1, j) = skewness(t);
        case 0
            X(1, j) = entropy(t);
    end
end
ret = X;
end

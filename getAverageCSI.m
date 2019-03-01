function ret = getAverageCSI(array, num_subcarrier)
streamCnt = size(array, 1) / num_subcarrier;
ret = zeros(streamCnt, size(array, 2));
    for i = 1 : streamCnt
        % MEAN(X,DIM) takes the mean along the dimension DIM of X.
        ret(i, :) = mean(array((i - 1) * num_subcarrier + 1 : i * num_subcarrier, :));
    end
end
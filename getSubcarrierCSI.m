function ret = getSubcarrierCSI(array, num_subcarrier, subcarrier_index)
streamCnt = size(array, 1) / num_subcarrier;
ret = zeros(streamCnt, size(array, 2));
    for i = 1 : streamCnt
        % MEAN(X,DIM) takes the mean along the dimension DIM of X.
        ret(i, :) = array((i - 1) * num_subcarrier + subcarrier_index, :);
    end
end
function ret = convertFormat(mat, rate)
    %% why plus 1?
    %len = fix(length(mat) / rate) + 1;
    len = fix(length(mat) / rate);
    
    prefixSum = 0; cnt = 0; it = 1;
    ret = zeros(len, 2);
    for i = 1 : length(mat)
        prefixSum = prefixSum + mat(1, i);
        cnt = cnt + 1;
        if (cnt == rate)
            % if detect frequency is 1000Hz
            % we make sample propotion to 1/10, the same as 100Hz detect
            % frequency
            ret(it, 1) = it * 0.01;
            %ret(it,1) = it;
            ret(it, 2) = prefixSum / rate;
            cnt = 0;
            prefixSum = 0;
            it = it + 1;
        end
    end
end
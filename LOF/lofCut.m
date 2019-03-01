function [s, t] = lofCut(mat, d, k)
    [suspicious_index lof] = LOF(mat, k);
    threshold = 2;
    target = mat(lof>=threshold, :);
    normal = mat(lof<threshold, :);
    s = target(1, 1);
    t = target(length(target), 1);
end
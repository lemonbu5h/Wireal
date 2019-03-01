function ret = checkVitalSignsExist(p, f, filter_mode)
if filter_mode == 0
    left_id = 0;
    for i = 1 : length(f)
        if f(i) * 60 > 5 && left_id == 0
            left_id = i;
        end
        if f(i) * 60 > 30
            will_be_checked_data = p(left_id : i);
            break;
        end
    end
elseif filter_mode == 1
    left_id = 0;
    for i = 1 : length(f)
        if f(i) * 60 > 50 && left_id == 0
            left_id = i;
        end
        if f(i) * 60 > 120
            will_be_checked_data = p(left_id : i);           
            break;
        end
    end
end
ret = any(isoutlier(will_be_checked_data));
end
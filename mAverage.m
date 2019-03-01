function ret = mAverage(array, m)
    % mAverage viz.:moving average(weighted)
    %-----------------------------------------------------
    %---------------M-Previous Average O(n)----------------
    weight = 0;
    for i = 1 : m
        weight = weight + i;
    end
    weight = 1 / weight;
    for kase = 1 : length(array)
       currentPackage = array{kase};
       len = length(currentPackage);
       newPackage = zeros(1, len);
       % queue represents the sum of m-previous values
       last = 1; head = m; queue = 0; sum = 0;
       for i = last : head
            queue = queue + currentPackage(1, i);
       end
       
       cnt = 1;
       for i = last : head
           sum = sum + (cnt * currentPackage(1, i));
           cnt = cnt + 1;
           % previous m datas are invalid
           %newPackage(1, i) = currentPackage(1, i);
       end
       newPackage(1, m) = sum * weight;
       head = m + 1;
       while (head <= length(currentPackage)) 
           sum = sum + (m * currentPackage(1, head));
           sum = sum - queue;
           queue = queue + currentPackage(1, head); 
           queue = queue - currentPackage(1, last);
           newPackage(1, head) = sum * weight;
           head = head + 1;
           last = last + 1;
       end
       
       %% deleted previous m datas which aren't been handled
       %% by weighted moving average -- outdated
       % m is the second parameter of mAverage function
       %newPackage = newPackage(m:length(newPackage));
       array{kase} = newPackage;
       
    end
    ret = array;
    %-----------------------------------------------------
end
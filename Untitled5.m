% [check_adapter_name_status, result] = system(sprintf('chcp 437 && netsh interface show interface name="%s" | findstr "connected"', 'Ethernet'));    
% disp(result);
% disp(check_adapter_name_status);
% getPeaks([1,2,3], 1,0.5, 0);
a = 3;
for i = 1 : a
    if mod(i, 2) == 0
        a = a + 1;
    end
    disp(a);
end
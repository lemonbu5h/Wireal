function ret = butterFilter(rawData, leftOffset, rightOffset)
% if rawData only one struct ,dont't do filter only split it into three
error(nargchk(1, 3, nargin));

if (nargin == 1)
    datalength = length(rawData);
    left = 1;
    right = datalength;
elseif (nargin == 3)
    datalength = rightOffset - leftOffset + 1;
    left = leftOffset;
    right = rightOffset;
else
    error('No enough input arguments for butterFilter function');
end

package1 = zeros(30, datalength);
package2 = zeros(30, datalength);
package3 = zeros(30, datalength);
fs = 500; %????????

% filterdata = zeros(30,datalength);
countlack = 0;ff = 0;
amp = zeros(1, datalength);
for i = left : right
    csi_entry = rawData{i};
    csi = get_scaled_csi(csi_entry);
    [u, v, ~] = size(csi);
    % .' means thanspose 
    thr_antenna = reshape(csi, u*v, 30).';
    a_antenna = thr_antenna; 
    temp = abs(a_antenna);
    % three received data stored respectively
    package1(:, i - left + 1) = temp(:, 1);
    package2(:, i - left + 1) = temp(:, 2);
    package3(:, i - left + 1) = temp(:, 3); 
end
if datalength == 1
    ret = {package1, package2, package3};
    return;
end

% %Time = 1:8192;
Wp = 1 / (fs / 2); 
Ws = 15 / (fs / 2);
Rp = 2; 
Rs = 40;
[n, Wn] = buttord(Wp, Ws, Rp, Rs);
[b, a] = butter(n, Wn);


filterdata1 = ones(30, datalength);
for i = 1 : 30
   filterdata1(i, :) = filtfilt(b, a, package1(i, :));
end

filterdata2 = ones(30, datalength);
for i = 1 : 30
   filterdata2(i, :) = filtfilt(b, a, package2(i, :));
end

filterdata3 = ones(30, datalength);
for i = 1 : 30
   filterdata3(i, :) = filtfilt(b, a, package3(i, :));
end

ret = {filterdata1, filterdata2, filterdata3};
end
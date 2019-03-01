% CHENYU ZHANG <303223118@qq.com>
function package = adjust_CSI(rawData, Ntx, Nrx, num_subcarrier)
data_length = size(rawData, 1);
package = zeros(Ntx * Nrx * num_subcarrier, data_length);
for i = 1 : data_length
    csi = get_scaled_csi(rawData{i});
    row = 0;
    for j1 = 1 : Ntx
        for j2 = 1 : Nrx
            for j3 = 1 : num_subcarrier
                row = row + 1;
                package(row, i) = csi(j1, j2, j3);
            end
        end
    end
end
%package = db(abs(package));
package = db(package);
end
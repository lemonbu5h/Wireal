% Polished by lemonbu5h
% Added support for real time system.
%READ_BF_FILE Reads in a file of beamforming feedback logs.
function [ret, cur] = read_bf_file_real_time(fhand, cur, recvSize, Num_Tx, Num_Rx)

f = fhand;
 %% Initialize variables
% 95 = 72 + 3(2 bytes length and 1 byte code) + 20
% 72 represents the sizeof 1*1 CSI data
% More details from read_bfee.c in which calc_len = (30 * (Nrx * Ntx * 8 *
% 2 + 3) + 7) / 8.  ATTENTION!: there is a difference in / between C and Matlab)
ret = cell(ceil(recvSize / 95), 1);     % Holds the return values - 1x1 CSI is 95 bytes big, so this should be upper bound
%cur = 0;                        % Current offset into file
inner_cur = 0;
count = 0;                      % Number of records output
broken_perm = 0;                % Flag marking whether we've encountered a broken CSI yet
triangle = [1 3 6];             % What perm should sum to for 1,2,3 antennas

%% Process all entries in file
% Need 3 bytes -- 2 byte size field and 1 byte code
%while cur < (cur + recvSize - 3)
while inner_cur < recvSize - 3
    % Read size and code
    field_len = fread(f, 1, 'uint16', 0, 'ieee-be');
    code = fread(f, 1); 
    cur = cur + 3;
    inner_cur = inner_cur + 3;
    
    % If unhandled code, skip (seek over) the record and continue
    if (code == 187) % get beamforming or phy data
        bytes = fread(f, field_len - 1, 'uint8=>uint8');
        lenBytes = length(bytes);
        if (lenBytes ~= field_len - 1)
            %fread(f, -lenBytes - 3);
            fseek(f, -lenBytes - 1 - 2, 'cof');
            cur = cur - 3;
            inner_cur = inner_cur - 3;
            break;
        end
        cur = cur + field_len - 1;
        inner_cur = inner_cur + field_len - 1;
    else % skip all other info
        fseek(f, field_len - 1, 'cof');
        cur = cur + field_len - 1;
        inner_cur = inner_cur + field_len - 1;
        continue;
    end
    
    if (code == 187) %hex2dec('bb')) Beamforming matrix -- output a record
        data = read_bfee(bytes);
        if data.Ntx == Num_Tx && data.Nrx == Num_Rx
            count = count + 1;
            ret{count} = read_bfee(bytes);
        else
            fprintf('WARN ONCE: Found CSI with Wrong Ntx=%d or Wrong Nrx=%d\n', data.Ntx, data.Nrx);
            continue;
        end
        
        perm = ret{count}.perm;
        if Num_Rx == 1 % No permu  ting needed for only 1 antenna
            continue;
        end
        if sum(perm) ~= triangle(Num_Rx) % matrix does not contain default values
            if broken_perm == 0
                broken_perm = 1;
                fprintf('WARN ONCE: Found CSI with Nrx=%d and invalid perm=[%s]\n', Nrx, int2str(perm));
            end
        else
            ret{count}.csi(:,perm(1:Num_Rx),:) = ret{count}.csi(:,1:Num_Rx,:);
        end
    end
end
% At some point, received data > threshold size, but after deleting invalid
% data, the count will be 0. (More precisely, that often happens in MIMO)
if count > 0
    ret = ret(1:count);
else
    ret = cell(1, 2);
end
% %% Close file
% fclose(f);
end

%READ_BF_FILE Reads in a file of beamforming feedback logs.
%   This version uses the *C* version of read_bfee, compiled with
%   MATLAB's MEX utility.
%
% (c) 2008-2011 Daniel Halperin <dhalperi@cs.washington.edu>
%  changed by jinhaizhan
function ret = readData(t)
%% Initialize variables
% ret = cell(1);     % Holds the return values - 1x1 CSI is 95 bytes big, so this should be upper bound
broken_perm = 0;                % Flag marking whether we've encountered a broken CSI yet
triangle = [1 3 6];             % What perm should sum to for 1,2,3 antennas

%% Process all entries in file
% Need 3 bytes -- 2 byte size field and 1 byte code
    % Read size and code
%     field_len = fread(t, 1, 'uint16', 0, 'ieee-be');
    field_len = fread(t, 1, 'uint16');
    code = fread(t,1);
    
    % If unhandled code, skip (seek over) the record and continue
    if (code == 187) % get beamforming or phy data
%         bytes = fread(t, field_len-1, 'uint8=>uint8');
        bytes = uint8(fread(t, field_len-1, 'uint8'));
        if (length(bytes) ~= field_len-1)
            fprintf('bytes length not equal to real length');
            return;
        end
    else % skip all other info
        fseek(t, field_len - 1, 'cof');
    end
    
    if (code == 187) %hex2dec('bb')) Beamforming matrix -- output a record
        ret = read_bfee(bytes);
        perm = ret.perm;
        Nrx = ret.Nrx;
        if Nrx ~= 1 % No permuting needed for only 1 antenna
            if sum(perm) ~= triangle(Nrx) % matrix does not contain default values
                if broken_perm == 0
                    broken_perm = 1;
                    fprintf('WARN ONCE: Found CSI stream with Nrx=%d and invalid perm=[%s]\n', Nrx, int2str(perm));
                end
            else
                ret.csi(:,perm(1:Nrx),:) = ret.csi(:,1:Nrx,:);
            end
        end
    end
end

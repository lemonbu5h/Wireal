% CHENYU ZHANG <303223118@qq.com>
% Used for deleting invalid pack(inf value) 
function ret = interpolation_data(pack)
ret = zeros(size(pack));
row_length = size(pack, 1);
havntFoundRuler = ones(row_length);
for row = 1 : row_length
    for col = 1 : size(pack, 2)
        pack_value = pack(row, col);
        if isinf(pack_value)
            if havntFoundRuler(row)
                continue;
            else
                ret(row, col) = ruler;
            end
        else
            if havntFoundRuler(row) && col == 1
                ret(row, col) = pack_value;
                ruler = pack_value;
                havntFoundRuler(row) = false;
            elseif havntFoundRuler(row) && col ~= 1
                ret(row, 1 : col) = pack_value;
                ruler = pack_value;
                havntFoundRuler(row) = false;
            else
                ret(row, col) = pack_value;
                ruler = pack_value;
            end
        end
    end
end
% There is a situation where all elements are all equal to inf.
% We need to handle it and display some useful message.
for i = 1 : row_length
    if havntFoundRuler(i)
        ret(i, 1 : end) = 0;
        fprintf('Row %d of data is all eual to inf!', i);
    end
end
end

% --------------- Archaic edition -------------------
% for i = 1 : size(pack, 1)
%     if isinf(pack(i, 1))
%         disp('The first element is invalid!');
%         return;
%     end
% end
% By default, we assume that the previous points of pack(row, :) may be
% inf.
% for i = 1 : size(pack, 1)
%     for j = 1 : size(pack, 2)
%         pack_value = pack(i, j);
%         if ~isinf(pack_value)
%             ret(i, j) = pack_value;
%             ruler = pack_value;
%         else
%             ret(i, j) = ruler;
%         end
%     end
% end
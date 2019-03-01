function validateCorrectness(pack)
if exist('test.mat', 'file') == 0
    p = pack;
    save('test.mat', 'p');
else
    load('test.mat');
    p = [p ; pack];
    save('test.mat', 'p');
end
end
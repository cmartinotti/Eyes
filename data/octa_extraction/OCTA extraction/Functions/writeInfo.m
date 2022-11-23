%% infoVals 
% reads patient info
% input: fileName (string) = file name of image
% output: 1x3 (string) matrix
function infoVals = writeInfo(fileName)
    [~, name, ~] = fileparts(fileName);
    info = split(name);
    infoVals = info(1:3)';
end


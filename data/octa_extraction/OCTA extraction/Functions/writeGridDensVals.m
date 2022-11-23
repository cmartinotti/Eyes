%% gridDensVals
% reads grid density values 
% input: bw (bool) = black white image
%        type (int) = differentiation of scan type 
%               1.sup | 2.deep | 3.onh
%        lr (int) = left or right eye
%               1.right | 2.left
% output: 1x9 (double) matrix
function gridDensVals =  writeGridDensVals(bw, type, lr)
    % ONH has grid values located higher 
    if type == 3
        roi = [1535, 538, 285, 65];
    else
        roi = [1535, 565, 285, 60];
    end 
    OCRout = ocr(bw, roi, 'Language', 'C:\Users\verma\OneDrive - Curtin\Documents\OCTA extraction\OCTA extraction\OCTa_new\tessdata\OCTa_new.traineddata');
    OCRwords = OCRout.Words;
    if size(OCRwords,1) ~= 9
        gridDensVals = cell(1,9);
        return 
    end 
    gridDensVals = {};
    % if read value is missing decimal point then divide by 100
    if lr == 1 
        j = [1 4 7 2 5 8 3 6 9];
    else
        j = [3 6 9 2 5 8 1 4 7]; 
    end
    for i = j
        densVal = str2double(cell2mat(OCRwords(i)));
        if densVal > 99
           densVal = densVal/10; 
        end
        gridDensVals = horzcat(gridDensVals,densVal);
    end 
end 


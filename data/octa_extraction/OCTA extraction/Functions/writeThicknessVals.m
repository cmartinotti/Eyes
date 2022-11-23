%% thickVals
% reads thickness values
% input: grey (int) = greyscale image
%        type (int) = differentiation of scan type 
%               1.sup | 2.deep | 3.onh
% output: thickVals = 1x11 (double) matrix for type 1 and 3
%         location (int) = matrix with location of low confidence values
function [thickVals, location] = writeThicknessVals(grey, type)
    % use custom threshold for thickness vals
    bw = grey < 160;
    % ONH vals are ocated in different location
    if type == 3
        roi = [1766,200,43,258];
    else
        roi = [1769,156,36,233];
    end
    OCRout = ocr(bw, roi, 'Language', 'C:\Users\verma\OneDrive - Curtin\Documents\OCTA extraction\OCTA extraction\OCTa_new\tessdata\OCTa_new.traineddata');
    values = OCRout.Words;
    thickVals = values';
    location = [];
    for i = 1 : size(OCRout.WordConfidences)
        if OCRout.WordConfidences(i) < 0.55
            thickVals{i} = 'N/A';
            location = horzcat(location, i);
        end
    end
end

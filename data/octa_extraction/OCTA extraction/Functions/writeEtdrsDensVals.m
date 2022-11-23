%% etdrsDensVals
% reads etdrs density values 
% input: bw (bool) = black white image
%        type (int) = differentiation of scan type 
%               1.sup | 2.deep | 3.onh
% output: etdrsDensVals = 1x11 (double) for type 1 and 2
%                         1x13 (double) for type 3
%         location (int) = matrix with location of low confidence values
function [etdrsDensVals, location] = writeEtdrsDensVals(bw, type)
    % ONH has more etdrs values to read
    if type == 3
        roi = [1546,158,47,296];
    else
        roi = [1545,156,46,233];
    end
    OCRout = ocr(bw, roi, 'Language', 'C:\Users\verma\OneDrive - Curtin\Documents\OCTA extraction\OCTA extraction\OCTa_new\tessdata\OCTa_new.traineddata');
    OCRwords = OCRout.Words;
    location = [];
    etdrsDensVals = {};
    for j = 1 : size(OCRwords)
        densVal = str2double(cell2mat(OCRwords(j)));
        if OCRout.WordConfidences(j) < 0.55           
           etdrsDensVals = horzcat(etdrsDensVals,"N/A");
           location = horzcat(location, j);
           continue
        elseif densVal > 99
           densVal = densVal/10; 
        end
        etdrsDensVals = horzcat(etdrsDensVals,densVal);
    end 
end 

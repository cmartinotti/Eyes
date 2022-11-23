%% scanVal 
% reads scan quality
% input: grey (int) = greyscale image
% output: (int) of scan value
function scanVal = writeScanVal(grey)
    % use default OCR on greyscale image 
    roi = [1121,65,42,23];
    OCRout = ocr(grey, roi);
    scanVal = {OCRout.Words{1}(1)};
end


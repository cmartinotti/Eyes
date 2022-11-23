%% fazVals
% reads FAZ values 
% input: bw (bool) = black white image
% output: 1x3 (double) of faz values {area, perim, FD}
function fazVals = writeFazVals(bw)
    fazVals = {};
    %%%% Area
    roi = [500, 101, 51, 22];
    OCRout = ocr(bw, roi, 'Language', 'C:\Users\verma\OneDrive - Curtin\Documents\OCTA extraction\OCTA extraction\OCTa_new\tessdata\OCTa_new.traineddata');
    word = OCRout.Text;
    % replace with NaN if no values were read
    word(word == ' ') = [];
    value = str2double(word)/1000;
    fazVals = horzcat(fazVals, value);
    %%%% Perim
    roi = [651, 100, 48, 23];
    OCRout = ocr(bw, roi, 'Language', 'C:\Users\verma\OneDrive - Curtin\Documents\OCTA extraction\OCTA extraction\OCTa_new\tessdata\OCTa_new.traineddata');
    word = OCRout.Text;
    word(word == ' ') = [];
    value = str2double(word)/1000;
    fazVals = horzcat(fazVals, value);
    %%%% FD
    roi = [730, 104, 45, 20];
    OCRout = ocr(bw, roi, 'Language', 'C:\Users\verma\OneDrive - Curtin\Documents\OCTA extraction\OCTA extraction\OCTa_new\tessdata\OCTa_new.traineddata');
    word = OCRout.Text;
    word(word == ' ') = [];
    value = str2double(word)/100;
    fazVals = horzcat(fazVals, value);
end


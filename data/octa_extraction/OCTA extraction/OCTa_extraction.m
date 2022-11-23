%this program makes use of the function xlsColNum2Str() from mathworks
%exchange.
% Matt G (2020). Excel Column Number To Column Name 
% (https://www.mathworks.com/matlabcentral/fileexchange/15748-excel-column-number-to-column-name),
% MATLAB Central File Exchange. Retrieved August 14, 2020.

clear;
clc;

% retrieve parent directory name, dir object, number of patients
directory_name = uigetdir();
parent_dir = dir(directory_name);
parent_dir = parent_dir(3:end);
num_patients = size(parent_dir);

% setting up csv file parameters 
Ex_File = "OCTA_summary12.xlsx";
sheet = 1;

% create error file
fileID = fopen('error.txt','w');
%location matrix of low conf values
locationDens = {};
locationThick = {};
locationMiss = {};

% iterate through each patient in parent folder
for i = 1:num_patients(1)
   % creating patient stuct holding all image names 
    patient_folder_location = strcat(parent_dir(i).folder,'\',parent_dir(i).name);
    disp(patient_folder_location);
    patient_folder = dir(strcat(patient_folder_location,'\*.','png'));
    exRow = string(i+4);
    
    
    % --RE FAZ--
    full_file = strcat(patient_folder_location,'\', patient_folder(6).name);
    im = imread(full_file);
    grey = rgb2gray(im);
    % use lower threshold to remove connected lines
    bw = grey < 120;
    % combining and writing info, quality, faz 
    infoVal = writeInfo(patient_folder(6).name);
    scanVal = writeScanVal(grey);
    fazVal = writeFazVals(bw);
    % error checks
    if isnan(fazVal{1})
        locationMiss = horzcat(locationMiss, strcat(exRow,"E"));
    end
    if isnan(fazVal{2})
        locationMiss = horzcat(locationMiss, strcat(exRow,"F"));
    end
    if isnan(fazVal{3})
        locationMiss = horzcat(locationMiss, strcat(exRow,"G"));
    end
    re_FAZ_val = horzcat(infoVal, scanVal, fazVal);
    range = strcat("A", num2str(i + 4));
    writecell(re_FAZ_val,Ex_File, 'Sheet',1,'Range',range)
    
    
    % --RE SUP-- 
    full_file = strcat(patient_folder_location,'\', patient_folder(8).name); 
    im = imread(full_file);
    grey = rgb2gray(im);
    % using standard threshold that was used to train OCR
    bw = grey < 200;
    % combining and writing thickness, grid, etrds 
    [thickVal, location] = writeThicknessVals(grey, 1);
    if size(thickVal,2) ~= 11
       thickVal = cell(1,11);
       locationMiss = horzcat(locationMiss, strcat(exRow,"H"));
    end 
    if ~isempty(location)
        location = location + 7;
        location = xlsColNum2Str(location);
        location = cellfun(@(x) strcat(exRow,x),location,'UniformOutput',false);
        locationThick = horzcat(locationThick, location);    
    end
    gridVal = writeGridDensVals(bw, 1, 1);
    if isempty(gridVal{1})
       locationMiss = horzcat(locationMiss, strcat(exRow,"S"));
    end
    [etdrsVal, location] = writeEtdrsDensVals(bw, 1);
    if size(etdrsVal,2) ~= 11
       etdrsVal = cell(1,11);
       locationMiss = horzcat(locationMiss, strcat(exRow,"AB"));
    end 
    if ~isempty(location)
        location = location + 27;
        location = xlsColNum2Str(location);
        location = cellfun(@(x) strcat(exRow,x),location,'UniformOutput',false);
        locationDens = horzcat(locationDens, location);    
    end
    re_SUP_val = horzcat(thickVal, gridVal, etdrsVal);
    range = strcat("H", num2str(i + 4));
    writecell(re_SUP_val,Ex_File, 'Sheet',1,'Range',range)
      
    % --RE DEEP-- 
    full_file = strcat(patient_folder_location,'\', patient_folder(5).name);
    im = imread(full_file);
    grey = rgb2gray(im);
    bw = grey < 200;
    % combining and writing grid and etrds 
    gridVal = writeGridDensVals(bw, 2, 1);
    if isempty(gridVal{1})
       locationMiss = horzcat(locationMiss, strcat(exRow,"AM"));
    end
    [etdrsVal, location] = writeEtdrsDensVals(bw, 2);
    if size(etdrsVal,2) ~= 11
       etdrsVal = cell(1,11);
       locationMiss = horzcat(locationMiss, strcat(exRow,"AV"));
    end 
    if ~isempty(location)
        location = location + 47;
        location = xlsColNum2Str(location);
        location = cellfun(@(x) strcat(exRow,x),location,'UniformOutput',false);
        locationDens = horzcat(locationDens, location);   
    end
    re_DEEP_val = horzcat(gridVal, etdrsVal);
    range = strcat("AM", num2str(i + 4));
    writecell(re_DEEP_val,Ex_File, 'Sheet',1,'Range',range)
    
    % --RE ONH-- 
    full_file = strcat(patient_folder_location,'\', patient_folder(7).name);
    im = imread(full_file);
    grey = rgb2gray(im);
    bw = grey < 200;
    % combining and writing quality, grid, etdrs and thickness 
    scanVal = writeScanVal(grey);
    gridVal = writeGridDensVals(bw, 3, 1);
    if isempty(gridVal{1})
       locationMiss = horzcat(locationMiss, strcat(exRow,"BH"));
    end
    [etdrsVal, location] = writeEtdrsDensVals(bw, 3);
    if size(etdrsVal,2) ~= 13
       etdrsVal = cell(1,13);
       locationMiss = horzcat(locationMiss, strcat(exRow,"BQ"));
    end
    if ~isempty(location)
        location = location + 68;
        location = xlsColNum2Str(location);
        location = cellfun(@(x) strcat(exRow,x),location,'UniformOutput',false);
        locationDens = horzcat(locationDens, location);   
    end
    [thickVal, location] = writeThicknessVals(grey, 3);
    if size(thickVal,2) ~= 11
       thickVal = cell(1,11);
       locationMiss = horzcat(locationMiss, strcat(exRow,"CD"));
    end 
    if ~isempty(location)
        location = location + 81;
        location = xlsColNum2Str(location);
        location = cellfun(@(x) strcat(exRow,x),location,'UniformOutput',false);
        locationThick = horzcat(locationThick, location);    
    end
    re_ONH_val = horzcat(scanVal, gridVal, etdrsVal, thickVal);
    range = strcat("BG", num2str(i + 4));
    writecell(re_ONH_val,Ex_File, 'Sheet',1,'Range',range)
    
    % --LE FAZ-- 
    full_file = strcat(patient_folder_location,'\', patient_folder(2).name);
    im = imread(full_file);
    grey = rgb2gray(im);
    bw = grey < 120;
    % combining and writing info, quality, faz 
    scanVal = writeScanVal(grey);
    fazVal = writeFazVals(bw);
    if isnan(fazVal{1})
        locationMiss = horzcat(locationMiss, strcat(exRow,"CQ"));
    end
    if isnan(fazVal{2})
        locationMiss = horzcat(locationMiss, strcat(exRow,"CR"));
    end
    if isnan(fazVal{3})
        locationMiss = horzcat(locationMiss, strcat(exRow,"CS"));
    end
    le_FAZ_val = horzcat(scanVal, fazVal);
    range = strcat("CP", num2str(i + 4));
    writecell(le_FAZ_val,Ex_File, 'Sheet',1,'Range',range)


    % --LE SUP-- 
    full_file = strcat(patient_folder_location,'\', patient_folder(4).name); 
    im = imread(full_file);
    grey = rgb2gray(im);
    bw = grey < 200;
    % combining and writing thickness, grid, etrds 
    [thickVal, location] = writeThicknessVals(grey, 1);
    if size(thickVal,2) ~= 11
       thickVal = cell(1,11);
       locationMiss = horzcat(locationMiss, strcat(exRow,"CT"));
    end 
    if ~isempty(location)
        location = location + 97;
        location = xlsColNum2Str(location);
        location = cellfun(@(x) strcat(exRow,x),location,'UniformOutput',false);
        locationThick = horzcat(locationThick, location);    
    end
    gridVal = writeGridDensVals(bw, 1, 2);
    if isempty(gridVal{1})
       locationMiss = horzcat(locationMiss, strcat(exRow,"DE"));
    end  
    [etdrsVal, location] = writeEtdrsDensVals(bw, 1);
    if size(etdrsVal,2) ~= 11
       etdrsVal = cell(1,11);
       locationMiss = horzcat(locationMiss, strcat(exRow,"DN"));
    end 
    if ~isempty(location)
        location = location + 117;
        location = xlsColNum2Str(location);
        location = cellfun(@(x) strcat(exRow,x),location,'UniformOutput',false);
        locationDens = horzcat(locationDens, location);    
    end
    le_SUP_val = horzcat(thickVal, gridVal, etdrsVal);
    range = strcat("CT", num2str(i + 4));
    writecell(le_SUP_val,Ex_File, 'Sheet',1,'Range',range)

    
    % --LE DEEP-- 
    full_file = strcat(patient_folder_location,'\', patient_folder(1).name); 
    im = imread(full_file);
    grey = rgb2gray(im);
    bw = grey < 200;
    % combining and writing grid and etrds
    gridVal = writeGridDensVals(bw, 2, 2);
    if isempty(gridVal{1})
       locationMiss = horzcat(locationMiss, strcat(exRow,"DY"));
    end
    [etdrsVal, location] = writeEtdrsDensVals(bw, 2);
    if size(etdrsVal,2) ~= 11
       etdrsVal = cell(1,11);
       locationMiss = horzcat(locationMiss, strcat(exRow,"EH"));
    end
    if ~isempty(location)
        location = location + 137;
        location = xlsColNum2Str(location);
        location = cellfun(@(x) strcat(exRow,x),location,'UniformOutput',false);
        locationDens = horzcat(locationDens, location);    
    end
    le_DEEP_val = horzcat(gridVal, etdrsVal);
    range = strcat("DY", num2str(i + 4));
    writecell(le_DEEP_val,Ex_File, 'Sheet',1,'Range',range)

    
    % --LE ONH-- 
    full_file = strcat(patient_folder_location,'\', patient_folder(3).name); 
    im = imread(full_file);
    grey = rgb2gray(im);
    bw = grey < 200;
    % combining and writing quality, grid, etdrs and thickness 
    scanVal = writeScanVal(grey);
    gridVal = writeGridDensVals(bw, 3, 2);
    if isempty(gridVal{1})
       locationMiss = horzcat(locationMiss, strcat(exRow,"ET"));
    end
    [etdrsVal, location] = writeEtdrsDensVals(bw, 3);
    if size(etdrsVal,2) ~= 13
       etdrsVal = cell(1,13);
       locationMiss = horzcat(locationMiss, strcat(exRow,"FC"));
    end
    if ~isempty(location)
        location = location + 158;
        location = xlsColNum2Str(location);
        location = cellfun(@(x) strcat(exRow,x),location,'UniformOutput',false);
        locationDens = horzcat(locationDens, location);    
    end
    [thickVal, location] = writeThicknessVals(grey, 3);
    if size(thickVal,2) ~= 11
       thickVal = cell(1,11);
       locationMiss = horzcat(locationMiss, strcat(exRow,"FP"));
    end 
    if ~isempty(location)
        location = location + 171;
        location = xlsColNum2Str(location);
        location = cellfun(@(x) strcat(exRow,x),location,'UniformOutput',false);
        locationThick = horzcat(locationThick, location);    
    end
    le_ONH_val = horzcat(scanVal, gridVal, etdrsVal, thickVal);
    range = strcat("ES", num2str(i + 4));
    writecell(le_ONH_val,Ex_File, 'Sheet',1,'Range',range)
    
end

% write to then close error log
locationDens = join(string(locationDens), ', ');
locationThick = join(string(locationThick), ', ');
locationMiss = join(string(locationMiss), ', ');

fprintf(fileID, "Missing values for located at : %s\n\n", string(locationMiss));
fprintf(fileID, "N/A values for etdrs density located at : %s\n\n", string(locationDens));
fprintf(fileID, "N/A values for etdrs thickness located at : %s\n", string(locationThick));
fclose(fileID);



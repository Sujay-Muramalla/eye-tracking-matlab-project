%datafile = importdata('F:\Tobii InternsF:\Tobii Internship Project\Tobii Assignment\Eye tracking data.xlsxhip Project\Tobii Assignment\Eye tracking data.xlsx')

%T = dlmread('F:\Tobii Internship Project\Tobii Assignment\123.txt','\t',1)
%[NUM,TXT,RAW]=xlsread('F:\Tobii Internship Project\Tobii Assignment\eyetrack.xltx')

Data = readtable('F:\Tobii Internship Project\Tobii Assignment\eyetrack.xltx');

%select fixation only
ind = Data.GazeEventType == 'Fixation';



T1 = Data(rows,cols);
DataSel = Data(ind,:);

[DimRows,DimColns] = size(Data);

MaxFix = Data(DimRows,6);

TransMatrix = zeros(10);
    
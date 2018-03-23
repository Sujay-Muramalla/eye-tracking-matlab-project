% *************************************************************************
%
% GazeTransitionMatrix.m
%
% Author: Sujay Muramalla
% Institution: Technical University of Kaiserslautern, Germany
% Date: February 23rd, 2015
% Version: 1.0
% This script creates the gaze transition matrix. 
% This script is structured as follows:
% 1. Load and initialize the data: eyetrackingdata.tsv
% 2. Extract relevant columns
% 3. Initialize matrices for operations 
% 4. Extract Fixation Data
% 5. Create Fixation Mapping Matrix
% 6. Update the Gaze Transition Matrix with Transition Data
% 7. Visualize The GTM Matrix 
% *************************************************************************
clear all % clear workspace
close all % close open windows
clc % clear command window

% *************************************************************************
%
% 1. Load and initialize the data. 
%
% *************************************************************************
%This section will import files with .tsv type. The import file 
%(importfile.m)needs to be included along with this file. 
% *************************************************************************

eyetrackingdata = importfile('F:\Tobii Internship Project\Tobii Assignment\eyetracking_data.tsv');

% *************************************************************************
%
% 2. Extract relevant columns 
%
% *************************************************************************
%This section lists out all the columns necessary for the GTM 
%(Gaze Transition Matrix).Except the Fixation index, the rest
%of the columns are used for Eye Gaze fixations on the different
%features of the website.
% *************************************************************************

%Listing the index values for each feature, as well as fixation index
%The value in the parentheses is the original table column index value and
%The value outside the parenthis
%FixationIndex = 1(6)
%GazeEventType =2(8)
%AOICartHit=3(12)
%AOILoginHit=4(13)
%AOIPaymentsHit=5(14)
%AOIProduct_descriptionHit=6(15)
%AOIBasketHit=7(16)
%AOIProduct_summaryHit=8(17)
%AOIMenuHit=9(18)
%AOILogoHit=10(19)
%AOIFullPageHit=11(20)

FixInd = eyetrackingdata(:,6);
%GazeType = eyetrackingdata(:,8); %for now it is not neccessary
AOICartHit = eyetrackingdata(:,12);
AOILoginHit = eyetrackingdata(:,13);
AOIPaymentsHit = eyetrackingdata(:,14);
AOIProdDescHit = eyetrackingdata(:,15);
AOIBasketHit = eyetrackingdata(:,16);
AOIProdSummHit = eyetrackingdata(:,17);
AOIProdPicHit = eyetrackingdata(:,18);
AOIMenuHit = eyetrackingdata(:,19);
AOILogoHit = eyetrackingdata(:,20);
AOIFullHit = eyetrackingdata(:,21);

% *************************************************************************
%
% 3. Initialize matrices for operations 
%
% *************************************************************************

%make a new matrix of eye tracking data with necessary website features
EyeData = [FixInd AOICartHit AOILoginHit AOIPaymentsHit AOIProdDescHit AOIBasketHit AOIProdSummHit AOIProdPicHit AOIMenuHit AOILogoHit AOIFullHit];
%Create Temporary Data for File operations
%EyeDataTemp = EyeData(1:end,:)
%GTMTemp=zeros(size(unique(EyeDataTemp.FixationIndex),1),size(EyeDataTemp,2));
%Initialize the temporary Gaze Transition Matrix (GTM) for operations
%GTMTemp=zeros(10);
GTM=zeros(10);


% *************************************************************************
%
% 4. Extract Fixation Data
%
% *************************************************************************
%This section lists out all the columns necessary for the GTM 
%(Gaze Transition Matrix).Except the Fixation index, the rest
%of the columns are used for Eye Gaze fixations on the different
%features of the website.
% *************************************************************************
%select all the rows with fixation index greater than one, to discard
%unnecessary data
%EyeDataTemp = EyeDataTemp(EyeDataTemp.FixationIndex>=1,:);
EyeData = EyeData(EyeData.FixationIndex>=1,:);
prevJ =[];
m=1;
for i=1:size(EyeData,1)
    for j=2:size(EyeData,2)
         if ((j<11)&&(EyeData{i,j} == 1))
            if (EyeData.FixationIndex(i)>=1)
                prevJ(m) = j;
                prevFix(m)  = EyeData.FixationIndex(i);
                m=m+1;
            end
        end
    end
end

% *************************************************************************
%
% 5. Create Fixation Mapping Matrix
%
% *************************************************************************
%create a new matrix with mappings of products and fixation indices.
FIXMAP = [prevFix;prevJ];
FIXMAP = FIXMAP'
filename = 'fixationsmapping.xlsx';
xlswrite(filename,FIXMAP);



% *************************************************************************
%
% 6. Update the Gaze Transition Matrix with Transition Data
%
% *************************************************************************
previous=0;
current=0;
%GTM Updation
for x = 1:size(FIXMAP,1)
        for k=x+1:size(FIXMAP,1)
            if ((FIXMAP(x,1))<(FIXMAP(k,1)))
                %update GTM with row and column of k
                previous=FIXMAP(x,2);
                current = FIXMAP(k,2);
                if previous ~= current
                    GTM(previous,current) = GTM(previous,current)+ 1;
                end 
            end 
        end 
end 
                
% *************************************************************************
%
% 7. Visualize The GTM Matrix 
%
% *************************************************************************

%this code will give a 3D representation of the GTM
mesh(GTM)

%this code will give a grey colormap grid representation of the GTM
figure
imagesc(GTM)
colormap(flipud(gray))


% *************************************************************************
%
% -------------------End of File! Thank you-------------------------------
%
% *************************************************************************

        


        
        




    
    









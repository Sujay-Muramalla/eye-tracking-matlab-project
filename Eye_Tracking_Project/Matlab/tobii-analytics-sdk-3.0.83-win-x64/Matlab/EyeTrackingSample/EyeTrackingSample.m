%
% EyeTrackingSample
%

clc 
clear all
close all

addpath('functions');
addpath('../tetio');  

% *************************************************************************
%
% Initialization and connection to the Tobii Eye-tracker
%
% *************************************************************************
 
disp('Initializing tetio...');
tetio_init();

% Set to tracker ID to the product ID of the tracker you want to connect to.
trackerId = 'NOTSET';

%   FUNCTION "SEARCH FOR TRACKERS" IF NOTSET
if (strcmp(trackerId, 'NOTSET'))
	warning('tetio_matlab:EyeTracking', 'Variable trackerId has not been set.'); 
	disp('Browsing for trackers...');

	trackerinfo = tetio_getTrackers();
	for i = 1:size(trackerinfo,2)
		disp(trackerinfo(i).ProductId);
	end

	tetio_cleanUp();
	error('Error: the variable trackerId has not been set. Edit the EyeTrackingSample.m script and replace "NOTSET" with your tracker id (should be in the list above) before running this script again.');
end

fprintf('Connecting to tracker "%s"...\n', trackerId);
tetio_connectTracker(trackerId)
	
currentFrameRate = tetio_getFrameRate;
fprintf('Frame rate: %d Hz.\n', currentFrameRate);

% *************************************************************************
%
% Calibration of a participant
%
% *************************************************************************

SetCalibParams; 

disp('Starting TrackStatus');
% Display the track status window showing the participant's eyes (to position the participant).
TrackStatus; % Track status window will stay open until user key press.
disp('TrackStatus stopped');

disp('Starting Calibration workflow');
% Perform calibration
HandleCalibWorkflow(Calib);
disp('Calibration workflow stopped');

% *************************************************************************
%
% Display a stimulus 
%
% For the demo this simply reads and display an image.
% Any method for generation and display of stimuli availble to Matlab could
% be inserted here, for example using Psychtoolbox or Cogent. 
%
% *************************************************************************
close all;


X = imread('TobiiDots.jpg');
img=X; % Remove

figure('menuBar', 'none', 'name', 'Image Display', 'keypressfcn', 'close;');
image(img);
axis equal;

axes('Visible', 'off', 'Units', 'normalized',...
    'Position', [0 0 1 1],...
    'DrawMode','fast',...
    'NextPlot','replacechildren');

Calib.mondims = Calib.mondims1;
set(gcf,'position', [Calib.mondims.x Calib.mondims.y Calib.mondims.width Calib.mondims.height]);

xlim([1,Calib.mondims.width]); ylim([1,Calib.mondims.height]);axis ij;
set(gca,'xtick',[]);set(gca,'ytick',[]);
htext1 = text(double(0.5*Calib.mondims.width), double(0.5*Calib.mondims.height),...
    'Focus on any area of the image and we will tell you where you were looking',...
    'HorizontalAlignment','center',... 
	'BackgroundColor',[.7 .9 .7],...
    'FontSize',18);

for i = 2:-1:1
htext2 = text(double(0.5*Calib.mondims.width),double(0.6*Calib.mondims.height),...
    ['Starting in ' num2str(i) ' seconds'],...
    'HorizontalAlignment','center',... 
	'BackgroundColor',[.7 .9 .7],...
    'FontSize',18);
    pause(1);
    delete(htext2);
end
delete(htext1);

hold on;



% *************************************************************************
%
% Start tracking and plot the gaze data read from the tracker.
%
% *************************************************************************

tetio_startTracking;

% leftEyeAll = [];
% rightEyeAll = [];
% timeStampAll = [];

pauseTimeInSeconds = 0.01;
durationInSeconds = 1.5*1;

[leftEyeAll, rightEyeAll, timeStampAll] = DataCollect(durationInSeconds, pauseTimeInSeconds);

tetio_stopTracking; 
tetio_disconnectTracker; 
tetio_cleanUp;

DisplayData(leftEyeAll, rightEyeAll );


% % Save gaze data vectors to file here using e.g:
csvwrite('gazedataleft.csv', leftEyeAll);


disp('Program finished.');

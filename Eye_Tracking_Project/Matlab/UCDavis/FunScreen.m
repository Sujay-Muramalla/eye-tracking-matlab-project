% FunScreen.m
%
% Opens a window using psychtoolbox and makes the window do some fun things
%
% Origiinally written for Psychtoolbox 3 by IF 3/2007 "funky screen" 
% Adaped for matlabfun.ucsd.edu 2009, 2010, 2011, 2012, 2013, 2014 on Mac OSX APS

Screen('Preference', 'SkipSyncTests', 1); 

screenNum=0; % setting a variable, which is the screen number
flipSpd = 13; %  a flip every 13 frames

res=[800 600]; % use this in debugging pass [] to use full window

[w,rect] = Screen('OpenWindow',screenNum,0, [0 0 res(1) res(2)]);
 
monitorFlipInterval = Screen('GetFlipInterval', w);
% 1/monitorFlipInterval is the frame rate of the monitor
 
black = BlackIndex(w);
white = WhiteIndex(w);
% Returns the CLUT (color look up table index to produce black/white 
% at the current screen depth, assuming a standard color lookup table 
% for that depth. See help BlackIndex and help WhiteIndex
  

%% black Screen and wait a second
Screen('FillRect',w,black); 
Screen('Flip', w);
HideCursor;
pause(1);
 
%% make a rectangle in the middle of the screen; flip colors and size
Screen('FillRect',w,black); 
% see help by typing Screen FillRect? in command window
% when rect location is not specified, it will use defaults
vbl = Screen('Flip', w); % see help by typing Screen Flip? in command window
% this collects the time for the first flip with vertical blanking
% PTB tries to sync with vertical blanking

for i=1:10
    Screen('FillRect', w, [250 200 100], [100 150 300 350]); 
    % see help by typing Screen FillRect? in command window
    % we are defining the color and location of rectangle
    % Screen('Flip',w);
    vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval)); 
    % you can simply use Screen (w,Flip); here and it will do the same
    % thing except it will flip every frame by default so it would go faster
    % with this it will flip flipSpd (currently 13) frames after vbl
    Screen('FillRect', w, [40 190 190], [100 150 500 550]);
    %vbl=Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
    vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval)); 
end
 
%% blank the screen and wait a second
Screen('FillRect', w, black);
Screen('Flip',w);
% or vbl=Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
pause(1);

 
%% make circles flip colors & size
Screen('FillRect', w, black);
vbl=Screen('Flip', w);
for i=1:6
    Screen('FillOval', w, [0 180 60], [200 200 300 300]);
    vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
    Screen('FillOval', w, [250 20 50], [300 300 400 500]);
    vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
    % similar timing as above for FillRect
end
 
%% blank the Screen and wait a second
Screen('FillRect',w, white);
Screen('Flip',w);
% vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
pause(1);

 
%% make lines that flip colors size  & position
Screen('FillRect',w,black);
vbl = Screen('Flip', w);
for i=1:6
    Screen('DrawLine', w, [50 50 255], 300, 200, 400 ,500, 5);
    vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
    Screen('DrawLine',w, [255 255 50], 100, 500, 500 ,100, 5);
    vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
end
 
%% blank the Screen and wait a second
Screen('FillRect', w, black);
vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
tic
pause(1);

 
%% combine different kinds of stimuli
Screen('FillRect', w, black);
vbl = Screen('Flip', w);
for i=1:6
    Screen('FillRect', w, [50 190 255], [200 150 400 310]);
    Screen('DrawLine', w, [200 100 0], 300, 200, 420 ,380, 5);
    Screen('FillOval', w, [350 20 50], [250 250 400 550]);
    Screen('TextSize', w, 150);
    Screen('DrawText', w,'OMG!!', 320, 200, [50 205 105]);
    vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
    % Notice the 5 stimuli you created don't appear one by one but
    % appear all together when you Flip
    Screen('FillRect', w, [255 0 0], [100 150 400 350]);
    Screen('FillOval', w, [0 255 0], [ 200 300 400 400]);
    Screen('DrawLine', w, [255 255 0], 100, 500, 200 ,100, 5);
    Screen('DrawText', w, 'OMG!!', 70, 300, [140 50 205]);
    vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
end
 
%% blank the screen and wait a second
Screen('FillRect', w, black);
Screen('Flip', w);
pause(1);
 
Screen('CloseAll');
ShowCursor;

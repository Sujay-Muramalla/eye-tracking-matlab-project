
function disp_gabor (sd, sf, theta, offx, offy)
% This function displays a gabor of the input parameters to be displayed by
% psychtoolbox. Input standard deviation (sd), spatial frequency (sf),
% orientation angle (theta) and offset from center of screen in offx and
% offy 
Screen('Preference', 'SkipSyncTests', 1);
screenNum=0;
res=[800 600];
matsize = 200; % size of gabor

[w,rect] = Screen('OpenWindow', screenNum, 0, [0 0 res(1) res(2)]);
[xc,yc] = RectCenter(rect);

% Retrieves color codes for black and white and gray.
black = BlackIndex(w);  % Retrieves the CLUT color code for black.
white = WhiteIndex(w);  % Retrieves the CLUT color code for white.
grey = (black + white) / 2;  % Computes the CLUT color code for gray.

% Taking the absolute value of the difference between white and gray will
% help keep the grating consistent regardless of whether the CLUT color
% code for white is less or greater than the CLUT color code for black.
inc = abs (white - grey);

% prepare gabor 
gabor = prep_gabor (sd, sf, theta, matsize);
gabor = grey + inc * gabor + 1;
[gw, gh] = size (gabor); % width and height of image 
gabortex = Screen('MakeTexture', w, gabor, [], [], []);
location = [xc - gw/2 + offx, yc - gh/2 + offy, xc + gw/2 + offx, yc+ gh/2+ offy];
% rightlocation = [3*xc/2 - imgwidth/2, yc - imgheight/2, 3*xc/2 + imgwidth/2, yc+imgheight/2];

% put it on screen
Screen(w, 'FillRect', grey);
Screen(w, 'Flip');
pause(1);
Screen(w, 'FillRect', grey);
Screen (w, 'DrawTexture', gabortex, [], location);
Screen(w, 'Flip');
WaitSecs(10);
  
Screen('CloseAll');

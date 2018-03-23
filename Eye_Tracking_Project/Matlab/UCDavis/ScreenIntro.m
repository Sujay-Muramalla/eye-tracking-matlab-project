% ScreenIntro.m
% Matlabfun 2011, 2012, 2013, 2014 APS
Screen('Preference', 'SkipSyncTests', 1); 

screenNum=0; % setting a variable, which is the screen number
res=[800 600]; % another variable, which is screen resolution

[window,rect] = Screen('OpenWindow',screenNum,0, [0 0 res(1) res(2)]);

% try Screen OpenWindow? to understand syntax
% the last array is the size. If you leave blank []  it'll default to full
% screen. Now I will get a screen that runs from coordinates 0,0 (top left
% corner to coordinates that are read from res, which are 800 and 600.
% At this point we opened an off screen window and didn't do anything else.

mycolor = [75 190 190]; % set a color
myrect = [50 50 200 300]; % set a rectangle

Screen(window, 'FillRect', mycolor, myrect);
% at this point we put a rectangle of a specific color and shape on the off
% screen window. nothing is on the viewable screen yet

% See Screen Flip?

Screen(window, 'Flip'); % this will put it on the on screen window.

HideCursor; % does what it says, hides cursor

pause (5); % wait so we can see the screen for some time

Screen('CloseAll');

ShowCursor; % does what it says

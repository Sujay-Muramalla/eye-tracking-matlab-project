function playwithtextures2 ()
% Reads an image as texture and displays
% Modified for Matlabfun 2011, 2013, 2014

Screen('Preference', 'SkipSyncTests', 1); % read help
Screen('CloseAll');
myscreen=max(Screen('Screens')); 
% on a laptop this will select an external display if there is one

[w,wRect]=Screen('OpenWindow', myscreen, 0 ,[0 0 800 600]);
% open screen with screen pointer w, and dimensions wRect 

% Read in image just like usual
myimg = imread('ucsdlogo','gif'); %I'm reading it like a bitmap
% 1 bitdepth means 1 bit per pixel. no color

bgcolor = [0 0 0]; % black, you can change this easily
textcolor = [0 220 220]; % you can change this easily

% make texture, nothing happens on screen.
% this just prepares the image as texture on offscreen window w
mytex = Screen('MakeTexture', w, myimg);

% lets say we want to display the image on left side of screen or right.
[xc,yc] = RectCenter(wRect);

[imgheight, imgwidth] = size (myimg); % this is a greyscale image 
% if you have color the size of the matrix will not be the same as
% size of image bc there will be 3 times the rows representing RGB

leftlocation = round([xc/2 - imgwidth/2, yc - imgheight/2, xc/2 + imgwidth/2, yc + imgheight/2]);
rightlocation = round([3*xc/2 - imgwidth/2, yc - imgheight/2, 3*xc/2 + imgwidth/2, yc + imgheight/2]);

a = 'First, we will display this with PutImage (left side)';
b = 'Then, we will display this with DrawTexture (right side)';
Screen('TextSize', w, 20);
% these are some strings I am defining

Screen('FillRect', w, bgcolor); % make background black
Screen('Flip',w); % flip buffer
Screen('DrawText', w, a, 150, 150, textcolor);
% this will draw the text in string a at location 150, 150 
% in color textcolor
Screen('Flip',w);
WaitSecs(2); % wait 2 seconds
% 
% First present image using put image
Screen('PutImage', w, myimg, leftlocation);
% See Screen PutImage? for syntax
Screen('Flip',w);
WaitSecs(2); 


Screen('FillRect', w, bgcolor); % make background bgcolor
Screen('Flip',w);
Screen('DrawText', w, b, 150, 150, textcolor);
% this will draw the text in string b at location 150, 150 in grey color
Screen('Flip',w);
WaitSecs(2);

% Next, present image using texture
Screen('DrawTexture', w, mytex, [], rightlocation); 
% See Screen DrawTexture? for syntax

Screen('Flip',w);
WaitSecs(2);

Screen('FillRect', w, bgcolor); % make background bgcolor
Screen('Flip',w);
WaitSecs(1);

Screen('CloseAll');
end
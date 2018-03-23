function playwithtextures2 ()
% Reads an image as texture and displays
% Modified for Matlabfun 2011, 2013, 2104

% We want to display the image centered on the left half 
% and the right half of the screen. Need to do some 
% geometry to get it centered

% Note, we are not centering text exactly
% Default text OS dependent or you can set it

Screen('Preference', 'SkipSyncTests', 1); % read help
Screen('CloseAll');
myscreen=max(Screen('Screens')); 
% select an external display if there is one

[w,wRect]=Screen('OpenWindow', myscreen, 0 ,[0 0 800 600]);
% open screen with screen pointer w, and dimensions wRect 

% Read in image just like usual
myimg = imread('sungod','jpg'); 
% This is a color image and its size is 160x160 pixels
% myimg in MATLAB will be 160x160x3, with 3 being the color 
% dimension (RGB)

bgcolor = [0 80 150]; % you can change this easily
textcolor = [230 230 0]; % you can change this easily
% make texture, nothing happens on screen.
% this just prepares the image as texture on offscreen window w
mytex = Screen('MakeTexture', w, myimg);

% lets say we want to display the image on left side of screen or right.
[xc,yc] = RectCenter(wRect); % see help RectCenter

% we know image size but we should write soft code and get it from myimg
imgheight =  size (myimg, 1); % first dimension
imgwidth = size (myimg, 2); % second dimension

leftlocation = round([xc/2 - imgwidth/2, yc - imgheight/2, xc/2 + imgwidth/2, yc + imgheight/2]);
rightlocation = round([3*xc/2 - imgwidth/2, yc - imgheight/2, 3*xc/2 + imgwidth/2, yc + imgheight/2]);

a = 'First, we will display this with PutImage (left side)';
b = 'Now, we will display this with DrawTexture (right side)';
c = 'New, we will display both locations and say goodbye!';
Screen('TextSize', w, 20);
% these are some strings I am defining, and I am also defining text size
% this time

Screen('FillRect', w, bgcolor); % make background bgcolor
Screen('Flip',w); % flip buffer
WaitSecs (0.3);
Screen('DrawText', w, a, 150, 150, textcolor);
% this will draw the text in string a at location 150, 150 
% in color textcolor
Screen('Flip',w);% this will actually put text on screen
WaitSecs(2); % wait 2 seconds
% 
% First present image using put image
Screen('PutImage', w, myimg, leftlocation);
% See Screen PutImage? for syntax
Screen('Flip',w);
WaitSecs(2); 


Screen('FillRect', w, bgcolor); % make background bgcolor
Screen('Flip',w);
WaitSecs (0.3);
Screen('DrawText', w, b, 150, 150, textcolor);
% this will draw the text in string b at location 150, 150 in grey color
Screen('Flip',w); % this will actually put text on screen
WaitSecs(2);

% Next, present image using texture
Screen('DrawTexture', w, mytex, [], rightlocation); 
% See Screen DrawTexture? for syntax
Screen('Flip',w);
WaitSecs(2);

Screen('FillRect', w, bgcolor); % make background bgcolor
Screen('Flip',w); 
WaitSecs (0.3);
Screen('DrawText', w, c, 150, 150, textcolor);
Screen('Flip',w); % this will actually put text on screen
WaitSecs(2);


Screen('FillRect', w, bgcolor); % make background bgcolor
Screen('DrawText', w, ' G O O D B Y E !!', 325, 150, textcolor);
Screen('DrawTexture', w, mytex, [], leftlocation); 
Screen('DrawTexture', w, mytex, [], rightlocation); 
Screen('Flip',w); % this will actually put text on screen
WaitSecs(3);

Screen('CloseAll');
end
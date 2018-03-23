function playwithtextures
% Reads an image as texture and displays
% Modified for Matlabfun 2011, 2012, 2013, 2014

Screen('Preference', 'SkipSyncTests', 1); % read help
Screen('CloseAll');
% myscreen=max(Screen('Screens')); 
% on a laptop this will select an external display if there is one

[w,wRect]=Screen('OpenWindow', 0, [100 100 100],[0 0 800 600]);
% open screen with screen pointer w, and dimensions wRect (which is
% specified with [0 0 800 600]

% Read in image just like usual
myimg = imread('ucsdlogo','gif');

% make texture, nothing happens on screen.
% this just prepares the image as texture on offscreen window w
mytex = Screen('MakeTexture', w, myimg); 


a = 'First, we will display this with PutImage';
b = 'Then, we will display this with DrawTexture';
% these are some strings I am defining


Screen('FillRect', w, [200 200 200]); % make background lighter grey
Screen('Flip',w); % flip buffer
Screen('DrawText', w, a, 150, 150, [0 0 0]);
% this will draw the text in string a at location 150, 150 in black ([0 0 0]
Screen('Flip',w);
WaitSecs(2); % wait 2 seconds

% First present image using put image
Screen('PutImage', w, myimg);
Screen('Flip',w);
WaitSecs(5); 

Screen('FillRect', w, [150 150 150]); % make background med grey
Screen('Flip',w);
Screen('DrawText', w, b, 150, 150, [0 0 0]);
% this will draw the text in string b at location 150, 150 
Screen('Flip',w);
WaitSecs(2);

% Next, present the image with texture
Screen('DrawTexture', w, mytex); 
Screen('Flip',w);
WaitSecs(5);

Screen('FillRect', w, [100 100 100]); % make background darker grey
Screen('Flip',w);
WaitSecs(2);

Screen('CloseAll');
end
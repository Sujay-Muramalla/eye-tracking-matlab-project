function playwithtextures
% Reads an image and displays is using both PutImage and texture 
% Modified for Matlabfun 2011, 2012, 2013, 2014 
% A.P. Saygin

Screen('Preference', 'SkipSyncTests', 1); % read help
Screen('CloseAll');
% myscreen=max(Screen('Screens')); 
% on a laptop this will select an external display if there is one
% if there is no added monitor the max will be 0. 
% this just makes portable code, is not necessary at the moment

[w,wRect] = Screen('OpenWindow', 0, [100 100 100],[0 0 800 600]);
% open screen with screen pointer w, and dimensions wRect (which is
% specified with [0 0 800 600]
% what color will the background be?

% read in image just like usual
myimg = imread('sungod','jpg');

% make texture, nothing happens on screen.
% this just prepares the image as texture on offscreen window w
mytex = Screen('MakeTexture', w, myimg); 


a = 'First, we will display this with PutImage';
b = 'Then, we will display this with DrawTexture';
% these are some strings we are defining


Screen('FillRect', w, [200 200 200]); 
% changing background color (what color?)
Screen('Flip',w); % flip buffer, will make the bg color apply to screen
Screen('DrawText', w, a, 300, 250, [0 0 0]);
% this will draw the text in string a at location 300, 250 in black ([0 0 0]
% since we didn't set Text Size, it will use defaults
Screen('Flip',w); % this will actually put text on screen
WaitSecs(3); % wait 3 seconds
% WaitSecs is like pause, but it's a PTB function so timing is better
% More on PTB timing next week

% First present image using put image
Screen('PutImage', w, myimg);
Screen('Flip',w);
WaitSecs(4); 

Screen('FillRect', w, [150 150 150]); 
% changing background color (what color?)
Screen('Flip',w); % flip buffer, will make the bg color apply to screen
Screen('DrawText', w, b, 290, 250, [0 0 0]);
% this will draw the text in string b at location 190,250 
Screen('Flip',w); % this will actually put text on screen
WaitSecs(3); % wait 2 seconds

% Next, present the image with texture
Screen('DrawTexture', w, mytex); % prepare texture from image
Screen('Flip', w); %show the texture on screen
WaitSecs(4);

Screen('FillRect', w, [100 100 100]); 
% changing background color (what color?)
Screen('Flip',w);
WaitSecs(2);

Screen('CloseAll');
end
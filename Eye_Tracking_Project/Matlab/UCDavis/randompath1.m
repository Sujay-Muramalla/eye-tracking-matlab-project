% From Keith Schneider's Notes
% Adapted for Matlab Fun 2010, AP Saygin
% 2011, 2012, 2013, 2014
% Can you understand this program?

[w,rect]=screen('OpenWindow',0,[0 0 0], [0 0 800 600]);
r = 50; % radius of circle (pixels)
v = 20; % velocity (pixels per frame)
x = rect(3)/2;
y = rect(4)/2; 
keypress = 0; %initialize

% KbCheck within the while loop below checks keyboard status
% its output reports keyboard state (and more see help KbCheck

while(~keypress) % draw circle in new position unless key is pressed
    
    Screen('FillOval',w,[255 255 255],[x-r,y-r,x+r,y+r]);
    Screen('Flip',w);
    % compute new position
    x = x+v*(2*rand-1); y = y+v*(2*rand-1);
    % check borders to make sure circle won't go beyond screen
    x = max(x,r); % left border
    x = min(x,rect(3)-r); % right border
    y = max(y,r); % top border
    y = min(y,rect(4)-r); % bottom border
    % check whether any keys are pressed
    keypress = KbCheck;
end

Screen('Close',w);
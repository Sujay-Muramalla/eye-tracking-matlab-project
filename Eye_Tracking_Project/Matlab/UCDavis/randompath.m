s% From Keith Schneider's Notes
% Adapted for Matlab Fun 2010,2011,2012,2013

[w,rect]=Screen('OpenWindow',0,[0 0 0], [0 0 800 600]);
r=50; % radius of circle (pixels)
v=10; % velocity (pixels per frame)
x=rect(3)/2;
y=rect(4)/2; kdown=0;

while(~kdown) % draw circle in new position until a key is pressed
    Screen('FillOval',w,[255 255 255],[x-r,y-r,x+r,y+r]);
    Screen('Flip',w);
    % compute new position
    x=x+v*(2*rand-1); y=y+v*(2*rand-1);
    % check borders
    x=max(x,r); % left border
    x=min(x,rect(3)-r); % right border
    y=max(y,r); % top border
    y=min(y,rect(4)-r); % bottom border
    % check whether any keys are depressed
    kdown=KbCheck;
end
Screen('Close',w);
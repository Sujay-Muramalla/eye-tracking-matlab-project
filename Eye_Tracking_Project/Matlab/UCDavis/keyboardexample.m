
KbName('UnifyKeyNames');

clear all;
Starttime = GetSecs; % get the current time
Waittime = 10;

% just to load KbCheck once cos it's slow first time.
% This also makes sure it's cleared.
while KbCheck; end % Wait until all keys are released.

while GetSecs < Starttime + Waittime
    [keyIsDown, secs, keycode] = KbCheck;
    
    if keyIsDown % if a key is pressed
        response = KbName(keycode); % get the key
        resptime = secs - Starttime; % calculate the response time
        break  % break once a key is pressed
    else % if no key is pressed
        response = 'none'; 
        resptime = 999;
    end
end;
while KbCheck; end

% Check the response and display message accordingly
if response == 'none'
    disp (['no key press was detected in ' num2str(Waittime) ' seconds']);
else
    disp (['the key was: ' response]);
    disp (['the time was: ' num2str(resptime)]);
end

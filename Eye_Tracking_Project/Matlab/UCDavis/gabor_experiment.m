function data = gabor_experiment
% call prep_gabor.m to prepare the gabor and display it similar to what we
% did in display_gabor.m
KbName('UnifyKeyNames');
Screen('Preference', 'SkipSyncTests', 1);
screenNum=0;
res=[800 600]; % screen resolution
matsize = 200; % size of gabor
offx = 0; offy = 0;
Trialtime = 2;
isi = 0.5;  % inter stimulus interval
matsize = 200; % size of gabor

disp ['Welcome to the gabor experiment'];
data.Subnum = input (['Enter subject number: ']);
data.Date = date;
data.Data = [];

[fid message] = fopen('gabor_output.txt', 'w');
if fid == -1
    fprintf('Couldn''t open output file.\n%s\n', message);
end
fprintf(fid, 'Subject no: %d\n', data.Subnum);                                                    
fprintf(fid, 'trial\tresponse\tRT\r\n');

% experiment has the following trial types:
% gabor with sd = 0.1, sf = 10, theta = 5;
% gabor with sd = 0.1, sf = 10, theta = 355;
% gabor with sd = 0.1, sf = 16, theta = 5;
% gabor with sd = 0.1, sf = 16, theta = 355;
rng('shuffle');
trials = [0.1 10 5; 0.1 10 355; 0.1 16 5; 0.1 16 355];
% trials has the order sd, sf, theta

offsets = [100 100; -120 100; 100 -50; -100 -100];
% offsets has the order x offset and y offset

% creating a new random order of the trials
trials = Shuffle(trials); offsets = Shuffle(offsets);
% Shuffle is a psychtoolbox function, read help
% trials and offsets are randomized separately - make sure this is what
% you want in your experiment or else keep them together

while KbCheck; end


[w,rect] = Screen('OpenWindow', screenNum, 0, [0 0 res(1) res(2)]);
% define window w and open screen
[xc,yc] = RectCenter(rect);

black = BlackIndex(w);  % Retrieves the CLUT color code for black.
white = WhiteIndex(w);  % Retrieves the CLUT color code for white.
grey = (black + white) / 2;  % Computes the CLUT color code for gray.
inc = abs (white - grey);

for t = 1: size (trials,1)
    
    gabor = prep_gabor (trials (t,1), trials (t,2), trials(t,3), matsize);
    gabor = grey + inc * gabor + 1;
    [gw, gh] = size (gabor); % width and height of gabor
    gabortex = Screen('MakeTexture', w, gabor, [], [], []); % make gabor texture
    location = [xc - gw/2 + offsets(t,1), yc - gh/2 + offsets(t,2), xc + gw/2 + offsets(t,1), yc+ gh/2+ offsets(t,2)];
    
    % Get key press
    Starttime = GetSecs;
    while GetSecs < Starttime + Trialtime
        % put it on screen        
        Screen(w, 'FillRect', grey);
        Screen (w, 'DrawTexture', gabortex, [], location); % draw gabor
        Screen(w, 'Flip'); % display gabor by flipping
        [keyIsDown, secs, keycode] = KbCheck;
        if keyIsDown
            response = KbName(keycode);
            resptime = secs - Starttime;
            break
        else
            response = 'none';
            resptime = 999;
        end
        
    end
    
    % record reaction time data into data
    data.Data = [data.Data resptime];
    
    % Write the trial information to the text file
    fprintf (fid, '%d\t%s\t%f\r\n', t, response, resptime);
    
    Screen(w, 'FillRect', grey);
    Screen(w, 'Flip');
    WaitSecs(isi);
end


Screen('CloseAll');

end

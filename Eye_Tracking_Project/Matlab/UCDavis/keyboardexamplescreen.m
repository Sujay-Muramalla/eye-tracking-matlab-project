function [RTArray ResponseArray AccuracyArray] = keyboardexamplescreen
% Reads an image as texture and displays
% Modified for Matlabfun 2011, 2012, 2013
% Subject should press u for upright and d for inverted


Screen('Preference', 'SkipSyncTests', 1); % read help
Screen('CloseAll');
% open screen with screen pointer w, and dimensions wRect (which is
% specified with [0 0 800 600]
[w,wRect]=Screen('OpenWindow', 0, [100 100 100],[0 0 800 600]);

while KbCheck; end

% Open a text file to write the results
[fid message] = fopen('image_output.txt', 'w');
if fid == -1
    fprintf('Couldn''t open output file.\n%s\n', message);
end
                                                    
fprintf (fid, 'trial\tresponse\tRT\taccuracy\r\n');

trials = [1,1,1,2,2,2]; % if 1, present uprighted image; if 2, present inverted image
randtrials = shuffle(trials); % randomize the order of trials

RTArray = []; % an array that holds the reaction times
ResponseArray = []; % an array that holds the key responses
AccuracyArray = []; % an array that holds the accuracy

Waittime = 2; % stimulus duration
isi = 0.5; % wait this amount of time in between trials
% Read in image just like usual
myimg = imread('ucsdlogo','gif');

myimg_inverted = flipud(myimg); % inverted image matrix


% make textures, nothing happens on screen.
% this just prepares the images as textures on offscreen window w
mytex_upright = Screen('MakeTexture', w, myimg); 
mytex_inverted = Screen('MakeTexture', w, myimg_inverted); 

Screen('FillRect', w, [150 150 150]); % make background med grey
Screen('Flip',w);


% Present the trials one by one
for i = 1:length(randtrials)
        
    if randtrials(i) == 1 % if the trial type is upright
        % Present the image with upright texture
        Screen('DrawTexture', w, mytex_upright);
        Screen('Flip',w);
        
    elseif randtrials(i) == 2 % if the trial type is inverted
        % Present the image with inverted texture
        Screen('DrawTexture', w, mytex_inverted);
        Screen('Flip',w);
        
    end
    
    % Get key response and reaction time
    
    Starttime = GetSecs;
    % keyIsDown = 0;
    while GetSecs < Starttime + Waittime 
        [keyIsDown, secs, keycode] = KbCheck;
        
        if keyIsDown
            response = KbName(keycode); % get the key
            resptime = secs - Starttime; % calculate the response time
            break;  % break once a key is pressed
        else
            % response = ' '; % this will put a blank space in array if no response
            response = '_'; % this will put an underscore in char array if no response
            resptime = 999; % this will put RT as 999 sec if no response
        end
        
    end
    while KbCheck; end
    

    % The above will get out of keyboard checking mode when subject responds the first time
    % If you want the trial to end (i.e., image disappears and get ready
    % for next trial, this is what you want.
    % If you want to hold the stimulus there until the maximum wait time is
    % reached, then you need to uncomment the following if statement which
    % will hold the image up until the time elapses
    % 
    
%     if resptime < Waittime
%          WaitSecs(Waittime - resptime);
%     end;

    % Record the reaction time data and response to the respective arrays
    % for this trial
    RTArray = [RTArray resptime];
    ResponseArray = [ResponseArray response];
    
    % Check accuracy
    if randtrials(i) == 1 % if it is a upright trial
        if response == 'u' % if the response is 'u'
            acc = 1; % it is correct
        else
            acc = 0; % it is not correct
        end
    elseif randtrials(i) == 2 % if it is an inverted trials
        if response == 'd' % if the response is d
            acc = 1; % it is correct
        else
            acc = 0; % it is not correct
        end
    end
    
    % Record the accuracy in accuracy array
    AccuracyArray = [AccuracyArray acc];
    
    % Write the trial information to the text file
    fprintf (fid, '%d\t%s\t%f\t%d\r\n', i, response, resptime, acc);
    % make blank screen and wait isi amount of time 
    Screen('FillRect', w, [150 150 150]); % make med grey screen
    Screen('Flip',w);
    WaitSecs (isi);
end

fprintf (fid, '\r\n');
fclose (fid);

Screen('CloseAll');
end
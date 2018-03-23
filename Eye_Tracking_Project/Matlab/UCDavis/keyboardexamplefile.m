function keyboardexamplefile()

KbName('UnifyKeyNames');
clear all;
FlushEvents; % release all events in the event queue
while KbCheck; end

% open a file to write the outputs
[outfile message] = fopen('keyboarddata.txt', 'a'); 
if outfile == -1
    fprintf('Couldn''t open output file.\n%s\n', message);
end

% Get user input
subjectname = input('Subject name: ', 's');
subjectnumber = input('Subject number: ');
ntrials = 5;
thedate = date;

fprintf(outfile, '\n\nSubject name: %s\nSubject number: %d\nDate: %s\r\n\r\n',...
        subjectname, subjectnumber, thedate);
fprintf(outfile,'Trial\tResponse\tRT (seconds)\r\n');

disp (['Welcome ' subjectname '.']); 

ExpStartTime = GetSecs; % Start of experiment.
WaitTime = 3; % how long to wait for keypress.

% Go through each trial one by one
for trial = 1:ntrials
    disp (['This is trial ' num2str(trial) ' of ' num2str(ntrials)]);
    disp (['Please press a key within ' num2str(WaitTime) ' seconds']);
    disp ([' ']);
  
    TrialStartTime = GetSecs; % now get the start time for this trial with GetSecs;
    % you're setting a timer each time you use GetSecs
    keyIsDown = 0;
    FlushEvents; % release all events in the event queue
    while KbCheck; end
    
    while GetSecs < TrialStartTime + WaitTime
        [keyIsDown, secs, keycode] = KbCheck;
        % this will keep checking the keyboard until Waittime is exceeded

        if keyIsDown % if a key is pressed figure out what it was and when it was
            response = KbName(keycode);
            resptime = secs - TrialStartTime; %Calculate RT from TrialStartTime
            keyIsDown = 0;     FlushEvents;
            break 
            % this means you break out of the while loop 
            % so you don't wait any longer after key is pressed
        else % if no key was pressed
            response = 'none';
            resptime = 999;
            FlushEvents;
        end
    keyIsDown = 0;     
    FlushEvents;
    end;
    while KbCheck; end 
    % Check the response and display message accordingly
    if response == 'none' % if no key was pressed
        disp (['No key press was detected in ' num2str(WaitTime) ' seconds']);
    else % if a key was pressed, display the response and reaction time
        disp (['The key was: ' response]);
        disp (['The time was: ' num2str(resptime)]);
    end
    
    % write into text file
    fprintf(outfile, '%d\t%s\t%f\r\n', trial, response, resptime);
   
end; % for loop

disp (['The experiment took ' num2str(GetSecs-ExpStartTime) ' seconds']);
fclose(outfile); %finish by closing file



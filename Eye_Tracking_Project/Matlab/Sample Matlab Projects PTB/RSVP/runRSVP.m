function runRSVP(subID)
%% PTB Experiment template: Rapid serial visual presentation (RSVP)
%
% To run, call this function with the id code for your subject, eg:
% runRSVP('ke1');
%
% See instructions file for more detailed instructions. 
%
% Krista Ehinger, December 2012

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up the experiment (don't modify this section)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

settingsRSVP; % Load all the settings from the file
rand('state', sum(100*clock)); % Initialize the random number generator

% Keyboard setup
KbName('UnifyKeyNames');
KbCheckList = [KbName('space'),KbName('ESCAPE')];
for i = 1:length(responseKeys)
    KbCheckList = [KbName(responseKeys{i}),KbCheckList];
end
RestrictKeysForKbCheck(KbCheckList);

% Screen setup
clear screen
whichScreen = max(Screen('Screens'));
[window1, rect] = Screen('Openwindow',whichScreen,backgroundColor,[],[],2);
slack = Screen('GetFlipInterval', window1)/2;
W=rect(RectRight); % screen width
H=rect(RectBottom); % screen height
Screen(window1,'FillRect',backgroundColor);
Screen('Flip', window1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up stimuli lists and results file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the image folders for the experiment
imageFolder = 'images';
f = dir(imageFolder);
folderList = {};
for i = 3:length(f)
    if exist([imageFolder '/' f(i).name],'dir')
        folderList = vertcat(folderList,f(i).name);
    end
end
nTrials = length(folderList);

% Load the text file (optional)
if strcmp(textFile,'none') == 0
    showTextItem = 1;
    textItems = importdata(textFile);
else
    showTextItem = 0;
end

% Set up the output file
resultsFolder = 'results';
outputfile = fopen([resultsFolder '/resultfile_' num2str(subID) '.txt'],'a');
fprintf(outputfile, 'subID\t imageSet\t trial\t textItem\t imageOrder\t response\t RT\n');

% Randomize the trial list
randomizedTrials = randperm(nTrials);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start screen
Screen('DrawText',window1,'Press the space bar to begin', (W/2-300), (H/2), textColor);
Screen('Flip',window1)
% Wait for subject to press spacebar
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('space'))==1
        break
    end
end

% Run experimental trials
for t = randomizedTrials
    
    % Get list of images in folder
    fileList = dir([imageFolder '/' folderList{t} '/*.' imageFormat]);
    nImages = length(fileList);
    
    % Determine image order for RSVP stream
    if randomizeStreams
        order = randperm(nImages);
    else
        order = 1:nImages;
    end
    % Save the ordering as a string for the results file
    orderStr = int2str(order(1));
    for i = 2:nImages
        orderStr = [orderStr '-' int2str(order(i))];
    end
    
    % Load images into texture array
    for i = 1:nImages
        img = imread([imageFolder '/' folderList{t} '/' fileList(order(i)).name]);
        imageDisplay(i) = Screen('MakeTexture', window1, img);
    
        % Calculate image position (center of the screen)
        imageSize = size(img);
        pos(i,:) = [(W-imageSize(2))/2 (H-imageSize(1))/2 (W+imageSize(2))/2 (H+imageSize(1))/2];
    end

    % Screen priority
    Priority(MaxPriority(window1));
    Priority(2);
    
    % Show fixation cross
    fixationDuration = 0.5; % Length of fixation in seconds
    drawCross(window1,W,H);
    tFixation = Screen('Flip', window1);

    % Blank screen
    Screen(window1, 'FillRect', backgroundColor);
    Screen('Flip', window1, tFixation + fixationDuration - slack,0);

    % Show text item (optional)
    if showTextItem
        % Display text
        textString = textItems{t};
        textDuration = 2; % How long to show text (in seconds)
        Screen('DrawText', window1, textString, (W/2-200), (H/2), textColor);
        tTextdisplay = Screen('Flip', window1);

        % Blank screen
        Screen(window1, 'FillRect', backgroundColor);
        Screen('Flip', window1, tTextdisplay + textDuration - slack,0);
    else
        textString = '';
    end
    
    % Show the image stream
    Screen(window1, 'FillRect', backgroundColor);
    Screen('DrawTexture', window1, imageDisplay(1), [], pos(1,:));
    flipTime = Screen('Flip', window1);
    for i = 2:nImages
        Screen(window1, 'FillRect', backgroundColor);
        Screen('DrawTexture', window1, imageDisplay(i), [], pos(i,:));
        flipTime = Screen('Flip', window1, flipTime + imageDuration - slack,0);
    end
    Screen(window1, 'FillRect', backgroundColor);
    startTime = Screen('Flip', window1, flipTime + imageDuration - slack,0);
    
    % Get keypress response
    rt = 0;
    resp = 0;
    while GetSecs - startTime < trialTimeout
        [keyIsDown,secs,keyCode] = KbCheck;
        respTime = GetSecs;
        pressedKeys = find(keyCode);
                
        % ESC key quits the experiment
        if keyCode(KbName('ESCAPE')) == 1
            clear all
            close all
            sca
            return;
        end
        
        % Check for response keys
        if ~isempty(pressedKeys)
            for i = 1:length(responseKeys)
                if KbName(responseKeys{i}) == pressedKeys(1)
                    resp = responseKeys{i};
                    rt = respTime - startTime;
                end
            end
        end
        
        % Exit loop once a response is recorded
        if rt > 0
            break;
        end

    end

    % Blank screen
    Screen(window1, 'FillRect', backgroundColor);
    Screen('Flip', window1, tFixation + fixationDuration - slack,0);

    % Save results to file
    fprintf(outputfile, '%s\t %s\t %d\t %s\t %s\t %s\t %f\n',...
        subID, imageFolder, t, textString, orderStr, resp, rt);
    
    % Clear texture array
    for i = 1:nImages
        Screen('Close',imageDisplay(i));
    end
    
    % Provide a short break after a certain number of trials
    if mod(t,breakAfterTrials) == 0
        Screen('DrawText',window1,'Break time. Press space bar when you''re ready to continue', (W/2-300), (H/2), textColor);
        Screen('Flip',window1)
        % Wait for subject to press spacebar
        while 1
            [keyIsDown,secs,keyCode] = KbCheck;
            if keyCode(KbName('space')) == 1
                break
            end
        end
    else
        
        % Pause between trials
        if timeBetweenTrials == 0
            while 1 % Wait for space
                [keyIsDown,secs,keyCode] = KbCheck;
                if keyCode(KbName('space'))==1
                    break
                end
            end
        else
            WaitSecs(timeBetweenTrials);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End the experiment (don't change anything in this section)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RestrictKeysForKbCheck([]);
fclose(outputfile);
Screen(window1,'Close');
close all
sca;
return

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfunctions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Draw a fixation cross (overlapping horizontal and vertical bar)
function drawCross(window,W,H)
    barLength = 16; % in pixels
    barWidth = 2; % in pixels
    barColor = 0.5; % number from 0 (black) to 1 (white) 
    Screen('FillRect', window, barColor,[ (W-barLength)/2 (H-barWidth)/2 (W+barLength)/2 (H+barWidth)/2]);
    Screen('FillRect', window, barColor ,[ (W-barWidth)/2 (H-barLength)/2 (W+barWidth)/2 (H+barLength)/2]);
end
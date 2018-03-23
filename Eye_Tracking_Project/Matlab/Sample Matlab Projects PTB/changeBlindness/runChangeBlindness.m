function runChangeBlindness(subID)
%% PTB experiment template: Change blindness
%
% To run, call this function with the id code for your subject and the
% name of the folder that contains your stimuli, eg:
% runChangeBlindness('ke1','imagesB');
%
% See instructions file for more detailed instructions. 
%
% Krista Ehinger, December 2012

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up the experiment (don't modify this section)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

settingsChangeBlindness; % Load all the settings from the file
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

% Get the image files for the experiment
imageFolder = 'images';
imgList = dir(fullfile(imageFolder,['*.' imageFormat]));
imgList = {imgList(:).name};
if mod(length(imgList),2) == 0
    nTrials = length(imgList)/2;
else
    disp(['ERROR: Found ' int2str(length(imgList)) ' images, but this experiment requires that the number of images be even.']);
    return
end

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
fprintf(outputfile, 'subID\t imageCondition\t trial\t textItem\t imageFile1\t imageFile2\t response\t RT\n');

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
    
    % Load image
    file1 = imgList{(t*2)-1};
    file2 = imgList{(t*2)};
    img1 = imread(fullfile(imageFolder,file1));
    img2 = imread(fullfile(imageFolder,file2));
    img3 = 127*ones(size(img1));
    
    imageDisplay1 = Screen('MakeTexture', window1, img1);
    imageDisplay2 = Screen('MakeTexture', window1, img2);
    blankDisplay = Screen('MakeTexture', window1, img3);
    
    % Calculate image position (center of the screen)
    imageSize = size(img1);
    pos = [(W-imageSize(2))/2 (H-imageSize(1))/2 (W+imageSize(2))/2 (H+imageSize(1))/2];

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
    
    % Show the images
    rt = 0;
    resp = 0;
    currentDisplay = 1;
    dur = imageDuration;
    Screen(window1, 'FillRect', backgroundColor);
    Screen('DrawTexture', window1, imageDisplay1, [], pos);
    startTime = Screen('Flip', window1); % Start of trial
    flickerTime = startTime;
    Screen('DrawTexture', window1, blankDisplay, [], pos);
    
    % Get keypress response
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
        
        % Flicker
        if GetSecs - flickerTime >= dur
            switch currentDisplay
                % Image 1
                case 1
                    flickerTime = Screen('Flip', window1);
                    Screen('DrawTexture', window1, imageDisplay2, [], pos);
                    currentDisplay = 2;
                    dur = blankDuration;
                % Blank
                case 2
                    flickerTime = Screen('Flip', window1);
                    Screen('DrawTexture', window1, blankDisplay, [], pos);
                    currentDisplay = 3;
                    dur = imageDuration;
                % Image 2
                case 3
                    flickerTime = Screen('Flip', window1);
                    Screen('DrawTexture', window1, imageDisplay1, [], pos);
                    currentDisplay = 4;
                    dur = blankDuration;
                % Blank
                case 4
                    flickerTime = Screen('Flip', window1);
                    Screen('DrawTexture', window1, blankDisplay, [], pos);
                    currentDisplay = 1;
                    dur = imageDuration;
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
    fprintf(outputfile, '%s\t %s\t %d\t %s\t %s\t %s\t %s\t %f\n',...
        subID, imageFolder, t, textString, file1, file2, resp, rt);
    
    % Clear textures
    Screen(imageDisplay1,'Close');
    Screen(imageDisplay2,'Close');
    Screen(blankDisplay,'Close');
    
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
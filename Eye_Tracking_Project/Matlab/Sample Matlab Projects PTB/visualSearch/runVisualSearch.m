function runVisualSearch(subID)
%% PTB experiment template: Visual search
%
% To run, call this function with the id code for your subject, eg:
% runVisualSearch('ke1');
%
% See instructions file for more detailed instructions. 
%
% Krista Ehinger, December 2012

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up the experiment (don't modify this section)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

settingsVisualSearch; % Load all the settings from the file
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
imTarg = imread([imageFolder '/' imageTarget]);
imDist = imread([imageFolder '/' imageDistractor]);

% Set up the trials
nSetSizes = length(setSize);
setSize = repmat(setSize,[nTrials 1]);
% Randomly assign half of trials to be target-present; rest will be
% target-absent
targetPresent = zeros(size(setSize));
for i = 1:nSetSizes
    t = zeros(nTrials,1);
    t(1:round(nTrials/2)) = 1;
    t = t(randperm(nTrials));
    targetPresent(:,i) = t;
end
% Randomly interleave trials or present them in blocks
if blockSetSize == 1
    randomizedTrials = 1:(nTrials*nSetSizes);
else
    randomizedTrials = randperm(nTrials*nSetSizes);
end

% Set up the output file
resultsFolder = 'results';
outputfile = fopen([resultsFolder '/resultfile_' num2str(subID) '.txt'],'a');
fprintf(outputfile, 'subID\t trial\t setSize\t targetPresent\t response\t RT\n');

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
for n = 1:length(randomizedTrials)
    t = randomizedTrials(n);
    
    % Make search display
    img = makeSearchDisplay(imTarg,imDist,setSize(t),targetPresent(t),rotateDistractor,backgroundColor,H,W);
    imageDisplay = Screen('MakeTexture', window1, img);
    
    % Calculate image position (center of the screen)
    imageSize = size(img);
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

    % Show the search display
    Screen(window1, 'FillRect', backgroundColor);
    Screen('DrawTexture', window1, imageDisplay, [], pos);
    startTime = Screen('Flip', window1); % Start of trial
    
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
    fprintf(outputfile, '%s\t %d\t %d\t %d\t %s\t %f\n',...
        subID, n, setSize(t), targetPresent(t), resp, rt);
    
    % Clear textures
    Screen(imageDisplay,'Close');
    
    % Provide a short break after a certain number of trials
    if mod(n,breakAfterTrials) == 0
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
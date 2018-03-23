%% Settings for image sequence experiment
% Change these to suit your experiment!

% Target and distractor images (these should be in the "images" folder)
%imageTarget = 'red.png';
%imageDistractor = 'green.png';
imageTarget = 'T.png';
imageDistractor = 'L.png';

% Randomly rotate distractors? (1 = yes, 0 = no)
rotateDistractor = 1;

% Set size (number of items to display in each search display). You can run
% several different set sizes in the same experiment.
setSize = [4 8 12];

% Number of trials per set size
nTrials = 20;

% Block trials by set size? If 1, each set size will be run in a separate
% block (in the order they are listed in setSize). If 0, set sizes will be
% randomly interleaved.
blockSetSize = 0;

% Response keys (optional; for no subject response use empty list)
responseKeys = {'p','a'};
%responseKeys = {};

% Number of trials to show before a break (for no breaks, choose a number
% greater than the number of trials in your experiment)
breakAfterTrials = 100;

% Background color: choose a number from 0 (black) to 255 (white)
backgroundColor = 0;

% Text color: choose a number from 0 (black) to 255 (white)
textColor = 255;

% How long to wait (in seconds) for subject response before the trial times out
trialTimeout = 12;

% How long to pause in between trials (if 0, the experiment will wait for
% the subject to press a key before every trial)
timeBetweenTrials = 1;
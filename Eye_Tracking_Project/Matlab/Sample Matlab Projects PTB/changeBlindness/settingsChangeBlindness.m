%% Settings for change blindness experiment
% Change these to suit your experiment!

% Path to text file input (optional; for no text input set to 'none')
textFile = 'textfile.txt';
%textFile = 'none';

% Response keys (optional; for no subject response use empty list)
responseKeys = {'space'};
%responseKeys = {};

% Number of trials to show before a break (for no breaks, choose a number
% greater than the number of trials in your experiment)
breakAfterTrials = 100;

% Background color: choose a number from 0 (black) to 255 (white)
backgroundColor = 255;

% Text color: choose a number from 0 (black) to 255 (white)
textColor = 0;

% Image format of the image files in this experiment (eg, jpg, gif, png, bmp)
imageFormat = 'jpg';

% How long (in seconds) the image should appear on screen during flicker
imageDuration = 1.000;

% Duration (in seconds) of the blanks between the images during flicker
blankDuration = 0.250;

% How long to wait (in seconds) for subject response before the trial times out
trialTimeout = 10;

% How long to pause in between trials (if 0, the experiment will wait for
% the subject to press a key before every trial)
timeBetweenTrials = 0;
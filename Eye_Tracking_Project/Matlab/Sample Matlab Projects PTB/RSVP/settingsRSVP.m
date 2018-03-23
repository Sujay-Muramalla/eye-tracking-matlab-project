%% Settings for image sequence experiment
% Change these to suit your experiment!

% Path to text file input (optional; for no text input set to 'none')
textFile = 'targetPrompt.txt';
%textFile = 'none';

% Response keys (optional; for no subject response use empty list)
responseKeys = {'y','n'};
%responseKeys = {};

% Randomize RSVP streams: set this to 1 if you want to show the images in
% each folder in a random order during the RSVP stream. Set to 0 if you
% want to show the images in file order (to make sure the ordering is
% correct, you should name your images with numbers: "image001",
% "image002", etc.).
randomizeStreams = 1;
%randomizeStreams = 0;

% How long (in seconds) each image in the RSVP sequence will stay on screen
imageDuration = 0.100;

% Number of trials to show before a break (for no breaks, choose a number
% greater than the number of trials in your experiment)
breakAfterTrials = 100;

% Background color: choose a number from 0 (black) to 255 (white)
backgroundColor = 255;

% Text color: choose a number from 0 (black) to 255 (white)
textColor = 0;

% Image format of the image files in this experiment (eg, jpg, gif, png, bmp)
imageFormat = 'jpg';

% How long to wait (in seconds) for subject response before the trial times out
trialTimeout = 5;

% How long to pause in between trials (if 0, the experiment will wait for
% the subject to press a key before every trial)
timeBetweenTrials = 1;
% PlayTones.m 
% plays a scale using the command sound

% written by Geoff Boynton May 2007
% Modified for Lecture: April 13, 2010
% Modified 2011
% Modified 2012
% A.P. Saygin, UCSD Cogsci
% MatFun Course http://www.matlabfun.com
% Goals: Play with sounds, play the scale
% Also: tic and toc and while loops
 
freqC = 278.4375;  % Frequency of midle C (Hz) (called 'C4')
numNotes = 13;       % number of notes (13 notes = one octave (C to C))
noteNumbers = [0:(numNotes-1)];
whiteKeys = [1,3,5,6,8,10,12,13]; %white keys on piano (key of C)
 
% Frequencies of subsequent notes on the 12-tone scale
% are obtained by multiplying the previous frequency by
% 2^(1/12).
% Example: freqD = freqC*(2^(1/12))
% freqE = freqD*(2^(1/12)) = freqC*(2^(2/12))...
 
multFac = 2.^(noteNumbers/12);
allFreqs = freqC*multFac;
 
% Now, let's make sound waves containing tones for each note
dur = .8;  %duration of the tone (Seconds)
ISI = 1; % time between the start of each note (Seconds)
silence = ISI - dur;
sampRate = 8192; % Sampling rate for sound (Hz)
nTimeSamples = dur*sampRate; % number of time samples
t = linspace(0,dur,nTimeSamples);

% plays the scale
% tic
for i=1:length(whiteKeys)
  freq = allFreqs(whiteKeys(i));
   y= sin(2*pi*freq*t);
 
  sound(y,sampRate);
  
  pause (silence);
%   while toc<i*ISI
%      ; % just keeping time
%   end % end of the while loop
end  

% toc



% now lets do stereo 
% you will need headphones to hear this
% we control the left and right speakers separately 
% using a n x 2 (two column) matrix instead of a simple 1d vector
% In sndmat below, column 1 are for the left speaker
% column 2 for the right speaker.

for i=1:length(whiteKeys)
    freq = allFreqs(whiteKeys(i));
    y= sin(2*pi*freq*t)';
    sndmat=repmat(y, 1, 2); % we simply replicated y
    if mod(i, 2)==0 % see help mod, basically odd or even
        sndmat(:, 1)=0; % zero one channel
    else
        sndmat(:, 2)=0; % zero the other channel
    end
    sound(sndmat, sampRate);
    pause (silence);
%     while toc<i*ISI
%         ;
%     end % end of the while loop
end




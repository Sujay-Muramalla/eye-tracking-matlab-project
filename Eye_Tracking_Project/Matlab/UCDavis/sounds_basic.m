% Basic sounds lecture
% A.P. Saygin, UCSD Cogsci
% MatFun Course
% Adapted from Fine & Boynton

% Sounds are also vectors

clear all;
beep; % makes a beep
pause;

% The simplest sounds are pure tones represented by functions of the form
% f(t) = A sin(2 pi freq t)
% where t is time 
% This family of functions has two parameters that we can hear freq, the frequency
% and A, the amplitude.

% 

freq=500;                    % frequency of the tone (Hz)
dur=1.5;                     % duration of the tone (seconds)
sampRate=44000; % sampling rate
nTimeSamples = dur*sampRate; %number of time samples

t = linspace(0,dur,nTimeSamples); 
y = sin(2*pi*freq*t);
sound(y,sampRate);  % this plays the sound
% try help sound
pause;
amp = 2;
y2 = amp * y;
sound(y2,sampRate);  % this plays the sound
pause;


noise = 0.2 * randn(1,sampRate);
sound (noise, sampRate);

% lets look at the wave we created
indexToPlot = t<10/1000; % select only the first 10 msec
plot(t(indexToPlot), y(indexToPlot));
xlabel('Time (sec)')
ylabel('Amplitude');
pause;

% Now lets make it louder
ramp=linspace(0, 1, nTimeSamples); % create ramp
figure(2);
plot(t, ramp, 'r');
xlabel('Time (sec)');
ylabel('amplitude envelope'); 
% We just plotted the ramp now
% multiply the sinusoid (sound wave)
% by the ramp to increase the volume over time

y3=y.*ramp;
sound(y3, sampRate);

% plotting again
plot(t(1:round(nTimeSamples/20)), y3(1:round(nTimeSamples/20)));
xlabel('time');
ylabel('amplitude');
pause;



% amplitude modulation
freq = 500; % carrier frequency
fm = 5;  % modulation frequency
f_c = sin(2*pi*freq*t);
f_m = sin(2*pi*fm*t);
f_mod = [f_c .* f_m];
sound(f_mod,sampRate);



% ALTERNATIVE:
% Psychtoolbox can also do sounds
% 
% Beep=sin([1:400]); 
% rate=22254; 
% for n=1:10 
% snd('Play',Beep,rate); 
% pause((length(Beep)/rate)); 
% snd('Close'); 
% end



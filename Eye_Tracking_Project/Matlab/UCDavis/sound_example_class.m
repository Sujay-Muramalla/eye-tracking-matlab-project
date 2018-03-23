freq=500;    % frequency of the tone (Hz)
dur=1.5;     % duration of the tone (seconds)
sampRate=44000;    % sampling rate
nTimeSamples = dur*sampRate;   % number of time samples
t = linspace(0,dur,nTimeSamples); 
y = sin(2*pi*freq*t);
sound(y,sampRate);  

amp = 2;
y2 = amp * y;

sound(y2, sampRate);  

noise = 0.2 * randn(1,sampRate);

sound (noise, sampRate);

indexToPlot = t<10/1000;  % select only the first 10 msec

plot(t(indexToPlot), y2(indexToPlot));

xlabel('Time (sec)')
ylabel('Amplitude');

ramp = linspace(0, 1, nTimeSamples); % create ramp
figure(2);
plot(t, ramp, 'r');
xlabel('Time (sec)');
ylabel('amplitude envelope'); 

y3=y.*ramp; % create new sound with pure tone and amplitude ramp
sound(y3, sampRate);

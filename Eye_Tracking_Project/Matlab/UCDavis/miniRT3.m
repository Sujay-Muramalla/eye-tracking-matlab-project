function [data] = miniRT3(numtrials)
%  miniRT - Small program that collects reaction time
%  Write a function miniRT that inputs number of trials, numtrials and outputs an array that contains user?s reaction time for those trials (i.e., 1 x numtrials array).
%  The program displays to user:
%  I say NOW, you press a button as fast as you can OK? (Press a key to continue)
%  Then for each trial, the program displays: Now!
%  The program waits for a key press, calculates reaction time
%  and adds it to the array

data = [];
disp (' I say NOW, you press a button as fast as you can OK? (Press a key to continue)');
pause;

for i = 1:numtrials
    % tic;
    disp ('NOW!!');
    tic;
    pause;
    rt = toc;
    % data = [data, rt];
    data(i) = rt;
    disp ('Press any key to continue');
    pause;
end


end


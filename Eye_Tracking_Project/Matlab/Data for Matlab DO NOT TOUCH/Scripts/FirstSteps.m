% Comment what you do
% Data analyses with matlab

% Tina Weis (November 2014)

% clear 
clear all % clear workspace
close all % close open windows
clc % clear command window


% define datapath as string
datapath = 'F:\Lab Rotations\Methods\Data for Matlab DO NOT TOUCH\Data\';

% load subjects
load([datapath 'subjects.mat']);

% VARIABLES
% define stimuli
stimuli = {'oneLL','oneL','oneH','oneHH',...
           'twoLL','twoL','twoH','twoHH',...
           'eightLL','eightL','eightH','eightHH',...
           'nineLL','nineL','nineH','nineHH'};

compatibility = {'compatible','incompatible'};  
task = {'number', 'pitch', 'parity'};

% load data for participant 1 into workspace
load([datapath subjects{1} filesep 'R_' subjects{1} '.mat']);

for ta = 1:length(task)
    
    for comp = 1:length(compatibility)

        % define variable rt_raw (column 4) for participant 1 (number - compatible)
        rt_raw = R.(task{ta}).(compatibility{comp})(:,4);

        % calculate median
        subjects_median = median(rt_raw);
        subjects_std = std(rt_raw);

        % sort stimuli
        [code, order] = sort(R.(task{ta}).(compatibility{comp})(:,1));
        rt_sort = rt_raw(order);

        % define correct
        correct_raw = R.(task{ta}).(compatibility{comp})(:,5);
        correct_sort = correct_raw(order);


        for st = 1:length(stimuli)

            rt(st,:) = rt_sort(st*10-9:st*10)';
            correct(st,:) = correct_raw(st*10-9:st*10)';

            n = 1; s = 1; o = 1; e = 1; c = 1;

            for r = 1:size(rt,2)

                if rt(st,r) < 0

                    RT.(task{ta}).(compatibility{comp}).nobutton.(stimuli{st})(n) = rt(st,r);
                    n = n+1;

                elseif rt(st,r) < 100

                    RT.(task{ta}).(compatibility{comp}).shorter.(stimuli{st})(s) = rt(st,r);
                    s = s+1;

                elseif rt(st,r) < subjects_median - 2*subjects_std || ...
                        rt(st,r) > subjects_median + 2*subjects_std

                    RT.(task{ta}).(compatibility{comp}).outlier.(stimuli{st})(o) = rt(st,r);
                    o = o+1;

                else
                    if correct(st,r) == 0

                        RT.(task{ta}).(compatibility{comp}).errors.(stimuli{st})(e) = rt(st,r);
                        e = e+1;

                    else

                        RT.(task{ta}).(compatibility{comp}).correct.(stimuli{st})(c) = rt(st,r);
                        c = c+1;

                    end;

                end;

            end;

        end;

    end;
    
end;

save([datapath filesep subjects{1} filesep 'RT_' subjects{1} '.mat'], 'RT');






















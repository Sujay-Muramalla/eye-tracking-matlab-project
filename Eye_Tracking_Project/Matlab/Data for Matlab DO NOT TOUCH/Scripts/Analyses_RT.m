% Analyses of SNARC and SPARC

% Tina Weis (November 2014)

clear all
close all
clc

% define datapath as string
datapath = 'F:\Lab Rotations\Methods\Data for Matlab DO NOT TOUCH\Data\';

% load subjects
load([datapath 'subjects.mat']);

% Variable
compatibility = {'compatible', 'incompatible'};
task = {'number', 'pitch', 'parity'};
conditions = {'small_low', 'small_high', 'large_low', 'large_high'};
position = [1,2,5,6; 3,4,7,8; 9,10,13,14; 11,12,15,16];
SNSP = {'SNcSPc', 'SNcSPi', 'SNiSPc', 'SNiSPi'};



for t = 1:length(task)
    
    left = zeros(length(subjects),16);
    right = zeros(length(subjects),16);
    
    for sub = 1:length(subjects)

        % load data of participant 1
        load([datapath filesep subjects{sub} filesep 'RT_' subjects{sub} '.mat']);

        

        for c = 1:length(compatibility)

            if c == 1 % compatible 

                if t == 1 % if number task
                    
                    left(sub, 1:8) = RT.(task{t}).(compatibility{c}).mean(1:8);
                    right(sub, 9:16) = RT.(task{t}).(compatibility{c}).mean(9:16);
                    
                elseif t == 2 % if pitch task
                    
                    left(sub, [1:2 5:6 9:10 13:14]) = RT.(task{t}).(compatibility{c}).mean([1:2 5:6 9:10 13:14]);
                    right(sub, [3:4 7:8 11:12 15:16]) = RT.(task{t}).(compatibility{c}).mean([3:4 7:8 11:12 15:16]); 
                    
                else % parity task
                    
                    left(sub, [1:4 13:16]) = RT.(task{t}).(compatibility{c}).mean([1:4 13:16]);
                    right(sub, 5:12) = RT.(task{t}).(compatibility{c}).mean(5:12);
                    
                end;

            else % incompatible 
                
                if t == 1 % if number task

                    left(sub, 9:16) = RT.(task{t}).(compatibility{c}).mean(9:16);
                    right(sub, 1:8) = RT.(task{t}).(compatibility{c}).mean(1:8);
                
                elseif t == 2
                    
                    left(sub, [3:4 7:8 11:12 15:16]) = RT.(task{t}).(compatibility{c}).mean([3:4 7:8 11:12 15:16]);
                    right(sub, [1:2 5:6 9:10 13:14]) = RT.(task{t}).(compatibility{c}).mean([1:2 5:6 9:10 13:14]);
                    
                else % parity task
                    
                    left(sub, 5:12) = RT.(task{t}).(compatibility{c}).mean(5:12);
                    right(sub, [1:4 13:16]) = RT.(task{t}).(compatibility{c}).mean([1:4 13:16]);
                    
                end;

            end;

        end;

    end;
    
    S.(task{t}) = struct('left', struct('all', left), 'right', struct('all', right));    
    
    for i = 1:length(conditions)  

        S.(task{t}).left.(conditions{i}) = mean(S.(task{t}).left.all(:,position(i,:)),2);
        S.(task{t}).right.(conditions{i}) = mean(S.(task{t}).right.all(:,position(i,:)),2);
        
   	end;
    
    for s = 1:length(SNSP) 
        
        S.(task{t}).(SNSP{s}).left = S.(task{t}).left.(conditions{s});
        S.(task{t}).(SNSP{s}).right = S.(task{t}).right.(conditions{5-s});  
        S.(task{t}).(SNSP{s}).both = mean([S.(task{t}).left.(conditions{s}) S.(task{t}).right.(conditions{s})],2); 
        S.(task{t}).(SNSP{s}).mean = mean(S.(task{t}).(SNSP{s}).both); 
        S.(task{t}).(SNSP{s}).std = std(S.(task{t}).(SNSP{s}).both)/sqrt(length(subjects)); 
        
    end;        

    % Plot the results
    h = figure;
    errorbar([1,2],[S.(task{t}).SNcSPc.mean, S.(task{t}).SNiSPc.mean],...
                   [S.(task{t}).SNcSPc.std, S.(task{t}).SNiSPc.std],'r-','Linewidth', 2);
    hold on;
    errorbar([1,2],[S.(task{t}).SNcSPi.mean, S.(task{t}).SNiSPi.mean],...
                   [S.(task{t}).SNcSPi.std, S.(task{t}).SNiSPi.std],'b-','Linewidth', 2);
    xlabel('SNARC compatibility'); 
    ylabel('mean RT [ms]');     
    title(['SNARC SPARC ' task{t}]);     
    ylim([500 800]);
    legend('SPc', 'SPi', 'Location', 'SouthEast');
    set(gca, 'xtick', [1,2], 'xTickLabel', 'SNc|SNi');
    saveas(h, [datapath task{t} '.jpg']);      
    
end;

save([datapath filesep 'S.mat'], 'S')

Table_SPSS = [S.number.SNcSPc.both S.number.SNcSPi.both S.number.SNiSPc.both S.number.SNiSPi.both...
              S.pitch.SNcSPc.both S.pitch.SNcSPi.both S.pitch.SNiSPc.both S.pitch.SNiSPi.both...
              S.parity.SNcSPc.both S.parity.SNcSPi.both S.parity.SNiSPc.both S.parity.SNiSPi.both];
          
          
          
          
          
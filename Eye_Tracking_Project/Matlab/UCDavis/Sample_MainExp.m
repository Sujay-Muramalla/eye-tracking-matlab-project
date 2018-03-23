function Sample_MainExp(subjectList, numTrials)
%% Sample_MainExp
% INPUTS:
%   subjectList: a cell array of strings each cell is a subjects' name
%   numTrials: the number of trials each subject goes through

% No outputs
% resulting data structure MyData is saved to disk directly

%initialized data stricture MyData
MyData = struct();

%initialize substructure MyData.Data
MyData.Data = struct();

%% collect data
%for each subject record their informaiton and collect their data
for iSubs = 1:length(subjectList)
    
    %subject name
    MyData(iSubs).Name = subjectList{iSubs}; % cell array so use { }
    
    %generate trials for this subejct, number of trials equals numTrials
    currentTrials = randi(40,[1,numTrials]);
    
    % use CollectData function to collect data from current subject
    [currentResponses, currentRT] = CollectData(subjectList{iSubs}, currentTrials);
    
    % save data into structure
    MyData(iSubs).Data.response = currentResponses;
    MyData(iSubs).Data.RT = currentRT;
    
    %% calculate accuracy and analyze data
    % go through each trial and check if response was correct
    % get correct RTs to caculate correct RT reaction times.
    correctRTs = [];
    for iTrial = length(currentTrials)
        % if divisible by 5 and response is 1 then the response is correct
        if mod(currentTrials(iTrial),5) == 0
            if currentResponses(iTrial) == 1
                % record correct trial
                MyData(iSubs).Data.Accuracy(iTrial) = 1;
                % add correct RT to array
                correctRTs = [CorrectRTs currentRT(iTrial)];
            else
                % incorrect response
                MyData(iSubs).Data.Accuracy(iTrial) = 0;
            end
        else
            % for non divisible trials
            if currentResponses(iTrial) == 0
                % record correct trial
                MyData(iSubs).Data.Accuracy(iTrial) = 1;
                % add correct RT to array
                correctRTs = [CorrectRTs currentRT(iTrial)];
                
            else
                % incorrect response
                MyData(iSubs).Data.Accuracy(iTrial) = 0;
            end
        end
    end
    % calculate correct RT average, make sure there are more than 0 RTs to
    % consider or else a divide by zero error will occur
    
    if ~isempty(correctRTs) % you can use length(correctRTs) > 0 as well
       MyData(iSubs).Data.MeanCorrect = mean(correctRTs);
    else
        % record -1 otherwise
        MyData(iSubs).Data.MeanCorrect = -1;
    end
end

%% save data
save('Sample_MyDataHW4.mat', 'MyData'); % only save the MyData structure
end

function [responses, RTs]= CollectData(subjectName, trialList)
% INPUTS:
%   subjectName: a string containing the name of a single subject
%   trialList: a list of number that the subject will see
% OUTPUTS:
%   responses: array of subject responses to the task
%   RTs: array of subject reaction times to the task

% initialize output arrays to -99 and -999
responses = ones(1,length(trialList))*-99;
RTs = ones(1,length(trialList))*-999;
% display message and instructions
disp(['hello ', subjectName, '. You will be shown a number and your task is to determine if the number is divisible by 5.']);
disp('Enter 1 if the number is divisible by 5, Enter 0 if it is not');
disp('Press any key to start');
fprintf('\n');
pause;
% start experiment
for iTrial = 1:length(trialList)
    %ask questions
    %start timer
    tic
    % get initial response
    currentResponse = input(['Is ' num2str(trialList(iTrial)) ' divisible by 5? Enter 1 for yes, 0 for no.']);
    % check if resposne is valid, keep asking question until valid repsonse
    while currentResponse ~= 0 && currentResponse ~= 1
        currentResponse = input('Invalid response, try agian');
    end
    % save data into arrays
    RTs(iTrial) = toc;
    responses(iTrial) = currentResponse;
    fprintf('\n');
end
end
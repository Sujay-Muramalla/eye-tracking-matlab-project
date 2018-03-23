function [leftEyeAll, rightEyeAll, timeStampAll] = DataCollect(durationInSeconds, pauseTimeInSeconds )
%DATACOLLECT collects the data from the eye tracker
% This function is used to collect the incoming data from the tobii eye tracker.
%     
%     Input:
%         durationInSeconds: duration of the desired acquisition.
%         pauseTimeInSeconds: time lapse between readings.
%     
%     Output:
%         leftEyeAll: EyeArray corresponding to the left eye.
%         rightEyeAll:EyeArray corresponding to the right eye.
%         timeStampAll : timestamp of the readings

leftEyeAll = [];
rightEyeAll = [];
timeStampAll = [];

for i = 1:(durationInSeconds/pauseTimeInSeconds)
    
    pause(pauseTimeInSeconds);
    
    [lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;
    
    if isempty(lefteye)
        continue;
    end
    
    numGazeData = size(lefteye, 2);
    leftEyeAll = vertcat(leftEyeAll, lefteye(:, 1:numGazeData));
    rightEyeAll = vertcat(rightEyeAll, righteye(:, 1:numGazeData));
    timeStampAll = vertcat(timeStampAll, timestamp(:,1));
    
end


end


function DisplayData(leftEyeAll, rightEyeAll)
% DISPLAYDATA plots the read 
% This function is used to plot the read 2D gaze data on the stimulus
% that was previously displayed
%     
%     Input:
%         leftEyeAll: left eye gaze data information read previously.
%         rightEyeAll: right eye gaze data information read previously.

rightGazePoint2d.x = rightEyeAll(:,7);
rightGazePoint2d.y = rightEyeAll(:,8);
leftGazePoint2d.x = leftEyeAll(:,7);
leftGazePoint2d.y = leftEyeAll(:,8);
gaze.x = mean([rightGazePoint2d.x, leftGazePoint2d.x],2);
gaze.y = mean([rightGazePoint2d.y, leftGazePoint2d.y],2);

hold on; 
scatter (gaze.x,gaze.y,50,'filled');
axis([0 1 0 1]); 

end


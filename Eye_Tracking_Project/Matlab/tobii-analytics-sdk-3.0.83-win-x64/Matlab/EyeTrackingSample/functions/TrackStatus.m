%TrackStatus script. Will show one dot per eye when the user positions himself in front of the eye tracker.
%Use spacebar (or any other) key press to continue. 
%   Input: 
%         Calib: The calib config structure (see SetCalibParams)

	keyPressFcn = 'breakLoopFlag=1;';

	figh = figure('menuBar', 'none', 'name', 'Track status window - Position your eyes in front of the eye tracker (Press any key to continue)', 'Color', Calib.bkcolor, 'Renderer', 'Painters', 'keypressfcn', keyPressFcn, 'NumberTitle', 'off');
	axes('Visible', 'off', 'Units', 'normalize', 'Position', [0 0 1 1], 'DrawMode', 'fast', 'NextPlot', 'replacechildren');

	if (Calib.resize)
		figloc.x =  Calib.mondims1.x + Calib.mondims1.width/4;
		figloc.y =  Calib.mondims1.y + Calib.mondims1.height/4;
		figloc.width =  Calib.mondims1.width/2;
		figloc.height =  Calib.mondims1.height/2;
	else
		figloc =  Calib.mondims1;
	end
	 
	set(figh,'position',[figloc.x figloc.y figloc.width figloc.height]);

	Calib.mondims = figloc;
	xlim([1,Calib.mondims.width]); 
	ylim([1,Calib.mondims.height]);

	axis ij; % specify "matrix" axes mode. Coordinate system origin is at upper left corner.
	set(gca,'xtick',[]);
	set(gca,'ytick',[]);
	set(gca, 'XDir', 'reverse');

	breakLoopFlag=0;
	updateFrequencyInHz = 60;

	tetio_startTracking;

	validLeftEyePos = 0;
	validRightEyePos = 0;

	while(~breakLoopFlag)
		
		pause(1/updateFrequencyInHz);
		
		[lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;

		if isempty(lefteye)
			continue;
		end

		GazeData = ParseGazeData(lefteye(end,:), righteye(end,:)); % Parse last gaze data.
		
		if  (GazeData.left_validity==0) && (GazeData.right_validity==0)
			eyeDotColor = 'green';
		else
			eyeDotColor = 'yellow';
		end

		if validLeftEyePos
			delete(leftEyePlot);
		end
		if validRightEyePos
			delete(rightEyePlot);
		end
		
		validLeftEyePos = GazeData.left_validity <= 2;
		validRightEyePos = GazeData.right_validity < 2; % If both left and right validities are 2 then only draw left.

		if validLeftEyePos || validRightEyePos
			if validLeftEyePos
				leftEyePlot = plot(GazeData.left_eye_position_3d_relative.x * Calib.mondims.width, GazeData.left_eye_position_3d_relative.y * Calib.mondims.height, 'o', 'MarkerEdgeColor', eyeDotColor, 'MarkerFaceColor', eyeDotColor, 'MarkerSize', Calib.TrackStat);
				hold on;
			end

			if validRightEyePos
				rightEyePlot = plot(GazeData.right_eye_position_3d_relative.x * Calib.mondims.width, GazeData.right_eye_position_3d_relative.y * Calib.mondims.height, 'o', 'MarkerEdgeColor', eyeDotColor, 'MarkerFaceColor', eyeDotColor, 'MarkerSize', Calib.TrackStat);
				hold on;
			end

			drawnow;		
		end
		
	end

	close ALL;
	tetio_stopTracking;

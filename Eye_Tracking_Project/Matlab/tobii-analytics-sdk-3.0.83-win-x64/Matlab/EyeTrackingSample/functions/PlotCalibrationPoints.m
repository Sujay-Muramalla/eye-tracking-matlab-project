function pts = PlotCalibrationPoints(calibPlot, Calib, mOrder)
%PLOTCALIBRATIONPOINTS plots the calibration data for a calibration session
%   Input: 
%         calibPlot: The calibration plot data, specifying the input and output calibration data   
%         Calib: The calib config structure (see SetCalibParams)         
%         mOrder: Vector containing indices indicating the order in which to show the calibration points, [1 2 3 4 5] to show five calibration points in order or [1 3 5 2 4] to show them in different order.
%     
%   Output: 
%         pts: The list of points used for calibration. These could be
%         further used for the analysis such as the variance, mean etc.

    close all
    NumCalibPoints = length(calibPlot)/8;
    if (NumCalibPoints == 0 )
        pts = [];
        disp('no calib point found');
        return;
    end
    clear OrignalPoints
    clear pts
    j = 1;
    for i = 1:NumCalibPoints
        OrignalPoints(i,:) = [calibPlot(j) calibPlot(j+1)];
        j = j+8;
    end
    lp = unique(OrignalPoints,'rows');
    for i = 1:length(lp)
        pts(i).origs = lp(i,:);
        pts(i).point =[];
    end
    j = 1;
    for i = 1:NumCalibPoints
        for k = 1:length(lp)
            if ((calibPlot(j)==pts(k).origs(1)) && (calibPlot(j+1)==pts(k).origs(2)))
                n = size(pts(k).point,2);
                pts(k).point(n+1).validity = [calibPlot(j+4) calibPlot(j+7)];
                pts(k).point(n+1).left= [calibPlot(j+2) calibPlot(j+3)];
                pts(k).point(n+1).right= [calibPlot(j+5) calibPlot(j+6)];
            end
        end
        j = j+8;
    end
	

	figh = figure('menuBar','none','name','Calib res - Press any key to continue','Color', Calib.bkcolor,'Renderer', 'Painters','keypressfcn','close;');
	axes('Visible', 'off', 'Units', 'normalize','Position', [0 0 1 1],'DrawMode','fast','NextPlot','replacechildren');
	if (Calib.resize)
		 figloc.x =  Calib.mondims1.x + Calib.mondims1.width/4;
		 figloc.y =  Calib.mondims1.y + Calib.mondims1.height/4;
		 figloc.width =  Calib.mondims1.width/2;
		 figloc.height =  Calib.mondims1.height/2;
	else
		figloc  =  Calib.mondims1;
	end
	set(figh,'position',[figloc.x figloc.y figloc.width figloc.height]);
	Calib.mondims = figloc;
	xlim([1,Calib.mondims.width]); 
	ylim([1,Calib.mondims.height]);axis ij;
	set(gca,'xtick',[]);set(gca,'ytick',[]);
	hold on
	for i = 1:length(lp)
		plot(Calib.mondims.width*pts(i).origs(1),...
			Calib.mondims.height*pts(i).origs(2),...
			'o','MarkerEdgeColor',Calib.fgcolor,'MarkerFaceColor',Calib.fgcolor,'MarkerSize',Calib.SmallMark);
		
		for n = 1:Calib.points.n
			a = strcmp(num2str(pts(i).origs(1)),num2str(Calib.points.x(mOrder(n))));
			b = strcmp(num2str(pts(i).origs(2)),num2str(Calib.points.y(mOrder(n))));
			if ( a && b)
				px = Calib.mondims.width*pts(i).origs(1)+Calib.BigMark;
				py = Calib.mondims.height*pts(i).origs(2);
				text(double(px),double(py),num2str(mOrder(n)),'FontSize',15,'color','k');        
			end
		end

		for j = 1:size(pts(i).point,2)
			if (pts(i).point(j).validity(1)==1)
				line([Calib.mondims.width*pts(i).origs(1) Calib.mondims.width*pts(i).point(j).left(1)],...
					[Calib.mondims.height*pts(i).origs(2) Calib.mondims.height*pts(i).point(j).left(2)],...
					'Color','r');
				plot(Calib.mondims.width*pts(i).point(j).left(1),...
					Calib.mondims.height*pts(i).point(j).left(2),...
					'o','MarkerEdgeColor','r','MarkerSize',Calib.SmallMark);
			end
			if (pts(i).point(j).validity(2)==1)
				line([Calib.mondims.width*pts(i).origs(1) Calib.mondims.width*pts(i).point(j).right(1)],...
					[Calib.mondims.height*pts(i).origs(2) Calib.mondims.height*pts(i).point(j).right(2)],...
					'Color','g');                    
					plot(Calib.mondims.width*pts(i).point(j).right(1),...
						Calib.mondims.height*pts(i).point(j).right(2),...
					'o','MarkerEdgeColor','g','MarkerSize',Calib.SmallMark);
			end
		end
	end

	drawnow

end

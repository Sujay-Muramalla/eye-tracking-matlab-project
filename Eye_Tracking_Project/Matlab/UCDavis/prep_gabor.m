
function gabor = prep_gabor (sd, sf, theta, matsize)

% This function prepares a gabor of the input parameters to be displayed by
% psychtoolbox (disp_gabor.m). Input standard deviation (sd), spatial frequency (sf),
% orientation angle (theta) and matrix size

[x,y] = meshgrid(linspace(-1,1,matsize+1));
xc = 0; yc = 0;

ramp = cos(theta*pi/180)*(x-xc) + sin(theta*pi/180)*(y-yc);

% lets make a grating from this with the spatial frequency sf
grating = sin(2*pi*sf*ramp);

% make a gaussian centered at (xc,yc)
gauss = exp( -((x-xc).^2 + (y-yc).^2)/(2*sd^2));

% now we can combine them into a gabor
gabor = gauss.*grating;

% scale it from 0 to 255 
% gabor = (gabor+1)*127.5; % or we can use imagesc

% just for testing, comment out after checking gabor is OK
% figure;
% imagesc (gabor); 
% colormap (gray); 
% axis off; 
% axis square%


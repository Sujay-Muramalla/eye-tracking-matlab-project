% Oriented Gabor code, MatlabFun 2010, 2012, 2013
% Adapted from G. Boynton & I. Fine course notes

n = 501;
[x,y] = meshgrid(linspace(-1,1,n));
cmap = gray(256);

colormap(cmap);
axis off; axis equal;

% Parameters for gabor
sd = .08; %standard deviation
xc = .5; %x center
yc = .1; %y center
sf = 12;  %spatial frequency (cycles/image)

figure(1);
for theta = 0:180
    
    ramp = cos(theta*pi/180)*(x-xc) + sin(theta*pi/180)*(y-yc);
    
    % uncomment below to show the ramp
    % imagesc(ramp);
    % axis equal;
    % axis off;
    colormap(cmap);
    
    % lets make a grating from this with the spatial frequency sf
    grating = sin(2*pi*sf*ramp);
    % uncomment to scale & display the image
    % imagesc(grating);
    % axis equal;
    % axis off;
    % pause;
    
    %Make a gaussian centered at (xc,yc)
    gauss = exp( -((x-xc).^2 + (y-yc).^2)/(2*sd^2));
    % scale & display the image
    
    % imagesc(gauss);
    % axis equal;
    % axis off;
    
    % now we can combine them into a gabor
    
    gabor = gauss.*grating;
    
    % optional: manually scale it from 0 to 255
    % if you uncomment and use this, use image instead of imagesc
    % you can keep using scalesc
    % gabor = (gabor+1).*127.5;
    % you can extend the code here to change contrast
    
    %show it
    imagesc(gabor);
    axis equal;
    axis off;
    pause(0.1);
end
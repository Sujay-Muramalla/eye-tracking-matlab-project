% Gabor prep step by step

sd = 0.3;  sf = 10;  theta = 45;  matsize = 600;
xc = 0; yc = 0;
% setting variables

% meshgrid
[x,y] = meshgrid(linspace(-1,1,matsize+1));
figure (1);
imagesc(x); axis off; axis square; colormap(gray);
figure (2);
imagesc(y); axis off; axis square; colormap(gray);


% ramp
ramp = cos(theta*pi/180)*(x-xc) + sin(theta*pi/180)*(y-yc);
figure(3);
imagesc(ramp); axis off; axis square; colormap(gray);

% grating
grating = sin(2*pi*sf*ramp);
figure(4);
imagesc(grating); axis off; axis square; colormap(gray);


% gaussian
gauss = exp( -((x-xc).^2 + (y-yc).^2)/(2*sd^2));
figure(5);
imagesc(gauss); axis square;  axis off; colormap(gray);


% gabor is grating multiplied by gaussian
gabor = gauss.*grating;
figure(6);
imagesc(gabor); axis off; axis square; colormap(gray);



%% Sample_Images.m
% reads in cute_dogs.jpg and makes adjustments to this image

%load image
original = imread('cute_dogs.jpg');

%display it in new figure window with proper proportions and no axis
figure;
image(original);
axis image;
axis off;
%axis commands must be made after the image is drawn

% crop image to show middle dog
% i have deteremined through inspection that 470-1100 is a good range
% the horizontal axis is the second dimension in a matrix
cropped = original(:,470:1100,:);

% open a new figure window but give the figure window a number so we can
% save it later
figure(2);
image(cropped);
axis image;a
xis off;
saveas(2,'Sample_Myimg2.jpg'); % I recommend png not jpg since png is lossless compression

%adjust original image to remove all green from it
% green is the second level (2) of R G B
% set green equal to 0

nogreen = original;
nogreen(:,:,2) = 0;

figure(3);
image(nogreen);
axis image;
axis off;
saveas(3,'Sample_Myimg3.jpg');

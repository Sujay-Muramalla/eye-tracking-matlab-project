% Student name and info should always be here for coursework
A= [1 2 3; 4 5 6];
B = [2 3 4; 6 7 0];
C = eye(3) + ones (3,3);
E = repmat (C, 5, 3);
F = repmat (E, [2,4,67]);
% I am just giving an example of repmat
% and practicing making comments
G = F(:,:,51);
G2 = F(3:7,7:10,51:57);
G3 = F (3,:,7);
% practicing understanding of matrix sizes
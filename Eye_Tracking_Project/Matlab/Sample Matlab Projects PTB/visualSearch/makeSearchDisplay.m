function img = makeSearchDisplay(imTarg,imDist,setSize,targetPresent,rotateDistractor,bgColor,H,W)

% Background image
img = bgColor*ones(H,W,3);

% Size of search items
itemWH = max([size(imTarg,1) size(imTarg,2) size(imDist,1) size(imDist,2)]);

% Place items on a jittered grid
% Number of grid squares in X and Y
X = sqrt(setSize*(W/H));
Y = sqrt(setSize*(H/W));
if (X-floor(X)) > (Y-floor(Y))
    Y = ceil(Y); X = ceil(setSize/Y);
else
    X = ceil(X); Y = ceil(setSize/X);
end
if ((H/Y) < itemWH)||((W/X) < itemWH)
    disp('Error');
    return
end
% Grid start positions and jitter
gridPosY = [round((H/Y)*(0:(Y-1))) H];
gridPosX = [round((W/X)*(0:(X-1))) W];
jitterH = (gridPosY(2:Y+1) - gridPosY(1:Y)) - itemWH;
jitterW = (gridPosX(2:X+1) - gridPosX(1:X)) - itemWH;
gridPosY = repmat(gridPosY(1:Y)',[1 X]);
gridPosX = repmat(gridPosX(1:X),[Y 1]);
jitterY = floor(rand(Y,X).*repmat(jitterH',[1 X]));
jitterX = floor(rand(Y,X).*repmat(jitterW,[Y 1]));
r = randperm(X*Y);
% Random grid positions for items
pos = [(gridPosY(r(1:setSize))+jitterY(r(1:setSize)))' (gridPosX(r(1:setSize))+jitterX(r(1:setSize)))'];

% Paste search items on the background
for i = 1:setSize
    % If target present, place target first
    if (i == 1)&&(targetPresent == 1)
        d = imTarg;
    else
        d = imDist;
        % Optional: randomly rotate distractors
        if rotateDistractor == 1
            if rand < 0.5
                d = flipdim(flipdim(d,1),2);
            end
            if rand < 0.5
                d = flipdim(permute(d,[2 1 3]),1);
            end
        end
    end
    img(pos(i,1)+1:pos(i,1)+size(d,1),pos(i,2)+1:pos(i,2)+size(d,2),:) = d;
end
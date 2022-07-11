function panorama = F_blending(sourceTiles,pyramidBlending)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

numTiles = length(sourceTiles);

% Initialize variable to hold image sizes.
imageSize = zeros(numTiles,2);
xlim = zeros(numTiles,2);
ylim = zeros(numTiles,2);
for i = 1:numTiles
    imageSize(i,:) = sourceTiles{i}.size;
    [xlim(i,:), ylim(i,:)] = outputLimits(sourceTiles{i}.tform, [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

maxImageSize = max(imageSize);

% Find the minimum and maximum output limits.
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Initialize the "empty" panorama.
panorama = zeros([height width size(sourceTiles{1}.val,3)], 'like', sourceTiles{1}.val);
blender = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port');

I = flipud(sourceTiles{1}.val);

progressMask = false(height,width,1);
warpedImage = imwarp(I, sourceTiles{1}.tform, 'OutputView', panoramaView);
mask = imwarp(true(size(I,1),size(I,2)), sourceTiles{1}.tform, 'OutputView', panoramaView);
panorama = step(blender, panorama, warpedImage, mask);
progressMask = progressMask | mask;

% Create the panorama.
if pyramidBlending
    for i = 2:numTiles
        I = flipud(sourceTiles{i}.val);
        % Transform I into the panorama.
        warpedImage = imwarp(I, sourceTiles{i}.tform, 'OutputView', panoramaView);
        % Generate a binary mask.
        mask = imwarp(true(size(I,1),size(I,2)), sourceTiles{i}.tform, 'OutputView', panoramaView);
        
        newMask = ~progressMask & mask;
        panorama1 = step(blender, panorama, warpedImage, newMask);
        panorama2 = step(blender, panorama, warpedImage, mask);
        
        mask0 = uint8(repmat(progressMask,1,1,3)).*255;
        panorama1 = repmat(panorama1,1,1,3);
        panorama2 = repmat(panorama2,1,1,3);
        panorama01 = LaplacianBlend(panorama2,panorama1, mask0);
        
        progressMask = progressMask | mask;
        mask = uint8(repmat(mask,1,1,3)).*255;
        
        % Overlay the warpedImage onto the panorama.
        panorama02 = LaplacianBlend(panorama1, panorama2, mask);
        panorama = (panorama01(:,:,1) + panorama02(:,:,1))./2;
    end
else
    for i = 2:numTiles
        I = flipud(sourceTiles{i}.val);
        % Transform I into the panorama.
        warpedImage = imwarp(I, sourceTiles{i}.tform, 'OutputView', panoramaView);
        
        % Generate a binary mask.
        mask = imwarp(true(size(I,1),size(I,2)), sourceTiles{i}.tform, 'OutputView', panoramaView);
        panorama = step(blender, panorama, warpedImage, mask);
        progressMask = progressMask | mask;
    end
end

panorama(~progressMask) = nan;
panorama = flipud(panorama);

end


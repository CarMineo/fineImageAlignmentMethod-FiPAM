function [pixelCorrectedTiles,x] = F_pixelIntensityCorrection(sourceTiles,expThrld)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_pixelIntensityCorrection v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

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


tiles = cell(numTiles,1);
ovlps = cell(numTiles,numTiles);
if numTiles>1
    for i = 1:numTiles
        I = flipud(sourceTiles{i}.val);
        warpedImage = imwarp(I, sourceTiles{i}.tform, 'OutputView', panoramaView);
        tiles{i} = warpedImage;
        
        if i<numTiles
            maskI = imwarp(true(sourceTiles{i}.size(1),sourceTiles{i}.size(2)), sourceTiles{i}.tform, 'OutputView', panoramaView);
            for j = i+1:numTiles
                maskJ = imwarp(true(sourceTiles{j}.size(1),sourceTiles{j}.size(2)), sourceTiles{j}.tform, 'OutputView', panoramaView);
                maskInt = maskI & maskJ;
                ind = find(maskInt);
                if ~isempty(ind)
                    ovlps{i,j} = ind;
                    ovlps{j,i} = ind;
                end
            end
        end
    end
end

x0 = zeros(numTiles,1);
lb = -inf(numTiles,1);
ub = inf(numTiles,1);

for i = 1:numTiles
    tileValues = [];
    tilePairs = [];
    
    for j = 1:numTiles
        if (i~=j)
            if ~isempty(ovlps{i,j})
                values = tiles{i}(ovlps{i,j});
                pairValues = tiles{j}(ovlps{i,j});
                
                diffs = pairValues - values;
                
                if ~isinf(expThrld)
                    [binCounts,binEdges] = histcounts(diffs);
                    binCentres = (binEdges(1,1:(end-1)) + binEdges(1,2:end))./2;
                    k = find(binCounts==max(binCounts),1);
                    
                    leftDiffThrld = binCentres(k) - expThrld;
                    rightDiffThrld = binCentres(k) + expThrld;
                    ignInd = find((diffs<leftDiffThrld) | (diffs>rightDiffThrld));
                    
                    ovlps{i,j}(ignInd) = [];
                    values(ignInd) = [];
                    pairValues(ignInd) = [];
                end
                
                tileValues = [tileValues; values];
                tilePairs = [tilePairs; pairValues];
            end
        end
    end
    
    diffs = tilePairs - tileValues;
    meanDiff = mean(diffs);
    
    if ~isempty(meanDiff)
        if meanDiff < 0
            lb(i) = meanDiff;
            ub(i) = 0;
        else
            lb(i) = 0;
            ub(i) = meanDiff;
        end
    end
end

fun = @(x) F_exposureFunDiffs(x,tiles,ovlps);
ms = MultiStart('Display','iter');
msProblem = createOptimProblem('lsqnonlin','x0',x0,'objective',fun,'lb',lb,'ub',ub');
[x,errormultinonlin] = run(ms,msProblem,10);

pixelCorrectedTiles = sourceTiles;
for i = 1:numTiles
    pixelCorrectedTiles{i}.val = pixelCorrectedTiles{i}.val + x(i);
end

end


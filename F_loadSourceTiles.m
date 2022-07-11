function [sourceTiles,x0,varStarts] = F_loadSourceTiles(dataFolder,numTiles,transforms,normPoses)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_loadSourceTiles v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

sourceTiles = cell(numTiles,1);
varStarts = zeros(numTiles,1);
x0 = [];

for i=1:numTiles
    fig = openfig([dataFolder '\' num2str(i) '.fig']);
    hIm = get(fig,'children');
    hIm = get(hIm(2),'children');
    rawData = get(hIm,'CData');
    close(fig);
    
    sourceTiles{i} = [];
    sourceTiles{i}.size = size(rawData);
    sourceTiles{i}.val = rawData;
    [sourceTiles{i}.x,sourceTiles{i}.y] = meshgrid(1:sourceTiles{i}.size(2),fliplr(1:sourceTiles{i}.size(1)));
    sourceTiles{i}.centre = [mean(sourceTiles{i}.x(:)) mean(sourceTiles{i}.y(:))];
    sourceTiles{i}.box = polyshape([sourceTiles{i}.x(end,1) sourceTiles{i}.x(1,1) sourceTiles{i}.x(1,end) sourceTiles{i}.x(end,end)],...
        [sourceTiles{i}.y(end,1) sourceTiles{i}.y(1,1) sourceTiles{i}.y(1,end) sourceTiles{i}.y(end,end)]);
    
    sourceTiles{i}.tformIni = rigid2d([1              0              0;
        0              1              0;
        normPoses(i,1) normPoses(i,2) 1]);
    sourceTiles{i}.tformType = transforms{i};
    
    switch transforms{i}
        case 'none'
            if i<numTiles
                varStarts(i+1) = varStarts(i);
            end
            
            sourceTiles{i}.tform = @(x) rigid2d([1              0              0;
                0              1              0;
                normPoses(i,1) normPoses(i,2) 1]);
        case 'translation'
            if i<numTiles
                varStarts(i+1) = varStarts(i) + 2;
            end
            x0 = [x0 normPoses(i,1) normPoses(i,2)];
            sourceTiles{i}.tform = @(x) rigid2d([1                 0                 0;
                0                 1                 0;
                x(varStarts(i)+1) x(varStarts(i)+2) 1]);
        case 'euclidean'
            if i<numTiles
                varStarts(i+1) = varStarts(i) + 3;
            end
            x0 = [x0 0 normPoses(i,1) normPoses(i,2)];
            sourceTiles{i}.tform = @(x) rigid2d([cos(x(varStarts(i)+1)) sin(x(varStarts(i)+1)) 0;
                -sin(x(varStarts(i)+1)) cos(x(varStarts(i)+1)) 0;
                x(varStarts(i)+2)      x(varStarts(i)+3)      1]);
        case 'similarity'
            if i<numTiles
                varStarts(i+1) = varStarts(i) + 4;
            end
            x0 = [x0 1 0 normPoses(i,1) normPoses(i,2)];
            sourceTiles{i}.tform = @(x) affine2d([x(varStarts(i)+1) x(varStarts(i)+2) 0;
                -x(varStarts(i)+2) x(varStarts(i)+1) 0;
                x(varStarts(i)+3) x(varStarts(i)+4) 1]);
        case 'affine'
            if i<numTiles
                varStarts(i+1) = varStarts(i) + 6;
            end
            x0 = [x0 1 0 normPoses(i,1) 0 1 normPoses(i,2)];
            sourceTiles{i}.tform = @(x) affine2d([x(varStarts(i)+1) x(varStarts(i)+4) 0;
                x(varStarts(i)+2) x(varStarts(i)+5) 0;
                x(varStarts(i)+3) x(varStarts(i)+6) 1]);
        case 'homography'
            if i<numTiles
                varStarts(i+1) = varStarts(i) + 8;
            end
            x0 = [x0 1 0 normPoses(i,1) 0 1 normPoses(i,2) 0 0];
            sourceTiles{i}.tform = @(x) projective2d([x(varStarts(i)+1) x(varStarts(i)+4) x(varStarts(i)+7);
                x(varStarts(i)+2) x(varStarts(i)+5) x(varStarts(i)+8);
                x(varStarts(i)+3) x(varStarts(i)+6) 1]);
    end
end


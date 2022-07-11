function [x,alignedTiles] = F_alignment(sourceTiles,ovlps,transforms,x0,lb,ub,varStarts,interpMethod,expThrld,maxStarts,multiStarts)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_alignment v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

numTiles = length(sourceTiles);

iStarts = 1;
for i = 1:numTiles
    for j = 1:numTiles
        if ~isempty(ovlps{i,j})
            l = length(ovlps{i,j}.tmp.val(:));
            iStarts(end+1,1) = iStarts(end) + l;
        end
    end
end

if ~isempty(x0)
    fun = @(x) F_funDiffs(x,varStarts,numTiles,transforms,ovlps,interpMethod,iStarts);
    ms = MultiStart('Display','iter');
    msProblem = createOptimProblem('lsqnonlin','x0',x0,'objective',fun,'lb',lb,'ub',ub');
    [x,errormultinonlin] = run(ms,msProblem,min(maxStarts,multiStarts^length(x0)));
end

for i = 1:numTiles
    sourceTiles{i}.tform = feval(sourceTiles{i}.tform,x);
end

alignedTiles = sourceTiles;

for i = 1:numTiles
    [alignedTiles{i}.x,alignedTiles{i}.y] = transformPointsForward(sourceTiles{i}.tform,sourceTiles{i}.x(:),sourceTiles{i}.y(:));
    alignedTiles{i}.x = reshape(alignedTiles{i}.x,size(sourceTiles{i}.x));
    alignedTiles{i}.y = reshape(alignedTiles{i}.y,size(sourceTiles{i}.y));
    alignedTiles{i}.box.Vertices = transformPointsForward(sourceTiles{i}.tform,sourceTiles{i}.box.Vertices);
    alignedTiles{i}.centre = transformPointsForward(sourceTiles{i}.tform,sourceTiles{i}.centre);
end


end


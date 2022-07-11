function ovlps = F_getOverlaps(sourceTiles,pixTol,normPoses)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_getOverlaps v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

numTiles = length(sourceTiles);
ovlps = cell(numTiles,numTiles);
if numTiles>1
    for i = 1:(numTiles-1)
        for j = i+1:numTiles
            tmpBox = sourceTiles{i}.box;
            tmpBox.Vertices = [tmpBox.Vertices(:,1)+normPoses(i,1) tmpBox.Vertices(:,2)+normPoses(i,2)];
            
            imBox = sourceTiles{j}.box;
            imBox.Vertices = [imBox.Vertices(:,1)+normPoses(j,1) imBox.Vertices(:,2)+normPoses(j,2)];
            
            polyIm = intersect(tmpBox,imBox);
            
            if polyIm.NumRegions>0
                polyTmp = polybuffer(polyIm,-pixTol,'JointType','square');
                
                inIm = inpolygon(sourceTiles{j}.x + normPoses(j,1),sourceTiles{j}.y + normPoses(j,2),polyIm.Vertices(:,1),polyIm.Vertices(:,2));
                inTmp = inpolygon(sourceTiles{i}.x + normPoses(i,1),sourceTiles{i}.y + normPoses(i,2),polyTmp.Vertices(:,1),polyTmp.Vertices(:,2));
                
                [I,J] = find(inIm);
                im = []; mi = min(I); Mi = max(I); mj = min(J); Mj = max(J);
                im.x = sourceTiles{j}.x(mi:Mi,mj:Mj);
                im.y = sourceTiles{j}.y(mi:Mi,mj:Mj);
                im.val = sourceTiles{j}.val(mi:Mi,mj:Mj);
                
                [I,J] = find(inTmp);
                tmp = []; mi = min(I); Mi = max(I); mj = min(J); Mj = max(J);
                tmp.x = sourceTiles{i}.x(mi:Mi,mj:Mj);
                tmp.y = sourceTiles{i}.y(mi:Mi,mj:Mj);
                tmp.val = sourceTiles{i}.val(mi:Mi,mj:Mj);
                
                ovlps{i,j}.tmp = tmp;
                ovlps{i,j}.im = im;
                
                inIm = inpolygon(sourceTiles{i}.x + normPoses(i,1),sourceTiles{i}.y + normPoses(i,2),polyIm.Vertices(:,1),polyIm.Vertices(:,2));
                inTmp = inpolygon(sourceTiles{j}.x + normPoses(j,1),sourceTiles{j}.y + normPoses(j,2),polyTmp.Vertices(:,1),polyTmp.Vertices(:,2));
                
                [I,J] = find(inIm);
                im = []; mi = min(I); Mi = max(I); mj = min(J); Mj = max(J);
                im.x = sourceTiles{i}.x(mi:Mi,mj:Mj);
                im.y = sourceTiles{i}.y(mi:Mi,mj:Mj);
                im.val = sourceTiles{i}.val(mi:Mi,mj:Mj);
                
                [I,J] = find(inTmp);
                tmp = []; mi = min(I); Mi = max(I); mj = min(J); Mj = max(J);
                tmp.x = sourceTiles{j}.x(mi:Mi,mj:Mj);
                tmp.y = sourceTiles{j}.y(mi:Mi,mj:Mj);
                tmp.val = sourceTiles{j}.val(mi:Mi,mj:Mj);
                
                ovlps{j,i}.tmp = tmp;
                ovlps{j,i}.im = im;
            end
        end
    end
end



function [lb,ub] = F_computeBounds(transforms,ovlps,pixTol,x0,varStarts)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_computeBounds v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

lb = []; ub = [];
numTiles = size(ovlps,1);

for i = 1:numTiles
    if ~strcmp(transforms{i},'none') && ~strcmp(transforms{i},'translation')
        maxTheta = inf;
        maxZoom = inf;
        for j=1:numTiles
            if ~isempty(ovlps{i,j})
                width = (max(ovlps{i,j}.tmp.x(:)) - min((ovlps{i,j}.tmp.x(:))))/2;
                height = (max(ovlps{i,j}.tmp.y(:)) - min((ovlps{i,j}.tmp.y(:))))/2;
                maxTheta = min(maxTheta, asin(pixTol/max(width,height)));
                
                widthIm = (max(ovlps{i,j}.im.x(:)) - min((ovlps{i,j}.im.x(:))))/2;
                heightIm = (max(ovlps{i,j}.im.y(:)) - min((ovlps{i,j}.im.y(:))))/2;
                maxZoom = min(maxZoom, min(widthIm/width,heightIm/height));
            end
        end
        
        dv1 = abs(1-maxZoom*cos(maxTheta));
        dv2 = maxZoom*sin(maxTheta);
    end
    
    switch transforms{i}
        case 'none'
            
        case 'translation'
            lb = [lb x0(varStarts(i)+1)-pixTol x0(varStarts(i)+2)-pixTol];
            ub = [ub x0(varStarts(i)+1)+pixTol x0(varStarts(i)+2)+pixTol];
        case 'euclidean'
            lb = [lb x0(varStarts(i)+1)-maxTheta x0(varStarts(i)+2)-pixTol x0(varStarts(i)+3)-pixTol];
            ub = [ub x0(varStarts(i)+1)+maxTheta x0(varStarts(i)+2)+pixTol x0(varStarts(i)+3)+pixTol];
        case 'similarity'
            lb = [lb x0(varStarts(i)+1)-dv1 x0(varStarts(i)+2)-dv2 x0(varStarts(i)+3)-pixTol x0(varStarts(i)+4)-pixTol];
            ub = [ub x0(varStarts(i)+1)+dv1 x0(varStarts(i)+2)+dv2 x0(varStarts(i)+3)+pixTol x0(varStarts(i)+4)+pixTol];
        case 'affine'
            lb = [lb x0(varStarts(i)+1)-dv1 x0(varStarts(i)+2)-dv2 x0(varStarts(i)+3)-pixTol x0(varStarts(i)+4)-dv2 x0(varStarts(i)+5)-dv1 x0(varStarts(i)+6)-pixTol];
            ub = [ub x0(varStarts(i)+1)+dv1 x0(varStarts(i)+2)+dv2 x0(varStarts(i)+3)+pixTol x0(varStarts(i)+4)+dv2 x0(varStarts(i)+5)+dv1 x0(varStarts(i)+6)+pixTol];
        case 'homography'
            lb = [lb x0(varStarts(i)+1)-dv1 x0(varStarts(i)+2)-dv2 x0(varStarts(i)+3)-pixTol x0(varStarts(i)+4)-dv2 x0(varStarts(i)+5)-dv1 x0(varStarts(i)+6)-pixTol x0(varStarts(i)+7)-dv2 x0(varStarts(i)+8)-dv2];
            ub = [ub x0(varStarts(i)+1)+dv1 x0(varStarts(i)+2)+dv2 x0(varStarts(i)+3)+pixTol x0(varStarts(i)+4)+dv2 x0(varStarts(i)+5)+dv1 x0(varStarts(i)+6)+pixTol x0(varStarts(i)+7)+dv2 x0(varStarts(i)+8)+dv2];
    end
end


end


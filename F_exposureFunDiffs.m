function diffs = F_exposureFunDiffs(x,tiles,ovlps)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_exposureFunDiffs v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

numTiles = length(tiles);
% corrTiles = cell(numTiles,1);
% for i = 1:numTiles
%     corrTiles{i} = tiles{i} + x(i);
% end

diffs = [];
for i = 1:(numTiles-1)
    for j = i+1:numTiles
        if ~isempty(ovlps{i,j})
            %diffs = [diffs; corrTiles{i}(ovlps{i,j})-corrTiles{j}(ovlps{i,j})];
            diffs = [diffs;  (mean(tiles{i}(ovlps{i,j}))+x(i)) - (mean(tiles{j}(ovlps{i,j}))+x(j))];
        end
    end
end

end


function [sourceTiles,x] = F_preliminaryIntensityCorrection(sourceTiles)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_preliminaryIntensityCorrection v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

numTiles = length(sourceTiles);
x = F_exposureCorrections(sourceTiles,0,inf);
for i = 1:numTiles
    sourceTiles{i}.val = sourceTiles{i}.val + x(i);
end

end


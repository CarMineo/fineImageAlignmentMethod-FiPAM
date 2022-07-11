function imPitch = F_estimateImPitch(dataFolder,tileNumber)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_estimateImPitch v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

fig = openfig([dataFolder '\' num2str(tileNumber,'%u') '.fig']);
set(fig,'name','Interactive pitch estimation','units','normalized','outerposition',[0 0 1 1]);
colormap('hot'); drawnow;

[CX,CY,C,xi,yi]=improfile;
P1 = [xi(1) yi(1)];
P2 = [xi(2) yi(2)];
L = sqrt(((P2(1)-P1(1))^2)+((P2(2)-P1(2))^2));

L0=input('Distanza=? ');
imPitch=L0/L;

close(fig);

end


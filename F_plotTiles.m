function hFig = F_plotTiles(sourceTiles,poses,colorMap,cMin,cMax,figName)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_plotTiles v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

numTiles = length(sourceTiles);

hFig = figure('name',figName,'units','normalized','outerposition',[0 0 1 1]);
hSub = subplot(1,1,1);

for i=1:numTiles
    hsurf = surf(sourceTiles{i}.x + poses(i,1),sourceTiles{i}.y + poses(i,2),zeros(sourceTiles{i}.size),sourceTiles{i}.val); hold on;
    set(hsurf,'facecolor','texturemap','facealpha',0.5,'linestyle','none'); axis image; view(0,90);
end
colormap(hSub,colorMap);
hCB = colorbar(hSub);
hCB.Label.String = 'Phase [degrees]';
hCB.Label.FontSize = 16;
hCB.Label.Interpreter = 'latex';
set(gca,'clim',[cMin,cMax]);
set(hCB,'Limits',[cMin,cMax],'LimitsMode','manual','linewidth',1.5);
set(gca,'visible','off','fontsize',12);
drawnow;
drawnow;


end


function hFig = F_plotPanorama(panorama,colorMap,cMin,cMax)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_plotPanorama v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

hFig = figure('name','Blended panorama','units','normalized','outerposition',[0 0 1 1]);
subplot(1,1,1);
imagesc(panorama);axis image;
colormap(colorMap);
hCB = colorbar();
hCB.Label.String = 'Phase [degrees]';
hCB.Label.FontSize = 16;
hCB.Label.Interpreter = 'latex';
set(gca,'clim',[cMin,cMax]);
set(hCB,'Limits',[cMin,cMax],'LimitsMode','manual','linewidth',1.5);
set(gca,'visible','off','fontsize',12);
drawnow;
end


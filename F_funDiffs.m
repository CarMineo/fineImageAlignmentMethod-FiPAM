function fun = F_funDiffs(x,varStarts,numTiles,transforms,ovlps,interpMethod,iStarts)
%
% Author: Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b
%
%   F_funDiffs v1.0
%   Copyright (C) 2022 Carmelo Mineo. See COPYRIGHT.txt for details.

%------------- BEGIN CODE --------------

fun = zeros(iStarts(end)-1,1);
k = 0;

for i = 1:numTiles
    for j = 1:numTiles
        if ~isempty(ovlps{i,j})
            switch transforms{i}
                case 'none'
                    switch transforms{j}
                        case 'none'
                            xPar = ovlps{i,j}.tmp.x;
                            yPar = ovlps{i,j}.tmp.y;
                        case 'translation'
                            xPar = (ovlps{i,j}.tmp.x - x(varStarts(j)+1));
                            yPar = (ovlps{i,j}.tmp.y - x(varStarts(j)+2));
                        case 'euclidean'
                            yPar = ((ovlps{i,j}.tmp.y - x(varStarts(j)+3) - tan(x(varStarts(j)+1)).*(ovlps{i,j}.tmp.x - x(varStarts(j)+2)))./(cos(x(varStarts(j)+1)) + tan(x(varStarts(j)+1))*sin(x(varStarts(j)+1))));
                            xPar = ((ovlps{i,j}.tmp.x - x(varStarts(j)+2))./cos(x(varStarts(j)+1))) + tan(x(varStarts(j)+1)).*yPar;
                        case 'similarity'
                            yPar = ((x(varStarts(j)+1).*(ovlps{i,j}.tmp.y - x(varStarts(j)+4))) - (x(varStarts(j)+2).*(ovlps{i,j}.tmp.x - x(varStarts(j)+3))))./((x(varStarts(j)+1)^2) + (x(varStarts(j)+2)^2));
                            xPar = ((ovlps{i,j}.tmp.x - x(varStarts(j)+3))./x(varStarts(j)+1)) + (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'affine'
                            yPar = ((x(varStarts(j)+1).*ovlps{i,j}.tmp.y) - (x(varStarts(j)+4).*ovlps{i,j}.tmp.x) + (x(varStarts(j)+3)*x(varStarts(j)+4)) - (x(varStarts(j)+1)*x(varStarts(j)+6)))./((x(varStarts(j)+1)*x(varStarts(j)+5)) - (x(varStarts(j)+2)*x(varStarts(j)+4)));
                            xPar = ((ovlps{i,j}.tmp.x - x(varStarts(j)+3))./x(varStarts(j)+1)) - (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'homography'
                            yPar = (((x(varStarts(j)+4) - (x(varStarts(j)+6)*x(varStarts(j)+7))).*ovlps{i,j}.tmp.x) + (((x(varStarts(j)+3)*x(varStarts(j)+7)) - x(varStarts(j)+1)).*ovlps{i,j}.tmp.y) + (x(varStarts(j)+1)*x(varStarts(j)+6)) - (x(varStarts(j)+3)*x(varStarts(j)+4)))./((((x(varStarts(j)+5)*x(varStarts(j)+7)) - (x(varStarts(j)+4)*x(varStarts(j)+8))).*ovlps{i,j}.tmp.x) + (((x(varStarts(j)+1)*x(varStarts(j)+8)) - (x(varStarts(j)+7)*x(varStarts(j)+8)) - (x(varStarts(j)+2)*x(varStarts(j)+7))).*ovlps{i,j}.tmp.y) + (x(varStarts(j)+7).*x(varStarts(j)+8).*ovlps{i,j}.tmp.x.*ovlps{i,j}.tmp.y) + (x(varStarts(j)+2).*x(varStarts(j)+4)) - (x(varStarts(j)+1).*x(varStarts(j)+5)));
                            xPar = ((ovlps{i,j}.tmp.x - x(varStarts(j)+3))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*ovlps{i,j}.tmp.x))) + ((((x(varStarts(j)+8).*ovlps{i,j}.tmp.x) - x(varStarts(j)+2))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*ovlps{i,j}.tmp.x))).*yPar);
                    end
                case 'translation'
                    switch transforms{j}
                        case 'none'
                            xPar = (ovlps{i,j}.tmp.x + x(varStarts(i)+1));
                            yPar = (ovlps{i,j}.tmp.y + x(varStarts(i)+2));
                        case 'translation'
                            xPar = (ovlps{i,j}.tmp.x + x(varStarts(i)+1) - x(varStarts(j)+1));
                            yPar = (ovlps{i,j}.tmp.y + x(varStarts(i)+2) - x(varStarts(j)+2));
                        case 'euclidean'
                            yPar = (((ovlps{i,j}.tmp.y + x(varStarts(i)+2)) - x(varStarts(j)+3) - tan(x(varStarts(j)+1)).*((ovlps{i,j}.tmp.x + x(varStarts(i)+1)) - x(varStarts(j)+2)))./(cos(x(varStarts(j)+1)) + tan(x(varStarts(j)+1))*sin(x(varStarts(j)+1))));
                            xPar = (((ovlps{i,j}.tmp.x + x(varStarts(i)+1)) - x(varStarts(j)+2))./cos(x(varStarts(j)+1))) + tan(x(varStarts(j)+1)).*yPar;
                        case 'similarity'
                            yPar = ((x(varStarts(j)+1).*((ovlps{i,j}.tmp.y + x(varStarts(i)+2)) - x(varStarts(j)+4))) - (x(varStarts(j)+2).*((ovlps{i,j}.tmp.x + x(varStarts(i)+1)) - x(varStarts(j)+3))))./((x(varStarts(j)+1)^2) + (x(varStarts(j)+2)^2));
                            xPar = (((ovlps{i,j}.tmp.x + x(varStarts(i)+1)) - x(varStarts(j)+3))./x(varStarts(j)+1)) + (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'affine'
                            yPar = ((x(varStarts(j)+1).*(ovlps{i,j}.tmp.y + x(varStarts(i)+2))) - (x(varStarts(j)+4).*(ovlps{i,j}.tmp.x + x(varStarts(i)+1))) + (x(varStarts(j)+3)*x(varStarts(j)+4)) - (x(varStarts(j)+1)*x(varStarts(j)+6)))./((x(varStarts(j)+1)*x(varStarts(j)+5)) - (x(varStarts(j)+2)*x(varStarts(j)+4)));
                            xPar = (((ovlps{i,j}.tmp.x + x(varStarts(i)+1)) - x(varStarts(j)+3))./x(varStarts(j)+1)) - (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'homography'
                            yPar = (((x(varStarts(j)+4) - (x(varStarts(j)+6)*x(varStarts(j)+7))).*(ovlps{i,j}.tmp.x + x(varStarts(i)+1))) + (((x(varStarts(j)+3)*x(varStarts(j)+7)) - x(varStarts(j)+1)).*(ovlps{i,j}.tmp.y + x(varStarts(i)+2))) + (x(varStarts(j)+1)*x(varStarts(j)+6)) - (x(varStarts(j)+3)*x(varStarts(j)+4)))./((((x(varStarts(j)+5)*x(varStarts(j)+7)) - (x(varStarts(j)+4)*x(varStarts(j)+8))).*(ovlps{i,j}.tmp.x + x(varStarts(i)+1))) + (((x(varStarts(j)+1)*x(varStarts(j)+8)) - (x(varStarts(j)+7)*x(varStarts(j)+8)) - (x(varStarts(j)+2)*x(varStarts(j)+7))).*(ovlps{i,j}.tmp.y + x(varStarts(i)+2))) + (x(varStarts(j)+7).*x(varStarts(j)+8).*(ovlps{i,j}.tmp.x + x(varStarts(i)+1)).*(ovlps{i,j}.tmp.y + x(varStarts(i)+2))) + (x(varStarts(j)+2).*x(varStarts(j)+4)) - (x(varStarts(j)+1).*x(varStarts(j)+5)));
                            xPar = (((ovlps{i,j}.tmp.x + x(varStarts(i)+1)) - x(varStarts(j)+3))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*(ovlps{i,j}.tmp.x + x(varStarts(i)+1))))) + ((((x(varStarts(j)+8).*(ovlps{i,j}.tmp.x + x(varStarts(i)+1))) - x(varStarts(j)+2))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*(ovlps{i,j}.tmp.x + x(varStarts(i)+1))))).*yPar);
                    end
                case 'euclidean'
                    switch transforms{j}
                        case 'none'
                            xPar = cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2);
                            yPar = sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) + cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3);
                        case 'translation'
                            xPar = cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2) - x(varStarts(j)+1);
                            yPar = sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) + cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3) - x(varStarts(j)+2);
                        case 'euclidean'
                            yPar = (((sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) + cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+3) - tan(x(varStarts(j)+1)).*((cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2)) - x(varStarts(j)+2)))./(cos(x(varStarts(j)+1)) + tan(x(varStarts(j)+1))*sin(x(varStarts(j)+1))));
                            xPar = (((cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2)) - x(varStarts(j)+2))./cos(x(varStarts(j)+1))) + tan(x(varStarts(j)+1)).*yPar;
                        case 'similarity'
                            yPar = ((x(varStarts(j)+1).*((sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) + cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+4))) - (x(varStarts(j)+2).*((cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2)) - x(varStarts(j)+3))))./((x(varStarts(j)+1)^2) + (x(varStarts(j)+2)^2));
                            xPar = (((cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2)) - x(varStarts(j)+3))./x(varStarts(j)+1)) + (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'affine'
                            yPar = ((x(varStarts(j)+1).*(sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) + cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) - (x(varStarts(j)+4).*(cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2))) + (x(varStarts(j)+3)*x(varStarts(j)+4)) - (x(varStarts(j)+1)*x(varStarts(j)+6)))./((x(varStarts(j)+1)*x(varStarts(j)+5)) - (x(varStarts(j)+2)*x(varStarts(j)+4)));
                            xPar = (((cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2)) - x(varStarts(j)+3))./x(varStarts(j)+1)) - (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'homography'
                            yPar = (((x(varStarts(j)+4) - (x(varStarts(j)+6)*x(varStarts(j)+7))).*(cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2))) + (((x(varStarts(j)+3)*x(varStarts(j)+7)) - x(varStarts(j)+1)).*(sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) + cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) + (x(varStarts(j)+1)*x(varStarts(j)+6)) - (x(varStarts(j)+3)*x(varStarts(j)+4)))./((((x(varStarts(j)+5)*x(varStarts(j)+7)) - (x(varStarts(j)+4)*x(varStarts(j)+8))).*(cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2))) + (((x(varStarts(j)+1)*x(varStarts(j)+8)) - (x(varStarts(j)+7)*x(varStarts(j)+8)) - (x(varStarts(j)+2)*x(varStarts(j)+7))).*(sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) + cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) + (x(varStarts(j)+7).*x(varStarts(j)+8).*(cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2)).*(sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) + cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) + (x(varStarts(j)+2).*x(varStarts(j)+4)) - (x(varStarts(j)+1).*x(varStarts(j)+5)));
                            xPar = (((cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2)) - x(varStarts(j)+3))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*(cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2))))) + ((((x(varStarts(j)+8).*(cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2))) - x(varStarts(j)+2))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*(cos(x(varStarts(i)+1))*(ovlps{i,j}.tmp.x) - sin(x(varStarts(i)+1))*(ovlps{i,j}.tmp.y) + x(varStarts(i)+2))))).*yPar);
                    end
                case 'similarity'
                    switch transforms{j}
                        case 'none'
                            xPar = x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3);
                            yPar = x(varStarts(i)+2)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+1)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+4);
                        case 'translation'
                            xPar = x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3) - x(varStarts(j)+1);
                            yPar = x(varStarts(i)+2)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+1)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+4) - x(varStarts(j)+2);
                        case 'euclidean'
                            yPar = (((x(varStarts(i)+2)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+1)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+4)) - x(varStarts(j)+3) - tan(x(varStarts(j)+1)).*((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+2)))./(cos(x(varStarts(j)+1)) + tan(x(varStarts(j)+1))*sin(x(varStarts(j)+1))));
                            xPar = (((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+2))./cos(x(varStarts(j)+1))) + tan(x(varStarts(j)+1)).*yPar;
                        case 'similarity'
                            yPar = ((x(varStarts(j)+1).*((x(varStarts(i)+2)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+1)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+4)) - x(varStarts(j)+4))) - (x(varStarts(j)+2).*((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+3))))./((x(varStarts(j)+1)^2) + (x(varStarts(j)+2)^2));
                            xPar = (((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+3))./x(varStarts(j)+1)) + (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'affine'
                            yPar = ((x(varStarts(j)+1).*(x(varStarts(i)+2)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+1)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+4))) - (x(varStarts(j)+4).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) + (x(varStarts(j)+3)*x(varStarts(j)+4)) - (x(varStarts(j)+1)*x(varStarts(j)+6)))./((x(varStarts(j)+1)*x(varStarts(j)+5)) - (x(varStarts(j)+2)*x(varStarts(j)+4)));
                            xPar = (((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+3))./x(varStarts(j)+1)) - (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'homography'
                            yPar = (((x(varStarts(j)+4) - (x(varStarts(j)+6)*x(varStarts(j)+7))).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) + (((x(varStarts(j)+3)*x(varStarts(j)+7)) - x(varStarts(j)+1)).*(x(varStarts(i)+2)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+1)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+4))) + (x(varStarts(j)+1)*x(varStarts(j)+6)) - (x(varStarts(j)+3)*x(varStarts(j)+4)))./((((x(varStarts(j)+5)*x(varStarts(j)+7)) - (x(varStarts(j)+4)*x(varStarts(j)+8))).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) + (((x(varStarts(j)+1)*x(varStarts(j)+8)) - (x(varStarts(j)+7)*x(varStarts(j)+8)) - (x(varStarts(j)+2)*x(varStarts(j)+7))).*(x(varStarts(i)+2)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+1)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+4))) + (x(varStarts(j)+7).*x(varStarts(j)+8).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)).*(x(varStarts(i)+2)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+1)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+4))) + (x(varStarts(j)+2).*x(varStarts(j)+4)) - (x(varStarts(j)+1).*x(varStarts(j)+5)));
                            xPar = (((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+3))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))))) + ((((x(varStarts(j)+8).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) - x(varStarts(j)+2))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) - x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))))).*yPar);
                    end
                case 'affine'
                    switch transforms{j}
                        case 'none'
                            xPar = x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3);
                            yPar = x(varStarts(i)+4)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+5)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+6);
                        case 'translation'
                            xPar = x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3) - x(varStarts(j)+1);
                            yPar = x(varStarts(i)+4)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+5)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+6) - x(varStarts(j)+2);
                        case 'euclidean'
                            yPar = (((x(varStarts(i)+4)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+5)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+6)) - x(varStarts(j)+3) - tan(x(varStarts(j)+1)).*((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+2)))./(cos(x(varStarts(j)+1)) + tan(x(varStarts(j)+1))*sin(x(varStarts(j)+1))));
                            xPar = (((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+2))./cos(x(varStarts(j)+1))) + tan(x(varStarts(j)+1)).*yPar;
                        case 'similarity'
                            yPar = ((x(varStarts(j)+1).*((x(varStarts(i)+4)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+5)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+6)) - x(varStarts(j)+4))) - (x(varStarts(j)+2).*((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+3))))./((x(varStarts(j)+1)^2) + (x(varStarts(j)+2)^2));
                            xPar = (((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+3))./x(varStarts(j)+1)) + (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'affine'
                            yPar = ((x(varStarts(j)+1).*(x(varStarts(i)+4)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+5)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+6))) - (x(varStarts(j)+4).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) + (x(varStarts(j)+3)*x(varStarts(j)+4)) - (x(varStarts(j)+1)*x(varStarts(j)+6)))./((x(varStarts(j)+1)*x(varStarts(j)+5)) - (x(varStarts(j)+2)*x(varStarts(j)+4)));
                            xPar = (((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+3))./x(varStarts(j)+1)) - (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'homography'
                            yPar = (((x(varStarts(j)+4) - (x(varStarts(j)+6)*x(varStarts(j)+7))).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) + (((x(varStarts(j)+3)*x(varStarts(j)+7)) - x(varStarts(j)+1)).*(x(varStarts(i)+4)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+5)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+6))) + (x(varStarts(j)+1)*x(varStarts(j)+6)) - (x(varStarts(j)+3)*x(varStarts(j)+4)))./((((x(varStarts(j)+5)*x(varStarts(j)+7)) - (x(varStarts(j)+4)*x(varStarts(j)+8))).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) + (((x(varStarts(j)+1)*x(varStarts(j)+8)) - (x(varStarts(j)+7)*x(varStarts(j)+8)) - (x(varStarts(j)+2)*x(varStarts(j)+7))).*(x(varStarts(i)+4)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+5)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+6))) + (x(varStarts(j)+7).*x(varStarts(j)+8).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)).*(x(varStarts(i)+4)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+5)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+6))) + (x(varStarts(j)+2).*x(varStarts(j)+4)) - (x(varStarts(j)+1).*x(varStarts(j)+5)));
                            xPar = (((x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3)) - x(varStarts(j)+3))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))))) + ((((x(varStarts(j)+8).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))) - x(varStarts(j)+2))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*(x(varStarts(i)+1)*(ovlps{i,j}.tmp.x) + x(varStarts(i)+2)*(ovlps{i,j}.tmp.y) + x(varStarts(i)+3))))).*yPar);
                    end
                case 'homography'
                    switch transforms{j}
                        case 'none'
                            xPar = (x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1);
                            yPar = (x(varStarts(i)+4)*ovlps{i,j}.tmp.x + x(varStarts(i)+5)*ovlps{i,j}.tmp.y + x(varStarts(i)+6))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1);
                        case 'translation'
                            xPar = (((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)) - x(varStarts(j)+1));
                            yPar = (((x(varStarts(i)+4)*ovlps{i,j}.tmp.x + x(varStarts(i)+5)*ovlps{i,j}.tmp.y + x(varStarts(i)+6))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)) - x(varStarts(j)+2));
                        case 'euclidean'
                            yPar = ((((x(varStarts(i)+4)*ovlps{i,j}.tmp.x + x(varStarts(i)+5)*ovlps{i,j}.tmp.y + x(varStarts(i)+6))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)) - x(varStarts(j)+3) - tan(x(varStarts(j)+1)).*(((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)) - x(varStarts(j)+2)))./(cos(x(varStarts(j)+1)) + tan(x(varStarts(j)+1))*sin(x(varStarts(j)+1))));
                            xPar = ((((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)) - x(varStarts(j)+2))./cos(x(varStarts(j)+1))) + tan(x(varStarts(j)+1)).*yPar;
                        case 'similarity'
                            yPar = ((x(varStarts(j)+1).*(((x(varStarts(i)+4)*ovlps{i,j}.tmp.x + x(varStarts(i)+5)*ovlps{i,j}.tmp.y + x(varStarts(i)+6))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)) - x(varStarts(j)+4))) - (x(varStarts(j)+2).*(((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)) - x(varStarts(j)+3))))./((x(varStarts(j)+1)^2) + (x(varStarts(j)+2)^2));
                            xPar = ((((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)) - x(varStarts(j)+3))./x(varStarts(j)+1)) + (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'affine'
                            yPar = ((x(varStarts(j)+1).*((x(varStarts(i)+4)*ovlps{i,j}.tmp.x + x(varStarts(i)+5)*ovlps{i,j}.tmp.y + x(varStarts(i)+6))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1))) - (x(varStarts(j)+4).*((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1))) + (x(varStarts(j)+3)*x(varStarts(j)+4)) - (x(varStarts(j)+1)*x(varStarts(j)+6)))./((x(varStarts(j)+1)*x(varStarts(j)+5)) - (x(varStarts(j)+2)*x(varStarts(j)+4)));
                            xPar = ((((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)) - x(varStarts(j)+3))./x(varStarts(j)+1)) - (x(varStarts(j)+2)/x(varStarts(j)+1)).*yPar;
                        case 'homography'
                            yPar = (((x(varStarts(j)+4) - (x(varStarts(j)+6)*x(varStarts(j)+7))).*((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1))) + (((x(varStarts(j)+3)*x(varStarts(j)+7)) - x(varStarts(j)+1)).*((x(varStarts(i)+4)*ovlps{i,j}.tmp.x + x(varStarts(i)+5)*ovlps{i,j}.tmp.y + x(varStarts(i)+6))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1))) + (x(varStarts(j)+1)*x(varStarts(j)+6)) - (x(varStarts(j)+3)*x(varStarts(j)+4)))./((((x(varStarts(j)+5)*x(varStarts(j)+7)) - (x(varStarts(j)+4)*x(varStarts(j)+8))).*((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1))) + (((x(varStarts(j)+1)*x(varStarts(j)+8)) - (x(varStarts(j)+7)*x(varStarts(j)+8)) - (x(varStarts(j)+2)*x(varStarts(j)+7))).*((x(varStarts(i)+4)*ovlps{i,j}.tmp.x + x(varStarts(i)+5)*ovlps{i,j}.tmp.y + x(varStarts(i)+6))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1))) + (x(varStarts(j)+7).*x(varStarts(j)+8).*((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)).*((x(varStarts(i)+4)*ovlps{i,j}.tmp.x + x(varStarts(i)+5)*ovlps{i,j}.tmp.y + x(varStarts(i)+6))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1))) + (x(varStarts(j)+2).*x(varStarts(j)+4)) - (x(varStarts(j)+1).*x(varStarts(j)+5)));
                            xPar = ((((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1)) - x(varStarts(j)+3))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1))))) + ((((x(varStarts(j)+8).*((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1))) - x(varStarts(j)+2))./(x(varStarts(j)+1) - (x(varStarts(j)+7).*((x(varStarts(i)+1)*ovlps{i,j}.tmp.x + x(varStarts(i)+2)*ovlps{i,j}.tmp.y + x(varStarts(i)+3))./(x(varStarts(i)+7)*ovlps{i,j}.tmp.x + x(varStarts(i)+8)*ovlps{i,j}.tmp.y + 1))))).*yPar);
                    end
            end
            
%             figure();
%             scatter(ovlps{i,j}.im.x(:),ovlps{i,j}.im.y(:),3,ovlps{i,j}.im.val(:),'s','filled'); hold on; axis image;
%             scatter(xPar(:),yPar(:),3,'s','filled'); hold on;
            k = k+1;
            
            valPar = reshape(interp2(ovlps{i,j}.im.x,ovlps{i,j}.im.y,ovlps{i,j}.im.val,xPar,yPar,interpMethod),numel(ovlps{i,j}.tmp.x),1);
            %             diffs = valPar - ovlps{i,j}.tmp.val(:);
            %             iniLength = length(diffs);
            %
            %             [binCounts,binEdges] = histcounts(diffs);
            %             binCentres = (binEdges(1,1:(end-1)) + binEdges(1,2:end))./2;
            %             kMax = find(binCounts==max(binCounts),1);
            %
            %             leftDiffThrld = binCentres(kMax) - expThrld;
            %             rightDiffThrld = binCentres(kMax) + expThrld;
            %             ind = find((diffs>=leftDiffThrld) & (diffs<=rightDiffThrld));
            %             newLength = length(ind);
            %
            %             iStarts(k+1:end) = iStarts(k+1:end) - (iniLength-newLength);
            %
            %             fun(iStarts(k):(iStarts(k+1)-1),1) = diffs(ind);
            fun(iStarts(k):(iStarts(k+1)-1),1) = valPar - ovlps{i,j}.tmp.val(:);
        end
    end
end

% if (iStarts(k+1)-1)<length(fun)
%     fun(iStarts(k+1):end) = mean(abs(fun(1:(iStarts(k+1)-1))));
% end



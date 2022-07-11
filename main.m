%
% This matlab script demonstrates the work related to the paper titled:
% "Fine Alignment of Thermographic Images for Robotic Inspection of Parts
% with Complex Geometries", by C. Mineo, N. Montinaro, M. Fustaino,
% A. Pantano and D. Cerniglia.
%
% INSTRUCTIONS TO USE THIS DEMONSTRATION SCRIPT:
% In order to demonstrate the Fine Pixel-based Alignment Method (FiPAM),
% the present script is provided with the dataset of thermographic images
% presented in the journal paper. This script executes FiPAM and plots
% the results.
%
% DISCLAIMER: 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
% AUTHOR OF THIS DEMONSTRATION SCRIPT:
% Dr Carmelo Mineo
% Institute for High-Performance Computing and Networking, National
% Research Council of Italy, Palermo, 90146, Italy.
% email: carmelo.mineo@icar.cnr.it
% Website: https://www.icar.cnr.it/en/
% July 2022; Last revision: 10-07-2022
% Tested with: Matlab 2020b

%--------------------------------------------------------------------------
clear; clc; close all;  % Clear enviroment
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                    DEFINITION OF INPUT PARAMETERS                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Folder directory containing the figures. This script looks for .fig files
% that contain the plots of the images. The files have to be names as
% "i".fig, with i being the image index (starting from 1).
dataFolder = 'Datasets\curvedSampleWithGrid';

% FiPAM parameters
imPitch = 0.1499;  % Image pixel resolution (mm/pixel). Replace it with NaN
                   % if resolution is unknown (the script will prompt for
                   % interactive estimation of resolution).
                   
tol = 1.0;         % Tollerance [mm]

% Choose type of transform for each image. Please adjust the length of the
% cell array to match the number of images. Possible values are: 'translation',
% 'euclidean', 'similarity', 'affine' and 'homography'.
transforms = [];
transforms{1} = 'similarity';
transforms{2} = 'similarity';
transforms{3} = 'similarity';
transforms{4} = 'similarity';
transforms{5} = 'similarity';
transforms{6} = 'similarity';
transforms{7} = 'similarity';
transforms{8} = 'similarity';
transforms{9} = 'similarity';
transforms{10} = 'similarity';
transforms{11} = 'similarity';
transforms{12} = 'similarity';
transforms{13} = 'similarity';
transforms{14} = 'similarity';
transforms{15} = 'similarity';

interpMethod = 'linear';    % Image pixel interpolation method ('linear' of 'cubic')
multiStarts = 3;            % Number of starting values for each degree of freedom
maxStarts = 100;            % Max number of total starting values

exposureCorrection = true;  % TRUE = perform pixel intensity correction.
expThrld = 10;              % Threshold for maximum difference in pixel
                            % intensity. Pixel pairs with intensity
                            % value bigger than this are discarded (not
                            % considered in the objective function).
pyramidBlending = true;     % TRUE = perform Laplacian blending.


colorMap = 'hot';
cMin = -60;
cMax = -40;

%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  COUNT NUMBER OF IMAGES IN FOLDER AND LOAD IMAGE POSITION COORDINATES %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numTiles = F_countTiles(dataFolder);
if numTiles == 0
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  LOAD IMAGES/TILES %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist([dataFolder '\originalTiles.mat'],'file')
    load([dataFolder '\originalTiles.mat']);
else
    if isnan(imPitch)
        imPitch = F_estimateImPitch(dataFolder,1);
    end
    
    pixTol = tol./imPitch;
    
    poses = load([dataFolder '\poses.txt']);
    normPoses = [(poses(:,1) - min(poses(:,1))) (poses(:,2) - min(poses(:,2)))]./imPitch;
    
    [sourceTiles,x0,varStarts] = F_loadSourceTiles(dataFolder,numTiles,transforms,normPoses);
    save([dataFolder '\originalTiles.mat'],'sourceTiles','x0','varStarts','imPitch','tol','pixTol','normPoses');
end

hFig = F_plotTiles(sourceTiles,normPoses,colorMap,cMin,cMax,'Original tiles');


%%%%%%%%%%%%%%%%%%%%%%%%
%%%  IMAGE ALIGNMENT %%%
%%%%%%%%%%%%%%%%%%%%%%%%

if exist([dataFolder '\alignedTiles.mat'],'file')
    load([dataFolder '\alignedTiles.mat']);
    sourceTiles = alignedTiles;
else
    ovlps = F_getOverlaps(sourceTiles,pixTol,normPoses);
    [sourceTiles,~] = F_preliminaryIntensityCorrection(sourceTiles);
    [lb,ub] = F_computeBounds(transforms,ovlps,pixTol,x0,varStarts);
    [x,alignedTiles] = F_alignment(sourceTiles,ovlps,transforms,x0,lb,ub,varStarts,interpMethod,expThrld,maxStarts,multiStarts);
    
    save([dataFolder '\alignedTiles.mat'],'alignedTiles','x','varStarts','imPitch','tol');
    sourceTiles = alignedTiles;
end

hFig = F_plotTiles(alignedTiles,zeros(numTiles,2),colorMap,cMin,cMax,'Aligned tiles');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  PIXEL INTENSITY CORRECTION %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exposureCorrection
    if exist([dataFolder '\pixelCorrectedTiles.mat'],'file')
        load([dataFolder '\pixelCorrectedTiles.mat']);
        sourceTiles = pixelCorrectedTiles;
    else
        [pixelCorrectedTiles,xCorr] = F_pixelIntensityCorrection(sourceTiles,expThrld);
        save([dataFolder '\pixelCorrectedTiles.mat'],'pixelCorrectedTiles','xCorr');
        sourceTiles = pixelCorrectedTiles;
    end
end

hFig = F_plotTiles(pixelCorrectedTiles,zeros(numTiles,2),colorMap,cMin,cMax,'Pixel corrected tiles');


%%%%%%%%%%%%%%%%%
%%%  BLENDING %%%
%%%%%%%%%%%%%%%%%

if exist([dataFolder '\blendedPanorama.mat'],'file')
    load([dataFolder '\blendedPanorama.mat']);
else
    panorama = F_blending(sourceTiles,pyramidBlending);
    save([dataFolder '\blendedPanorama.mat'],'panorama');
end

hFig = F_plotPanorama(panorama,colorMap,cMin,cMax);

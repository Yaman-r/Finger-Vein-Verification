% The mathematical Model of the Retinal Ganglion Cells
% clc
% clear
% close all
% global   initContour contIndex newK newB windowSize index reqInd pos
% Parameters of RF cell
% disp('Building the orientation map ...');
% For center gaussian function
vc=4;            % The ratio r/sigma : vc must be >= 4 refer to the paper
rc=5;            % Radius of the center
sigmaC=rc/vc;    % standard deviation of the center
xc=-rc:rc;
yc=-rc:rc;
[xc,yc]=meshgrid(xc,yc);
zc=GaussFunc(sigmaC,xc,yc);

% For surround gaussian function
vs=10;            % The ratio r/sigma : vs must be >= 4 refer to the paper
rs=15;           % Radius of the surround
sigmaS=rs/vs;    % standard deviation of the surround
xs=-rs:1:rs;
ys=-rs:1:rs;
[xs,ys]=meshgrid(xs,ys);
zs=GaussFunc(sigmaS,xs,ys);

% center/surround ratio
rt=rc/rs;
% Compute response function
[respFunc,etaVal]=ComputeNormalizedRespFunc(rt);
% Maximum error
eMax=400;
%figure;plot(respFunc)

% Main Parameters
interval=3;          % distance between two cells in pixel

winBorder=windowSize+2*rs;
xi=1:interval:windowSize;
yi=1:interval:windowSize;
rfNum=length(xi)*length(yi);

% User image

%im(:,1:600,:)=[];
%im(:,2200:end,:)=[];
[n,m,dim]=size(im);
while mod(size(im,1),windowSize)~=0
    im(end,:,:)=[];
end
while mod(size(im,2),windowSize)~=0
    im(:,end,:)=[];
end
% imBin=im2bw(im,0.6);

% Apply median filter for removing noise
% imBin = medfilt2(imBin, [11 11]);
% imBin = medfilt2(imBin, [9 9]);
imBin = medfilt2(imBin, [5 5]);
% imshow(imBin)
big=1;
while rs>big*windowSize
    big=big+1;
end
imBin=padarray(imBin,[big*windowSize big*windowSize],0);


% Call Orientation Map code
OrientationMap
% figure;
% subplot(2,1,1);
% imshow(imBin);
% subplot(2,1,2);
% imshow(imOut);
return ;
rng('default');
% Find the squares that have line
index=find(~isnan(k));

% Convert each line segment into a node
[nodes,adjMat]=GeneratingNodes(k,b,windowSize,index);

% Find the initial contours
threshold=windowSize/2;
initContour=InitialContours(adjMat,threshold);
disp('Removing outliers ...')
RemovingOutliers;
disp('Optimization using genetic algorithm ...')
GeneticModifiedOrientationMap;

figure
imshow(imOut)
figure
imshow(imOut1)
figure
imshow(imOut2)

function features = getOrientationMap(imBin,windowSize)
    addpath orientationMap;
    imBin = imresize(imBin , 3);
%     windowSize=24;         % unit is pixel
    im=imBin;
    MainFile;
    [r c]=size(k);
    features = [reshape(k,[1 r*c]) reshape(b,[1 r*c])];
end
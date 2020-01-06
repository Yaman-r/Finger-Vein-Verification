[imBinageRows,imBinageCols]=size(imBin);     % size of user imBinage
n=imBinageRows/windowSize;                   % number of rows of patches
m=imBinageCols/windowSize;                   % number of columns of patches 
k=zeros(n,m);                                % slope of line
b=zeros(n,m);                                % constant of line
ekb=zeros(n,m);                              % error
resp=zeros(length(yi),length(xi));           % response of cells
d=zeros(length(yi),length(xi));              % refer to the paper
weights=zeros(length(yi),length(xi));        % refer to the paper

for i=big+1:n-big    % rows in the image
    for j=big+1:m-big    % columns in the image
        % Inside the window
        %window=imBin((i-1)*windowSize+1:(i-1)*windowSize+windowSize+2*rs,(j-1)*windowSize+1:(j-1)*windowSize+windowSize+2*rs);
        for h=1:length(yi)    % row in the window
            for g=1:length(xi)    % column in the window
                imageWinC=imBin(1+(h-1)*interval+(i-1)*windowSize-rc:1+(h-1)*interval+(i-1)*windowSize+rc,...
                    1+(g-1)*interval+(j-1)*windowSize-rc:1+(g-1)*interval+(j-1)*windowSize+rc);
                imageWinS=imBin(1+(h-1)*interval+(i-1)*windowSize-rs:1+(h-1)*interval+(i-1)*windowSize+rs,...
                    1+(g-1)*interval+(j-1)*windowSize-rs:1+(g-1)*interval+(j-1)*windowSize+rs);
                % check if the window from the same intensity
                sumS=sum(sum(imageWinS));
                if sumS==0 || sumS==(2*rs+1)^2
                    resp(h,g)=0;
                else
                    resp(h,g)=sum(sum(imageWinC.*zc))-sum(sum(imageWinS.*zs));
                end
                eta=ComputeEta(resp(h,g),respFunc,etaVal);
                [weights(h,g),d(h,g)]=ComputeWeights(eta,rs);                                               
            end
        end
        [b(i,j),k(i,j),ekb(i,j)]=ComputeLineCoff(weights,xi+(j-1)*windowSize,yi+(i-1)*windowSize,d,resp);
        %imOut=DrawLine(imOut,k(i,j),b(i,j),windowSize,(j-1)*windowSize,(i-1)*windowSize);
        lineWidth=1;
        %imOut=DrawShortLine(imOut,k(i,j),b(i,j),windowSize,i,j,lineWidth);
    end
end
% Remove the padding values
imBin(:,1:big*windowSize)=[];
imBin(1:big*windowSize,:)=[];
imBin(:,end-big*windowSize+1:end)=[];
imBin(end-big*windowSize+1:end,:)=[];

%imOut(:,1:big*windowSize)=[];
%imOut(1:big*windowSize,:)=[];
%imOut(:,end-big*windowSize+1:end)=[];
%imOut(end-big*windowSize+1:end,:)=[];

k(1:big,:)=[];
k(:,1:big)=[];
k(end-big+1:end,:)=[];
k(:,end-big+1:end)=[];

b(1:big,:)=[];
b(:,1:big)=[];
b(end-big+1:end,:)=[];
b(:,end-big+1:end)=[];
b=k*big*windowSize-big*windowSize+b;    % edit b values after changing the coordinates center

ekb(1:big,:)=[];
ekb(:,1:big)=[];
ekb(end-big+1:end,:)=[];
ekb(:,end-big+1:end)=[];

imOut=true(size(imBin));                     % Image contains orientation map
for i=1:size(k,1)    % rows in the image
    for j=1:size(k,2)    % columns in the image
        imOut=DrawShortLine(imOut,k(i,j),b(i,j),windowSize,i,j,lineWidth);
        imOut(1+(i-1)*windowSize,:)=0;
        imOut(2+(i-1)*windowSize,:)=0;
        imOut(3+(i-1)*windowSize,:)=0;
        imOut(:,1+(j-1)*windowSize)=0;
        imOut(:,2+(j-1)*windowSize)=0;
        imOut(:,3+(j-1)*windowSize)=0;
    end
end
%figure
% imshow(imOut)

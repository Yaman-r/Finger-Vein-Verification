% Find the squares that have line
index=find(~isnan(k));

% Convert each line segment into a node
[nodes,adjMat]=GeneratingNodes(k,b,windowSize,index);

% Find the initial contours
initContour=InitialContours(adjMat,threshold);

% Remove the short contours from orientation map
lengthThreshold=4;
counter=0;
unReq=zeros(1,length(initContour));
for i=1:length(initContour)
    if length(initContour{i})<=lengthThreshold
        counter=counter+1;
        unReq(counter)=i;
    end
end
unReq(counter+1:end)=[];
initContour(unReq)=[];

% Remove the short contours (outliers of objects) from orientation map
beforeSummation=zeros(1,length(initContour));
reqInd=[];
for i=1:length(initContour)
    longestCont=FindLongestContour(nodes,initContour{i},threshold);
    initContour{i}=initContour{i}(longestCont);
    reqInd=[reqInd initContour{i}];
    beforeSummation(i)=SumOfDistances(initContour{i},adjMat);
end

% Find the squares that have line after removing the outliers
for i=1:length(index)
    if isempty(find(i==reqInd))
        k(index(i))=NaN;
        b(index(i))=NaN;
    end
end
index=find(~isnan(k));

% Convert each line segment into a node
[nodes,adjMat]=GeneratingNodes(k,b,windowSize,index);

% Find the initial contours and arrange them
initContour=InitialContours(adjMat,threshold);
for i=1:length(initContour)
    longestCont=FindLongestContour(nodes,initContour{i},threshold);
    initContour{i}=initContour{i}(longestCont);
end

imOut1=true(size(imBin));                     % Image contains orientation map
for i=1:size(k,1)    % rows in the image
    for j=1:size(k,2)    % columns in the image
        imOut1=DrawShortLine(imOut1,k(i,j),b(i,j),windowSize,i,j,lineWidth);
%         imOut1(1+(i-1)*windowSize,:)=0;
%         imOut1(2+(i-1)*windowSize,:)=0;
%         imOut1(3+(i-1)*windowSize,:)=0;
%         imOut1(:,1+(j-1)*windowSize)=0;
%         imOut1(:,2+(j-1)*windowSize)=0;
%         imOut1(:,3+(j-1)*windowSize)=0;
    end
end
%figure
%imshow(imOut1)

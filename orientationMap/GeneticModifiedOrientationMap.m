for contIndex=1:length(initContour)
    try
newK=k;
[nodes,adjMat]=GeneratingNodes(k,b,windowSize,index);
reqInd=index(FindWorstCases(nodes,initContour{contIndex},windowSize/4));
[row,col]=ind2sub(size(k),reqInd);
lowerBound=zeros(1,length(reqInd));
higherBound=zeros(1,length(reqInd));
for i=1:length(reqInd)
    if k(reqInd(i))>=0
        lowerBound(i)=((1+(row(i)-1)*windowSize)-b(reqInd(i)))/(col(i)*windowSize);
        higherBound(i)=(row(i)*windowSize-b(reqInd(i)))/(1+(col(i)-1)*windowSize);
    else
        lowerBound(i)=((1+(row(i)-1)*windowSize)-b(reqInd(i)))/(1+(col(i)-1)*windowSize);
        higherBound(i)=((row(i)*windowSize)-b(reqInd(i)))/(col(i)*windowSize);
    end
end
lowerBound(lowerBound<-20)=-20;
higherBound(higherBound>20)=20;
options=gaoptimset('PlotFcns', @gaplotbestf,'Generations',300);%,'StallGenLimit',inf);
[chrom,minVal,flag]=ga(@ObjectiveFunc,length(reqInd),[],[],[],[],lowerBound,higherBound,[],options);
newK(reqInd)=chrom;
k=newK;
imOut2=true(size(imBin));
for i=1:size(k,1)
    for j=1:size(k,2)
        imOut2=DrawShortLine(imOut2,newK(i,j),b(i,j),windowSize,i,j,lineWidth);
        imOut2(1+(i-1)*windowSize,:)=0;
        imOut2(2+(i-1)*windowSize,:)=0;
        imOut2(3+(i-1)*windowSize,:)=0;
        imOut2(:,1+(j-1)*windowSize)=0;
        imOut2(:,2+(j-1)*windowSize)=0;
        imOut2(:,3+(j-1)*windowSize)=0;
    end
end
close all
%imshow(imOut2);

[newNodes,newAdjMat]=GeneratingNodes(newK,b,windowSize,index);
afterSummation=zeros(1,length(initContour));
for i=1:length(initContour)
    afterSummation(i)=SumOfDistances(initContour{i},newAdjMat);
end
    catch
        str=['Not necessary for the contour : ' num2str(contIndex)];
        disp(str)
    end
end
function fitVal=ObjectiveFunc(chrom)

global  newK b k windowSize reqInd index initContour contIndex
newK(reqInd)=chrom;
%[reqNodes,reqAdjMat]=GeneratingNodes(newK,b,windowSize,reqInd);
[reqNodes,reqAdjMat]=GeneratingNodes(newK,b,windowSize,index(initContour{contIndex}));
fitVal=0;
for i=1:length(reqAdjMat)
    col=reqAdjMat(:,i);
    col(i)=inf;
    neb1=find(min(col)==col,1);
    col(neb1)=inf;
    neb2=find(min(col)==col,1);
    [dis1,ind]=ComputeMinDistance(reqNodes(i),reqNodes(neb1));
    [dis2,ind]=ComputeMinDistance(reqNodes(i),reqNodes(neb2));
    fitVal=fitVal+dis1+dis2;
end
end

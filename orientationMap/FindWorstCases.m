function reqInd=FindWorstCases(nodes,initContour,threshold)
% Find the longest connected contour
% nodes is a variable containing the required nodes
nodes=nodes(initContour);
adjMat=zeros(length(nodes),length(nodes));
for i=1:length(nodes)
    for j=1:length(nodes)    
        adjMat(i,j)=ComputeMinDistance(nodes(i),nodes(j));
    end
end

reqInd=zeros(1,length(nodes));
counter=0;
for i=1:length(nodes)
    row=adjMat(i,:);
    row(i)=inf;
    neb1=find(row==min(row),1);
    summation=row(neb1);
    row(neb1)=inf;
    neb2=find(row==min(row),1);
    summation=summation+row(neb2);
    if summation>threshold
        counter=counter+1;
        reqInd(counter)=initContour(i);        
    end
end
reqInd(counter+1:end)=[];
end
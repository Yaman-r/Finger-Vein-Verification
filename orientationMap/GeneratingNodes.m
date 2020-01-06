function [nodes,adjMat]=GeneratingNodes(k,b,winSize,ind)

numberOfNodes=length(ind);

%Representing each line by a node
for i=1:numberOfNodes
    [row,col]=ind2sub(size(k),ind(i));
    x=1+(col-1)*winSize:col*winSize;
    yWin=1+(row-1)*winSize:row*winSize;
    y=round(k(ind(i))*x+b(ind(i)));
    x(y<yWin(1) | y>yWin(winSize))=[];
    if isempty(x)
        x=1+(col-1)*winSize:col*winSize;
        y=ceil(k(ind(i))*x+b(ind(i)));
        x(y<yWin(1) | y>yWin(winSize))=[];
        if isempty(x)
            x=1+(col-1)*winSize:col*winSize;
            y=floor(k(ind(i))*x+b(ind(i)));
            x(y<yWin(1) | y>yWin(winSize))=[];
        end
    end
    y(y<yWin(1) | y>yWin(winSize))=[];
    nodes(i)=struct('number',i,'start',[x(1) y(1)],'end',[x(length(x)) y(length(y))],'slope',k(ind(i)),'bias',b(ind(i)));
    
end

%Computing Adjacency Matrix
adjMat=zeros(length(ind),length(ind));
for i=1:length(ind)
    for j=1:length(ind)    
        adjMat(i,j)=ComputeMinDistance(nodes(i),nodes(j));
    end
end
%adjMat=adjMat./ max(max(adjMat));

end




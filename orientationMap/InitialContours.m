function initContour=InitialContours(adjMat,threshold)
% This function will extract each connected graph in the image
nodes=1:length(adjMat);
initContour=cell(length(adjMat),1);
numOfCont=0;

while ~isempty(nodes)
    numOfCont=numOfCont+1;
    initContour{numOfCont}=nodes(1);
    elemPtr=0;
    elemNum=length(initContour{numOfCont});
    while elemPtr<elemNum
        elemPtr=elemPtr+1;
        elem=initContour{numOfCont}(elemPtr);
        index=find(adjMat(:,elem)<=threshold);
        % Remove any duplicate elements
        for i=1:length(initContour{numOfCont})
            index(index==initContour{numOfCont}(i))=[];
        end
        initContour{numOfCont}=[initContour{numOfCont} index'];
        elemNum=length(initContour{numOfCont});
    end
    % Remove this connected graph from the whole graph
    for i=1:length(initContour{numOfCont})
        nodes(nodes==initContour{numOfCont}(i))=[];
    end
end
initContour(numOfCont+1:end,:)=[];    % Remove empty fields
end
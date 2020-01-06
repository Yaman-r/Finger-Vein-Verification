function [longestCont]=FindLongestContour(nodes,contour,threshold)
% Find the longest connected contour
% nodes is a variable containing the required nodes
nodes=nodes(contour);
adjMat=zeros(length(nodes),length(nodes));
connectedGraph=cell(length(nodes),1);    % cell array contains the neighbours of each item
distSum=zeros(1,length(nodes));
% Find the adjacency matrix
for i=1:length(nodes)
    for j=1:length(nodes)    
        adjMat(i,j)=ComputeMinDistance(nodes(i),nodes(j));
    end
    row=adjMat(i,:);
    connectedGraph{i}=find(row<=threshold & row~=0);
    row(i)=inf;
    temp1=row(find(row==min(row),1));
    row(find(row==min(row),1))=inf;
    temp2=row(find(row==min(row),1));
    distSum(i)=temp1+temp2;
end

% Find the best case of this line which has minimum distance with the
% neighbours
seed=find(distSum==min(distSum),1);

searchCell=cell(1000000,2);
searchCounter=1;
searchCell{1,1}=seed;
searchCell{1,2}=1;
distSum=inf(1000000,1);
while true
    counterOfTer=0;
    for i=1:searchCounter
        if searchCell{i,2}==1
            elem=searchCell{i,1}(end);
            neb=connectedGraph{elem};
            % Delete the repeated elements from neighbours
            for j=1:length(neb)
                if ~isempty(find(neb(j)==searchCell{i,1})) 
                    neb(j)=0;
                end
            end
            neb(neb==0)=[];
            if isempty(neb)
                % There are no new neighbours
                searchCell{i,2}=0;
               % if %ComputeMinDistance(nodes(searchCell{i,1}(1)),nodes(searchCell{i,1}(end)))<=threshold ...
                if length(searchCell{i,1})>0.5*length(nodes)
                    distSum(i)=SumOfDistances(searchCell{i,1},adjMat);
                end
            else
                % Create new record for the new neighbours
                for j=length(neb):-1:1
                    if j==1
                       % Add a neighbour to the same record
                       searchCell{i,1}=[searchCell{i,1} neb(1)];
                       neb(1)=[];
                    else
                        searchCounter=searchCounter+1;
                        searchCell{searchCounter,1}=[searchCell{i,1} neb(j)];
                        searchCell{searchCounter,2}=1;
                    end
                end
            end
        else
            counterOfTer=counterOfTer+1;
        end
    end
    if counterOfTer==searchCounter
        break;
    end
end
searchCell(searchCounter+1:end,:)=[];
distSum(searchCounter+1:end,:)=[];
longestCont=searchCell{find(distSum==min(distSum))};

end
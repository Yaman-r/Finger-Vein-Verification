function [trainData,testData] = splitDataset(dataset,innClass , normalize)
% split dataset into training and testing sets
% for each class training data contains 4 records and testing data contains
% two records selected ranomly
    dataset( find(dataset(:,end) ~= innClass) , :) =[];
    dataset(:,end) =[];
    dataset(find(isnan(dataset))) = -1;
    target= dataset(:,end);
    dataset(:,end)=[];
    if normalize == 1
        dataset = Normalize(dataset,-1,+1);
    end
    dataset = [dataset target];
    nClass = length(unique(dataset(:,end)));
    trainData = [];
    testData = [];
    for i = 1:nClass
       ids = find(dataset(:,end) == i);
       len = length(ids);
       randperm(len);
       len = floor(len/2)+1;
       trainData = [trainData;dataset(ids(1:len),:)];
       testData = [testData;dataset(ids(len+1:end),:)];
    end
end
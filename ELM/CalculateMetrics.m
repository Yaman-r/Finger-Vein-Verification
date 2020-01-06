function [confusionMatrix,tableOfConfusion,accuracy,precision,recall,overall] = CalculateMetrics(numberOfClasses,targets,outputs)

% Initializing variables
confusionMatrix = zeros(numberOfClasses);
tableOfConfusion = zeros(2,2,numberOfClasses);
accuracy = zeros(1,numberOfClasses);
precision = zeros(1,numberOfClasses);
recall = zeros(1,numberOfClasses);
TP = zeros(1,numberOfClasses);
FN = zeros(1,numberOfClasses);
FP = zeros(1,numberOfClasses);
TN = zeros(1,numberOfClasses);

for i = 1:numberOfClasses
    T = targets(targets==i);
    O = outputs(targets==i);
    Oprime = outputs(targets~=i);
    % Constitute confusion matrix
    for j = 1:numberOfClasses
        confusionMatrix(i,j) = (length(find(O==j)))/(length(T));
    end
    % Constitute table of confusion
    tableOfConfusion(1,1,i) = length(find(O==i));      % True Positive
    tableOfConfusion(2,1,i) = length(find(O~=i));      % False Negative
    tableOfConfusion(1,2,i) = length(find(Oprime==i)); % False Positive
    tableOfConfusion(2,2,i) = length(find(Oprime~=i)); % True Negative
    
    % Use shortcuts for easy work
    TP(i) = tableOfConfusion(1,1,i);
    FN(i) = tableOfConfusion(2,1,i);
    FP(i) = tableOfConfusion(1,2,i);
    TN(i) = tableOfConfusion(2,2,i);

    % Compute accuracy
    accuracy(i) = (TP(i)+TN(i))/(TP(i)+FN(i)+FP(i)+TN(i));
    % Compute precision or positive predictive value  (PPV)
    precision(i) = TP(i)/(TP(i)+FP(i));
    % Compute sensitivity, recall or True Positive rate (TPR)
    recall(i) = TP(i)/(TP(i)+FN(i));
end

tableOfConfusion =[];
tableOfConfusion.TP = TP;
tableOfConfusion.TN = TN;
tableOfConfusion.FP = FP;
tableOfConfusion.FN = FN;
overall.Precision = sum(TP)/sum(TP+FP);
overall.Recall = sum(TP)/sum(TP+FN);
overall.F_Measure = (2*overall.Precision*overall.Recall)/(overall.Precision+overall.Recall);
overall.G_Mean = prod(accuracy);

end
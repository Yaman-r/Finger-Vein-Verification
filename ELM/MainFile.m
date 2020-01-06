clc
clear all

SplitTheDataset;

%% Loading Training dataset & Testing dataset

load('dataset.mat');

%% Input Parameters

ElmType = 1;
numberOfHiddenNeurons = 40;
activationFunctionType = 'sig';
numberOfClasses = 5;

%% Calling ELM function

tic;

[trainingAccuracy,testingAccuracy,train,test] = ...
    ELM(trainingData,testingData,ElmType,numberOfHiddenNeurons,activationFunctionType,numberOfClasses);

elapsedTime = toc;

%% Results

clc
disp(['Training Accuracy is: ' num2str(trainingAccuracy)]);
disp(['Testing Accuracy is: ' num2str(testingAccuracy)]);

%% Calculate metrics

[trainResult.confusionMatrix,trainResult.tableOfConfusion,trainResult.accuracy,trainResult.precision,trainResult.recall,trainResult.overall] = ...
    CalculateMetrics(numberOfClasses,train.Target,train.Output);

[trainResult2.confusionMatrix,trainResult2.tableOfConfusion,trainResult2.accuracy,trainResult2.precision,trainResult2.recall,trainResult2.overall] = ...
    CalculateMetricsAs2Classes(train.Target,train.Output);

[testResult.confusionMatrix,testResult.tableOfConfusion,testResult.accuracy,testResult.precision,testResult.recall,testResult.overall] = ...
    CalculateMetrics(numberOfClasses,test.Target,test.Output);

[testResult2.confusionMatrix,testResult2.tableOfConfusion,testResult2.accuracy,testResult2.precision,testResult2.recall,testResult2.overall] = ...
    CalculateMetricsAs2Classes(test.Target,test.Output);

[trainingAccuracy2,testingAccuracy2] = CalculateAccuracyAs2Classes(train,test);

%% Save results

save(['Basic_ELM_' activationFunctionType]);

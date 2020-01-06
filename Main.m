clear all
clc;
close all;
addpath 'ELM';
rng(1331);

% ELM & SVM classifier on the datasets extracted by scripts :
% ExtractFeaturesHOG.m , ExtractFeaturesOrientationMap.m

%%  load datasets
% discriptor = 'histogram';
discriptor = 'orientationMap';
load(['dataset/datasetWLD_' discriptor '.mat'],'datasetWLD');
load(['dataset/datasetMC_' discriptor '.mat'],'datasetMC');
load(['dataset/datasetRL_' discriptor '.mat'],'datasetRL');

type = 1 ;% for ELM
% type = 0; % for SVM
nClass =106;  % number of classes ( persons) in the dataset
%% ELM classifier
if type == 1
activationFunction = 'sig';
for nHiddenNeurons = 5000:1000:5000

for innerClass=3:3
    [trainData,testData] = splitDataset(datasetMC,innerClass,0);
    [trainingAccuracy,testingAccuracy,train,test] = ...
        ELM(trainData,testData,1,nHiddenNeurons,activationFunction,nClass);
    [~,tableOfConfusion,~,~,~,~] = ...
        CalculateMetrics(nClass,test.Target,test.Output);
%     ELM_MC(innerClass).train = train;
%     ELM_MC(innerClass).test = test;
    testingAccuracy
    ELM_MC(innerClass).trainingAccuracy = trainingAccuracy;
    ELM_MC(innerClass).testingAccuracy = testingAccuracy;
    ELM_MC(innerClass).tableOfConfusion = tableOfConfusion;
    
    [trainData,testData] = splitDataset(datasetRL,innerClass,0);
    [trainingAccuracy,testingAccuracy,train,test] = ...
        ELM(trainData,testData,1,nHiddenNeurons,activationFunction,nClass);
    [~,tableOfConfusion,~,~,~,~] = ...
        CalculateMetrics(nClass,test.Target,test.Output);
%     ELM_RL(innerClass).train = train;
%     ELM_RL(innerClass).test = test;
    testingAccuracy
    ELM_RL(innerClass).trainingAccuracy = trainingAccuracy;
    ELM_RL(innerClass).testingAccuracy = testingAccuracy;
    ELM_RL(innerClass).tableOfConfusion = tableOfConfusion;
    
    [trainData,testData] = splitDataset(datasetWLD,innerClass,0);
    [trainingAccuracy,testingAccuracy,train,test] = ...
        ELM(trainData,testData,1,nHiddenNeurons,activationFunction,nClass);
    [~,tableOfConfusion,~,~,~,~] = ...
        CalculateMetrics(nClass,test.Target,test.Output);
%     ELM_WLD(innerClass).train = train;
%     ELM_WLD(innerClass).test = test;
    testingAccuracy
    ELM_WLD(innerClass).trainingAccuracy = trainingAccuracy;
    ELM_WLD(innerClass).testingAccuracy = testingAccuracy;
    ELM_WLD(innerClass).tableOfConfusion = tableOfConfusion;
end
% save(['results/ELM_OM_' activationFunction '_' num2str(nHiddenNeurons)] ...
%     ,'ELM_WLD','ELM_RL','ELM_MC','nHiddenNeurons','activationFunction');
end
end

%% SVM classifier
if(type == 0)
kernel  = 'polynomial';
for innerClass=1:6
    [trainData,testData] = splitDataset(datasetMC,innerClass,1);
    SVM = svm.train(trainData(:,1:end-1),trainData(:,end), 'kernel_function', kernel ...
    ,'rbf_sigma',15,'polyorder',2);
    trainOut = svm.predict(SVM,trainData(:,1:end-1));
    testOut = svm.predict(SVM,testData(:,1:end-1));
    trainingAccuracy=mean(trainData(:,end)==trainOut)*100;
    trainingAccuracy = round(trainingAccuracy , 3);
    testingAccuracy=mean(testData(:,end)==testOut)*100;
    testingAccuracy = round(testingAccuracy , 3);
    [~,tableOfConfusion,~,~,~,~] = ...
        CalculateMetrics(nClass,testData(:,end),testOut);
    SVM_MC(innerClass).trainingAccuracy = trainingAccuracy;
    SVM_MC(innerClass).testingAccuracy = testingAccuracy;
    SVM_MC(innerClass).tableOfConfusion = tableOfConfusion;
    
    [trainData,testData] = splitDataset(datasetRL,innerClass,1);
    SVM = svm.train(trainData(:,1:end-1),trainData(:,end), 'kernel_function', kernel ...
    ,'rbf_sigma',15,'polyorder',2);
    trainOut = svm.predict(SVM,trainData(:,1:end-1));
    testOut = svm.predict(SVM,testData(:,1:end-1));
    trainingAccuracy=mean(trainData(:,end)==trainOut)*100;
    trainingAccuracy = round(trainingAccuracy , 3);
    testingAccuracy=mean(testData(:,end)==testOut)*100;
    testingAccuracy = round(testingAccuracy , 3);
    [~,tableOfCon   fusion,~,~,~,~] = ...
        CalculateMetrics(nClass,testData(:,end),testOut);
    SVM_RL(innerClass).trainingAccuracy = trainingAccuracy;
    SVM_RL(innerClass).testingAccuracy = testingAccuracy;
    SVM_RL(innerClass).tableOfConfusion = tableOfConfusion;
    
    [trainData,testData] = splitDataset(datasetWLD,innerClass,1);
    SVM = svm.train(trainData(:,1:end-1),trainData(:,end), 'kernel_function', kernel ...
    ,'rbf_sigma',15,'polyorder',2);
    trainOut = svm.predict(SVM,trainData(:,1:end-1));
    testOut = svm.predict(SVM,testData(:,1:end-1));
    trainingAccuracy=mean(trainData(:,end)==trainOut)*100;
    trainingAccuracy = round(trainingAccuracy , 3);
    testingAccuracy=mean(testData(:,end)==testOut)*100;
    testingAccuracy = round(testingAccuracy , 3);
    [~,tableOfConfusion,~,~,~,~] = ...
        CalculateMetrics(nClass,testData(:,end),testOut);
    SVM_WLD(innerClass).trainingAccuracy = trainingAccuracy;
    SVM_WLD(innerClass).testingAccuracy = testingAccuracy;
    SVM_WLD(innerClass).tableOfConfusion = tableOfConfusion;
end
% save(['results/SVM_OM_' kernel] , 'SVM_WLD','SVM_RL','SVM_MC');
end
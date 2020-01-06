clear all
clc;
close all;
addpath 'ELM';

% this code to test SVM and ELM classifiers
% rng(1331);
%% load dataset
load('dataset/datasetMC_histogram.mat');
load('dataset/datasetWLD_histogram.mat');
load('dataset/datasetRL_histogram.mat');
% load('dataset/datasetMC_orientationMap.mat');
% dataset = datasetMC;
% dataset = datasetRL;
% dataset = datasetWLD;
% load('dataset/datasetMC2.mat');
dataset = datasetMC;

innerclass = 3; % choose innerclass from [1 2 3 4 5 6]
%% split the dataset
[trainData,testData] = splitDataset(datasetMC,innerclass,0);
nClass=106;
%% SVM classifier
kernel  = 'linear';
SVM = svm.train(trainData(:,1:end-1),trainData(:,end), 'kernel_function', kernel ...
    ,'rbf_sigma',15);
trainOut = svm.predict(SVM,trainData(:,1:end-1));
testOut = svm.predict(SVM,testData(:,1:end-1));

Accuracy=mean(trainData(:,end)==trainOut)*100;
Accuracy = round(Accuracy , 3);
fprintf('\n Training Accuracy =%f \n',Accuracy)

Accuracy=mean(testData(:,end)==testOut)*100;
Accuracy = round(Accuracy , 3);
fprintf('\n Testing Accuracy =%f \n',Accuracy)

return ;
%% ELM classifier
nHiddenNeurons = 5000;
activationFunction = 'hardlim';
[trainingAccuracy,testingAccuracy,train,test] = ...
    ELM(trainData,testData,1,nHiddenNeurons,activationFunction,nClass);
testingAccuracy
trainingAccuracy
[confusionMatrix,tableOfConfusion,accuracy,precision,recall,overall] = ...
    CalculateMetrics(nClass,test.Target,test.Output);

return ;
bar([testingAccuracy mean(tableOfConfusion.TP) mean(tableOfConfusion.TP) ...
    mean(tableOfConfusion.FP) mean(tableOfConfusion.FN)]);


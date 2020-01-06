function [trainingAccuracy,testingAccuracy,train,test] = ELM(trainingData,testingData,ElmType,numberOfHiddenNeurons,activationFunctionType,numberOfClasses)

% Usage: [trainingAccuracy,testingAccuracy,train,test] = ELM(trainingData,testingData,ElmType,numberofHiddenNeurons,activationFunctionType,numberOfClasses)
%------------------------------------------------------------------------------------------------------------
% Input:
%-------
% trainingData              - Training data set
% testingData               - Testing data set
% ElmType                   - 0 for regression; 1 for (both binary and multi-classes) classification
% numberofHiddenNeurons     - Number of hidden neurons assigned to the ELM
% activationFunctionType    - Type of activation function:
%                               'sig' for Sigmoidal function
%                               'sin' for Sine function
%                               'hardlim' for Hardlim function
%                               'tribas' for Triangular basis function
%                               'radbas' for Radial basis function (for additive type of SLFNs instead of RBF type of SLFNs)
% numberOfClasses           - Number of needed classes 
%------------------------------------------------------------------------------------------------------------
% Output: 
%--------
% trainingAccuracy          - Training accuracy: 
%                               RMSE for regression or correct classification rate for classification
% testingAccuracy           - Testing accuracy: 
%                               RMSE for regression or correct classification rate for classification
% train                     - structure contains the actual outputs and targets of training dataset
% test                      - structure contains the actual outputs and targets of testing dataset
%------------------------------------------------------------------------------------------------------------
% MULTI-CLASSE CLASSIFICATION: NUMBER OF OUTPUT NEURONS WILL BE AUTOMATICALLY SET EQUAL TO NUMBER OF CLASSES
% FOR EXAMPLE, if there are 7 classes in all, there will have 7 output neurons 
% (for example, if neuron 5 has the highest output means input belongs to 5-th class)
%------------------------------------------------------------------------------------------------------------

%% Macro definition

REGRESSION = 0;
CLASSIFIER = 1;

%% Preparing datasets

% Training dataset
trainDat.Target = trainingData(:,size(trainingData,2))';
trainDat.Input = trainingData(:,1:size(trainingData,2)-1)';

% Testing dataset
testDat.Target = testingData(:,size(testingData,2))';
testDat.Input = testingData(:,1:size(testingData,2)-1)';

numberOfTrainingData = size(trainDat.Input,2);
numberOfTestingData = size(testDat.Input,2);
numberOfInputNeurons = size(trainDat.Input,1);

%% Processing the targets of training dataset

if ElmType==CLASSIFIER
    tempTrain = zeros(numberOfClasses,numberOfTrainingData);
    ind = sub2ind(size(tempTrain),trainDat.Target,1:numberOfTrainingData);
    tempTrain(ind) = 1;
    trainDat.ProcessedTarget = tempTrain*2-1;
end

%% Generating the Hidden Layer Output Matrix (H)

% Random generating of the input weight matrix and the biases of hidden neurons
W_in = rand(numberOfHiddenNeurons,numberOfInputNeurons)*2-1;
biasOfHiddenNeurons = rand(numberOfHiddenNeurons,1);

% For training dataset
tempH_train = W_in*trainDat.Input;                                       
biasMatrix = repmat(biasOfHiddenNeurons,1,numberOfTrainingData); % Extend the bias matrix to match the demention of H
tempH_train = tempH_train+biasMatrix;
H_train = ActivationFunction(tempH_train,activationFunctionType);

% For testing dataset
tempH_test = W_in*testDat.Input;
biasMatrix = repmat(biasOfHiddenNeurons,1,numberOfTestingData);
tempH_test = tempH_test+biasMatrix;
H_test = ActivationFunction(tempH_test,activationFunctionType);

%% Calculate the output weight matrix

if ElmType==CLASSIFIER
    OutputWeights = trainDat.ProcessedTarget*pinv(H_train);
elseif ElmType==REGRESSION
    OutputWeights = trainDat.Target*pinv(H_train);
end

%% Calculate the actual output of training and testing data

ActualOutputOfTrainData = OutputWeights*H_train; 
ActualOutputOfTestData = OutputWeights*H_test;    

%% Calculate training accurcy & testing accurcy

if ElmType==REGRESSION
    % Calculate training accuracy (RMSE)
    trainingAccuracy = sqrt(mse(trainDat.Target-ActualOutputOfTrainData));
    % Calculate testing accuracy (RMSE)
    testingAccuracy = sqrt(mse(testDat.Target-ActualOutputOfTestData));
elseif ElmType==CLASSIFIER
    % Calculate training accuracy
    [~,labelIndexActualTrain] = max(ActualOutputOfTrainData);
    trainingAccuracy = 1-(length(find(trainDat.Target~=labelIndexActualTrain))/numberOfTrainingData);
    % Calculate testing accuracy
    [~,labelIndexActualTest] = max(ActualOutputOfTestData);
    testingAccuracy = 1-(length(find(testDat.Target~=labelIndexActualTest))/numberOfTestingData);    
end

%% Outputs and Targets

train.Target = trainDat.Target;
test.Target = testDat.Target;
if ElmType==CLASSIFIER
    train.Output = labelIndexActualTrain;
    test.Output = labelIndexActualTest;
elseif ElmType==REGRESSION
    train.Output = ActualOutputOfTrainData;
    test.Output = ActualOutputOfTestData;
end

end
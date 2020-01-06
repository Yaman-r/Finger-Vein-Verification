clc
clear all

x=-4*pi:0.01:4*pi;
y=sin(x);
data=[x' y'];
Ratio=0.01;
trainingIndex=randi([1 size(data,1)],round(size(data,1)*Ratio),1);
trainingData=data(trainingIndex,:);
data(trainingIndex,:)=[];
testingData=data;
ElmType=0;
numberOfHiddenNeurons=15;
activationFunctionType='sig';
 [trainingAccuracy,testingAccuracy,train,test] =...
    ELM(trainingData,testingData,ElmType,numberOfHiddenNeurons,...
    activationFunctionType);

plot(testingData(:,1),test.Output)

class1=rand(100,2)+[5*ones(size(rand(100,1))) 3*ones(size(rand(100,1)))];
plot(class1(:,1),class1(:,2),'*')
axis([-10 10 -10 10])


class2=rand(100,2)+[2*ones(size(rand(100,1))) -3*ones(size(rand(100,1)))];

class3=rand(100,2)+[-2*ones(size(rand(100,1))) 2*ones(size(rand(100,1)))];

plot(class1(:,1),class1(:,2),'*')
hold on 
plot(class2(:,1),class2(:,2),'*')
plot(class3(:,1),class3(:,2),'*')

axis([-10 10 -10 10])

data=[class1 ones(size(class1(:,1)));class2 2*ones(size(class1(:,1)));class3 3*ones(size(class1(:,1)))];

Ratio=0.5;
trainingIndex=randi([1 size(data,1)],round(size(data,1)*Ratio),1);
trainingData=data(trainingIndex,:);
data(trainingIndex,:)=[];
testingData=data;

ElmType=1;
numberOfHiddenNeurons=2;
activationFunctionType='sig';
numberOfClasses=3;
 [trainingAccuracy,testingAccuracy,train,test] =...
    ELM(trainingData,testingData,ElmType,numberOfHiddenNeurons,...
    activationFunctionType,numberOfClasses);


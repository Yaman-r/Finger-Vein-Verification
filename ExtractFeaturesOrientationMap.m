close all
clear all
clc

Database = '../Results/Images';
hand = {'left','right'};

datasetWLD = [];
datasetMC = [];
datasetRL = [];

% orientationMap parameters
windowSize = 16;

labels = dir(Database);
labels(1:2)=[];
% 
% img = imread([Database '/007/left/ring_1_RL.bmp']);
% getOrientationMap(img,windowSize);
% return ;
tic;
for person = 5:length(labels);
    for h=1:2
        images = dir([Database '/' labels(person).name '/' hand{h} '/*.bmp']);
        for i =1:length(images)
            img=imread([Database '/' labels(person).name '/' hand{h} '/' images(i).name]);
            disp([Database '/' labels(person).name '/' hand{h} '/' images(i).name]);
            innerClass = innerclass(images(i).name,h);
            name=images(i).name;
            name(end-3:end)=[];
            if innerClass ~= 2
                continue; 
            end
            if strcmp(name(end-1:end),'mc') == 1
                features= getOrientationMap(img,windowSize);
                features=[features person innerClass];
                datasetMC=[datasetMC;features];
            elseif strcmp(name(end-1:end),'rl') == 1
                features= getOrientationMap(img,windowSize);
                features=[features person innerClass];
                datasetRL=[datasetRL;features];
            elseif strcmp(name(end-2:end),'wld') == 1
                features= getOrientationMap(img,windowSize);
                features=[features person innerClass];
                datasetWLD=[datasetWLD;features];
            end
        end
    end
end
toc;
save('datasetMC_orientationMap3.mat','datasetMC','windowSize');
save('datasetRL_orientationMap3.mat','datasetRL','windowSize');
save('datasetWLD_orientationMap3.mat','datasetWLD','windowSize');
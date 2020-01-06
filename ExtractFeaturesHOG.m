close all
clear all
clc

Database = '../Dataset/Finger Vein Database';
hand = {'left','right'};

datasetWLD = [];
datasetMC = [];
datasetRL = [];

% HOG parameters
cellSize = [8,16];
blockSize = [1,1];
blockOverlap = [0 0];
numBins = 12;

labels = dir(Database);
labels(1:2)=[];

tic;
for person = 1:length(labels);
    for h=1:2
        images = dir([Database '/' labels(person).name '/' hand{h} '/*.bmp']);
        for i =1:length(images)
            img=imread([Database '/' labels(person).name '/' hand{h} '/' images(i).name]);
            disp([Database '/' labels(person).name '/' hand{h} '/' images(i).name]);
            innerClass = innerclass(images(i).name,h);
            path = ['../Results/Imagges/' labels(person).name '/' hand{h} '/'];
            name=images(i).name;
            name(end-3:end)=[];
            %% pre-processing
            img = im2double(img);
%             img = rgb2gray(img);
%             img = imresize(img,0.4);               % Downscale image
            fvr = lee_region(img,4,40);    % Get finger region
            H=size(img,1);
            img(H-15:H,:)=[];fvr(H-15:H,:)=[];
            img(1:16,:)=[];fvr(1:16,:)=[];
%             imwrite(img , ['../Results/Imagges/' labels(person).name '/' hand{h} '/' images(i).name]);
            %%  WLD
            r = 7;g = 0.50;t = 1;
            tic;
            wld = WideLineDetector(im2uint8(img) ,r,g,t);
            wld = min(wld,fvr);
            
%             wld = mesdfilt2(wld,[3 3]);
            wld = wld > 0;
            
            [featureVectorWLD,hogVisualization] = extractHOGFeatures(...
            wld,'CellSize',cellSize,'BlockSize',blockSize,...
            'BlockOverlap',blockOverlap,'NumBins',numBins);
        
        
            featureVectorWLD = [featureVectorWLD person innerClass];
            datasetWLD=[datasetWLD;featureVectorWLD];
            
%             imwrite(wld,[path name '_wld.bmp']);
            %% repeated line 
%             tic;
            max_iterations = 3000; r=1; W=17; % Parameters
            v_repeated_line = repeated_line_tracking(img,fvr,3000,r,W);
            md = median(v_repeated_line(v_repeated_line>0));
            repeatedLine = v_repeated_line > md;
            
            [featureVectorRL,hogVisualization] = extractHOGFeatures(...
            repeatedLine,'CellSize',cellSize,'BlockSize',blockSize,...
            'BlockOverlap',blockOverlap,'NumBins',numBins);
            featureVectorRL = [featureVectorRL person innerClass];
            datasetRL=[datasetRL;featureVectorRL];
%             
%             imwrite(repeatedLine,[path name '_rl.bmp']);
            %% maximum curvaature
            sigma = 3; % Parameter
            v_max_curvature = max_curvature(img,fvr,sigma,0);
            md = median(v_max_curvature(v_max_curvature>0));
            maxCurvature = v_max_curvature >= md; 
            
            [featureVectorMC,hogVisualization] = extractHOGFeatures(...
            v_max_curvature,'CellSize',cellSize,'BlockSize',blockSize,...
            'BlockOverlap',blockOverlap,'NumBins',numBins);
            featureVectorMC = [featureVectorMC person innerClass];
            datasetMC=[datasetMC;featureVectorMC];
            
%             imwrite(maxCurvature,[path name '_mc.bmp']);
          
        end
    end
    
end
toc;


save('datasetRL.mat','datasetRL');
 save('datasetMC.mat','datasetMC');
save('datasetWLD.mat','datasetWLD');



foldernc = 'C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\CroppedImages\nc\';
foldercar = 'C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\CroppedImages\car\';
I=imread('C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\CroppedImages\nc\nc201.png');
folderCarTest = 'C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\TestData\car_final_1002cars\';
folderNcTest  = 'C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\TestData\nc_final_1003noncars\';
ncTestData=zeros(64,64,3,2202); % 3D with singleton or 4D 
for t= 1200:2202
    ncname=strcat(folderNcTest,'nc_',num2str(t),'.png');
    f = imread(ncname);
    ncTestData(:,:,:,t-1200+1)=imresize(f ,[64,64]);
end
 [r n p]=size(I);  % Your Images are either 2D or 3D
 
 
 numbernc = 587;
 ncData=zeros(64,64,3,numbernc); % 3D with singleton or 4D 
 
 %%
 for x=1:numbernc
 filename=strcat(foldernc,'nc',num2str(x+200),'.png');
 f = imread(filename);
 ncData(:,:,:,x)=imresize(f ,[64,64]);
 end
 %%
  numbercar = 515;
 carData=zeros(64,64,3,numbercar); % 3D with singleton or 4D 
 
 for x=1:numbercar
 filename=strcat(foldercar,'car',num2str(x+200),'.png');
 f = imread(filename);
 carData(:,:,:,x)=imresize(f ,[64,64]);
 end
 %%
 rand01 = rand(587+515,1);
 randnc = rand(587,1);
 randcar= rand(515,1);
 
 rand01 = rand01.*(587+515-1);
 rand01 = uint32(rand01);
 
 
 imData = ones(64,64,3,587+515);
 %%
 imData2 = ones(64,64,3,587+515);
 imData2(:,:,:,1:587)= ncData(:,:,:,:);
 imData2(:,:,:,588:end)= carData(:,:,:,:);
 %%
 imData3 = ones(64,64,3,(587+515)*2);
 imData3(:,:,:,1:587)= ncData(:,:,:,:);
 imData3(:,:,:,588:587+515)= carData(:,:,:,:);
 imData3(:,:,:,587+515+1:587+515+587)= flip(ncData(:,:,:,:),2);
 imData3(:,:,:,587+515+587+1:587+515+587+515) = flip(carData(:,:,:,:),2);
 %%
 imLabel2=ones(1102,1);
 imLabel2(588:end)= ones(515,1).*2;
 %%
 imLabel3=ones((587+515)*2,1);
 imLabel3(588:587+515)= ones(515,1).*2;
 imLabel3(587+515+587+1:end)=ones(515,1).*2;
 %%
 %for randomised + augmented data
 imData4 = ones(64,64,3,(587+515)*2);
 imLabel4=ones((587+515)*2,1);
 row = randperm((587+515)*2,(587+515)*2);
 for t=1:(587+515)*2
       number = row(t);
       imData4(:,:,:,t)= imData3(:,:,:,number);
       imLabel4(t) = imLabel3(number); 
 end
 
 %%
 ncData2=zeros(64,64,3,515); % 3D with singleton or 4D 
 
 
 imData5 = ones(64,64,3,(515+515)*2);
 imData5(:,:,:,1:515)= ncData2(:,:,:,:);
 imData5(:,:,:,516:515+515)= carData(:,:,:,:);
 imData5(:,:,:,515+515+1:515+515+515)= flip(ncData2(:,:,:,:),2);
 imData5(:,:,:,515+515+515+1:515+515+515+515) = flip(carData(:,:,:,:),2);
 
 
 %%
 imLabel = ones(587+515,1);
 %%
 for t=1:(587+515)
    number = rand01(t);
    if(number<=587)
       imData(:,:,:,t)= ncData(:,:,:,number);
       imLabel(t) = 1;                              % 1 for nc
    else
        num = number - 587;
        imData(:,:,:,t)= carData(:,:,:,num);
        imLabel(t) = 2;                             % 2 for car
    end
     
 end
 %%
 
 Label = categorical(imLabel);
 Label2 = categorical(imLabel2);
 Label3 = categorical(imLabel3);
 Label4 = categorical(imLabel4);
 %%
 %% CNN Architecture
input = imageInputLayer([28 28 1]);
conv1 = convolution2dLayer(5,10,'Stride',1,'Padding',2);
pool1 = maxPooling2dLayer(2,'Stride',2);
conv2 = convolution2dLayer(5,20,'Stride',1,'Padding',2);
relu1 = reluLayer();
pool2 = maxPooling2dLayer(3,'Stride',3);
conv3 = convolution2dLayer(2,50,'Stride',1,'Padding',2);
relu2 = reluLayer();
fullconnect = fullyConnectedLayer(10);
softmax = softmaxLayer();
pool3 = maxPooling2dLayer(4,'Stride',4);
classoutput = classificationLayer();
conv4 = convolution2dLayer(4,500,'Stride',1,'Padding',0);
conv5 = convolution2dLayer(1,10,'Stride',1,'Padding',0);
droplayer1 = dropoutLayer(0.5);
droplayer2 = dropoutLayer(0.5);
%layers = [input;conv1;relu1;pool1;conv2;relu2;pool2;fullconnect;softmax;classoutput];
%layers = [input;conv1;relu1;pool1;conv2;relu2;pool2;conv3;fullconnect;softmax;classoutput];
%layers = [input;conv1;relu1;pool1;conv2;relu1;pool2;conv3;relu2;fullconnect;droplayer1;softmax;classoutput];
%layers = [input;conv2;pool1;conv3;pool1;conv3;relu2;conv5;softmax;classoutput];

layers = [imageInputLayer([64 64 3]);...
           convolution2dLayer(5,64,'Stride',1,'Padding',2);...
           reluLayer();...
           maxPooling2dLayer(2,'Stride',2);...
           convolution2dLayer(5,128,'Stride',1,'Padding',2);...
           reluLayer();...
           maxPooling2dLayer(2,'Stride',2);...
           convolution2dLayer(5,128,'Stride',1,'Padding',2);...
           reluLayer();...
           convolution2dLayer(5,128,'Stride',1,'Padding',2);...
           reluLayer();...
           convolution2dLayer(5,256,'Stride',1,'Padding',2);...
           reluLayer();...
           maxPooling2dLayer(2,'Stride',2);...
           fullyConnectedLayer(512);...
           reluLayer();...
           dropoutLayer(0.5);...
           fullyConnectedLayer(512);...
           reluLayer();...
           dropoutLayer(0.5);...
           fullyConnectedLayer(2);...
           softmaxLayer();...
           classificationLayer();...
            ];

%%
opts = trainingOptions('sgdm',...
      'LearnRateSchedule','piecewise',...
      'LearnRateDropFactor',0.2,... 
      'LearnRateDropPeriod',20,... 
      'MaxEpochs',40,... 
      'MiniBatchSize',50,...
      'CheckpointPath','C:\TEMP\checkpoint');

%%
[trainedNet,traininfo] = trainNetwork(imData,Label,layers,opts);
%%
[trainedNet2,traininfo2] = trainNetwork(imData2,Label2,layers,opts);
%%
[trainedNet3,traininfo3] = trainNetwork(imData3,Label3,layers,opts);
%%
traininfo3

figure ,plot(traininfo3.TrainingLoss);
figure ,plot(traininfo3.TrainingAccuracy);
%%

traininfo2

figure ,plot(traininfo2.TrainingLoss);
figure ,plot(traininfo2.TrainingAccuracy);
%%
traininfo

figure ,plot(traininfo.TrainingLoss);
figure ,plot(traininfo.TrainingAccuracy);
%%
%% Get Accuracy
acc = 0;
[Ypred,scores] = classify(trainedNet3,ncTestData);

acc = 0;
for i = 1:(1003)
    if Ypred(i) == categorical(1)
        acc = acc + 1;
    end
end

(acc/((1003)))*100
%%

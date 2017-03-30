%%
load('C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\trainnet3accurate.mat','trainedNet3');

load('C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\trainnet3accurate.mat','traininfo3');
%%

folderCarTest = 'C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\TestData\car_final_1002cars\';
folderNcTest  = 'C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\TestData\nc_final_1003noncars\';
%%
%car car_1200.png to 2202
%car nc_1200.png to 2202
ncTestData=zeros(64,64,3,1003); % 3D with singleton or 4D 
carTestData=zeros(64,64,3,1003); % 3D with singleton or 4D 


for t= 1200:2202
    carname=strcat(folderCarTest,'car_',num2str(t),'.png');
    f = imread(carname);
    carTestData(:,:,:,t-1200+1)=imresize(f ,[64,64]);
    
end

for t= 1200:2202
    ncname=strcat(folderNcTest,'nc_',num2str(t),'.png');
    f = imread(ncname);
    ncTestData(:,:,:,t-1200+1)=imresize(f ,[64,64]);
    
end
%%
%for random
imData3 = ones(64,64,3,2202*2);
 imData3(:,:,:,1:1003)= ncTestData(:,:,:,:);
 imData3(:,:,:,1004:1003*2)= carTestData(:,:,:,:);
% imData3(:,:,:,587+515+1:587+515+587)= flip(ncData(:,:,:,:),2);
 %imData3(:,:,:,587+515+587+1:587+515+587+515) = flip(carData(:,:,:,:),2);
 imLabel3=ones(1003*2,1);                       %1 nc
 imLabel3(1004:1003*2)= ones(1003,1).*2;         %2 car

 imData4test    = ones(64,64,3,1003*2);
 imLabel4test   = ones(1003*2,1);
 rowtest        = randperm(1003*2,1003*2);
for t=1:1003*2
       number = rowtest(t);
       imData4test(:,:,:,t)= imData3(:,:,:,number);
       imLabel4test(t) = imLabel3(number); 
end

 Label4test = categorical(imLabel4test);
%%
%% Get Accuracy
acc = 0;
[Ypred,scores] = classify(trainedNet3,imData4test);

for i = 1:1003*2
    if Ypred(i) == Label4test(i)
        acc = acc + 1;
    else ;
    end
end

(acc/(1003*2))*100
%%

%% Get Accuracy
acc = 0;
[Ypred,scores] = classify(trainedNet3,imData3);
%%
acc = 0;
for i = 1:1003
    if Ypred(i) == categorical(imLabel3(i))
        acc = acc + 1;
        
    else
        t = (imData3(:,:,:,i)./256);
         outputFileName = sprintf('C:\\Users\\shivam arora\\Videos\\Youtube Videos\\ISI sTUDY\\ExtraWork\\Wrong\\Wrong1\\%d.png',i);
        imwrite(t,outputFileName);  
    end
end

(acc/(1003))*100
%%
% image =  imread('C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\test2\t4.png');
% image = imresize(image , [64, 64]);
% [Ypred2,scores] = classify(trainedNet3,image);
% 

%Ypred2
%%
acc = 0;
for i = 1004:1003*2
    if Ypred(i) == categorical(imLabel3(i))
        acc = acc + 1;
    else
        t = (imData3(:,:,:,i)./256);
         outputFileName = sprintf('C:\\Users\\shivam arora\\Videos\\Youtube Videos\\ISI sTUDY\\ExtraWork\\Wrong\\Wrong2\\%d.png',i);
        imwrite(t,outputFileName);  
    end
end

(acc/(1003))*100
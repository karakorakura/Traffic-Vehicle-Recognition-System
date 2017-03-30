
%% Step 1 - Import Video and Initialize Median Foreground Detector
% 
%%
load('E:\Youtube Videos\ISI sTUDY\ExtraWork\trainnet3accurate.mat','trainedNet3');

load('E:\Youtube Videos\ISI sTUDY\ExtraWork\trainnet3accurate.mat','traininfo3');

%%

foldervid='E:\Youtube Videos\ISI sTUDY\ExtraWork\Chandni_Chowk_X-ing_4_E.avi';
%foldervid= 'H:\ISI Project\Images and Vid\Kankurgachi_Island_3_W.avi';
%foldervid= 'H:\ISI Project\Images and Vid\Rajabazar_X-ing_1_W.avi';
%foldervid = 'H:\ISI Project\Images and Vid\Shyambazar_X-ing_5_SW.avi';

videoReader = vision.VideoFileReader(foldervid);
%videoReader = VideoReader('C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\Chandni_Chowk_X-ing_4_E.avi')
%videoReader = read(videoReader);
%%
buf = 400;
stride = 15;
r = randi([0,stride-1],1,buf);
t=1;

start = 500;
k = start+stride*buf;
diff = zeros(1,k);

for i = 1:k
    f = step(videoReader); % read the next video frame
    if i == 1
        s = size(f);
        framesR = zeros(s(1),s(2),buf,'single');
        framesG = zeros(s(1),s(2),buf,'single');
        framesB = zeros(s(1),s(2),buf,'single');
        f_1 = f;
        diff(i) = 0;
    else
        diff(i) = sum(sum(abs(rgb2gray(f)-rgb2gray(f_1))>0.07))/(s(1)*s(2));
        f_1 = f;
    end
    
    if t<=buf && i>=start && r(t) == mod(i,stride)
        framesR(:,:,t) = f(:,:,1);
        framesG(:,:,t) = f(:,:,2);
        framesB(:,:,t) = f(:,:,3);
        t = t + 1;
    end

    %foreground = step(foregroundDetector, frame);
end
background = f;
background(:,:,1) = mode(framesR,3);
background(:,:,2) = mode(framesG,3);
background(:,:,3) = mode(framesB,3);
%%
add = ones(size(f));
%background = background + add/10;
%%
%background = imsharpen(background);
figure;imshow(background) 
hspec1 = imhist(background(100:end,:,1));
hspec2 = imhist(background(100:end,:,2));
hspec3 = imhist(background(100:end,:,3));

%B = colorspace('Luv<-RGB',double(background));
%%
% After the training, the detector begins to output more reliable
% segmentation results. The two figures below show one of the video frames
% and the foreground mask computed by the detector.

%figure; imshow(frame); title('Video Frame');

%%
%figure; imshow(foreground); title('Foreground');
    
%% Step 2 - Detect Cars in an Initial Video Frame
% The foreground segmentation process is not perfect and often includes
% undesirable noise. The example uses morphological opening to remove the
% noise and to fill gaps in the detected objects.
th=0.06;
th=0.06;
%C = colorspace('Luv<-RGB',double(f));
%foreground = (abs(B(:,:,1)-C(:,:,1))>th);


%{
f1= histeq(f(100:end,:,1),hspec1);
f2= histeq(f(100:end,:,2),hspec2);
f3= histeq(f(100:end,:,3),hspec3);
f(100:end,:,1) = f1;
f(100:end,:,2) = f2;
f(100:end,:,3) = f3;
%}
%%
figure ;imshow(f);
figure ;imshow(background);
%%
foreground = (abs(rgb2gray(background)-rgb2gray(f))>th);

se = strel('square', 3);
filteredForeground = imopen(foreground, se);
regions = detectHarrisFeatures(filteredForeground);
figure; imshow(f);hold on ;plot(regions); title('Harris');
hold off;

figure; imshow(filteredForeground); title('Clean Foreground');
impixelinfo;
%% Step 3 - Process the Rest of Video Frames
% In the final step, we process the remaining video frames.
videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
se = strel('square', 3); % morphological filter for noise removal
maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);

iteration=0; 
while ~isDone(videoReader)
    iteration = iteration +1;
    f = step(videoReader); % read the next video frame
    for l=1:4
        f = step(videoReader);
    end;   
    
    % Detect the foreground in the current video frame
    %foreground = step(foregroundDetector, frame);
    %C = colorspace('Luv<-RGB',double(f));
    %foreground = (abs(B(:,:,1)-C(:,:,1))>th);
    
    %{
    f1= histeq(f(100:end,:,1),hspec1);
    f2= histeq(f(100:end,:,2),hspec2);
    f3= histeq(f(100:end,:,3),hspec3);
    f(100:end,:,1) = f1;
    f(100:end,:,2) = f2;
    f(100:end,:,3) = f3;
    %}
    %if(mod(iteration,10)== 0)f = imsharpen(f);end;    
        
    foreground = (abs(rgb2gray(background)-rgb2gray(f))>th);
    %foreground = (abs(B(:,:,1)-C(:,:,1))>th);
    
    % Use morphological opening to remove noise in the foreground
    filteredForeground = foreground;
    filteredForeground = imerode(foreground, se);
    filteredForeground = imopen(foreground, se);

    
    
    % step(videoPlayer, filteredForeground);  % display the results
    
    %%%%%%
     % Detect the connected components with the specified minimum area, and
    % compute their bounding boxes
    blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 900,'MaximumBlobArea', 18000);
    
     bbox = step(blobAnalysis, filteredForeground);
     
     %%%%
     %regions = detectHarrisFeatures(filteredForeground);
    % result= insertMarker(f,regions);
     %%%%
     

    % Draw bounding boxes around the detected cars
   result = insertShape(f, 'Rectangle', bbox, 'Color', 'green');

   
    % Display the number of cars found in the video frame
    numCars = size(bbox, 1);
    
    j = 0;
    labelname = cell(numCars,1);
    for i=1:numCars
    image = f(bbox(i,2):bbox(i,2)+ bbox(i,4)-1,bbox(i,1):bbox(i,1)+ bbox(i,3)-1,:);
    %figure,imshow(image);
    image = imresize(image , [64, 64]);
    image = im2uint8(image);
    Ypred2 = categorical(1);
    [Ypred2,scores] = classify(trainedNet3,image);
    if scores(1)>0.49
        Ypred2 = categorical(1);
    else
        j = j+1;
    end
    %name1 = 'car';
    
     name1 = num2str(j);
     if Ypred2 == categorical(1)
       name1='.';
       bbox(i,:) = [0 0 0 0];
     end;
    labelname{i} = name1;
    end
   
    result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
        'FontSize', 14);
    
    if numCars>0
        result = insertObjectAnnotation(f,'rectangle',bbox,labelname,'TextBoxOpacity',0.9,'FontSize',18);
    end;
    step(videoPlayer, result);  % display the results
     step(maskPlayer, filteredForeground);  % display the results
    %%%%%%
    
    
end

release(videoReader); % close the video file

%%
% The output video displays the bounding boxes around the cars. It also
% displays the number of cars in the upper left corner of the video.
%displayEndOfDemoMessage(mfilename)

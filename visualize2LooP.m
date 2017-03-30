imt1 = imread('C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\test2\white.png');

imt1 = imresize(imt1,[64,64]);

for l =1:14


features = activations(trainedNet3,imt1,l,'OutputAs','channels');

x=2;
y=2;
size1 = size(features,3);
if size1 == 64
    x=8;
    y=8;
end
if size1 == 128
    x=8;
    y=16;
end
if size1 == 256
    x=16;
    y=16;
end
if size1 == 512
    x=16;
    y=32;
end



for i =1:size1
  if i == 1
      figure,
  end;
  
  subplot_tight(x,y,i)
  imf = features(:,:,i);
  min1 = (min(min(imf)));
  max1 = (max(max(imf)));
  diff1= max1-min1;
  imf = imf - ones(size(imf)).*min1;
  imf = (imf./diff1);
  imf1 = single(imf);
  imshow(imf1);
  
  
end


end
%%

for l =15:23


features = activations(trainedNet3,imt1,l,'OutputAs','channels');

x=2;
y=2;
size1 = size(features,3);
if size1 == 64
    x=8;
    y=8;
end
if size1 == 128
    x=8;
    y=16;
end
if size1 == 256
    x=16;
    y=16;
end
if size1 == 512
    x=16;
    y=32;
end



for i =1:size1
  if i == 1
      figure,
  end;
  
  subplot_tight(x,y,i)
  imf = features(:,:,i);
  
  imf1 = single(imf);
  imshow(imf1);
  
  
end


end


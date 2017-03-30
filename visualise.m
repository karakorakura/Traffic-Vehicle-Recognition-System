
for i =1:64
  if i == 1
      figure,
  end;   
  subplot(8,8,i)
  imf = convv(:,:,:,i);
  min1 = min(min(min(imf)));
  max1 = max(max(max(imf)));
  diff1= max1-min1;
  imf = imf - ones(size(imf)).*min1;
  imf = (imf./diff1);
  imf1 = single(imf);
  imshow(imf1);
  
  
end

%%
imt1 = imread('C:\Users\shivam arora\Videos\Youtube Videos\ISI sTUDY\ExtraWork\test2\t6.png');
imt1 = imresize(imt1,[64,64]);
features = activations(trainedNet3,imt1,11,'OutputAs','channels');

%%

%ha = tight_subplot(3,2,[.01 .03],[.1 .01],[.01 .01])
for i =1:64
  j = mod(i,16);
  if j == 0
   j = 16;
  end
  if  j == 1
      figure,
  end;   
  %subplot(4,4,j)
  subplot_tight(4,4,j)
  %axes(ha(ii));
  imf = features(:,:,i);
  min1 = (min(min(imf)));
  max1 = (max(max(imf)));
  diff1= max1-min1;
  imf = imf - ones(size(imf)).*min1;
  imf = (imf./diff1);
  imf1 = single(imf);
  imshow(imf1);
  
  
end
%%


for i =1:64
  if i == 1
      figure,
  end;   
  subplot_tight(8,8,i)
  imf = features(:,:,1,i);
  min1 = (min(min(imf)));
  max1 = (max(max(imf)));
  diff1= max1-min1;
  imf = imf - ones(size(imf)).*min1;
  imf = (imf./diff1);
  imf1 = single(imf);
  imshow(imf1);
  
  
end

%%



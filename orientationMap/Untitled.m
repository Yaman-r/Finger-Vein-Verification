%for h=1:110
    k(25)=NaN;
    imOut=true(size(imBin));                     % Image contains orientation map
for i=1:size(k,1)    % rows in the image
    for j=1:size(k,2)    % columns in the image
        imOut=DrawShortLine(imOut,k(i,j),b(i,j),windowSize,i,j,lineWidth);
    end
end
figure
imshow(imOut)


%end 
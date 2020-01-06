function im=DrawOrientationMapOnRGBimage(im,imOut)

imR=im(:,:,1);
imG=im(:,:,2);
imB=im(:,:,3);

ind=find(imOut==0);
imR(ind)=0;
imG(ind)=0;
imB(ind)=0;

im(:,:,1)=imR;
im(:,:,2)=imG;
im(:,:,3)=imB;

end
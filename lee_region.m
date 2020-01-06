function [region, edges] = lee_region(img, mask_h, mask_w)
% Localise the finger region

% Parameters:
%  img    - Input vascular image
%  mask_h - Height of the mask
%  mask_w - Width of the mask

% Returns:
%  region - Binary mask indicating the finger region
%  edges  - Matrix containing two rows, first row corresponds to the 
%           y-positions of the upper finger edge and the second row
%           corresponds to the y-positions of the lower finger edge.

[img_h, img_w] = size(img);

% Determine lower half starting point
if mod(img_h,2) == 0
    half_img_h = img_h/2 + 1;
else
    half_img_h = ceil(img_h/2);
end

% Construct mask for filtering
mask = zeros(mask_h,mask_w);
mask(1:mask_h/2,:) = -1;
mask(mask_h/2 + 1:end,:) = 1;

% Filter image using mask
img_filt = imfilter(img, mask,'replicate'); 
%figure; imshow(img_filt)

% Upper part of filtred image
img_filt_up = img_filt(1:floor(img_h/2),:);
[~, y_up] = max(img_filt_up); 

% Lower part of filtred image
img_filt_lo = img_filt(half_img_h:end,:);
[~,y_lo] = min(img_filt_lo);

% Fill region between upper and lower edges
region = zeros(size(img));
for i=1:img_w
    region(y_up(i):y_lo(i)+size(img_filt_lo,1), i) = 1;
end

% Save y-position of finger edges
edges = zeros(2,img_w);
edges(1,:) = y_up;
edges(2,:) = round(y_lo + size(img_filt_lo,1));
end
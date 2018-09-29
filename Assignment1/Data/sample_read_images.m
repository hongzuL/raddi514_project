clear all
%Sample Script for Assignment 1
us_img = imread('dataset1_img_hip.png'); % Load the image
mask   = imread('dataset1_mask_hip.png'); % Load the mask of regions of interest
% Convert Image to grayscale
us_img = rgb2gray(us_img);
mask   = rgb2gray(mask);

% Apply Enhancement
% Apply filter to the image for edge detection
sobel_x = [1,0,1;-2,0,2;-1,0,1];
sobel_y = [1,2,1;0,0,0;-1,-2,-1];
img1 = imfilter(us_img,sobel_x);
img2 = imfilter(us_img,sobel_y);
img = img1-img2;
Kavg = imfilter(img,fspecial('average',3));
Kmedian = medfilt2(img);
Klog = imfilter(img,fspecial('log',7));
Klap = imfilter(img,fspecial('laplacian'));
K = wiener2(img,[5 5]);
%convert to binary image
img_bw = imbinarize(img,'adaptive','Sensitivity',0.5);
Kavg_bw = imbinarize(Kavg,'adaptive','Sensitivity',0.5);
Kmedian_bw = imbinarize(Kmedian,'adaptive','Sensitivity',0.5);
bw_w = imbinarize(K,'adaptive','Sensitivity',0.5);
% Calcualte Indices
    % Convert to double if necesary
    % Multiply by mask

% Display
figure(1),
subplot(1,2,1); imshow(us_img,[])
subplot(1,2,2); imshow(mask,[])
figure(2)
subplot(2,2,1); imshow(img1,[])
subplot(2,2,2); imshow(img2,[])
subplot(2,2,3); imshow(img,[])
subplot(2,2,4); imshow(img_bw,[])
figure(3),
subplot(2,2,1);imshow(Kavg,[])
subplot(2,2,2);imshow(Kmedian,[])
subplot(2,2,3);imshow(Kavg_bw,[])
subplot(2,2,4);imshow(Kmedian_bw,[])

[peaksnr, snr] = psnr(uint8(img_bw)*255, mask);
disp(peaksnr)
figure(4)
imshow(uint8(img_bw)*255)
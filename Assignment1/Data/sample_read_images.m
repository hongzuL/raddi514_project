clear all
%Sample Script for Assignment 1
us_img = imread('dataset2_img_heart.png'); % Load the image
mask   = imread('dataset2_mask_heart.png'); % Load the mask of regions of interest
% Convert Image to grayscale
us_img = rgb2gray(us_img);
mask   = rgb2gray(mask);

% Apply Enhancement
% Apply filter to the image for edge detection
sobel_x = [1,0,1;-2,0,2;-1,0,1];
sobel_y = [1,2,1;0,0,0;-1,-2,-1];
img1 = imfilter(us_img,sobel_x);
img2 = imfilter(us_img,sobel_y);
img3 = imfilter(img1,sobel_x);
img4 = imfilter(img2,sobel_y);
% Kavg = imfilter(img,fspecial('average',3));
% Kmedian = medfilt2(img);
% Klog = imfilter(img,fspecial('log',7));
% Klap = imfilter(img,fspecial('laplacian'));
% K = wiener2(img,[5 5]);
%convert to binary image
img_bw = imbinarize(img1,'adaptive','Sensitivity',0.5);
% Kavg_bw = imbinarize(Kavg,'adaptive','Sensitivity',0.4);
% Kmedian_bw = imbinarize(Kmedian,'adaptive','Sensitivity',0.4);
% bw_w = imbinarize(K,'adaptive','Sensitivity',0.5);
% Calcualte Indices
    % Convert to double if necesary
    % Multiply by mask

% Display
figure(1),
subplot(1,2,1); imshow(us_img,[])
subplot(1,2,2); imshow(mask,[])
figure(2)
subplot(1,2,1); imshow(img1,[])
subplot(1,2,2); imshow(img_bw,[])
% 
% [peaksnr_sobel, snr_sobel] = psnr(uint8(img_bw), mask);
% fprintf("%f, %f\n",peaksnr_sobel, snr_sobel)
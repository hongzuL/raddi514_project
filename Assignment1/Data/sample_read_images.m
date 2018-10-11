clear all
%Sample Script for Assignment 1
us_img = imread('dataset1_img_hip.png'); % Load the image
mask   = imread('dataset1_mask_hip.png'); % Load the mask of regions of interest
bg_mask = imread('dataset1_bg_mask_hip.png'); % Load the background mask of regions of interest
% Convert Image to grayscale
us_img = rgb2gray(us_img);
mask   = rgb2gray(mask);
% Apply Enhancement
% noise removal
img_rm_noise = medfilt2(us_img);
% Contrast Enhancement
img_adjust = imadjust(img_rm_noise,[0.1 0.5]);
img = img_adjust;
% Apply filter to the image for edge detection
% sobel
sobel_x = [-1,0,1;-2,0,2;-1,0,1];
sobel_y = [1,2,1;0,0,0;-1,-2,-1];
sobel_tmp_x = imfilter(img,sobel_x);
sobel_tmp_y = imfilter(img,sobel_y);
rec_img_sobel = img-(sobel_tmp_x+sobel_tmp_y);
% laplacian 4
lap_4 = [0,-1,0;-1,4,-1;0,-1,0];
lap4_tmp = imfilter(img,lap_4);
rec_img_lap4 = img-lap4_tmp;
% laplacian 8
lap_8 = [-1,-1,-1;-1,8,-1;-1,-1,-1];
lap8_tmp = imfilter(img,lap_8);
rec_img_lap8 = img-lap8_tmp;
% laplacian of gaussian filter
log_k = imfilter(img,fspecial('log',3));
rec_img_log = img-log_k;

% Display
figure(1),
subplot(1,3,1); imshow(us_img,[]),title('Original')
subplot(1,3,2); imshow(img_rm_noise,[]),title('remove noise')
subplot(1,3,3); imshow(img_adjust,[]),title('adjust contrast')
figure(2)
subplot(2,2,1); imshow(rec_img_sobel,[]),title('sobel')
subplot(2,2,2); imshow(rec_img_lap4,[]),title('lap 4')
subplot(2,2,3); imshow(rec_img_lap8,[]),title('lap 8')
subplot(2,2,4); imshow(rec_img_log,[]),title('log')

% SNR
signal = double(us_img).*(double(mask==255));
noise = double(us_img).*(double(bg_mask==255));
fprintf("Original Image SNR: %f\n",snr(signal,noise))
signal = double(img_rm_noise).*(double(mask==255));
noise = double(img_rm_noise).*(double(bg_mask==255));
fprintf("Image SNR after removed noise: %f\n",snr(signal,noise))
signal = double(img_adjust).*(double(mask==255));
noise = double(img_adjust).*(double(bg_mask==255));
fprintf("Image SNR after adjust contrast: %f\n",snr(signal,noise))
signal = double(rec_img_sobel).*(double(mask==255));
noise = double(rec_img_sobel).*(double(bg_mask==255));
fprintf("Sobel Enhanced Image SNR: %f\n",snr(signal,noise))
signal = double(rec_img_lap4).*(double(mask==255));
noise = double(rec_img_lap4).*(double(bg_mask==255));
fprintf("lap 4 Enhanced Image SNR: %f\n",snr(signal,noise))
signal = double(rec_img_lap8).*(double(mask==255));
noise = double(rec_img_lap8).*(double(bg_mask==255));
fprintf("lap 8 Enhanced Image SNR: %f\n",snr(signal,noise))
signal = double(rec_img_log).*(double(mask==255));
noise = double(rec_img_log).*(double(bg_mask==255));
fprintf("log Enhanced Image SNR: %f\n",snr(signal,noise))
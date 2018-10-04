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
% Apply threshold
img = img_adjust;
% threshold = mean(mean(img));
% img(img<threshold)=0;
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

% rec_img_sobel = imadjust(rec_img_sobel);
% rec_img_lap4 = imadjust(rec_img_lap4);
% rec_img_lap8 = imadjust(rec_img_lap8);
% rec_img_log = imadjust(rec_img_log);

% rec_img_sobel(rec_img_sobel<mean(mean(rec_img_sobel)))=0;
% rec_img_lap4(rec_img_lap4<mean(mean(rec_img_lap4)))=0;
% rec_img_lap8(rec_img_lap8<mean(mean(rec_img_lap8)))=0;
% rec_img_log(rec_img_log<mean(mean(rec_img_log)))=0;
% Calcualte Indices
    % Convert to double if necesary
    % Multiply by mask
%

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
SNR=10*log10(sum(sum(signal))/sum(sum(noise)));
disp(SNR)
disp(snr(signal,noise))
signal = double(rec_img_sobel).*(double(mask==255));
noise = double(rec_img_sobel).*(double(bg_mask==255));
SNR=10*log10(sum(sum(signal))/sum(sum(noise)));
disp(SNR)
disp(snr(signal,noise))
% [peaksnr_sobel, snr_sobel] = psnr(uint8(rec_img_sobel), bg_mask);
% fprintf("%f, %f\n",peaksnr_sobel, snr_sobel)
% [peaksnr_lap4, snr_lap4] = psnr(uint8(rec_img_lap4), bg_mask);
% fprintf("%f, %f\n",peaksnr_lap4, snr_lap4)
% [peaksnr_lap8, snr_lap8] = psnr(uint8(rec_img_lap8), bg_mask);
% fprintf("%f, %f\n",peaksnr_lap8, snr_lap8)
% [peaksnr_log, snr_log] = psnr(uint8(rec_img_log), bg_mask);
% fprintf("%f, %f\n",peaksnr_log, snr_log)
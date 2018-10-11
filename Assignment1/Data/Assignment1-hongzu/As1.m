clear all
usr_input = input('Select the dataset(1 or 2):');
if usr_input ==1
    %load dataset 1
    us_img = imread('dataset1_img_hip.png'); % Load the image
    mask   = imread('dataset1_mask_hip.png'); % Load the mask of regions of interest
    bg_mask = imread('dataset1_bg_mask_hip.png'); % Load the background mask of regions of interest
else
    %load dataset 2
    us_img = imread('dataset2_img_heart.png'); % Load the image
    mask   = imread('dataset2_mask_heart.png'); % Load the mask of regions of interest
    bg_mask = imread('dataset2_bg_mask_heart.png'); % Load the background mask of regions of interest
end
% Convert Image to grayscale
us_img = rgb2gray(us_img);
mask   = rgb2gray(mask);

[rec_img,img_rm_noise,img_adjust] = image_enhance(us_img,mask);
% Display
figure(1),
subplot(2,2,1); imshow(us_img,[]),title('Original image')
subplot(2,2,2); imshow(img_rm_noise,[]),title('After removing noise')
subplot(2,2,3); imshow(img_adjust,[]),title('After adjust contrast')
subplot(2,2,4); imshow(rec_img,[]),title('After removing edges')

% SNR and contrast
double_img = double(us_img);
signal = double_img.*(mask==255);
noise = double_img.*(bg_mask==255);
fprintf("Original Image SNR: %f\n",snr(signal,noise))
fprintf("Original Image Contrast: %f\n",mean(mean(signal))-mean(mean(noise)))
double_img = double(img_rm_noise);
signal = double_img.*(mask==255);
noise = double_img.*(bg_mask==255);
fprintf("Image SNR after removed noise: %f\n",snr(signal,noise))
fprintf("Image Contrast after removed noise: %f\n",mean(mean(signal))-mean(mean(noise)))
double_img = double(img_adjust);
signal = double_img.*(mask==255);
noise = double_img.*(bg_mask==255);
fprintf("Image SNR after adjust contrast: %f\n",snr(signal,noise))
fprintf("Image Contrast after removed noise: %f\n",mean(mean(signal))-mean(mean(noise)))
double_img = double(rec_img);
signal = double_img.*(mask==255);
noise = double_img.*(bg_mask==255);
fprintf("Image SNR after removing the edges: %f\n",snr(signal,noise))
fprintf("Image Contrast after removed noise: %f\n",mean(mean(signal))-mean(mean(noise)))
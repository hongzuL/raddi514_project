function [rec_img_lap8,img_rm_noise,img_adjust] = image_enhance(us_img,mask)
    % Apply Enhancement
    % noise removal
    img_rm_noise = medfilt2(us_img);
    % Contrast Enhancement
    img_adjust = imadjust(img_rm_noise,[0.1 0.5]);
    img = img_adjust;
    % Apply filter to the image for edge detection
    % laplacian 8
    lap_8 = [-1,-1,-1;-1,8,-1;-1,-1,-1];
    lap8_tmp = imfilter(img,lap_8);
    rec_img_lap8 = img-lap8_tmp;
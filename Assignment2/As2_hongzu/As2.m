%% load all provided images
img = imread('MRI.png'); % Load the image
mask   = imread('InitialMask.png'); % Load the mask of regions of interest
GT = imread('GT.png'); % Load the ground truth
GT = ~imbinarize(GT); % binarize the gournd truth for easy comparision
%% apply segmentation
seg_img = activecontour(img,mask,70); % active contour
[hausdorff_dist,tp,tn,fp,fn] = validation_metrics(seg_img,GT);
precision = tp/(tp+fp);
recall = tp/(tp+fn);
dice = (2*tp)/(2*tp+fp+fn);
fprintf('precision: %2.4f\n',precision);
fprintf('recall: %2.4f\n',recall);
fprintf('dice: %2.4f\n',dice);
fprintf('hausdorff distance: %2.4f\n',hausdorff_dist);

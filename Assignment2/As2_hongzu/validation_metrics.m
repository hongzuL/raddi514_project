function [Hausdorff_dist,tp,tn,fp,fn] = validation_metrics(img,GT)
    % This function take segmentated image and the groud truth as the
    % inputs and output the hasudorff distance, true positive, true
    % negative, false positive, false negative.
    Hausdorff_dist = 0;
    if size(img) ~= size(GT)
        error('two images are not the same size!')
    else
        % generate point set A and B from image and ground truth, and get
        % tp, tn, fp, fn
        [row,col] = size(img);
        fn = 0; fp = 0; tn = 0; tp = 0;
        A = zeros(row*col,2);
        A_count = 0;
        B = zeros(row*col,2);
        B_count = 0;
        found_start_img = 0;
        found_start_GT = 0;
        for i = 1:row
            for j = 1:col
                if(found_start_img == 0 && img(i,j)==1)
                    % find the start point for finding contour
                    start_r_img = i;
                    start_c_img = j;
                    found_start_img = 1;
                end
                if(found_start_GT == 0 && GT(i,j)==1)
                    % find the start point for finding contour
                    start_r_GT = i;
                    start_c_GT = j;
                    found_start_GT = 1;
                end
                if(img(i,j)==1 && GT(i,j)==1)
                    tp = tp + 1;
                    A(1,:)=[i,j];
                    A_count = A_count + 1;
                    B(1,:)=[i,j];
                    B_count = B_count + 1;
                elseif(img(i,j)==0 && GT(i,j)==0)
                    tn = tn + 1;
                elseif(img(i,j)==1 && GT(i,j)==0)
                    fp = fp + 1;
                    A(1,:)=[i,j];
                    A_count = A_count + 1;
                elseif(img(i,j)==0 && GT(i,j)==1)
                    fn = fn + 1;
                    B(1,:)=[i,j];
                    B_count = B_count + 1;
                end
            end
        end
        contour_img = bwtraceboundary(img,[start_r_img start_c_img],'W');
        contour_GT = bwtraceboundary(GT,[start_r_GT start_c_GT],'W');
        figure(1),imshow(img); hold on; plot(contour_img(:,2),contour_img(:,1),'g','LineWidth',2); hold off; title('segmented image with contor')
        figure(2),imshow(GT); hold on; plot(contour_GT(:,2),contour_GT(:,1),'g','LineWidth',2); hold off; title('ground truth with contour')
        figure(3),imshowpair(img,GT); title('both segmented image and ground truth')
        Hausdorff_dist = max(directed_hasusdorff_dist(contour_img,contour_GT),directed_hasusdorff_dist(contour_GT,contour_img));
    end
    
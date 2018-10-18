function [Hausdorff_dist,tp,tn,fp,fn] = Hausdorff_distance(img,GT)
    % This function take segmentated image and the groud truth as the
    % inputs and output the hasudorff distance, true positive, true
    % negative, false positive, false negative.
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
        for i = 1:row
            for j = 1:col
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
        Hausdorff_dist = max(directed_hasusdorff_dist(A,B),directed_hasusdorff_dist(B,A));
    end
    
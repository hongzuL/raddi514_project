function max_dist = directed_hasusdorff_dist(A,B)
    % This function takes two point sets and compute the directed hausdorff
    % distance A to B
    max_dist = 0;
    for p=1:length(A(:,1))
        min_norm = Inf;
        point_a = A(p,:);
        % for all points in A
        for q = 1:length(B(:,1))
            % for all points in B
            point_b = B(q,:);
            % compute the distance between two points
            tmp_norm = norm(point_a-point_b);
            if min_norm>tmp_norm
                min_norm = tmp_norm;
            end
        end
        if max_dist < min_norm
            max_dist = min_norm;
        end
    end
function best_H = ransac_homography(p1,p2)
    thresh = sqrt(2); % threshold for inlier points
    p = 1-1e-4; % probability of RANSAC success
    w = 0.5; % fraction inliers

	
     % n: number of correspondences required to build the model (homography)
    n = 4;
    % number of iterations required
    % from the lecture given the probability of RANSAC success, and fraction of inliers
    k = ceil(log(1-p)/log(1-w^n));
	k
    num_pts = size(p1,1);
    best_inliers = 4;
    best_H = eye(3);
    for iter = 1:5*k
        % randomly select n correspondences from p1 and p2
        % use these points to compute the homography
        rand_indexes = randperm(num_pts,n);
        p1_sample = p1(rand_indexes,:);
        p2_sample = p2(rand_indexes,:);
        H = compute_homography(p1_sample,p2_sample);
%         p2_sample';
%         temp_pos = [p2_sample'; ones(1,4)];
%         temp = H*temp_pos;
%         p1_sample'
%         temp = temp(1:2,:)./temp(3,:)
        % transform p2 to homogeneous coordinates
        p2_h = [p2';ones(1,num_pts)];
      %  p2_h = [p2_sample';ones(1,4)];
        % estimate the location of correspondences given the homography
        p1_hat_temp = H*p2_h;

        % convert to image coordinates by dividing x and y by the third coordinate
        p1_hat = p1_hat_temp(1:2,:)./p1_hat_temp(3,:);
%         p1_sample
%         p1_hat = p1_hat'
        % compute the distance between the estimated correspondence location and the 
        % putative correspondence location
        %temp = p1-p1_hat';
        p1_hat = p1_hat';
        dist = pdist2(p1,p1_hat);
        
        len = size(dist,1);
        
        match_flag = zeros(len,1);
        
        for i=1:len
            dist_array = dist(i,:);
            [min_dist, min_index] = min(dist_array);
            if min_dist<=thresh
                match_flag(min_index) = 1;
            end
        end
        num_inliers = sum(match_flag);
        if num_inliers > best_inliers
            best_inliers = num_inliers;
            best_H = H;
            best_inliers;
        end
        
    end
end

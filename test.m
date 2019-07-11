% buildingDir = fullfile(toolboxdir('vision'), 'visiondata', 'building');
% buildingScene = imageDatastore(buildingDir);
% 
% I1 = readimage(buildingScene, 1);
% I2 = readimage(buildingScene, 2);
close all;
clear all;
I1 = imread('image1086.jpg');
I2 = imread('image1090.jpg');
size(I1)
size(I2)
I1_gray = rgb2gray(I1);
I2_gray = rgb2gray(I2);

% get points
points1 = detectHarrisFeatures(I1_gray);
points2 = detectHarrisFeatures(I2_gray);

% get features
[features1, points1] = extractFeatures(I1_gray, points1);
[features2, points2] = extractFeatures(I2_gray, points2);

loc1 = points1.Location;
loc2 = points2.Location;

[match,match_fwd,match_bkwd] = match_features(double(features1.Features),double(features2.Features));


H = ransac_homography(loc1(match(:,1),:),loc2(match(:,2),:));
H
I = stitch(I1,I2,H);

% figure(1)
% imshow(I1);
% figure(2)
% imshow(I2);
% figure(3)
% imshow(I)

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

function H = compute_homography(p1,p2)		 %p2->p1
    % use SVD to solve for H as was done in the lecture
    mat = zeros(8,9);
    for i=1:4
        u = p2(i,:);
        v = p1(i,:);
        subm = rearrange(u,v);
        mat(2*i-1:2*i,:) = subm;
    end
    
    [u1,d1,v1] = svd(mat);
    X = v1(:,end)/v1(end,end);
    H = reshape(X,3,3)';
end

function subm = rearrange(u,v)
    subm=[u(1) u(2) 1  0 0 0 -u(1)*v(1) -u(2)*v(1) -v(1);
        0 0 0 u(1) u(2) 1 -u(1)*v(2) -u(2)*v(2) -v(2)];
end


function [match,match_fwd,match_bkwd] = match_features(f1,f2)
  %% INPUT
    %% f1,f2: [ number of points x number of features ]
    %% OUTPUT
    %% match, match_fwd, match_bkwd: [ indices in f1, corresponding indices in f2 ]
    
    % get matches using pdist2 and the ratio test with threshold of 0.7
    % fwd matching
    ratio = 0.7;
    f_dist_m = pdist2(f1,f2);
    len = size(f_dist_m,1);
    
   
    min_1st_index_array = zeros(len,1);
    for i=1:len
        dist_array = f_dist_m(i,:);
        [min_1st, min_1st_index] = min(dist_array);
        dist_array(min_1st_index) = inf;
        min_2nd = min(dist_array);
        
        if min_1st/min_2nd<=0.7
            min_1st_index_array(i) = min_1st_index;
        end
    end
    match_fwd = [(1:len)' min_1st_index_array];
    
    match_fwd(match_fwd(:,2)==0,:)=[];
    % bkwd matching
    
    len2 = size(f_dist_m,2);
    min_1st_index_array = zeros(len2,1);
    for i=1:len2
        dist_array = f_dist_m(:,i);
        [min_1st, min_1st_index] = min(dist_array);
        dist_array(min_1st_index) = inf;
        min_2nd = min(dist_array);
        
        if min_1st/min_2nd<=0.7
            min_1st_index_array(i) = min_1st_index;
        end
    end

    
    match_bkwd = [(1:len2)' min_1st_index_array];
    
    match_bkwd(match_bkwd(:,2)==0,:)=[];
    % fwd bkwd consistency check
    
    temp = match_bkwd(:,1);
    match_bkwd(:,1) = match_bkwd(:,2);
    match_bkwd(:,2) = temp;
    
    match = intersect(match_fwd,match_bkwd,'row');
end
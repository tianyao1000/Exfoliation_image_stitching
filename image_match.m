function I = image_match(I1,I2,feature_match_threshold,method,edge_flag)
size(I1);
size(I2);
I1_gray = rgb2gray(I1);
I2_gray = rgb2gray(I2);

% get points

if edge_flag
    I1_gray = edge(I1_gray,'canny',0.4);
    I2_gray = edge(I1_gray,'canny',0.4);
end

se = strel('square',5);
I1_gray = imopen(I1_gray,se);
I2_gray = imopen(I2_gray,se);
  
switch method
    case 'corner'
        %% corner features
        points1 = detectHarrisFeatures(I1_gray);
        points2 = detectHarrisFeatures(I2_gray);
    case 'SURF'
        %% surf features
        points1 = detectSURFFeatures(I1_gray);
        points2 = detectSURFFeatures(I2_gray);
    case 'MSER'
        %%
        points1 = detectMSERFeatures(I1_gray);
        points2 = detectMSERFeatures(I2_gray);
    case 'KAZE'
        points1 = detectKAZEFeatures(I1_gray);
        points2 = detectKAZEFeatures(I2_gray);
end
%%


% get features
[features1, points1] = extractFeatures(I1_gray, points1);
[features2, points2] = extractFeatures(I2_gray, points2);

loc1 = points1.Location;
loc2 = points2.Location;



%[match,match_fwd,match_bkwd] = match_features(double(features1.Features),double(features2.Features));
match = matchFeatures(features1,features2);
if length(match) < feature_match_threshold
    I = [];
    return;
end

H = ransac_homography(loc1(match(:,1),:),loc2(match(:,2),:));
H


plot_corr(I1,I2,loc1(match(:,1),:),loc2(match(:,2),:));
I = stitch(I1,I2,H);

end
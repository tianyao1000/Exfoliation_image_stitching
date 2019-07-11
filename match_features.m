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
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
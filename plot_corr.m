 function plot_corr(I1,I2,p1,p2)
 
    y1 = size(I1,1);
    y2 = size(I2,1);
    if y1~=y2
        I2_temp = ones(y1,size(I2,2),3);
        I2_temp(1:size(I2,1),1:size(I2,2),:)=I2;
        I2 = I2_temp;
    end
	I = [I1,I2];
	%[sy,sx] = size(I1);
	
    sx = size(I1,2);
	figure(1)
	imshow(I)
	hold on;
	plot(p1(:,1),p1(:,2),'bo');
	plot(sx + p2(:,1),p2(:,2),'rx');
	plot([p1(:,1),sx+p2(:,1)]',[p1(:,2),p2(:,2)]','g-');
	hold off;
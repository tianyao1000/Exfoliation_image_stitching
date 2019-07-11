folder = 'test_image3';
im = imread([folder '/image1085.jpg']);
I = rgb2gray(im);
I2=edge(I,'canny',0.2);
imshowpair(I,I2,'montage');
se = strel('disk',1);
I3=imclose(I2,se);
imshowpair(I2,I3,'montage');
I1 = imread('image1089.jpg');
I2 = imread('image1090.jpg');

I1_gray = rgb2gray(I1);
I2_gray = rgb2gray(I2);
figure;
imshow(I1_gray);
figure;
imshow(I2_gray);
se = strel('square',5);
I1 = imopen(I1_gray,se);
imshowpair(I1_gray, I1,'montage')
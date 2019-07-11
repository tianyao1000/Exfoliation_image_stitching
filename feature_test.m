I1 = imread('image1089.jpg');
I2 = imread('image1090.jpg');

I1_gray = rgb2gray(I1);
I2_gray = rgb2gray(I2);
% hp=imhist(I1_gray);
% hp(1)=0;
% T=otsuthresh(hp);
% 
% %threshold = 0.4*255;
% %I1_gray(I1_gray<threshold)=0;
% %I1_gray(I1_gray>=threshold)=255;
% 
% I1_gray=im2bw(I1_gray,T);
% imhist(I1_gray)
% 
% imshow(I1_gray)
% %I1_gray = 255-I1_gray;
% imshow(I1_gray)

% 
% I1_gray = edge(I1_gray,'canny',0.4);
% I2_gray = edge(I2_gray,'canny',0.4);
size = 5;

se = strel('square',3);
I1_gray = imerode(I1_gray,se);
imshow(I1_gray);
I1_gray = imdilate(I1_gray,se);
imshow(I1_gray);
I1_gray = imopen(I1_gray,se);

imshow(I1_gray)
I1_gray = imopen(I1_gray,se);

imshow(I1_gray);
I2_gray = imopen(I2_gray,se);
I1_gray = imopen(I1_gray,se);
I2_gray = imopen(I2_gray,se);

points1 = detectHarrisFeatures(I1_gray);
points2 = detectHarrisFeatures(I2_gray);
[f1,vP1] = extractFeatures(I1_gray,points1);
[f2,vP2] = extractFeatures(I2_gray,points2);
figure(1);
subplot(1,2,1)
hold on;
imshow(I1_gray);
plot(vP1);
hold off;
subplot(1,2,2);
hold on;
imshow(I2_gray);
plot(vP2);
hold off;



%% surf features
points1 = detectSURFFeatures(I1_gray);
points2 = detectSURFFeatures(I2_gray);

[f1,vP1] = extractFeatures(I1_gray,points1);
[f2,vP2] = extractFeatures(I2_gray,points2);
figure(2);
subplot(1,2,1)
hold on;
imshow(I1_gray);
plot(vP1,'showOrientation',true);
hold off;
subplot(1,2,2);
hold on;
imshow(I2_gray);
plot(vP2,'showOrientation',true);
hold off;

%%
points1 = detectMSERFeatures(I1_gray);
points2 = detectMSERFeatures(I2_gray);

[f1,vP1] = extractFeatures(I1_gray,points1);
[f2,vP2] = extractFeatures(I2_gray,points2);
figure(3);
subplot(1,2,1)
hold on;
imshow(I1_gray);
plot(vP1,'showOrientation',true);
hold off;
subplot(1,2,2);
hold on;
imshow(I2_gray);
plot(vP2,'showOrientation',true);
hold off;


points1 = detectKAZEFeatures(I1_gray);
points2 = detectKAZEFeatures(I2_gray);

[f1,vP1] = extractFeatures(I1_gray,points1);
[f2,vP2] = extractFeatures(I2_gray,points2);
figure(4);
subplot(1,2,1)
hold on;
imshow(I1_gray);
plot(vP1,'showOrientation',true);
hold off;
subplot(1,2,2);
hold on;
imshow(I2_gray);
plot(vP2,'showOrientation',true);
hold off;
feature_match_threshold = 4;
method = 'KAZE';

resulting_image = image_match(I1,I2,feature_match_threshold,method,false);
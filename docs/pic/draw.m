%% 中值滤波
origin = imread('原图.jpg');

origin_n = imnoise(origin,'salt & pepper',0.02);

imwrite(origin_n, 'origin_n.jpg');

I1=origin_n(:,:,1);%R通道
I2=origin_n(:,:,2);%G通道
I3=origin_n(:,:,3);%B通道
I1_med = medfilt2(I1);
I2_med = medfilt2(I2);
I3_med = medfilt2(I3);
img_med(:,:,1)=I1_med;
img_med(:,:,2)=I2_med;
img_med(:,:,3)=I3_med;

figure(1)
imshow(I1);
title('原始图像');
figure(2)
imshow(I1_med);

figure
subplot(1,2,1)
imshow(origin_n);
title('原始图像(加入椒盐噪声)');
subplot(1,2,2)
imshow(img_med);
title('中值滤波图像');

%% 原图 & 二值化
clc
% origin = imread('原图.jpg');
binary = imread('阈值检测.bmp');

se = strel('disk',3);
fopen = imopen(binary, se);

figure
subplot(1,3,1)
imshow(origin);
title('原始图像');
subplot(1,3,2)
imshow(binary);
title('二值化图像');
subplot(1,3,3)
imshow(fopen);
title('开运算图像');

%% 投影
projection1 = imread('第一次投影&填充.bmp');

[m n]=size(fopen);
y = 1:n;
x = 1:m;

figure
subplot(2,2,1)
imshow(fopen);
title('二值化图像');

subplot(222)
plot(sum(fopen,2)/255,x);
title('水平投影');
set(gca,'YDir','reverse')%对Y方向反转
ylim([0 m]);

subplot(223)
plot(y,sum(fopen)/255);
title('垂直投影');
xlim([0 n]);

subplot(2,2,4)
imshow(projection1,'Border','tight');
hold on
drawRectangleImage = rectangle('Position',[1,1,n-1,m-1],'LineWidth',1,'EdgeColor','black');
hold off

title('投影和填充');

%% 极差法分割
clc
img_char = ~projection1;
img_range_min_flag = zeros(size(y),'logical');
img_range_min = zeros(size(y),'uint32');
img_range_max = zeros(size(y),'uint32');
% img_range = zeros(size(y),'uint32');

% j->y, i->x
for j = 1:m
    for i = 1:n
        if img_char(j,i) ~= 0
           if img_range_min_flag(i) ~= 1
               img_range_min(i) = j;
               img_range_min_flag(i) = 1;
           else
               img_range_max(i) = j;
           end
        end
    end
end

figure
imshow(img_char);
hold
plot((1:n),img_range_min,'r');
set(gca,'YDir','reverse')%对Y方向反转
plot((1:n),img_range_max,'b');
set(gca,'YDir','reverse')%对Y方向反转

img_range = img_range_max - img_range_min;



figure
subplot(1,3,1)
imshow(img_char);
title('二值化图像');

subplot(1,3,2)
plot(y,sum(img_char));
title('传统投影法曲线');
xlim([0 n]);

subplot(1,3,3)
plot(y,img_range);
% imshow(projection1,'Border','tight');
title('极差投影法曲线');
xlim([0 n]);

%% 图像归一化
img_su = imread('缩放到统一大小/su.bmp');
img_A = imread('缩放到统一大小/A.bmp');
img_point = imread('缩放到统一大小/point.bmp');
img_1 = imread('缩放到统一大小/1.bmp');
img_2 = imread('缩放到统一大小/2.bmp');
img_3 = imread('缩放到统一大小/3.bmp');
img_4 = imread('缩放到统一大小/4.bmp');
img_5 = imread('缩放到统一大小/5.bmp');

figure
title('归一化的字符');
subplot(1,8,1),imshow(img_su);
subplot(1,8,2),imshow(img_A);
subplot(1,8,3),imshow(img_point);
subplot(1,8,4),imshow(img_1);
subplot(1,8,5),imshow(img_2);
subplot(1,8,6),imshow(img_3);
subplot(1,8,7),imshow(img_4);
subplot(1,8,8),imshow(img_5);



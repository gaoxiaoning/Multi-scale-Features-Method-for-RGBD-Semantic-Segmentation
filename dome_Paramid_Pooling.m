I = imread('E:\学习与研究\图像研究\语义分割\数据集\NY2_dataset\dataset_dome\rgb\rgb1.jpg');
I1 = imresize(I, 0.4);
I2 = imresize(I, 0.8);
I3 = imresize(I, 2.5);
figure;
imshow(I);
title('Original');
figure;
imshow(I1);
title('I_0.4');
figure;
imshow(I2);
title('I_0.8');
figure;
imshow(I3);
title('I_2.5');
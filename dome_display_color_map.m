addpath('common/');
addpath('surfaces/');
addpath('structure_classes/');
addpath(genpath('iccv07Final'));
Consts;
Params;
N=40;
cmap = NYU_v2_labelcolormap(N+1);%Ҫ����unlabel�����ݣ�����ublabel���ݣ��Ҹ��丳ֵΪ��0��0��0��
load('E:\\ѧϰ���о�\\ͼ���о�\\����ָ�\\���ݼ�\\NY2_dataset\\labels_objects/labels_000900.mat');
load('E:\\ѧϰ���о�\\ͼ���о�\\����ָ�\\���ݼ�\\NY2_dataset\\name/names.mat');
imgStructureLabels = object2structure_labels(imgObjectLabels, names);
imshow(imgStructureLabels,cmap);


% Determines the class and instance labels for each of the initial superpixel segments produced by
% the watershed segmentation.

addpath('common/');
addpath('segmentation/');
consts.level=0;
Consts;

OVERWRITE = true;%��С��

%%
fprintf('\nRunning regions2labels on superpixels from Watershed:\n');

for ii = 1 : consts.numImages
  if ~consts.useImages(ii)
    continue;
  end
  
  outFilename = sprintf(consts.objectLabelsSegFilename, ii);
  if exist(outFilename, 'file') && ~OVERWRITE
    fprintf('Skipping file %d/%d (already exists).\n', ii, consts.numImages);
    continue;
  end
  
  fprintf('Running regions2labels (%d/%d)\r', ii, consts.numImages);
  
  % 
  load(sprintf(consts.objectLabelsFilename, ii), 'imgObjectLabels');
  load(sprintf(consts.instanceLabelsFilename, ii), 'imgInstanceLabels');

  load(sprintf(consts.watershedFilename, ii), 'boundaryInfo');
  
  [instanceMasks, instanceLabels] =  get_instance_masks(imgObjectLabels, imgInstanceLabels);
  [classLabels, instanceLabels, intersectionPcnt] = ...
      regions2labels(boundaryInfo.imgRegions, instanceMasks, instanceLabels);
   %%�˴������classLabelsΪÿһ�������ظ�ֵ��һ�����ǩ������instanceLabel��ʾ���ǵڼ���Ŀ�꣨����ֻ��18��Ŀ�꣬��ô���ǩ����1...18,��
   %%���嶼�Ǹ���Mask���ص��Ƚ��м���ģ�������ص�����һ�����Ե��ڵĲ�����������ֵ��IoU
   %%��ÿһ��ͼƬ���е�����ĸ����ǲ�һ�µĴ����1700����
   save(outFilename, 'classLabels', 'instanceLabels', 'intersectionPcnt');
end

fprintf('\n');
fprintf('===============================\n');
fprintf('Finished running region2labels \n');
fprintf('===============================\n\n');
% Performs an initial watershed segmentation on each RGBD image.
addpath(genpath('iccv07Final'));
addpath('segmentation/');
consts.level=0;
Consts;
Params;

OVERWRITE = true;

%%
if ~exist(consts.watershedDir, 'dir')
  mkdir(consts.watershedDir);
end

for ii = 1 : consts.numImages
  if ~consts.useImages(ii)
    continue;
  end
  
  fprintf('Running watershed %d/%d.\n', ii, consts.numImages);
  
  outFilename = sprintf(consts.watershedFilename, ii);
  if exist(outFilename, 'file') && ~OVERWRITE
   continue;
  end

  load(sprintf(consts.imageRgbFilename, ii), 'imgRgb');  
  load(sprintf(consts.planeDataFilename, ii), 'planeData');
  %�ܽ������������ͼ��ĳ����طָ��ʵֻ��Ҫһ��ͼ��Ϳ��ԣ���Ȼ��������ʹ����
  %planeMap��������������Ż������Եõ��ĳ�����������ӵ�׼ȷ��������planeMap��һ����
  [boundaryInfo, pbAll] = im2superpixels(imgRgb, double(planeData.planeMap));
  save(outFilename, 'boundaryInfo', 'pbAll');
end

fprintf('Finished initial watershed segmentation.\n');

% Finds major scene surfaces and rotates the entire scene such that the
% floor plane's surface normal points directly up.
addpath('common');
addpath(genpath('iccv07Final'));
addpath(genpath('graph_cuts'));
addpath('surfaces');
consts.level=0;
Consts;

% Whether or not to overwrite the planeData files if they're already found
% on disk.
OVERWRITE = true;

if ~exist(consts.planeDataDir, 'dir')
  mkdir(consts.planeDataDir);
end

%% ����ƽ������
for ii = 1 : consts.numImages
  fprintf('Extracting plane data (%d/%d).\n', ii, consts.numImages);

  if ~consts.useImages(ii)
    continue;
  end
  
  outFilename = sprintf(consts.planeDataFilename, ii);
  if exist(outFilename, 'file') && ~OVERWRITE
    continue
  end
  
  load(sprintf(consts.imageRgbFilename, ii), 'imgRgb');
  load(sprintf(consts.imageDepthFilename, ii), 'imgDepthOrig');
  load(sprintf(consts.imageDepthRawFilename, ii), 'imgDepthRawOrig');
  load(sprintf(consts.surfaceNormalData, ii), 'imgNormals', 'normalConf');
  %�ڲ�ִ�е�ͼ�ָ����planeData��һ������������ͼ�ָransac����
  %%planeData����planeMap��normals��supportSurfaces��
  planeData = rgbd2planes(imgRgb, imgDepthOrig, imgDepthRawOrig, ...
      imgNormals, normalConf,consts.level);
    
  save(outFilename, 'planeData');
end

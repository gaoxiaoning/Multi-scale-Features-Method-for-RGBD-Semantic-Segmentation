% Trains several stages of boundary classifiers
addpath('common/');
addpath('segmentation/');
addpath(genpath('iccv07Final'));
consts.level=0;
Consts;
Params;

params.overwrite = true;%��С��
params.seg.featureSet = consts.BFT_RGBD;

% Load the train/test split.
load(consts.splitsPath, 'trainNdxs');

if ~exist(consts.boundaryFeaturesDir, 'dir')
  mkdir(consts.boundaryFeaturesDir);
end
%�˴���Ϊ���м���
for stage = 1 : params.seg.numStages  %��С�� 1����>2
  %%�����Ƕ����е�ͼƬ����ȡ�˱߽������������ֻ��use image:909--1200)��
  %%watershedFile�а�����boundaryInfo��pbAll������Ϣ
  %% ����
  %%[boundaryFeatures, boundaryLabels] = get_boundary_classifier_features( 
  %%ii, imgRgb, planeData, boundaryInfo, pbAll, instanceLabels, params);
  %����extract_boundary_classifier_features_and_labels�еĺ�������һ���������⣬�ǿ��Խ��и��ĵ�
  extract_boundary_classifier_features_and_labels(stage, params);

  %% Create the boundary-classification dataset.
  datasetFilename = sprintf(consts.boundaryFeaturesDataset, ...
      params.seg.featureSet, stage);
    
  %���������ѵ��������Լ�ֻ�в������ݣ�������ȫ��ͼ�����ɵı߽�����
  if ~exist(datasetFilename, 'file') || params.overwrite
    [trainData, testData, trainLabels, testLabels] = ...
        create_boundary_classifier_dataset(stage, trainNdxs, params.seg.featureSet);
    fprintf('Saving dataset...');
    save(datasetFilename, 'trainData', 'trainLabels', ...
        'testData', 'testLabels', '-v7.3');
    fprintf('DONE\n');
  else
    fprintf('Loading the boundary-classification dataset.\n');
    load(datasetFilename, 'trainData', 'trainLabels', ...
      'testData', 'testLabels');
  end

  %% Train the boundary classifier.
  boundaryClassifierFilename = ...
      sprintf(consts.boundaryClassifierFilename, params.seg.featureSet, stage);

  if ~exist(boundaryClassifierFilename, 'file') || params.overwrite
    classifier = train_boundary_classifier_dt(stage, trainData, trainLabels, ...
        testData, testLabels, params);
    save(boundaryClassifierFilename, 'classifier');
  else
    fprintf('Skipping creation of boundary classifier for stage %d\n', stage);
    load(boundaryClassifierFilename, 'classifier');
  end

  %%
  fprintf('Performing merges:\n');
  for ii = 1 : consts.numImages
    fprintf('Merging regions (Image %d/%d, stage %d).\r', ...
        ii, consts.numImages, stage);

    if ~consts.useImages(ii)
      continue;
    end
    %��info���Ǻ���ı߽��ļ�
    outFilename = sprintf(consts.boundaryInfoPostMerge, ...
          params.seg.featureSet, stage, ii);
    if exist(outFilename, 'file') && ~params.overwrite
      continue;
    end

    load(sprintf(consts.planeDataFilename, ii), 'planeData');
    load(sprintf(consts.watershedFilename, ii), 'pbAll');
    %%�����stage1,��ʹ��watershed..mat������ʹ��info_.._stage-1..mat
    if stage == 1
      boundaryInfoFilename = sprintf(consts.watershedFilename, ii);
    else
      boundaryInfoFilename = sprintf(consts.boundaryInfoPostMerge, ...
          params.seg.featureSet, stage-1, ii);
    end
    
    load(boundaryInfoFilename, 'boundaryInfo');
    load(sprintf(consts.imageRgbFilename, ii), 'imgRgb');
    load(sprintf(consts.objectLabelsFilename, ii), 'imgObjectLabels');
    load(sprintf(consts.instanceLabelsFilename, ii), 'imgInstanceLabels');
    load(sprintf(consts.boundaryFeaturesFilename, ...
        params.seg.featureSet, stage, ii), 'boundaryFeatures');
    
    [~, instanceLabels] = get_labels_from_instances(boundaryInfo.imgRegions, ...
        imgObjectLabels, imgInstanceLabels);
    
    result = merge_regions(boundaryInfo, boundaryFeatures, ...
        classifier, stage, params);
    boundaryInfo = update_boundary_info(boundaryInfo, result, imgRgb);
    save(outFilename, 'boundaryInfo');
  end

  fprintf('\n');
  fprintf('======================================\n');
  fprintf('Finished merging regions for stage %d!\n', stage);
  fprintf('======================================\n');
end

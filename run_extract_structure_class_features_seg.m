% Extracts and saves all of the region-to-structure class features.
addpath('common/');
addpath('structure_classes/');
consts.level=0;
Consts;
Params;
params.regionSrc = consts.REGION_SRC_BOTTOM_UP;
params.stage = 5;

addpath(consts.spamsPath);
% Whether or not to overwrite the structure class features file if it
% already exists on disk.
OVERWRITE = true;
if ~exist(consts.structureFeaturesDir, 'dir')
  mkdir(consts.structureFeaturesDir);
end

%%
%��С��
% RandStream.setDefaultStream(RandStream.create('mrg32k3a', 'Seed', 1));
RandStream.setGlobalStream(RandStream.create('mrg32k3a', 'Seed', 1));

for ii = 1 : consts.numImages
  fprintf('Extracting region-to-structure-class features %d/%d.\n', ...
      ii, consts.numImages);
  if ~consts.useImages(ii)
    continue;
  end
    outFilename = sprintf(consts.structureFeaturesFilename, ...
    params.regionSrc, params.seg.featureSet, params.stage, ii);
  %�Ѿ����Լ��Ѿ���ȡ�ˣ��˴�����ѵ������ȡ����������ʹ��ground truth��
      if exist(outFilename, 'file') && ~OVERWRITE
        continue;
      end
    %��SIFT�������������д����γ���������:128+1000(����+SIFTϡ���ʾϵ��)
      regionFeatures = extract_region_to_structure_classes_features(ii, params);
      assert(~any(isnan(regionFeatures(:))));
      assert(~any(isinf(regionFeatures(:))));
      save(outFilename, 'regionFeatures');
end

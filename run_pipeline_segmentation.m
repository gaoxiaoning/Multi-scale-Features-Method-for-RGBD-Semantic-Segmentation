% Contains the scripts that implement the segmentation pipeline.

% Compile all CPP files.
run_compile_all;
% Creates individual files for each RGB, Depth and Label image.
for iii=0:3
    consts = struct();
    consts.level=iii;
    run_save_individual_files;
end

% Compute the surface normals, find the major scene surfaces and rotate the
% image so that the floor points up and the walls are perpendicular to
% the XY plane (in the right handed coordinate space).
run_extract_surface_normals;
%floor plane's surface normal points directly up.������ת��ʹ�õ��泯�ϣ���С��ע
run_rgbd2planes;

% Compute the initial watershed segmentation and label each of the initial
% segments with an instance label.
%���ַ�ˮ���㷨����ֻʹ��ԭʼͼ��+ƽ������
run_watershed_segmentation;
run_regions2labels;

% Next, train and evaluat eseveral stages of boundary classifiers.
run_train_boundary_classifiers;
run_evaluate_segmentation;
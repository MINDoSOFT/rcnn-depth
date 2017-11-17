demoDataDir = 'demo-data';
demoImages = sprintf('%s/%s', demoDataDir, 'images');
demoDepths = sprintf('%s/%s', demoDataDir, 'depth');
demoRawdepths = sprintf('%s/%s', demoDataDir, 'rawdepth');

filesImages = regexp(ls(demoImages), '(\s+|\n)', 'split');
filesImages(end) = [];
filesImages = sort(filesImages);

filesDepths = regexp(ls(demoDepths), '(\s+|\n)', 'split');
filesDepths(end) = [];
filesDepths = sort(filesDepths);

filesRawdepths = regexp(ls(demoRawdepths), '(\s+|\n)', 'split');
filesRawdepths(end) = [];
filesRawdepths = sort(filesRawdepths);

for ii = 1 : 2
%for ii = 1 : numel(filesImages)
  % For each of the files in demo-data/images
  disp(filesImages{ii});
  disp(filesDepths{ii});
  disp(filesRawdepths{ii});
  % Retrieve its related depth and rawdepth
  I = imread(fullfile(demoImages, filesImages{ii}));
  D = imread(fullfile(demoDepths, filesDepths{ii}));
  RD = imread(fullfile(demoRawdepths, filesRawdepths{ii}));
  C = cropCamera(getCameraParam('color'));
  % Set the output file to output/images_XYZ.mat
  [pathstr,name,ext] = fileparts(fullfile(demoImages, filesImages{ii}));
  out_file = fullfile([demoDataDir '/output'], [name '.mat']);
  % For checking
  disp(out_file);
  % Run rcnn-depth for each file
  run_all_for_std2p(I, D, RD, C, out_file);

end

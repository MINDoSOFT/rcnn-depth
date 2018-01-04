demoDataDir = './demo-data';
demoImages = sprintf('%s/%s', demoDataDir, 'images');
demoDepths = sprintf('%s/%s', demoDataDir, 'depth');
demoRawdepths = sprintf('%s/%s', demoDataDir, 'rawdepth');
demoOutputAllDir = sprintf('%s/%s/%s', demoDataDir, 'output', 'all');
demoOutputSpDir = sprintf('%s/%s/%s', demoDataDir, 'output', 'sp');

filesImages = regexp(ls(demoImages), '(\s+|\n)', 'split');
filesImages(end) = [];
filesImages = sort(filesImages);

filesDepths = regexp(ls(demoDepths), '(\s+|\n)', 'split');
filesDepths(end) = [];
filesDepths = sort(filesDepths);

filesRawdepths = regexp(ls(demoRawdepths), '(\s+|\n)', 'split');
filesRawdepths(end) = [];
filesRawdepths = sort(filesRawdepths);

exists_or_mkdir(demoOutputAllDir);
exists_or_mkdir(demoOutputSpDir);

frameListFile = './frame_list.txt';

if (exist('generateFrameList') == 1)
  % Reads the list of frames.
  frameList = filesImages;
  % Save the frame list (for python to know how many to spawn)
  fileID = fopen(frameListFile, 'w');
  for ii = 1 : numel(frameList)
    frame = sprintf('%04d', ii);
    fprintf(fileID,'%s\n', frame);
  end
  fclose(fileID);
  return;
else
  if ~(exist('batchId') == 1)
    disp('You need to set batchId to run this script.');
    return;
  end
end

if ~(exist('operation') == 1)
  operation = 0;
end

p = get_paths();

filesToSkip = batchId - 1; % Useful when something goes wrong e.g. segmentation fault, default is 0.

testing = false;

disp('Started running rcnn-depth');

ii = max(1, filesToSkip + 1);
%for ii = max(1, filesToSkip + 1) : numel(filesImages)
  % Set the output file to output/images_XYZ.mat
  [pathstr,name,ext] = fileparts(fullfile(demoImages, filesImages{ii}));
  out_file = fullfile(demoOutputAllDir, [name '.mat']);
  out_file_sp_filename = [name '_sp' '.mat'];
  out_file_sp = fullfile(demoOutputSpDir, out_file_sp_filename);
  if(exist([demoOutputSpDir '/' out_file_sp_filename]) == 2)
    % Skip existing files
    disp(sprintf('Skipping %s', name));
    exit;
  end
  % For each of the files in demo-data/images
  disp(filesImages{ii});
  disp(filesDepths{ii});
  disp(filesRawdepths{ii});
  % Retrieve its related depth and rawdepth
  I = imread(fullfile(demoImages, filesImages{ii}));
  D = imread(fullfile(demoDepths, filesDepths{ii}));
  RD = imread(fullfile(demoRawdepths, filesRawdepths{ii}));
  C = cropCamera(getCameraParam('color'));
  % For checking
  disp(out_file);
  % Run rcnn-depth for each file
  if (testing == false)
    if (operation == 0) % ALL
      run_all_for_std2p(I, D, RD, C, out_file, name, out_file_sp);
    elseif (operation == 1) % HHA
      saveHHA([name], C, p.for_std2p_hha_dir, D, RD);
    else
      disp(['Unknown operation: ' operation])
    end
  end

%end

disp('All done');

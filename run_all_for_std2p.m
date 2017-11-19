function [E, ucm2, candidates, detection_scores_no_nms, cls] = run_all(I, D, RD, C, out_file, image_name)
% function [E, ucm2, candidates, detection_scores_no_nms, cls] = run_all(I, D, RD, C, out_file, image_name)

% AUTORIGHTS

  %% Compute the UCMs
  p = get_paths();
  edge_model_file = fullfile_ext(p.contours_model_dir, 'forest', 'modelNyuRgbd-3', 'mat');
  model = load(edge_model_file);
  model = model.model;
  sc = [2 1 0.5];
  [E, Es, O] = detectEdge(I, D, [], C, model, sc, [], []);
  [ucm2 ucms] = contours_to_ucm(I, sc, Es, O);
  if(~isempty(out_file)), save(out_file, 'E', 'Es', 'O', 'ucm2', 'ucms'); end

  disp('Compute UCMs OK');

  %% Compute the regions
%  params = nyud_params('root_cache_dir', p.cache_dir, 'feature_id', 'depth', 'depth_features', true, 'camera_matrix', C);  
%  rf = loadvar(params.files.trained_classifier,'rf');
%  n_cands = loadvar(params.files.pareto_point,'n_cands');
   
%  mcg_cache_obj = cache_mcg_features(params, {ucm2, ucms(:,:,1), ucms(:,:,2), ucms(:,:,3)}, [], []);
%  candidates = compute_mcg_cands(params, rf, n_cands, mcg_cache_obj, D, RD);
%  if(~isempty(out_file)), save(out_file, '-append', 'candidates'); end

%  disp('Compute regions OK');

  % Display the superpixels and the regions
%  figure(1); 
%  subplot(2,3,1); imagesc(Es{2}); axis image; title('Edge Signal');
%  subplot(2,3,2); imagesc(ucm2(3:2:end, 3:2:end)); axis image; title('Multi UCM');
  sp = bwlabel(ucm2 < 0.20); sp = sp(2:2:end, 2:2:end);
%  for i = 1:3, csp(:,i) = accumarray(sp(:), linIt(I(:,:,i)), [], @mean); end
%  subplot(2,3,3); imagesc(ind2rgb(sp, im2double(uint8(csp)))); axis image; title('Superpixels');
  if(~isempty(out_file)), save(out_file, '-append', 'sp'); end
  
%  boxes = candidates.bboxes(1:2000, [2 1 4 3]);
  
  % Compute the RGB Features
%  net_file = fullfile_ext(p.snapshot_dir, sprintf('nyud2_finetune_color_iter_%d', 30000), 'caffemodel');
%  net_def_file = fullfile('nyud2_finetuning', 'imagenet_color_256_fc6.prototxt');
%  mean_file = fullfile_ext(p.mean_file_color, 'mat');
%  rcnn_model = rcnn_create_model(net_def_file, net_file, mean_file);
%  rcnn_model = rcnn_load_model(rcnn_model);
%  feat{1} = rcnn_features(I, boxes, rcnn_model);

  % Compute the HHA Features
  HHA = saveHHA([image_name], C, p.for_std2p_hha_dir, D, RD);
%  net_file = fullfile_ext(p.snapshot_dir, sprintf('nyud2_finetune_hha_iter_%d', 30000), 'caffemodel');
%  net_def_file = fullfile('nyud2_finetuning', 'imagenet_hha_256_fc6.prototxt');
%  mean_file = fullfile_ext(p.mean_file_hha, 'mat');
%  rcnn_model = rcnn_create_model(net_def_file, net_file, mean_file);
%  rcnn_model = rcnn_load_model(rcnn_model);
%  feat{2} = rcnn_features(HHA, boxes, rcnn_model);
  
  disp('Compute the HHA Features OK');
  return;

end

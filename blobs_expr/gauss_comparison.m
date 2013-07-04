% % % clear all
% % % close all
% % cd /home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/blobs_expr
xaxis = [2, 500];
% % range = [2000, 1000];
% % sigma_types = {'single', 'median', 'multiple'};
% % acc = zeros(length(xaxis), length(sigma_types));
% % addpath('..');
% % [ data_params, alg_params ] = initializeblobs(3000);
% % data_params.location = 'sample_complexity';    
% % data_params.m = 1000;
% % 
% % % 
% % % data_params.same = 1;
% % % [ Xsame, Ysame ] = get_all_data( data_params, alg_params );
% % % 
% % % data_params.same = 0;
% % % [ Xdiff, Ydiff ] = get_all_data( data_params, alg_params );
% % 
% % vals_same = {};
% % vals_diff = {};
% sig = 1;
% for block_idx = 2%1:length(xaxis)
%     fprintf('iteration : %d\n', block_idx);
%     vals_same_ = zeros(length(Xsame), 1);
%     vals_diff_ = zeros(length(Xsame), 1);
%     for i = 2000:length(Xsame)
%         fprintf('%d\n', i);
%         tmp = SumExtended( Xsame{i}(1:range(block_idx), :), Ysame{i}(1:range(block_idx), :), xaxis(block_idx), [1,2], sig );
%         vals_same_(i) = sum(tmp) / sqrt(length(tmp));
%         tmp = SumExtended( Xdiff{i}(1:range(block_idx), :), Ydiff{i}(1:range(block_idx), :), xaxis(block_idx), [1,2], sig );
%         vals_diff_(i) = sum(tmp) / sqrt(length(tmp));       
%     end    
%     vals_same{block_idx}(vals_same_ ~= 0) = vals_same_(vals_same_ ~= 0);
%     vals_diff{block_idx}(vals_diff_ ~= 0) = vals_diff_(vals_diff_ ~= 0);
% end

load('/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/blobs_expr/gauss_comparison_results', 'vals_same', 'vals_diff');

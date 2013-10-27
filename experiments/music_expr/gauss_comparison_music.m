% clear all
% close all
cd /home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/music_expr
xaxis = [2, 250];
sigma_types = {'single', 'median', 'multiple'};
acc = zeros(length(xaxis), length(sigma_types));
addpath('..');
[ data_params, alg_params ] = initializesongs(0);
data_params.location = 'sample_complexity';    
data_params.m = 250;
vals_same = {};
vals_diff = {};
[X, Y] = get_data(2*data_params.m,data_params);    
sig = get_median_sigma( X, Y );
nr_iter = 3000;
for block_idx = 1:length(xaxis)
    fprintf('iteration : %d\n', block_idx);
    vals_same_ = zeros(nr_iter, 1);
    vals_diff_ = zeros(nr_iter, 1);
    for i = 1:nr_iter
        fprintf('block_idx = %d, %d\n', block_idx, i);
        randn('seed', i);
        rand('seed', i);
        [Xsame, ~] = get_data(2*data_params.m,data_params);    
        [Ysame, ~] = get_data(2*data_params.m,data_params);    
        [Xdiff, Ydiff] = get_data(2*data_params.m,data_params);            
        tmp = sum_extended( Xsame, Ysame, xaxis(block_idx), 1:1000, sig );
        vals_same_(i) = sum(tmp) / length(tmp);
        tmp = sum_extended( Xdiff, Ydiff, xaxis(block_idx), 1:1000, sig );
        vals_diff_(i) = sum(tmp) / length(tmp);       
    end    
    vals_same{block_idx}(vals_same_ ~= 0) = vals_same_(vals_same_ ~= 0);
    vals_diff{block_idx}(vals_diff_ ~= 0) = vals_diff_(vals_diff_ ~= 0);
end

load('/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/music_expr/gauss_comparison_results', 'vals_same', 'vals_diff');

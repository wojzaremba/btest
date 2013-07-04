clear all
close all
cd /home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/blobs_expr
xaxis = [2, 5, 10, 20];
sigma_types = {'single', 'median', 'multiple'};
acc = zeros(length(xaxis), length(sigma_types));
addpath('..');
[ data_params, alg_params ] = initializeblobs(2000);
data_params.location = 'bug_chasing';    
data_params.m = 100;
data_params.same = 0;
[ Xdiff, Ydiff ] = get_all_data( data_params, alg_params );
data_params.same = 1;
[ Xsame, Ysame ] = get_all_data( data_params, alg_params );
vals_diff = {};
sig = 1;
for block_idx = 1:length(xaxis)
    fprintf('iteration : %d\n', block_idx);
    vals_same_ = zeros(length(Xdiff), 1);
    vals_diff_ = zeros(length(Xdiff), 1);
    for i = 1:length(Xdiff)
        fprintf('%d\n', i);
        tmp = SumExtended( Xsame{i}, Ysame{i}, xaxis(block_idx), [1,2], sig );
        vals_same_(i) = sum(tmp) / length(tmp);               
        tmp = SumExtended( Xdiff{i}, Ydiff{i}, xaxis(block_idx), [1,2], sig );
        vals_diff_(i) = sum(tmp) / length(tmp);       
    end    
    vals_same{block_idx}(vals_same_ ~= 0) = vals_same_(vals_same_ ~= 0);
    vals_diff{block_idx}(vals_diff_ ~= 0) = vals_diff_(vals_diff_ ~= 0);
end

same = zeros(4, 1);
diff = zeros(4, 1);
for i = 1:length(xaxis)
    fprintf('same k = %d, mean = %f, var = %f\n', xaxis(i), mean(vals_same{i}), var(vals_same{i}));
    same(i) = var(vals_same{i});
end
fprintf('\n')
for i = 1:length(xaxis)    
    fprintf('diff k = %d, mean = %f, var = %f\n', xaxis(i), mean(vals_diff{i}), var(vals_diff{i}));
    diff(i) = var(vals_diff{i});
end

loglog(xaxis, same, 'Color', 'r');
hold on
loglog(xaxis, diff, 'Color', 'b');
hold off
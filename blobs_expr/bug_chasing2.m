cd /home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/blobs_expr
xaxis = [10, 20, 30, 50];
sigma_types = {'single', 'median', 'multiple'};
acc = zeros(length(xaxis), length(sigma_types));
addpath('..');
[ data_params, alg_params ] = initializeblobs(500);
data_params.num_blobs=1;
data_params.location = 'bug_chasing2';    
data_params.same = 0;
vals_diff = {};
sig = 1;
for block_idx = 1:length(xaxis)
    data_params.m = xaxis(block_idx);
    [ Xdiff, Ydiff ] = get_all_data( data_params, alg_params );
    for k = 1:length(Ydiff)
        Ydiff{i} = Ydiff{i} + 10;
    end
    fprintf('iteration : %d\n', block_idx);
    vals_diff_ = zeros(length(Xdiff), 1);
    for i = 1:length(Xdiff)
        fprintf('%d\n', i);           
        tmp = SumExtended( Xdiff{i}, Ydiff{i}, xaxis(block_idx), [1,2], sig );
        vals_diff_(i) = sum(tmp) / length(tmp);       
    end    
    vals_diff{block_idx}(vals_diff_ ~= 0) = vals_diff_(vals_diff_ ~= 0);
end

vars = zeros(length(xaxis), 1);
means = zeros(length(xaxis), 1);
for i = 1:length(xaxis)
    vars(i) = var(vals_diff{i});
    means(i) = mean(vals_diff{i});
end

plot(log(xaxis), vars);
polyfit(log(xaxis'), log(vars), 1)
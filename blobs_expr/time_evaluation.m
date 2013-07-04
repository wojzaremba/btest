clear all
close all
cd /home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/blobs_expr
addpath('..');
xaxis = 2.^[1, 3, 5, 6];
sigma_types = {'median', 'multiple'};
opt_execution_time = zeros(length(xaxis), length(sigma_types));
btype_execution_time = zeros(length(sigma_types), 1);
[ data_params, alg_params ] = initializeblobs(100);
data_params.location = 'timeevaluation_machine_at_work';    
data_params.same = 0;
[ X, Y ] = get_all_data( data_params, alg_params );
% inner block size makes distribution non-Gaussian
opt_execution_time(4, 2) = NaN;
for s_idx = 1:length(sigma_types)
    alg_params.type = 'opt';
    alg_params.sigma_type = sigma_types{s_idx};
    for i = 1:length(xaxis)
        if (isnan(opt_execution_time(i, s_idx)))
            continue;
        end
        alg_params.innersize = xaxis(i);
        [~, opt_execution_time(i, s_idx), nn] = single_test(data_params,alg_params, X, Y);
        fprintf('opt_execution_time = %f, nn = %d, i = %d, s_idx = %d\n\n', opt_execution_time(i, s_idx), nn, i, s_idx);
    end
    alg_params.sigma_type = sigma_types{s_idx};
    alg_params.type = 'btest';
    alg_params.innersize = -1;
    fprintf('btest\n');
    [~, btype_execution_time(s_idx), ~] = single_test(data_params,alg_params, X, Y);
end

mmdu_types = {'pears', 'gamma', 'spec', 'boot'};
num_trials = {3, 100, 3, 3};
execution_time_mmdu = NaN * ones(length(mmdu_types), 1);
for i = 1:length(mmdu_types)
    fprintf('mmdu_types = %s\n', mmdu_types{i});
    alg_params.num_trials = num_trials{i};
    alg_params.sigma_type = 'median';
    alg_params.innersize = -1;
    alg_params.type = mmdu_types{i};
    [~, execution_time_mmdu(i), nn] = single_test(data_params,alg_params, X, Y);
    fprintf('execution_time_mmdu = %f, nn = %d, i = %d, s_idx = %d\n\n', execution_time_mmdu(i), nn, i, s_idx);
end
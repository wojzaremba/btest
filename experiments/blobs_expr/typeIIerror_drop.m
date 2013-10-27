xaxis = 2.^(1:6);
sigma_types = {'single', 'median', 'multiple'};
acc = zeros(length(xaxis), length(sigma_types));
addpath(genpath('../../'));
[ data_params, alg_params ] = initializeblobs(1000);
data_params.location = 'testIIerror_drop';    
alg_params.type = 'opt';
data_params.same = 0;
[ X, Y ] = get_all_data( data_params, alg_params );
% inner block size makes distribution non-Gaussian
acc(6, 3) = NaN;
for s_idx = 1:length(sigma_types)
    alg_params.sigma_type = sigma_types{s_idx};
    for i = 1:length(xaxis)
        if (isnan(acc(i, s_idx)))
            continue;
        end
        alg_params.innersize = xaxis(i);
        [acc(i, s_idx), ~, nn] = single_test(data_params,alg_params, X, Y);
        fprintf('acc = %f, nn = %d, i = %d, s_idx = %d\n\n', acc(i, s_idx), nn, i, s_idx);
    end
end

mmdu_types = {'pears', 'gamma', 'spec', 'boot'};
alg_params.num_trials = 10;
acc_mmdu = NaN * ones(length(mmdu_types), 2);
for i = 1:length(mmdu_types)
    fprintf('mmdu_types = %s\n', mmdu_types{i});
    for s_idx = 1:2
        alg_params.sigma_type = sigma_types{s_idx};
        alg_params.innersize = -1;
        alg_params.type = mmdu_types{i};
        [acc_mmdu(i, s_idx), ~, nn] = single_test(data_params,alg_params, X, Y);
    end
end

addpath(genpath('../../'));
num_trails = 1000;
data_types = {'mean', 'var', 'sine'};

for data_type_idx = 1:length(data_types)
    [ data_params, alg_params ] = initialize_mean_var_sine(num_trails, data_types{data_type_idx});
    data_params.location = 'results_mean_var_freq';  
    data_params_same = data_params;
    data_params_same.same = 1;

    data_params_diff = data_params;
    data_params_diff.same = 0;
    [ Xsame, Ysame ] = get_all_data( data_params_same, alg_params );
    [ Xdiff, Ydiff ] = get_all_data( data_params_diff, alg_params );

    params_diff.which_data = [data_params_diff.which_data, 'same1'];

    types = {'opt', 'btest'};

    for t_idx = 1:length(types)
        alg_params.type = types{t_idx};
        alg_params.innersize = 2;
        alg_params.sigma_type = 'median';

        [acc, timeall, nn] = single_test(data_params_same,alg_params, Xsame, Ysame);
        fprintf('data_type = %s, type = %s, alg_params.sigma_type = %s same 1 - acc = %f, nn = %d, timeall = %f\n', data_types{data_type_idx}, types{t_idx}, alg_params.sigma_type, 1 - acc, nn, timeall);
        [acc, timeall, nn] = single_test(data_params_diff,alg_params, Xdiff, Ydiff);
        fprintf('data_type = %s, type = %s, alg_params.sigma_type = %s diff acc = %f, nn = %d, timeall = %f\n', data_types{data_type_idx}, types{t_idx}, alg_params.sigma_type, acc, nn, timeall);
        fprintf('\n\n');
    end

    alg_params.num_trials = 100;
    types = {'spec', 'boot'};
    for t_idx = 1:length(types)
        alg_params.type = types{t_idx};
        alg_params.innersize = -1;
        alg_params.sigma_type = 'median';

        [acc, timeall, nn] = single_test(data_params_same,alg_params, Xsame, Ysame);
        fprintf('type = %s, alg_params.sigma_type = %s same 1 - acc = %f, nn = %d, timeall = %f\n', types{t_idx}, alg_params.sigma_type, 1 - acc, nn, timeall);
        [acc, timeall, nn] = single_test(data_params_diff,alg_params, Xdiff, Ydiff);
        fprintf('type = %s, alg_params.sigma_type = %s diff acc = %f, nn = %d, timeall = %f\n', types{t_idx}, alg_params.sigma_type, acc, nn, timeall);
    end
end

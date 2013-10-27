% clear all
% close all
cd /home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/music_expr
num_trails = 1000;
[ data_params, alg_params ] = initializesongs(num_trails);
data_params.location = 'results';  
data_params_same = data_params;
data_params_same.same = 1;

data_params_diff = data_params;
data_params_diff.same = 0;

sigma_types = {'single', 'median', 'multiple'};
types = {'opt', 'btest'};

for t_idx = 1:length(types)
    for s_idx = 1:length(sigma_types)
        alg_params.type = types{t_idx};
        alg_params.innersize = 2;
        alg_params.sigma_type = sigma_types{s_idx};

        alg_params.check_type1 = data_params_same.same;
        [acc, timeall, nn] = single_test(data_params_same,alg_params);
        fprintf('type = %s, alg_params.sigma_type = %s same 1 - acc = %f, nn = %d, timeall = %f\n', types{t_idx}, alg_params.sigma_type, 1 - acc, nn, timeall);
        alg_params.check_type1 = data_params_diff.same;
        [acc, timeall, nn] = single_test(data_params_diff,alg_params);
        fprintf('type = %s, alg_params.sigma_type = %s diff acc = %f, nn = %d, timeall = %f\n', types{t_idx}, alg_params.sigma_type, acc, nn, timeall);
    end
    fprintf('\n\n');
end

alg_params.num_trials = 100;
types = {'spec', 'boot'};
for t_idx = 1:length(types)
    for s_idx = 1:2
        alg_params.type = types{t_idx};
        alg_params.innersize = 2;
        alg_params.sigma_type = sigma_types{s_idx};

        alg_params.check_type1 = data_params_same.same;
        [acc, timeall, nn] = single_test(data_params_same,alg_params);
        fprintf('type = %s, alg_params.sigma_type = %s same 1 - acc = %f, nn = %d, timeall = %f\n', types{t_idx}, alg_params.sigma_type, 1 - acc, nn, timeall);
        alg_params.check_type1 = data_params_diff.same;        
        [acc, timeall, nn] = single_test(data_params_diff,alg_params);
        fprintf('type = %s, alg_params.sigma_type = %s diff acc = %f, nn = %d, timeall = %f\n', types{t_idx}, alg_params.sigma_type, acc, nn, timeall);
    end
    fprintf('\n\n');
end
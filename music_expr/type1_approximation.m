cd /home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/music_expr
xaxis = 2.^(1:7);
sigma_types = {'single', 'median', 'multiple'};
type1error = zeros(length(xaxis), length(sigma_types));
type1var = zeros(length(xaxis), length(sigma_types));
nn = zeros(length(xaxis), length(sigma_types));
addpath('..');

for j = 1%500:500:30000

    [ data_params, alg_params ] = initializesongs(j);
    data_params.location = 'test1error_approximation';    
    alg_params.type = 'opt';
    data_params.same = 1;
    data_params.m = 1000;

    for s_idx = 1:length(sigma_types)
        alg_params.sigma_type = sigma_types{s_idx};
        for i = 1:length(xaxis)
            alg_params.innersize = xaxis(i);
            [type1error(i, s_idx), ~, nn(i, s_idx), type1var(i, s_idx)] = single_test(data_params,alg_params);
            fprintf('acc = %f, nn = %d, i = %d, s_idx = %d\n\n', type1error(i, s_idx), nn(i, s_idx), i, s_idx);
        end
    end

end
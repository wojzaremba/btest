cd /home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/sine_expr
xaxis = 2.^(1:7);
data_types = {'mean', 'var', 'sine'};
type1error = zeros(length(xaxis), length(data_types));
type1var = zeros(length(xaxis), length(data_types));
nn = zeros(length(xaxis), length(sigma_types));
addpath('..');

for j = 1%1000:1000:30000
    for data_type_idx = 1:length(data_types)
        [ data_params, alg_params ] = initialize_mean_var_sine(j, data_types{data_type_idx});    
        data_params.location = 'sine_test1error_approximation';    
        alg_params.type = 'opt';
        data_params.same = 1;
        data_params.m = 1000;
        alg_params.sigma_type = 'median';
        for i = 1:length(xaxis)
            alg_params.innersize = xaxis(i);
            [type1error(i, data_type_idx), ~, nn(i, data_type_idx), type1var(i, data_type_idx)] = single_test(data_params,alg_params);
            fprintf('data_type = %s, acc = %f, nn = %d, i = %d\n\n', data_types{data_type_idx}, type1error(i, data_type_idx), nn(i, data_type_idx), i);
        end
    end

end
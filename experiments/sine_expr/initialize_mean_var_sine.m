function [ data_params, alg_params ] = initialize_mean_var_sine(num_trails, type)
    data_params.which_data=type;
    data_params.dimension=2;
    data_params.difference=0.5;
    data_params.m=1000;
    alg_params.num_trials=num_trails;
    alg_params.lambda=10E-4;
    alg_params.innersize=29;
    alg_params.path_prefix='';
    alg_params.check_type1=0;
    alg_params.do_xval=0;
    alg_params.alpha = 0.05;
end
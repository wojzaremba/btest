function [ data_params, alg_params ] = initializeblobs(num_trails)
    addpath('../');
    randn('seed', 1);
    rand('seed', 1);
    data_params.which_data='blobs';
    data_params.dimension=2;
    data_params.difference=0.5;
    data_params.stretch=10;
    data_params.angle=4; % (pi/angle) is rotation
    data_params.blob_distance=15;
    data_params.num_blobs=5;
    data_params.window_length=1000; % dimension of samples
    data_params.added_noise = 0.5;  % standard deviation of added noise
    data_params.f_multiple=3;  
    data_params.f_transmit_multiple=5;
    data_params.offset=2;
    data_params.envelope_scale=1;  
    data_params.relevant=2;
    data_params.sigma_selection=3;
    alg_params = struct;
    alg_params.num_trials=num_trails;
    alg_params.sigma_step=1;
    alg_params.lambda=10E-4;
    alg_params.path_prefix='';
    alg_params.check_type1=0;
    alg_params.do_xval=0;
    alg_params.alpha = 0.05;    
    data_params.m = 1000;
end

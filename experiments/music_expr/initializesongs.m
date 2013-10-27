function [ data_params, alg_params ] = initializesongs(num_trails)
    addpath('../');
    randn('seed', 1);
    rand('seed', 1);
    data_params.which_data='am';
    data_params.dimension=2;
    data_params.wav_dir='/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/music/';
    data_params.wav1='song1';
    data_params.wav2='song2';
    data_params.window_length=1000; % dimension of samples
    data_params.added_noise = 0.0;  % standard deviation of added noise
    data_params.f_multiple=3;  
    data_params.f_transmit_multiple=5;
    data_params.offset=2;
    data_params.m = 1000;
    data_params.envelope_scale=1;  
    data_params.relevant=2;
    data_params.sigma_selection=3;
    alg_params.num_trials=num_trails;
    alg_params.lambda=10E-4;
    alg_params.alpha = 0.05;
    alg_params.path_prefix='';
    alg_params.check_type1=0;
    alg_params.do_xval=0;
end

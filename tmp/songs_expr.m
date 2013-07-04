clear all
close all
randn('seed', 1);
rand('seed', 1);
data_params.which_data='am';
data_params.dimension=2;
data_params.difference=0.5;
data_params.stretch=10;
data_params.angle=4; % (pi/angle) is rotation
data_params.blob_distance=15;
data_params.num_blobs=5;
data_params.wav_dir='/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/music/';
data_params.wav1='song1';
data_params.wav2='song2';
data_params.window_length=1000; % dimension of samples
data_params.added_noise = 0.0;  % standard deviation of added noise
data_params.f_multiple=3;  
data_params.f_transmit_multiple=5;
data_params.offset=2;
data_params.envelope_scale=1;  
data_params.relevant=2;
data_params.same = 0;
data_params.sigma_selection=3;
alg_params.num_trials=2;
alg_params.sigma_from=-15;
alg_params.sigma_to=10;
alg_params.sigma_step=1;
alg_params.lambda=10E-4;
% alg_params.type = 'opt';
alg_params.alpha = 0.05;
alg_params.path_prefix='';
alg_params.check_type1=0;
alg_params.do_xval=0;

X = cell(alg_params.num_trials, 1);
Y = cell(alg_params.num_trials, 1);
data_params.m = 1000;
m = data_params.m;
for nn=1:alg_params.num_trials;
    fprintf('Generating data %d/%d\n', nn, alg_params.num_trials);
    randn('seed', nn);
    rand('seed', nn);            
    if (data_params.same)
        [X{nn}, ~] = get_data(2*m,data_params);    
        [Y{nn}, ~] = get_data(2*m,data_params);    
    else
        [X{nn}, Y{nn}] = get_data(2*m,data_params);    
    end
end

alg_params.type = 'spec';
alg_params.innersize = 2;

[acc, timeall] = single_test(data_params,alg_params, X, Y);
timeall / alg_params.num_trials



% 
% acceptancedist = zeros(floor(log2(size(X{1},1))), 1);
% hh = {};
% for nn=1:alg_params.num_trials;
%     X_ = X{nn};
%     Y_ = Y{nn};
%     X_ = X_(1:(size(X_, 1) / 2), :);
%     Y_ = Y_(1:(size(X_, 1) / 2), :);
%     lastaccepted = log2(fit_kstest(X_, Y_));
%     acceptancedist(lastaccepted, 1) = acceptancedist(lastaccepted, 1) + 1;
% end
clear all;
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
data_params.same = 1;
alg_params.num_trials = 100;
alg_params.sigma_from=1;
alg_params.sigma_step=1;
alg_params.sigma_to=1;
data_params.m = 1000;

X = cell(alg_params.num_trials, 1);
Y = cell(alg_params.num_trials, 1);
m=data_params.m;
for nn=1:alg_params.num_trials;
    fprintf('Generating data %d/%d\n', nn, alg_params.num_trials);
    randn('seed', nn);
    rand('seed', nn);
    % extract data, two halfs: training and test data
    if (data_params.same)
        [X{nn}, ~] = get_data(2*data_params.m,data_params);    
        [Y{nn}, ~] = get_data(2*data_params.m,data_params);    
    else
        [X{nn}, Y{nn}] = get_data(2*data_params.m,data_params);    
    end
end

sigmas=2.^[alg_params.sigma_from:alg_params.sigma_step:alg_params.sigma_to];

acceptancedist = zeros(floor(log2(size(X{1},1))), 1);
hh = {};
for nn=1:alg_params.num_trials;
    X_ = X{nn};
    Y_ = Y{nn};
    X_ = X_(1:(size(X_, 1) / 2), :);
    Y_ = Y_(1:(size(Y_, 1) / 2), :);    
    lastaccepted = log2(fit_kstest(X_, Y_));
    acceptancedist(lastaccepted, 1) = acceptancedist(lastaccepted, 1) + 1;
end
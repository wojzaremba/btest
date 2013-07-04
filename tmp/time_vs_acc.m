% clear all
% close all
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
data_params.m = 1000;
data_params.same = 0;
alg_params.num_trials=100;
alg_params.sigma_step=1;
alg_params.lambda=10E-4;
alg_params.path_prefix='';
alg_params.check_type1=0;
alg_params.do_xval=0;

X = cell(alg_params.num_trials, 1);
Y = cell(alg_params.num_trials, 1);
m=data_params.m;
for nn=1:alg_params.num_trials;
    fprintf('Generating data %d/%d\n', nn, alg_params.num_trials);
    randn('seed', nn);
    rand('seed', nn);
    % extract data, two halfs: training and test data
    if (data_params.same)
        [X{nn}, ~] = get_data(2*m,data_params);    
        [Y{nn}, ~] = get_data(2*m,data_params);    
    else
        [X{nn}, Y{nn}] = get_data(2*m,data_params);    
    end
end

alg_params.alpha = 0.05;

froms = {1, -15, 1, -15};
tos = {1, 10, 1, 10};
types = {'opt', 'opt', 'btest', 'btest'};
innersizes = {2, 2, -1, -1};
acc = zeros(length(froms), 1);
timeall = zeros(length(froms), 1);

for i = 1:length(froms)
    alg_params.type = types{i};
    alg_params.innersize = innersizes{i};
    alg_params.sigma_from = froms{i};
    alg_params.sigma_to = tos{i};
    [acc(i), timeall(i)] = single_test(data_params,alg_params, X, Y);
    timeall(i) = timeall(i) / alg_params.num_trials;
end

scatter(acc, timeall)
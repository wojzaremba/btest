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
alg_params.num_trials=100;
alg_params.sigma_from=1;
alg_params.sigma_to=1;
alg_params.sigma_step=1;
alg_params.lambda=10E-4;
alg_params.path_prefix='';
alg_params.check_type1=0;
alg_params.alpha = 0.05;
alg_params.do_xval=0;
alg_params.type = 'opt';
data_params.same = 0;
X = cell(alg_params.num_trials, 1);
Y = cell(alg_params.num_trials, 1);
for nn=1:alg_params.num_trials;
    randn('seed', nn);
    rand('seed', nn); 
    fprintf('Generating data %d/%d\n', nn, alg_params.num_trials);
    m=1500;
    if (data_params.same)
        [X{nn}, ~] = get_data(2*m,data_params);    
        [Y{nn}, ~] = get_data(2*m,data_params);    
    else
        [X{nn}, Y{nn}] = get_data(2*m,data_params);    
    end
end

for i = 64%, 2]%, 5, 10, 2]%[20, 2, 5]%[2, 5, 10, 15, 20, 25, 30]
    m_inf = 200;
    m_sup = 1500;
    alg_params.innersize = i;
    while ((m_sup - m_inf) > 10)
        data_params.m = floor((m_inf +  m_sup) / 2);
        data_params.m
        [acc, timeall] = single_test(data_params,alg_params, X, Y);
        acc
        timeall
        if (abs(acc - 0.05) <= 0.01)
            break;
        end
        if (acc > 0.05)
            m_inf = data_params.m;
        else
            m_sup = data_params.m;
        end
    end
end
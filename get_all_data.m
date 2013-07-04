function [ X, Y ] = get_all_data( data_params, alg_params )
    X = cell(alg_params.num_trials, 1);
    Y = cell(alg_params.num_trials, 1);
    m=data_params.m;
    parfor nn=1:alg_params.num_trials;
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
end


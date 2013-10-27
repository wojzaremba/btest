function [error, timeall, nn, variance] = single_test(data_params,alg_params, X_, Y_)
m = data_params.m;
if (~exist('X_', 'var'))
    X_ = cell(alg_params.num_trials, 1);
    Y_ = cell(alg_params.num_trials, 1);
    for nn=start:alg_params.num_trials;
        fprintf('Generating data %d/%d\n', nn, alg_params.num_trials);
        randn('seed', nn);
        rand('seed', nn);            
        if (data_params.same)
            [X_{nn}, ~] = get_data(2 * m, data_params);    
            [Y_{nn}, ~] = get_data(2 * m, data_params);    
        else
            [X_{nn}, Y_{nn}] = get_data(2 * m, data_params);    
        end
    end
end            
timeall_start = tic;
for nn = 1:alg_params.num_trials
    X = X_{nn};
    Y = Y_{nn};                    
    alpha = alg_params.alpha;    
    params = struct;
    params.shuff = 1000;
    params.numNullSamp = 500;   
    params.bootForce = 1;
    % compute test statistics and threshold on test data    
    sigmas = -1;
    switch alg_params.sigma_type
        case 'single'
            sigmas = 2;
            params.sig = sigmas;
        case 'multiple'
            sigma_from = -15;
            sigma_step = 1;
            sigma_to = 10;
            sigmas=2.^(sigma_from:sigma_step:sigma_to);
        case 'median'
            sigmas = get_median_sigma( X, Y );
            params.sig = sigmas;
        otherwise
            assert(0);
    end        

    Xtest = [];
    Ytest = [];
    if (strcmp(alg_params.sigma_type, 'multiple'))
        Xtrain = X((m+1):(2*m), :);
        Ytrain = Y((m+1):(2*m), :);                    
        Xtest = X(1:m, :);
        Ytest = Y(1:m, :);
    else
        Xtrain = X(1:2*m, :);
        Ytrain = Y(1:2*m, :);
    end        

    switch alg_params.type
        case {'opt', 'btest'}                
            if (strcmp(alg_params.type, 'btest'))
                innersize = fit_heuristic(size(Xtrain, 1));
            else
                innersize = alg_params.innersize;
            end           
            if (strcmp(alg_params.sigma_type, 'multiple'))
                [~, ~, ~, ws_opt, ~, ~] = opt_kernel_comb(Xtest, Ytest, innersize, sigmas, alg_params.lambda, alg_params.do_xval);                
            else
                ws_opt = 1;
            end
            [testStat(nn),thresh(nn)] = mmd_linear_combo(Xtrain,Ytrain,innersize, sigmas,ws_opt);                                        
        case 'gamma'
            assert(~strcmp(alg_params.type, 'multiple'));
            [testStat(nn), thresh(nn)] = mmdTestGamma(Xtrain,Ytrain,alpha,params);            
        case 'spec'
            params.numEigs = -1;
            params.plotEigs = 0;
            assert(~strcmp(alg_params.type, 'multiple'));
            [testStat(nn), thresh(nn)] = mmdTestSpec(Xtrain,Ytrain,alpha,params);
        case 'boot'
            assert(~strcmp(alg_params.type, 'multiple'));
            [testStat(nn), thresh(nn)] = mmdTestBoot(Xtrain,Ytrain,alpha,params);                
        case 'pears'
            assert(~strcmp(alg_params.type, 'multiple'));
            [testStat(nn), thresh(nn)] = mmdTestPears(Xtrain,Ytrain,alpha,params);                                
        otherwise
            assert(0);
    end    
end        
timeall = toc(timeall_start) / alg_params.num_trials;                  

nn = alg_params.num_trials;
fprintf('OPT: %d/%d=%f;\n', sum(testStat(1:nn) <= thresh(1:nn)), nn, sum(testStat(1:nn) <= thresh(1:nn)) / nn);           

error = mean(testStat(1:nn) <= thresh(1:nn));
variance = var(testStat(1:nn) <= thresh(1:nn));
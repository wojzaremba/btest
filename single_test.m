% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann

% Takes data parameters and algorithm parameters struct and performs a
% number of two-sample tests. Prints some results and saves the latest
% state in a file which can be loaded and further be processed
function [error, timeall, nn, variance] = single_test(data_params,alg_params, X_, Y_)
% easier to read code
m=data_params.m;

% generate filenames for temporary saving the current state for all data
% types
state_dir=strcat(alg_params.path_prefix, data_params.location, '/');
filename = strcat('state_',...
    data_params.which_data, ...
    '_alpha=', num2str(alg_params.alpha), ...
    '_m=', num2str(m), ...
    '_sigma_type=', num2str(alg_params.sigma_type), ...
    '_type=', num2str(alg_params.type), ...
    '_innersize=', num2str(alg_params.innersize), ...
    '_do_xval=', num2str(alg_params.do_xval), ...
    '_check_type1=', num2str(alg_params.check_type1) ...
    );


if strcmp(data_params.which_data, 'mean') || strcmp(data_params.which_data, 'var')
     filename=strcat(filename, ...
     '_dimension=', num2str(data_params.dimension) ...
    );
end

if strcmp(data_params.which_data, 'mean') ...
        || strcmp(data_params.which_data, 'var') ...
        || strcmp(data_params.which_data, 'sine')
    filename=strcat(filename, ...
    '_difference=', num2str(data_params.difference) ...
    );
end

if strcmp(data_params.which_data, 'blobs')
    filename=strcat(filename, ...
    '_stretch=', num2str(data_params.stretch), ...
    '_angle=', num2str(data_params.angle), ...
    '_blob_distance=', num2str(data_params.blob_distance), ...
    '_num_blobs=', num2str(data_params.num_blobs) ...
    );
end

if strcmp(data_params.which_data, 'am')
    filename=strcat(filename, ...
        '_wav1=', num2str(data_params.wav1), ...
        '_wav2=', num2str(data_params.wav2), ...
        '_window_length=', num2str(data_params.window_length), ...
        '_added_noise=', num2str(data_params.added_noise), ...
        '_f_multiple=', num2str(data_params.f_multiple), ...
        '_f_transmit_multiple=', num2str(data_params.f_transmit_multiple), ...
        '_offset=', num2str(data_params.offset), ...
        '_envelope_scale=', num2str(data_params.envelope_scale) ...
    );
end

state_filename=strcat(state_dir, filename, '.mat');

% check whether state dir exists and create if not
if exist(data_params.location, 'dir')==0
    mkdir(data_params.location);
end


% check if a state file exists and continue in this case
testStat = zeros(alg_params.num_trials, 1);
thresh = zeros(alg_params.num_trials, 1);    
if ~exist(state_filename,'file')    
    start=1;
    nn = 0;
    timeall = 0;
    error = 01;
    variance = -1;
    nn = -1;
else    
%     try
        load(state_filename);
%     catch
%         error = -1;
%         variance = -1;
%         nn = -1;
%         timeall = 0;
%         return;
%     end
    nonzero = testStat ~= 0;
    testStat = testStat(nonzero);
    thresh = thresh(nonzero);    
    start = length(testStat) + 1;
    testStat = [testStat; zeros(alg_params.num_trials - start + 1, 1)];
    thresh = [thresh; zeros(alg_params.num_trials - start + 1, 1)];  
    error = mean(testStat(1:(start - 1))<=thresh(1:(start-1)));
    variance = var(testStat(1:(start - 1))<=thresh(1:(start - 1)));
    nn = start - 1;
    return;
end


% do a number of two-sample tests to estimate errors
if (start <= alg_params.num_trials)
%     if (~exist('X_', 'var'))
%         X_ = cell(alg_params.num_trials, 1);
%         Y_ = cell(alg_params.num_trials, 1);
%         for nn=start:alg_params.num_trials;
%             fprintf('Generating data %d/%d\n', nn, alg_params.num_trials);
%             randn('seed', nn);
%             rand('seed', nn);            
%             if (data_params.same)
%                 [X_{nn}, ~] = get_data(2*m,data_params);    
%                 [Y_{nn}, ~] = get_data(2*m,data_params);    
%             else
%                 [X_{nn}, Y_{nn}] = get_data(2*m,data_params);    
%             end
%         end
%     end            
    generate = 0;
    if (~exist('X_', 'var'))
        fprintf('Dont meassure time\n');        
        generate = 1;
    else
        timeall_start = tic;
    end
    for nn=start:alg_params.num_trials
        X = [];
        Y = [];
        fprintf('nn = %d\n', nn);
        if (generate)
            randn('seed', nn);
            rand('seed', nn);            
            if (data_params.same)
                [X, ~] = get_data(2*m,data_params);    
                [Y, ~] = get_data(2*m,data_params);    
            else
                [X, Y] = get_data(2*m,data_params);    
            end
        else
            X = X_{nn};
            Y = Y_{nn};                    
        end
        
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
%         fprintf('toc(timeall_start) = %f\n', toc(timeall_start));
        if ((generate) && (mod(nn, 1000) == 0))
            save(state_filename, 'thresh', 'testStat', 'timeall');    
        end
    end      
    if (~exist('X_', 'var'))
        timeall = -1;
    else
        timeall = (toc(timeall_start) + timeall * (start - 1)) / alg_params.num_trials;                  
    end
    save(state_filename, 'thresh', 'testStat', 'timeall');    
end
nn = alg_params.num_trials;
fprintf('Timing: %f, ', timeall);
fprintf('OPT: %d/%d=%f;\n',    sum(testStat(1:nn)<=thresh(1:nn)),nn, sum(testStat(1:nn)<=thresh(1:nn))/nn);           

error = mean(testStat(1:nn)<=thresh(1:nn));
variance = var(testStat(1:nn)<=thresh(1:nn));
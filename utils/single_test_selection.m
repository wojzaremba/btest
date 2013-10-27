% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann

% Does the same as single_test.m, but each kernel corresponds to one single
% dimension of the data in order to simulate a feature selection problem.
% Works with a fixed sigma only
% Note that we only consider maxmmd/maxrat vs L2/Opt here to illustrate
% combined kernels vs single ones
function single_test_selection(data_params,alg_params)
starttime = tic;
% easier to read code
m=data_params.m;

% generate filenames for temporary saving the current state for all data
% types
state_dir=strcat(alg_params.path_prefix, 'states/');
filename = strcat('state_',...
    data_params.which_data, ...
    '_m=', num2str(m), ...
    '_num_trials=', num2str(alg_params.num_trials), ...
    '_sigma_from=', num2str(alg_params.sigma_from), ...
    '_sigma_to=', num2str(alg_params.sigma_to), ...
    '_sigma_step=', num2str(alg_params.sigma_step),...
    '_check_type1=', num2str(alg_params.check_type1), ...
    '_innersize=', num2str(alg_params.innersize), ...
    '_dimension=', num2str(data_params.dimension), ...
    '_difference=', num2str(data_params.difference), ...
    '_relevant=', num2str(data_params.relevant) ...
    );

state_filename=strcat(state_dir, filename, '.mat');

% check whether state dir exists and create if not
if exist('states', 'dir')==0
    mkdir 'states';
end

% check if a state file exists and continue in this case
if ~exist(state_filename,'file')
    start=1;
else
    load(state_filename);
    start=nn+1;
end

% do a number of two-sample tests to estimate errors
for nn=start:alg_params.num_trials;
    % extract data, two halfs: training and test data
    [X, Y] = get_data(2*m,data_params);
    
    % if type 1 error should be checked, merge samples
    if alg_params.check_type1
        Z=[X;Y];
        inds=randperm(size(Z,1));
        Z=Z(inds,:);
        X=Z(1:2*data_params.m,:);
        Y=Z(2*m+1:4*m,:);
    end

    % learn kernel on training data, note that each weight dimensions
    % corresponds to one data dimension. sigma is fixed
    [ws_maxmmd(:,nn),ws_maxrat(:,nn),ws_l2(:,nn),ws_opt(:,nn)]=...
        opt_kernel_comb_selection(X(1:m,:),Y(1:m,:), alg_params.innersize, data_params.sigma_selection,...
        alg_params.lambda);
    
    % evaluate kernel on test data
    X=X(m+1:2*m,:);
    Y=Y(m+1:2*m,:);
    
    % compute test statistics and threshold on test data
    [testStat_maxmmd(nn),thresh_maxmmd(nn)]=mmd_linear_combo_selection(X,Y,alg_params.innersize,data_params.sigma_selection,ws_maxmmd(:,nn));
    [testStat_maxrat(nn),thresh_maxrat(nn)]=mmd_linear_combo_selection(X,Y,alg_params.innersize,data_params.sigma_selection,ws_maxrat(:,nn));
    [testStat_l2(nn),thresh_l2(nn)]=mmd_linear_combo_selection(X,Y,alg_params.innersize,data_params.sigma_selection,ws_l2(:,nn));
    [testStat_opt(nn),thresh_opt(nn)]=mmd_linear_combo_selection(X,Y,alg_params.innersize,data_params.sigma_selection,ws_opt(:,nn));

    % output some statistics
    fprintf('OPT: %f (stat); %f(thresh)\n', testStat_opt(nn), thresh_opt(nn));
    fprintf('MxRt: %f (stat); %f(thresh)\n', testStat_maxrat(nn), thresh_maxrat(nn));
    fprintf('MxMMD: %f (stat); %f(thresh)\n', testStat_maxmmd(nn), thresh_maxmmd(nn));
    fprintf('L2: %f (stat); %f(thresh)\n', testStat_l2(nn), thresh_l2(nn));

    fprintf('acceptance rates (type II error)\n');
    fprintf('OPT: %d/%d=%f; ',    sum(testStat_opt<=thresh_opt),nn, sum(testStat_opt<=thresh_opt)/nn);
    fprintf('MxRt: %d/%d=%f; ', sum(testStat_maxrat<=thresh_maxrat),nn, sum(testStat_maxrat<=thresh_maxrat)/nn);
    fprintf('MxMMD: %d/%d=%f; ', sum(testStat_maxmmd<=thresh_maxmmd),nn, sum(testStat_maxmmd<=thresh_maxmmd)/nn);
    fprintf('L2: %d/%d=%f\n', sum(testStat_l2<=thresh_l2),nn, sum(testStat_l2<=thresh_l2)/nn);

    % save variables for current state
    entiretime = toc(starttime);
    save(state_filename, 'nn', ...
        'thresh_maxmmd', 'thresh_maxrat', 'thresh_l2', 'thresh_opt',...
        'testStat_maxmmd', 'testStat_maxrat', 'testStat_l2', 'testStat_opt',...
        'ws_maxmmd', 'ws_maxrat', 'ws_l2', 'ws_opt', 'entiretime'...
        );
end

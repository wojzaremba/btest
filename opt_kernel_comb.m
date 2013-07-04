% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann, Dino Sejdinovic

% Takes samples from P and Q, a collection of Gaussian kernel widths
% sigmas, regulariser size lambda, and a flag whether cross-validation
% should be performed and returns kernel weights according to all methods
% for kernel selection in the paper. 
function [w_maxmmd,w_maxrat,w_l2,w_opt,w_med,w_xvalc]=...
    opt_kernel_comb(X,Y,innersize,sigmas,lambda,do_xval)

lss=length(sigmas);

% kernel selection method: xvalc
% minimise expeced loss for the binary classifier interpretation of the
% MMD. Selects a single kernel
if do_xval
    num_folds=5;
    mmds=zeros(1,lss);
    for i=1:lss
        %fprintf('xvalmaxmmd for log2(sigma)=%f: ', log2(sigmas(i)));
        % different index permutation for each run
        indices=randperm(size(X,1));

        % do x-validation
        fold_mmds=zeros(1,num_folds);
        for k=1:num_folds
            [train, validation]=cross_val_fold(indices, num_folds, k);

            % training and validation points
            train=[X(train,:);Y(train,:)];
            X_val=X(validation,:);
            Y_val=Y(validation,:);

            % evaluate E[f] on the validation points for all points in P and Q
            % first mean computes function f per validation point (which is
            % mean of kernel values with all training points)
            % second mean computes mean of f values for all validation points
            E_f_P=mean(mean(rbf_dot(X_val,train,sigmas(i)),2));
            E_f_Q=mean(mean(rbf_dot(Y_val,train,sigmas(i)),2));

            fold_mmds(k)=E_f_P-E_f_Q;
        end
        mmds(i)=abs(mean(fold_mmds));
        %fprintf('mmd=%f\n', mmds(i));
    end
    w_xvalc=zeros(lss,1);
    [~,idx_maxxvalc]=max(mmds);
    w_xvalc(idx_maxxvalc)=1;
%     fprintf('sigma index for xvalc: %d\n', idx_maxxvalc);
else
    w_xvalc=zeros(lss,1);
end



% kernel selection method: med
% select single kernel that corresponds to the median distance in the data
med_sigma_idx=get_median_sigma_idx(X,Y,sigmas);
w_med=zeros(lss,1);
w_med(med_sigma_idx)=1;
% fprintf('sigma index for median: %d\n', med_sigma_idx);


% get rid of MATLAB's optimization terminated message from here
options = optimset('Display', 'off');

% some local variables to make code look nicer
m=size(X,1);
m2=floor(m/innersize);

% preallocate arrays for mmds, ratios, etc
mmds=zeros(lss,1);
vars=zeros(lss,1);
ratios=zeros(lss,1);
hh=zeros(lss,m2);

% single kernel selection methods are evaluated for all kernel sizes
for i=1:lss
    % compute kernel diagonals
%     K_XX = rbf_dot_diag(X(1:m2,:),X(m2+1:m,:),sigmas(i));
%     K_YY = rbf_dot_diag(Y(1:m2,:),Y(m2+1:m,:),sigmas(i));
%     K_XY = rbf_dot_diag(X(1:m2,:),Y(m2+1:m,:),sigmas(i));
%     K_YX = rbf_dot_diag(X(m2+1:m,:),Y(1:m2,:),sigmas(i));
    
    % this corresponds to the h-statistic that the linear time MMD is the
    % average of
    hh(i,:)=SumExtended( X, Y, innersize, 1:size(X,2), sigmas(i));%K_XX+K_YY-K_XY-K_YX;
    mmds(i)=mean(hh(i,:));
    
    %variance computed using h-entries from linear time statistic
    vars(i)=var(hh(i,:));
    
    % add lambda to ensure numerical stability
    ratios(i)=mmds(i)/(sqrt(vars(i))+lambda);
    
    % always avoid NaN as the screw up comparisons later. The appear due to
    % divisions by zero. This effectively makes the test fail for the
    % kernel that produced the NaN
    ratios(isnan(ratios))=0;
    ratios(isinf(ratios))=0;
end

% kernel selection method: maxmmd
% selects a single kernel that maxismised the MMD statistic
w_maxmmd=zeros(lss,1);
[~,idx_maxmmd]=max(mmds);
w_maxmmd(idx_maxmmd)=1;
% fprintf('sigma index for maxmmd: %d\n', idx_maxmmd);


% kernel selection method: maxrat
% selects a single kernel that maxismised ratio of the MMD by its standard
% deviation. This leads to optimal kernel selection
w_maxrat=zeros(lss,1);
[~,idx_maxrat]=max(ratios);
w_maxrat(idx_maxrat)=1;
% fprintf('sigma index for maxrat: %d\n', idx_maxrat);


% kernel selection method: L2
% selects a combination of kernels with a l2 norm constraint that maximises
% the MMD of the combination. Corresponds to maxmmd for convex kernel
% combinations. Note that this corresponds to the 'opt' method below with
% an identity matrix in the optimisation.
w_l2=zeros(lss,1);
warning off
if nnz(mmds>0)>0
    w_l2=quadprog(eye(lss),[],[],[],mmds', 1,zeros(lss,1),[],[],options);
else
    w_l2=quadprog(-eye(lss),[],[],[],mmds',-1,zeros(lss,1),[],[],options);
end
% normalise and apply a low cut to avoid unnecessary computations later
w_l2=w_l2/sum(w_l2);
w_l2(w_l2<1e-7)=0;
[~,max_l2]=max(w_l2);
% fprintf('sigma index for maximum weight of l2: %d\n', max_l2);
warning on


% kernel selection method: opt
% selects a combination of kernels via the ratio from maxrat. Corresponds
% to optimal kernel weights

% construct Q matrix and add regulariser to avoid numerical problems
Q=cov(hh');
Q=Q+eye(size(Q))*lambda;
warning off
if nnz(mmds>0)>0 % at least one positive entry
    [wa,~,~]=quadprog(Q,[],[],[],mmds', 1,zeros(lss,1),[],[],options);
else
    [wa,~,~]=quadprog(-Q,[],[],[],mmds',-1,zeros(lss,1),[],[],options);
end
warning on
% normalise and apply low cut to avoid unnecessary computations later
w_opt=zeros(lss,1);
w_opt=wa;
w_opt(w_opt<1e-7)=0;
w_opt=w_opt/sum(w_opt);
[~,max_opt]=max(w_opt);
% fprintf('sigma index for maximum weight of opt: %d\n', max_opt);

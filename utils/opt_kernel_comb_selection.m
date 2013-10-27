% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann

% Does the same as opt_kernel_comb.m, but each kernel corresponds to one
% single dimension of the data in order to simulate a feature selection
% problem. Works with a fixed sigma only
% Note that we only consider maxmmd/maxrat vs L2/Opt here to illustrate
% combined kernels vs single ones
function [w_maxmmd,w_maxrat,w_l2,w_opt]=...
    opt_kernel_comb_selection(X,Y,innersize,sigma,lambda)

% get rid of MATLAB's optimization terminated message from here
options = optimset('Display', 'off');

% some local variables to make code look nicer
m=size(X,1);
m2=floor(m/innersize);
dim=size(X,2);

% preallocate arrays for mmds, ratios, etc
mmds=zeros(dim,1);
vars=zeros(dim,1);
ratios=zeros(dim,1);
hh=zeros(dim,m2);

% single kernel selection methods are evaluated for all dimensions
for i=1:dim
    hh(i,:)= sum_extended(X, Y, innersize, i, sigma);
    mmds(i)=mean(hh(i,:));
    
    % variance computed using h-entries from linear time statistic
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
w_maxmmd=zeros(dim,1);
[~,idx_maxmmd]=max(mmds);
w_maxmmd(idx_maxmmd)=1;
fprintf('sigma index for maxmmd: %d\n', idx_maxmmd);


% kernel selection method: maxrat
% selects a single kernel that maxismised ratio of the MMD by its standard
% deviation. This leads to optimal kernel selection
w_maxrat=zeros(dim,1);
[~,idx_maxrat]=max(ratios);
w_maxrat(idx_maxrat)=1;
fprintf('sigma index for maxrat: %d\n', idx_maxrat);


% kernel selection method: L2
% selects a combination of kernels with a l2 norm constraint that maximises
% the MMD of the combination. Corresponds to maxmmd for convex kernel
% combinations. Note that this corresponds to the 'opt' method below with
% an identity matrix in the optimisation.
w_l2=zeros(dim,1);
warning off
if nnz(mmds>0)>0
    w_l2=quadprog(eye(dim),[],[],[],mmds', 1,zeros(dim,1),[],[],options);
else
    w_l2=quadprog(-eye(dim),[],[],[],mmds',-1,zeros(dim,1),[],[],options);
end
% normalise and apply a low cut to avoid unnecessary computations later
w_l2=w_l2/sum(w_l2);
w_l2(w_l2<1e-7)=0;
[~,max_l2]=max(w_l2);
fprintf('sigma index for maximum weight of l2: %d\n', max_l2);
warning on


% kernel selection method: opt
% selects a combination of kernels via the ratio from maxrat. Corresponds
% to optimal kernel weights

% construct Q matrix and add regulariser to avoid numerical problems
Q=cov(hh');
Q=Q+eye(size(Q))*lambda;
warning off
if nnz(mmds>0)>0 % at least one positive entry
    [wa,~,~]=quadprog(Q,[],[],[],mmds', 1,zeros(dim,1),[],[],options);
else
    [wa,~,~]=quadprog(-Q,[],[],[],mmds',-1,zeros(dim,1),[],[],options);
end
warning on
% normalise and apply low cut to avoid unnecessary computations later
w_opt=zeros(dim,1);
w_opt=wa;
w_opt(w_opt<1e-7)=0;
w_opt=w_opt/sum(w_opt);
[~,max_opt]=max(w_opt);
fprintf('sigma index for maximum weight of opt: %d\n', max_opt);

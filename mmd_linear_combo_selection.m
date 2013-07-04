% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann

% Does the same as mmd_linear_combo.m, but each kernel corresponds to one
% single dimension of the data in order to simulate a feature selection
% problem. Works with a fixed sigma only
% Note that we only consider maxmmd/maxrat vs L2/Opt here to illustrate
% combined kernels vs single ones
function [testStat, thresh_est] = mmd_linear_combo_selection(X,Y,innersize, sigma,w)

% make sure dimensions fit
assert(size(X,1)==size(Y,1));
assert(size(X,2)==size(Y,2));
assert(length(w)==size(X,2));
    
% some local variable for readability
m=size(X,1);
m2=floor(m/innersize);
assert(m2 >= 30);
dim=size(X,2);

% only compute MMD for non-zero weights (thats why the low cut filter was
% applied on opt_kernel_comb.m
idxs=find(w);
II=length(idxs);
mmds=zeros(II,1);
hh=zeros(II,m2);

% compute MMD for all non-zeros weights (=dimensions)
for ii=1:II
    % average of sum of kernel diagonals
%     K_XX = rbf_dot_diag(X(1:m2,ii),X(m2+1:m,ii),sigma);
%     K_YY = rbf_dot_diag(Y(1:m2,ii),Y(m2+1:m,ii),sigma);
%     K_XY = rbf_dot_diag(X(1:m2,ii),Y(m2+1:m,ii),sigma);
%     K_YX = rbf_dot_diag(X(m2+1:m,ii),Y(1:m2,ii),sigma);
%         K_XX+K_YY-K_XY-K_YX;
    hh(ii,:)=SumExtended(X, Y, innersize, ii, sigma);
    mmds(ii)=mean(hh(ii,:));
end

% replace NaN by worst possible value - makes the test fail if numerical
% errors occur
testStat = w(idxs)'*mmds;
testStat=replace_nan(testStat, -Inf);


% now estimate threshold as (1-alpha) quantil of a gaussian with zero mean
% and variance (1/m2) * w'*cov(hh)*w
alpha=0.05;
var_est=(1/m2) * w(idxs)'*cov(hh')*w(idxs);
thresh_est=norminv(1-alpha,0,sqrt(var_est));

% replace NaN by worst possible value - makes the test fail if numerical
% errors occur
thresh_est=replace_nan(thresh_est, Inf);
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann, Dino Sejdinovic

% Takes data, kernel weights, and corresponding Gaussian kernel sizes and
% computes a linear combination of linear time MMD statistics along with a
% linear time alpha=0.05 threshold estimate
function [testStat, thresh_est] = mmd_linear_combo(X,Y,innersize, sigmas,w)
% make sure dimensions fit
assert(size(X,1)==size(Y,1));
assert(length(w)==length(sigmas));
    
% some local variable for readability
m=size(X,1);
m2=floor(m/innersize);

% only compute MMD for non-zero weights (thats why the low cut filter was
% applied on opt_kernel_comb.m
idxs=find(w);
II=length(idxs);
mmds=zeros(II,1);
hh=zeros(II,m2);

% compute MMD for all non-zeros weights
for ii=1:II
%     % average of sum of kernel diagonals
%     K_XX = rbf_dot_diag(X(1:m2,:),X(m2+1:m,:),sigmas(idxs(ii)));
%     K_YY = rbf_dot_diag(Y(1:m2,:),Y(m2+1:m,:),sigmas(idxs(ii)));
%     K_XY = rbf_dot_diag(X(1:m2,:),Y(m2+1:m,:),sigmas(idxs(ii)));
%     K_YX = rbf_dot_diag(X(m2+1:m,:),Y(1:m2,:),);
    hh(ii,:)=SumExtended( X, Y, innersize, 1:size(X,2), sigmas(idxs(ii)) ); %K_XX+K_YY-K_XY-K_YX;
    mmds(ii)=mean(hh(ii,:));
end

% replace NaN by worst possible value - makes the test fail if numerical
% errors occur
if (isempty(idxs))
    testStat = 0;
else
    testStat = w(idxs)'*mmds;
end
testStat=replace_nan(testStat, -Inf);


% now estimate threshold as (1-alpha) quantil of a gaussian with zero mean
% and variance (1/m2) * w'*cov(hh)*w
alpha=0.05;
if (isempty(idxs))
    var_est = 0;
else
    var_est=(1/m2) * w(idxs)'*cov(hh')*w(idxs);
end
thresh_est=norminv(1-alpha,0,sqrt(var_est));

% replace NaN by worst possible value - makes the test fail if numerical
% errors occur
thresh_est=replace_nan(thresh_est, Inf);
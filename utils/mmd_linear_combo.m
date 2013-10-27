function [testStat, thresh_est] = mmd_linear_combo(X, Y, innersize, sigmas, w)
assert(size(X,1) == size(Y,1));
assert(length(w) == length(sigmas));
    
m = size(X,1);
m2 = floor(m / innersize);

% only compute MMD for non-zero weights (thats why the low cut filter was
% applied on opt_kernel_comb.m
idxs = find(w);
II = length(idxs);
mmds = zeros(II, 1);
hh = zeros(II, m2);

% compute MMD for all non-zeros weights
for ii=1:II
    hh(ii,:)=sum_extended(X, Y, innersize, 1 : size(X,2), sigmas(idxs(ii)));
    mmds(ii)=mean(hh(ii,:));
end

% replace NaN by worst possible value - makes the test fail if numerical
% errors occur
if (isempty(idxs))
    testStat = 0;
else
    testStat = w(idxs)' * mmds;
end
testStat=replace_nan(testStat, -Inf);

% now estimate threshold as (1 - alpha) quantil of a gaussian with zero mean
% and variance (1/m2) * w' * cov(hh) * w
alpha = 0.05;
if (isempty(idxs))
    var_est = 0;
else
    var_est=(1/m2) * w(idxs)' * cov(hh') * w(idxs);
end
thresh_est = norminv(1 - alpha, 0, sqrt(var_est));

% replace NaN by worst possible value - makes the test fail if numerical
% errors occur
thresh_est=replace_nan(thresh_est, Inf);

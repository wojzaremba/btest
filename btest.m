% [h, p] = btest(X, Y)
% [h, p] = btest(X, Y, Name, Value)	
% 
% B-test is a fast maximum mean discrepancy (MMD) kernel two-sample tests 
% that has low sample complexity and is consistent. The B-test uses a 
% smaller than quadratic number of kernel evaluations and avoids
% completely the computational burden of complex null-hypothesis
% approximation, while maintaining consistency and probabilistically
% conservative thresholds on Type I error.
% 
% 	[h, p] = btest(____)
% 
% Returns a test decision for the null hypothesis that the data X comes 
% from the same distribution as the data Y. By default B-test computes
% RBF-kernel for input data points X and Y. However, any kernel might 
%     be provided. p corresponds to p-value of the test. 
% 
% btest allows to specify 
% * 'Kernel' - kernel function handler, which takes two arguments 
%              and returns kernel value for them. Gaussian kernel (default)
% * 'Alpha' -  Significance level. 0.05 (default) | scalar 
%              value in the range (0,1)
% * 'BlockSize' - Block size used in B-test. square root of number 
%                 of samples (default)
% 
% More on it under http://www.cs.nyu.edu/~zaremba/docs/btest.pdf .
function [h, p] = btest(X, Y, varargin)
    m = size(X, 1);        
    okargs =   {'Alpha', 'Kernel' 'BlockSize'};
    defaults = {0.05, @rbf, floor(sqrt(length(X)))};
    [alpha, kernel, blocksize] = ...
        internal.stats.parseArgs(okargs, defaults, varargin{:});    
    assert(blocksize >= 2 && blocksize < m / 3);    
    m2 = floor(m / blocksize);    
    hh = zeros(m2, 1);
    for x = 1 : blocksize
        for y = (x + 1) : blocksize
            idx1 = ((m2 * (x - 1)) + 1) : (m2 * x);
            idx2 = ((m2 * (y - 1)) + 1) : (m2 * y);
            hh = hh + kernel(X(idx1), X(idx2));
            hh = hh + kernel(Y(idx1), Y(idx2));
            hh = hh - kernel(X(idx1), Y(idx2));
            hh = hh - kernel(Y(idx1), X(idx2));
        end
    end    
    testStat = mean(hh);
    var_est = (1 / m2) * cov(hh');
    p = 1 - normcdf(testStat, 0, sqrt(var_est));
    h = p < alpha;
end


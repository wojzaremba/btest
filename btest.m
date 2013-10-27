function [h, p] = btest(X, Y, varargin)
    m = size(X, 1);        
    okargs =   {'Alpha', 'Kernel' 'BlockSize'};
    defaults = {0.05,    @rbf, floor(sqrt(length(X)))};
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


function [h, p] = btest(X, Y, kernel)
    if (~exist('kernel', 'var'))
        kernel = @rbf_dot_diag;
    end
    innersize = floor(sqrt(length(X)));
    m = size(X,1);
    m2 = floor(m / innersize);
    hh = zeros(m2, 1);
    for x = 1 : innersize
        for y = (x + 1) : innersize
            idx1 = ((m2 * (x - 1)) + 1) : (m2 * x);
            idx2 = ((m2 * (y - 1)) + 1) : (m2 * y);
            hh = hh + kernel(X(idx1), X(idx2));
            hh = hh + kernel(Y(idx1), Y(idx2));
            hh = hh - kernel(X(idx1), Y(idx2));
            hh = hh - kernel(Y(idx1), X(idx2));
        end
    end    
    testStat = mean(hh);
    
    alpha = 0.05;
    var_est = (1 / m2) * cov(hh');
    thresh_est = norminv(1 - alpha, 0, sqrt(var_est));    
    h = testStat < thresh_est;
    p = 1 - normcdf(testStat, 0, sqrt(var_est));
end


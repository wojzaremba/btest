function [ sum ] = SumExtended( X, Y, innersize, i, sigma )
    sum = 0;
    m=size(X,1);
    m2=floor(m/innersize);
    for x = 1:innersize
        for y = (x+1):innersize
            idx1 = ((m2 * (x - 1)) + 1):(m2 * x);
            idx2 = ((m2 * (y - 1)) + 1):(m2 * y);
            sum = sum + rbf_dot_diag(X(idx1,i), X(idx2,i), sigma);
            sum = sum + rbf_dot_diag(Y(idx1,i), Y(idx2,i), sigma);
            sum = sum - rbf_dot_diag(X(idx1,i), Y(idx2,i), sigma);
            sum = sum - rbf_dot_diag(Y(idx1,i), X(idx2,i), sigma);
        end
    end
    % XXX : big change
%     sum = sum / (innersize * (innersize - 1));
end


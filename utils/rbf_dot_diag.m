% Computes the diagonal of a Gaussian kernel matrix for given data 
% (each datum one row) and a kernel size deg.
function [H] = rbf_dot_diag(X, Y, deg)
    if (~exist('deg', 'var'))
        deg = 1;        
    end
    dists = zeros(length(X), 1);
    for i = 1:length(X)
        dists(i) = sum(X{i} - Y{i}) .^ 2;
    end     
    H = exp(-dists / (2 * deg ^ 2));
end
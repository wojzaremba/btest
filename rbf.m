function [H] = rbf(X, Y)
    dists = zeros(length(X), 1);
    for i = 1:length(X)
        dists(i) = sum(X{i} - Y{i}) .^ 2;
    end     
    H = exp(-dists / 2);
end
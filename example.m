addpath(genpath('.'));
rng('default');
num_samples = 500;

% Data generation.
R = [cos(pi / 4), -sin(pi / 4); sin(pi / 4), cos(pi / 4)];
X = cell(2 * num_samples, 1);
Y = cell(num_samples, 1);
eigenvalues = ones(2, 1);
eigenvalues(1,1) = 10;
% Elongated, tilted 3 x 3 Gaussian blobs.
for i = 1 : (2 * num_samples)
    mu = [randi(5) * 15; randi(5) * 15];    
    H = R * diag(sqrt(eigenvalues)); 
    X{i} = (H * randn(2, 1) + repmat(mu, 1, 1))';
end
% 3 x 3 Gaussian blobs.
for i = 1 : num_samples
    mu = [randi(5) * 15; randi(5) * 15];	
    Y{i} = (randn(2, 1) + repmat(mu, 1, 1))';    
end

[~, p] = btest(X(1 : num_samples), X((num_samples + 1) : end));
fprintf(['p value = %f > 0.05 for data comming from the same ' ...
         'distribution. This should fail 5%% of the time. \n'], p);

[~, p] = btest(X(1 : num_samples), Y);
fprintf(['p value = %f < 0.05 for data comming from the different ' ... 
         'distributions\n'], p);

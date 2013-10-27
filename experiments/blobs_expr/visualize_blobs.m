addpath(genpath('../..'));
data_params.which_data='blobs';
data_params.dimension=2;
data_params.difference=0.5;
data_params.stretch=10;
data_params.angle=4; % (pi/angle) is rotation
data_params.blob_distance=15;
data_params.num_blobs=5; 
data_params.m=10000;
[X,Y] = get_data(2 * data_params.m, data_params);

figure(1)
scatter(X(:, 1), X(:, 2), ones(size(X, 1), 1), 'r')
xlim([5 85]);
ylim([5 85]);
set(gca,'xtick',[],'ytick', [])

figure(2)
scatter(Y(:, 1), Y(:, 2), ones(size(Y, 1), 1), 'b')
set(gca,'xtick',[],'ytick', [])
xlim([5 85]);
ylim([5 85]);

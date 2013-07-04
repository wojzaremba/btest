data_params.which_data='blobs';
data_params.dimension=2;
data_params.difference=0.5;
data_params.stretch=10;
data_params.angle=4; % (pi/angle) is rotation
data_params.blob_distance=15;
data_params.num_blobs=5;
data_params.wav_dir='~/data/music/';
data_params.wav1='song1';
data_params.wav2='song2';
data_params.window_length=1000; % dimension of samples
data_params.added_noise = 0.5;  % standard deviation of added noise
data_params.f_multiple=3;  
data_params.f_transmit_multiple=5;
data_params.offset=2;
data_params.envelope_scale=1;  
data_params.relevant=2;
data_params.sigma_selection=3;
data_params.m=10000;
[X,Y] = get_data(2*data_params.m,data_params);


scatter(X(:, 1), X(:, 2), ones(size(X, 1), 1), 'r')
xlim([5 85]);
ylim([5 85]);
set(gca,'xtick',[],'ytick', [])
print(gcf, '/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/writing/img/blobs1','-dpdf');
scatter(Y(:, 1), Y(:, 2), ones(size(Y, 1), 1), 'b')
set(gca,'xtick',[],'ytick', [])
xlim([5 85]);
ylim([5 85]);
print(gcf, '/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/writing/img/blobs2','-dpdf');

% title('samples drawn from q');

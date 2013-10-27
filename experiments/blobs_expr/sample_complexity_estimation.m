% clear all
% close all
cd /home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/blobs_expr
xaxis = [2.^[1, 2, 3, 4], 20, 25];
sigma_types = {'single', 'median', 'multiple'};
acc = zeros(length(xaxis), length(sigma_types));
addpath('..');
max_m = 10000;
[ data_params, alg_params ] = initializeblobs(3000);
data_params.location = 'sample_complexity';    
data_params.same = 0;
data_params.m = max_m;
% [ X, Y ] = get_all_data( data_params, alg_params );

complexity = zeros(length(xaxis), length(sigma_types));
complexity_acc = zeros(length(xaxis), length(sigma_types));

btest_complexity = zeros(length(sigma_types), 1);
btest_complexity_acc = zeros(length(sigma_types), 1);

for s_idx = 1:length(sigma_types)
  alg_params.type = 'opt';
  alg_params.sigma_type = sigma_types{s_idx};
  for i = 2:length(xaxis)
      alg_params.innersize = xaxis(i);
      [complexity(i, s_idx), complexity_acc(i, s_idx)] = sample_complexity_rutine(data_params, alg_params, X, Y, max_m);
  end
  alg_params.type = 'btest';
  alg_params.innersize = -1;
  [btest_complexity(s_idx), btest_complexity_acc(s_idx)] = sample_complexity_rutine(data_params, alg_params, X, Y, max_m);
  fprintf('\n');
end

alg_params.num_trials = 10;
mmdu_types = {'gamma', 'pears', 'spec', 'boot'};
mmd_complexity = zeros(length(mmdu_types), 2);
mmdu_complexity_acc = zeros(length(mmdu_types), 2);
alg_params.innersize = -1;
for i = 1:length(mmdu_types)
  for s_idx = 1:2
    alg_params.innersize = -1;
    alg_params.sigma_type = sigma_types{s_idx};
    alg_params.type = mmdu_types{i};
    [mmdu_complexity(i, s_idx), mmdu_complexity_acc(i, s_idx)] = sample_complexity_rutine(data_params, alg_params, X, Y, max_m);
  end
end

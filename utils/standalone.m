% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann

% Start script to perform kernel selection with methods described in
% Optimal kernel choice for large-scale two-sample tests.
% Gretton, A., Sriperumbudur, B., Sejdinovic, D., Strathmann, H.,
% Balakrishnan, S., Pontil, M., & Fukumizu, K. (2012).
% Advances in Neural Information Processing Systems.

% This scripts allows to specify one of the datasets mentioned in the
% paper. In addition, all five kernel selection strategies can be
% performed in order to select from a discrete set of Gaussian kernels
% which are specified via a range of kernel widths sigma:
%
% maxmmd - Select kernel via maximising the MMD
% L2     - L2 norm constraint optimisation, maxmmd for multiple kernels
% maxrat - Select optimal single kernel via maximising MMD divided by std-dev
% opt    - Select optomal convex kernel combination, maxrat for multiple kernels
% med    - Set Gaussian kernel width according to the median data distance
% xvalc  - Select kernel via minimising the expected loss of a binary
%          classifier interpretation of the MMD (optional since costly)
% See paper for details.
%
% This script performs a number of two-sample test trials on specified
% data. Reported are the acceptance rates, which correspond to the type II
% error given the alternative hypothesis is true and to the type I error in
% case the null hypothesis is true. Data can be generated under both, see
% check_type1 flag below.
%
% All datatypes from the paper are available. See below for
% parametrisation. There are also generated some example samples for visual
% inspection.

% clean up
% clear all
% close all
randn('seed', 1);
rand('seed', 1);

% choose data type. Parameters of datasets see below
% 'mean'      - First dimension of data has a different mean
% 'var'       - First dimension of data has a different variance 
% 'sine'      - One dimensional Gaussian data with a Sinusoidal pertubation
% 'blobs'     - 2D grid of Gaussians with different shapes
% 'am'        - Amplitude modulated music signal
% 'selection' - Gaussian data where one of a number of relevant dimensions
%               is randomly shifted by an offset. Kernels here are
%               univariate Gaussian kernels - one per dimension, so this is
%               a feature selection problem
data_params.which_data='blobs';

% data_params.which_data='sine';

% for mean, var, selection, specify data dimension
data_params.dimension=2;

% for mean, var specify difference in first simension
% for sine, specify frequency of sinusoidal pertubation
% for selection data, specify difference in relevant dimensions
data_params.difference=0.5;

% for blobs, specify stretch, rotation and distance of Gaussians in 2D grid
data_params.stretch=10;
data_params.angle=4; % (pi/angle) is rotation
data_params.blob_distance=15;
data_params.num_blobs=5;

% for am specify filenames of wav files
% these are assumed to be in the wav_dir folder and named
% $data_params.wav1$.wav and $data_params.wav2$.wav, where you can enter
% the song name (without .wav ending) below
data_params.wav_dir='~/data/music/';
data_params.wav1='song1';
data_params.wav2='song2';
data_params.window_length=1000; % dimension of samples
data_params.added_noise = 0.5;  % standard deviation of added noise

% the multiple of the sampling frequency used for the carrier
data_params.f_multiple=3;  

% the multiple of the carrier frequency at which the AM signal is sampled
data_params.f_transmit_multiple=5;

% offset which is added to music signal
data_params.offset=2;

% scaling of sound envelope
data_params.envelope_scale=1;  

% selection data: number of relevant dimensions and fixed sigma value. (We
% do not select sigma per dimension but rather use a fixed value for all
% dimensions for simplicity. The point here is to compare single kernels
% with combined kernels, so a fixed width is sufficient.
data_params.relevant=2;
data_params.sigma_selection=3;

% for all data types, specify number of samples m,
% number of trials,
% range of Gaussian kernel sigma,
% lambda regulariser added to ensure numerical stability (see paper)
data_params.m=1000;
alg_params.num_trials=100;
alg_params.sigma_from=1;
alg_params.sigma_to=1;
alg_params.sigma_step=1;
alg_params.lambda=10E-4;
alg_params.innersize=29;

% for running on a cluster, is added before all specified paths except for
% wav filenames. If unsure, leave empty
alg_params.path_prefix='';

% 1: null hypothesis data generation, samples are merged before testing,
% type I error is reported
% 0: alternative hypothesis data generation, type II error is reported
alg_params.check_type1=0;

% whether to do (quadratic: costly) cross-validation kernel selection
% all other kernel selection methods are always performed
% is ignored for 'selection' dataset
alg_params.do_xval=0;
if strcmp('selection', data_params.which_data)
    single_test_selection(data_params,alg_params);
else
    single_test(data_params,alg_params);
end
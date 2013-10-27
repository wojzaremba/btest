% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann

% Produces the 'blobs' dataset which consists of a 2D grid of Gaussians which
% have a different shape
function X=gaussian_blobs(stretch, angle, blob_distance, num_blobs, num_samples)

% rotation matrix
R=[cos(angle),-sin(angle);sin(angle),cos(angle)];

% construct covariance matrix where ratio of Eigenvalues corresponds to stretch
X=zeros(num_samples, 2);
eigenvalues=ones(2,1);
eigenvalues(1,1)=stretch;

for i=1:num_samples
    % random sample from blob number
    mu=[randi(num_blobs)*blob_distance; randi(num_blobs)*blob_distance];
    
    % generate multivariate random sample with rotation and stretch
    X(i,:)=normal_sample(mu, R, eigenvalues, 1);
end

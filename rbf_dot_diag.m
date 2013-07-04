% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann

% computes the diagonal of a Gaussian kernel matrix for given data (each datum
% one row) and a kernel size deg
function [H]=rbf_dot_diag(X,Y,deg);
dists=X-Y;
dists= dists .^ 2;
dists=sum(dists, 2);
dists=dists';
temp=2*deg^2;       
H=exp(-dists/temp)';

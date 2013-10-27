% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann


% takes a col vector mu, a rotation matrix R and a scaling vector L
% and produces n random normal samples from desired distribution
% result is a set of row vectors that form a matrix X
function X=normal_sample(mu, R,L, n)
dim=length(mu);

% "square root" of covariance matrix obtained via rotating the matrix of
% Eigenvalues
H=R*diag(sqrt(L)); 

% transform standard normal samples to desired form
X=H*randn(dim,n)+repmat(mu,1,n);
X=X';

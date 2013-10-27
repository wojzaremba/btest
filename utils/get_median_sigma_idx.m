% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Arthur Gretton, Heiko Strathmann

% Takes data and a collection of Gaussian kernel sizes and returns the index to
% the kernel size which is closest to the median distance along the data
function median_sigma_idx=get_median_sigma_idx(X,Y, sigmas)
Z=[X;Y];
% use 1000 points at max - median is stable
size1=size(Z,1);
if size1>1000
  Zmed = Z(1:1000,:);
  size1 = 1000;
else
  Zmed = Z;
end
G = sum((Zmed.*Zmed),2);
Q = repmat(G,1,size1);
R = repmat(G',size1,1);
dists = Q + R - 2*Zmed*Zmed';
dists = dists-tril(dists);
dists=reshape(dists,size1^2,1);

%rbf_dot has factor of two in kernel
median_width = sqrt(0.5*median(dists(dists>0)));
clear Z  Q  R  dists;

% search for given sigma which is closest to median width
w_med=zeros(size(sigmas));
median_sigma_idx=1;
min_dist=inf;
for i=1:length(w_med)
    d=abs(sigmas(i)-median_width);
    if d<min_dist
        min_dist=d;
        median_sigma_idx=i;
    end
end

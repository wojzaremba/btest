% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann

% for a vector of indices, returns training/validation indices the i-th fold
% of a k-fold cross validation
function [train, validation]=cross_val_fold(indices, k, i)

validation_size=round(length(indices)/k);
if i<k
  select=(i-1)*validation_size+1:i*validation_size;
else
  % catch possible different size of folds
  select=(i-1)*validation_size+1:length(indices);
end

% extract test and train indices
validation=indices(select);
indices(select)=[];
train=indices;

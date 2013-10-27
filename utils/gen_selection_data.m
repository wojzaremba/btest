% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann

% Generates the 'selection' dataset which consists of normal distributed
% vectors where one of a number of relevant dimensions is shifted by an
% offset
function [X,Y]=gen_selection_data(m, difference, dim, relevant)

X=randn(m,dim);
Y=randn(m,dim);

% randomly add difference in one of the dims on Y with equal probability
change=zeros(m, relevant);
for i=1:m
    idx=randi(relevant);
    change(i,idx)=difference;
end
Y=[Y(:,1:relevant)+change, Y(:,relevant+1:dim)];
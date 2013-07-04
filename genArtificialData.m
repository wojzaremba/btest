%Generates two samples from various artificial datasets.
%The datasets are as follows:

%INPUT: 

% n: number of samples
% d: dataset parameter. Dimensionality for the first two datasets,
%    frequency of the sinusoid for the third.
% whichData: which toy dataset to generate. Can be one of:

%"mean": Gaussians in high dimension which have different means in a
%         single dimension.

%"var":   Gaussians in high dimension which have different variances in a
%   single dimension.

%"sine"   A 1-D Gaussian, and a Gaussian with a sinusoidal perturbation to
%         the density

%dataParam.meanShift: how much the mean is shifted
%dataParam.stdScale: how much the standard deviation is scaled
%dataParam.nuArr: frequency of perturbation for 'sine'

%OUTPUT: 

% Y,X each of dimension n rows * d columns. Each row is an
%     i.i.d. sample. Each column is a different dimension

%Arthur Gretton

%SINE code by Bharath Sriperumbudur, taken from:
%/Users/arthur/Documents/gatsby/kernelDistributionComparison/COLT-09/Experiments/sampling.m

% sine code modified for large scale applications by Heiko Strathmann

% 9 Dec 2012



function [X,Y] = genArtificialData(n,d,whichData,dataParam)



switch whichData
  case 'mean'

    X = randn(n,dataParam.dim(d));           
    Y = randn(n,dataParam.dim(d)); 
    Y(:,1) = Y(:,1) + ones(n,1)*dataParam.meanShift;
 
  case 'var'
    
    X = randn(n,dataParam.dim(d));           
    Y = randn(n,dataParam.dim(d)); 
    Y(:,1) = Y(:,1) *dataParam.stdScale;
   
    
  case 'sine'
    % create very large global sample, store in memory and sample from it
    % to generate samples much faster
    n_selected=n;
    n=10000000;
    global global_d;
    global global_X;
    global global_Y;
    if  isempty(global_d) || global_d~=dataParam.nuArr(d)
        fprintf('generating global sample of size %d\n', n);
        
        global_d=dataParam.nuArr(d);
        global_X=randn(n,1);
        global_Y=zeros(n,1);
        
        nInd=1;
        while nInd<=n,
            u=rand(1);
            y=randn(1);
            tt=.5*(1+sin(dataParam.nuArr(d)*y));
            if(u<tt),
                global_Y(nInd)=y;
                nInd=nInd+1;
            else
                continue;
            end
        end
    end
    % use global data and select n_selected with repetition
    inds=randi(n,n_selected,1);
    X=global_X(inds);
    Y=global_Y(inds);
    
  otherwise
    disp('whichData is not one ofthe permitted choices')
    
    
end


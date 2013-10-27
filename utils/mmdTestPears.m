%This function implements the MMD two-sample test using Pearson curves.

%Arthur Gretton
%07/12/08

%Inputs: 
%        X contains dx columns, m rows. Each row is an i.i.d sample
%        Y contains dy columns, m rows. Each row is an i.i.d sample
%        alpha is the level of the test
%        params.sig is kernel size (set to -1 to use median
%                   distance between inputs)
%        params.numNullSamp is number of samples from null Pearson MMD
%                       distribution used to estimate CDF


%Outputs: 
%        thresh: test threshold for level alpha test
%        testStat: test statistic m*MMD (unbiased)

%Uses original test code from Malte Rasch

function [testStat,thresh] = mmdTestPears(X,Y,alpha,params);
m=size(X,1);



%Set kernel size to median distance between points IN AGGREGATE SAMPLE
if params.sig == -1
  Z = [X;Y];  %aggregate the sample
  size1=size(Z,1);
    if size1>100
      Zmed = Z(1:100,:);
      size1 = 100;
    else
      Zmed = Z;
    end
    G = sum((Zmed.*Zmed),2);
    Q = repmat(G,1,size1);
    R = repmat(G',size1,1);
    dists = Q + R - 2*Zmed*Zmed';
    dists = dists-tril(dists);
    dists=reshape(dists,size1^2,1);
    params.sig = sqrt(0.5*median(dists(dists>0)));  %rbf_dot has factor two in kernel
end

K = rbf_dot(X,X,params.sig);
L = rbf_dot(Y,Y,params.sig);
KL = rbf_dot(X,Y,params.sig);

%%%% Get test statistic (unbiased)
MMDf = ( K + L - KL - KL' );
MMDf = MMDf - diag(diag(MMDf));
testStat = 1/m/(m-1) * sum(sum( MMDf ));
testStat = testStat * m; %null distirbution on m*MMD

%%%% Compute test threshold

%Get 2nd moment

MMDg = MMDf.^2 ;
MMD =  MMDg / m/(m-1); 
preVarMMD = sum(sum(MMD));
U_m2 = preVarMMD*2/m/(m-1);

%Get 3rd moment

pre3rdMMD = 0;

for i1=1:m
  for i2 = 1:m
    if i1~=i2
      intMean = 0; %intermediate mean
      for i3 = 1:m
	if i3~=i1 & i3~=i2
	  intMean = intMean + MMDf(i1,i3)*MMDf(i2,i3);
	end
      end
      intmean = intMean/(m-2);
      pre3rdMMD = pre3rdMMD + intmean*MMDf(i1,i2);
    end
  end
end
pre3rdMMD = pre3rdMMD/ (m*(m-1)); 
U_m3 = 8*(m-2)/(m*(m-1))^2 * pre3rdMMD;

%Rescale 2nd and 3rd moments, since they were computed for MMD and
%must be applied to m*MMD
U_m3 = m^3 * U_m3;
U_m2 = m^2 * U_m2;

%Approx 4th moment
kurt = 2*((U_m3)^2/U_m2^3 + 1); %kurtosis >= skewness^2 + 1
    
%Sample the distribution
U_moments = {0,sqrt(U_m2),U_m3/U_m2^(3/2),kurt};
[r1] = pearsrnd(U_moments{:},params.numNullSamp,1);
    
%Compute empirical CDF to get the 95% quantile
%keyboard
[fi,xi]  = ecdf(r1);
thresh= xi(find(fi<1-alpha,1,'last'));
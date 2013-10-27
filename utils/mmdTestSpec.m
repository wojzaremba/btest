%This function implements the MMD two-sample test using the Gram
%matrix spectrum to estimate the coefficients of the infinite sum
%of chi^2 (which constitutes the null distibution)


%Arthur Gretton
%07/12/08

%Inputs: 
%        X contains dx columns, m rows. Each row is an i.i.d sample
%        Y contains dy columns, m rows. Each row is an i.i.d sample
%        alpha is the level of the test
%        params.sig is kernel size.  If -1, use median distance heuristic.
%        params.numEigs is number of eigenvalues used to compute
%            the null distribution.If it is -1, then use 
%            2*m - 2
%        params.numNullSamp is number of samples from null spectral MMD
%                       distribution used to estimate CDF



%Outputs: 
%        thresh: test threshold for level alpha test
%        testStat: test statistic: m * MMD_b (biased)

%Set kernel size to median distance between points, if no kernel specified


function [testStat,thresh] = mmdTestSpec(X,Y,alpha,params);
    
m=size(X,1);

if params.numEigs==-1
  params.numEigs = 2*m-2;
end


%Set kernel size to median distance between points in aggregate sample
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


%MMD statistic. Here we use biased 
%v-statistic. NOTE: this is m * MMD_b
testStat = 1/m * sum(sum(K + L - KL - KL'));


%Draw samples from null distribution

Kz = [K KL; KL' L];
H = eye(2*m) - 1/(2*m)*ones(2*m,2*m);
Kz = H*Kz*H;



kEigs = eigs(Kz,params.numEigs); %note: this retains only largest magnitude eigenvalues
        %empirical eigenvalues scaled by 1/2/m: see p. 2 Shawe-Tayor
        %et al. (2005)
kEigs = 1/2/m * abs(kEigs); 
numEigs = length(kEigs);  


%DEBUG: plot the eigenspectrum to ensure it is not truncated
if params.plotEigs
  stem(kEigs);
  keyboard
end


nullSampMMD = zeros(1,params.numNullSamp);

for whichSamp = 1:params.numNullSamp
  nullSampMMD(whichSamp) = 2*sum(kEigs.*(randn(length(kEigs),1)).^2);
end



nullSampMMD = sort(nullSampMMD);
thresh = nullSampMMD(round((1-alpha)*params.numNullSamp));
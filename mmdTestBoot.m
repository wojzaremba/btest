%This function implements the MMD two-sample test using a bootstrap
%approach to compute the test threshold.


%Arthur Gretton
%07/12/08

%Inputs: 
%        X contains dx columns, m rows. Each row is an i.i.d sample
%        Y contains dy columns, m rows. Each row is an i.i.d sample
%        alpha is the level of the test
%        params.sig is kernel size. If -1, use median distance heuristic.
%        params.shuff is number of bootstrap shuffles used to
%                     estimate null CDF
%        params.bootForce: if this is 1, do bootstrap, otherwise
%                     look for previously saved threshold


%Outputs: 
%        thresh: test threshold for level alpha test
%        testStat: test statistic: m * MMD_b (biased)



function [testStat,thresh,executiontime] = mmdTestBoot(X,Y,alpha,params);
starttime = tic;
    
m=size(X,1);



%Set kernel size to median distance between points in aggregate sample
if params.sig == -1
  Z = [X;Y];  %aggregate the sample
  size1=size(Z,1);
    if size1>100
      Zmed = Z(1:100,:);
      size1 = 100;
      elseRHS
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

threshFileName = strcat('mmdTestThresh',num2str(m));

Kz = [K KL; KL' L];


if ~exist(strcat(threshFileName,'.mat'),'file') || params.bootForce==1
  
%  disp(strcat('Generating new threshold: ',threshFileName))
  


  MMDarr = zeros(params.shuff,1);
  for whichSh=1:params.shuff
    
    [notUsed,indShuff] = sort(rand(2*m,1));
    KzShuff = Kz(indShuff,indShuff);
    K = KzShuff(1:m,1:m);
    L = KzShuff(m+1:2*m,m+1:2*m);
    KL = KzShuff(1:m,m+1:2*m);
    
    MMDarr(whichSh) = 1/m * sum(sum(K + L - KL - KL'));
    
  end 

  MMDarr = sort(MMDarr);
  thresh = MMDarr(round((1-alpha)*params.shuff));

  save(threshFileName,'thresh','MMDarr');  

else
  load(threshFileName);
end
executiontime = toc(starttime);
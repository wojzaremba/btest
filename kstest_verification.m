% hh_normal = randn(1, 100);
% [h, p] = kstest(2 * hh_normal)
% 
% 
% hh_uniform = randi(100, 1, 100);
% [h, p] = kstest(hh_uniform)


 b = randn(50000,1);
a = randn(50000,1);
[h,p]=kstest2(a,b)
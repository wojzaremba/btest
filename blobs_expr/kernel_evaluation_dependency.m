ksize = [2, 4, 16, 20, 25];
nr_elems = [26400, 8774, 1774, 1412, 1136];

nk = nr_elems ./ ksize;
block = ksize .* (ksize - 1);
h = plot([ksize, 190], [nk .* block, 190^2]);
set(h, 'LineWidth', 4);
set(gca,'FontSize', 16);
ylabel('Overall number of kernel evaluations');
xlabel('Size of inner block');

set(gca,'XScale','log');
%  set(gca, 'XTick', ksize)
print(gcf, '/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/writing/img/number_of_kernel_evals', '-dpdf');
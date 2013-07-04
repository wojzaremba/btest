xaxis = [2, 250];
load('/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/code/music_expr/gauss_comparison_results', 'vals_same', 'vals_diff');
quantile_val = {};
u = {};
sig = {};
for i = 1:length(ks)
    vals_same{i} = 2 * vals_same{i} ./ (xaxis(i) * (xaxis(i) - 1));
    vals_diff{i} = 2 * vals_diff{i} ./ (xaxis(i) * (xaxis(i) - 1));
end

for i = 1:length(xaxis)
    u{i} = mean(vals_same{i});
    sig{i} = std(vals_same{i});
    quantile_val{i} = norminv(0.95, u{i}, sig{i});
end

k = 1;
hf1 = histfit(vals_diff{k}, 50);
hold on
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0 .5 .5]);
set(h,'EdgeColor', [0 .5 .5]);
hf2 = histfit(vals_same{k}, 50);
h = findobj(gca,'Type','patch');
h = h(1);
set(h,'FaceColor',[.5 0 .1]);
set(h,'EdgeColor', [.5 0 .1]);
lig = line([quantile_val{k} ; quantile_val{k}], [0.00 ; 250], 'LineWidth', 3, 'Color', 'g');
ylim([0, 250]);
legend([hf1(1), hf2(1), lig], 'H_0 histogram', 'H_A histogram', 'approximated 5% quantile of H_0', 'Location', 'NorthEast');
h = findobj(gca,'Type','patch');
% axis([-0.025 0.025 -0.1 250])
hold off

% 
print(gcf, '/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/writing/img/SmallKempirical','-dpdf');
% print(gcf, '/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/writing/img/LargeKempirical','-dpdf');
% 
% for k = 1:2
%     u = mean(vals_same{k});
%     st = std(vals_same{k});
%     vals_same{k} = (vals_same{k} - u) / st;
% end
% 
% q = randn(1000000, 1);
% 
% [f2,x2] = ecdf(vals_same{2});
% [f1,x1] = ecdf(vals_same{1});
% [fg,xg] = ecdf(q);
% fg1 = csaps(xg, fg, [], x1);
% fg2 = csaps(xg, fg, [], x2);
% % there is a bug in splines approximation.
% fg1(1748) = fg1(1749);
% % fg1(1338) = fg1(1339);
% fg2(1337) = fg2(1339);
% fg2(1338) = fg2(1339);
% plot(x1, abs(f1 - fg1), 'Color', 'r');
% hold on
% plot(x2, abs(f2 - fg2), 'Color', 'b');
% hold off
% legend('Absolute difference of cdfs for small block size', 'Absolute difference of cdfs for large block size');
% print(gcf, '/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/writing/img/CDFcomparison','-dpdf');
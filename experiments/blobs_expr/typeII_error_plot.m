% Run first typeIIerror_drop

Xplot = {};
Yplot = {};
entiretime = {};

sigma_types = {'single', 'median', 'multiple'};
for i = 1:length(sigma_types)
    Yplot{i} = acc(:, i);
    Xplot{i} = xaxis;
end
h = figure(1);
h1 = plot(Xplot{1}, Yplot{1}, '.-r');
hold on
h2 = plot(Xplot{2}, Yplot{2}, '--b');
h3 = plot(Xplot{3}, Yplot{3}, '-.g');
h4 = plot(2000, 0, 'r*', 'Color', [0.2,0.7,0]);
h5 = plot(2000, 0.95, 'c*', 'Color', [0.4,0,0.6]);
set(h1, 'LineWidth', 3);
set(h2, 'LineWidth', 3);
set(h3, 'LineWidth', 3);
set(h4, 'LineWidth', 4);
set(h5, 'LineWidth', 4);
h_legend = legend('B-test, a single kernel, \sigma = 1', ...
    'B-test, a single kernel, \sigma = median', ...
    'B-test kernel selection', ...
    'Tests estimating MMD_u with \sigma=1', ...
    'Tests estimating MMD_u with \sigma=median', 'Location', 'NorthOutside');
set(h_legend,'FontSize',16);
set(gca,'FontSize', 16);
ylabel('Emprical number of Type II errors');
xlabel('Size of inner block');
set(gca,'XScale','log');
set(h, 'Position', [0 0 1200 400])
set(h4,{'markers'},{15})  
set(h5,{'markers'},{15})  
xlim([0 2200])
hold off
print(gcf, '/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/writing/img/blobs_typeII_error_drop','-dpdf');

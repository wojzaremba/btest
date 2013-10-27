function [ output_args ] = type1_plot( biggest_k, type1error, title, xaxis )
%     h1 = errorbar(xaxis, 1 - type1error(:, s_idx), type1var(:, s_idx).^(1/2) / alg_params.num_trials, '.-r');
    h1 = plot(xaxis, 1 - type1error, '.-r');
    hold on
    h2 = plot(ones(max(xaxis(:)), 1) * 0.05, '--b');
    line([biggest_k ; biggest_k],[0.00 ; 0.08], 'LineWidth', 4, 'Color', 'g')    
    xlim([min(xaxis(:)), max(xaxis(:))]);    
    set(h1, 'LineWidth', 4);
    set(h2, 'LineWidth', 4);
    h_legend = legend('Empirical Type I error', 'Expected Type I error', title , 'Location', 'NorthWest');        
    set(h_legend,'Interpreter','latex')
    set(h_legend,'FontSize',16);
    set(gca,'FontSize', 16);
    ylabel('Type I error');
    xlabel('Size of inner block');
    set(gca,'XScale','log');
    set(gca, 'XTick', xaxis)
    ylim([0.0; 0.08]);
    hold off

end


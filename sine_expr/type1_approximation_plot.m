biggest_k = {sqrt(2000), sqrt(2000), sqrt(2000)};
titles = {'$B = \sqrt{n}$', '$B = \sqrt{n}$', '$B = \sqrt{n}$'};
data_types = {'mean', 'var', 'sine'};
for s_idx = 1:length(data_types)
    type1_plot(biggest_k{s_idx}, type1error(:, s_idx), titles{s_idx}, xaxis);
    print(gcf, ['/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/writing/img/mean_var_freq_type1_error_sigmatype=', sigma_types{s_idx}],'-dpdf');
end
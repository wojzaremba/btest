biggest_k = {sqrt(2000), sqrt(2000), sqrt(1000)};
titles = {'$B = \sqrt{n}$', '$B = \sqrt{n}$', '$B = \sqrt{\frac{n}{2}}$'};
sigma_types = {'single', 'median', 'multiple'};
for s_idx = 1:length(sigma_types)
    type1_plot(biggest_k{s_idx}, type1error(:, s_idx), titles{s_idx}, xaxis);
    print(gcf, ['/home/wojto/bio/Dropbox/Wojciechs_shared/nips2013/writing/img/songs_type1_error_sigmatype=', sigma_types{s_idx}],'-dpdf');
end
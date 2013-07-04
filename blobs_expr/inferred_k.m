[ data_params, alg_params ] = initializeblobs(100);

data_params.same = 0;
[ X, Y ] = get_all_data( data_params, alg_params );
possible_k = zeros(floor(log2(data_params.m)), 1);
for i = 1:length(X)
    [ biggest_k ] = fit_kstest( X{i}, Y{i} );
    possible_k(log2(biggest_k)) = possible_k(log2(biggest_k)) + 1;
end
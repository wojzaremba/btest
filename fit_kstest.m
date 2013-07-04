function [ biggest_k ] = fit_kstest( X_, Y_ )
    sigmas = 2.^1;
    lastaccepted = -1;
    for innersize_idx = 1:floor(log2(size(X_,1)))
        innersize = 2^innersize_idx;
        m2=floor(size(X_,1)/innersize);
        hh=zeros(m2, 1);
        hh(:)=SumExtended( X_, Y_, innersize, 1:size(X_,2), sigmas );      
        len = length(hh);
        accept = 0;
        for block_idx = 0:floor(log2(len))        
            blocks = 2^block_idx;
            rest = floor(len / blocks);
            newhh = zeros(rest, 1);
            for b = 1:rest
                newhh(b) = sum(hh(((b-1) * blocks + 1):(b * blocks)));
            end            
            if (length(newhh) < 4)
                continue
            end
            [h,p,ksstat,cv] = lillietest(newhh, 0.001 * ((log2(size(X_,1)) * (log2(size(X_,1)) - 1)) / 2));
            accept = accept || ~h;
            fprintf('innersize = %d, blocks = %d, h = %d, p = %f\n', innersize, blocks, h, p);
            if (~h) 
                break;
            end
        end            
        if (~accept)
            break;
        else
            lastaccepted = innersize_idx;
        end
    end
    biggest_k = 2^lastaccepted;    
    fprintf('biggest_k = %d\n', biggest_k);
end


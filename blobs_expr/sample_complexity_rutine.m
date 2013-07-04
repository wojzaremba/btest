function [complexity, acc] = sample_complexity_rutine(data_params, alg_params, X, Y, max_m)
      m_inf = 50;
      m_sup = Inf;
      while ((m_sup - m_inf) > 10)
          if (m_sup == Inf)
            data_params.m = m_inf * 2;
          else
            data_params.m = floor((m_inf +  m_sup) / 2);
          end
          if (data_params.m > max_m)
              data_params.m = max_m;
              break;
          end          
          switch alg_params.sigma_type
            case {'single', 'median'}
              biggest_k = fit_heuristic( 2 * data_params.m);
            case 'multiple'
              biggest_k = fit_heuristic( data_params.m );
            otherwise assert(0);
          end
          if ((strcmp(alg_params.type, 'opt')) && (biggest_k < alg_params.innersize))
            m_inf = data_params.m;
            continue;              
          end

          [acc, timeall] = single_test(data_params,alg_params, X, Y);
          fprintf('data_params.m = %d, acc = %f\n', data_params.m, acc)
          if (abs(acc - 0.05) <= 0.0025)
              break;
          end
          if (acc > 0.05)
              m_inf = data_params.m;
          else
              m_sup = data_params.m;
          end
      end
      fprintf('biggest_k = %d\n', biggest_k);
      complexity = 2 * data_params.m;
end

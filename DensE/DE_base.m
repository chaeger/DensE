classdef DE_base < handle
  properties
    channel   % DE_channel
    scheme    % DE_scheme
    precision % for threshold computation
  end
  
  properties(Access = private)
    max_iterations
    target_error_rate
  end
  
  methods
    function obj = DE_base(p_channel, p_scheme, p_max_iterations, p_target_error_rate)
      obj.channel = p_channel;
      obj.scheme = p_scheme;
      obj.max_iterations = p_max_iterations;
      obj.target_error_rate = p_target_error_rate;
      obj.precision = p_channel.default_precision; % default precision from the channel
      disp(['threshold is determined with precision: obj.precision = ' num2str(obj.precision)]);
      
      % passing functionalities to the ensemble object
      obj.scheme.set_max_iterations(obj.max_iterations);
      obj.scheme.set_target_error_rate(p_target_error_rate);
      obj.scheme.set_channel(p_channel);
    end
    
    function threshold = find_threshold(obj)
      % Find the approximate treshold via bisection method (binary search)
      
      % initial search range
      channel_param_lb = obj.channel.channel_param_lb;
      channel_param_ub = obj.channel.channel_param_ub;
      higher_is_better  = obj.channel.higher_is_better; 
      
      if(channel_param_lb >= channel_param_ub)
        error('Lower bound has to be strictly lower than upper bound');
      end
     
      if(higher_is_better)
        % higher ChannelParameter is better (e.g., SNR)
        while(1)
          channel_param_test = channel_param_lb+(channel_param_ub-channel_param_lb)/2;
          success = obj.scheme.density_evolution(channel_param_test);

          if(success)
            channel_param_ub = channel_param_test;
          else
            channel_param_lb = channel_param_test;
          end

          if(channel_param_ub - channel_param_lb < obj.precision)
            threshold = ceil(channel_param_ub/obj.precision)*obj.precision; 
            if(obj.scheme.density_evolution(threshold-obj.precision))
              threshold = threshold - obj.precision; 
            end
            break;
          end
        end % while
      else
        % lower ChannelParameter is better (e.g., erasure prob.)
        while(1)
          channel_param_test = channel_param_lb+(channel_param_ub-channel_param_lb)/2;
          success = obj.scheme.density_evolution(channel_param_test);

          if(success)
            channel_param_lb = channel_param_test;
          else
            channel_param_ub = channel_param_test;
          end

          if(channel_param_ub - channel_param_lb < obj.precision)
            threshold = floor(channel_param_lb/obj.precision)*obj.precision; 
            if(obj.scheme.density_evolution(threshold+obj.precision))
              threshold = threshold + obj.precision; 
            end
            break;
          end
        end % while
      end
    end % find_threshold
    
    function pe = get_final_error_rate(obj, channel_parameter_range)
      
      pe = zeros(size(channel_parameter_range));
      
      for i = 1:length(pe)
        obj.scheme.density_evolution(channel_parameter_range(i));
        pe(i) = obj.scheme.get_finalErrProb();
      end
    end
    
    function iter = required_iterations(obj, channel_parameter_range)
      % Compute the required number of iterations to achieve the target
      % error rate
      
      iter = zeros(size(channel_parameter_range));
      
      for i = 1:length(iter)
        % do bisection search
        iter_lb = 1;
        iter_ub = obj.max_iterations; 

        while(1)
          iter_test = round(iter_lb + (iter_ub-iter_lb)/2);
          
          obj.scheme.set_max_iterations(iter_test);
          obj.scheme.density_evolution(channel_parameter_range(i));
          pe = obj.scheme.get_finalErrProb();
          
          if(pe > obj.target_error_rate)
            iter_lb = iter_test;
          else
            iter_ub = iter_test;
          end
          
          if(iter_ub - iter_lb <= 1)
            iter(i) = iter_ub;
            break;
          end
        end
      end
      
    end
  end
end
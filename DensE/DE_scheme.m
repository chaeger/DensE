classdef DE_scheme < handle
  properties 
    channel
    
    % copied / initialized by DE_base
    max_iterations    % maximum number of iterations
    target_error_rate % target error probability
    
    % information about the last density evolution that was run
    errProb_avg % vector of length maxIter+1 
    errProb     % matrix (maxIter+1) rows, columns depends on VN types
    nIter       % number of iterations until target error probability was reached
  end
  
  methods 
    function set_max_iterations(obj, p_max_iterations)
      obj.max_iterations = p_max_iterations;
      obj.errProb_avg = zeros(p_max_iterations+1, 1);
    end
    
    function set_target_error_rate(obj, p_target_error_rate)
      obj.target_error_rate = p_target_error_rate;
    end
    
    function set_channel(obj, p_channel)
      obj.channel = p_channel;
    end
    
    function tmp = get_finalErrProb(obj)
      % nIter = 0 -> uncoded 
      % nIter = 1 -> after one iteration
      tmp = mean(obj.errProb_avg(obj.nIter+1, :));
    end
  end
end
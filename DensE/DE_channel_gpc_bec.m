classdef DE_channel_gpc_bec < DE_channel
  % high-rate binary erasure channel (BEC) for analyzing 
  % deterministic generalized product codes
  % parametrized by c, where p = c/n is the erasure-correcting capability
  % and n is the component code length
  
  methods
    function obj = DE_channel_gpc_bec()
      obj.channel_param_lb = 1;
      obj.channel_param_ub = 100; 
      obj.higher_is_better = 0;  
      obj.default_precision = 0.01;
    end
  end
end
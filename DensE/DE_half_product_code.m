classdef DE_half_product_code < DE_det_gpc
  methods
    function obj = DE_half_product_code(t)
      % t : erasure-correcting capability of the component codes
      
      obj.eta = 1;
      obj.L = 1;
      obj.gamma = 1;
      obj.tau{1} = [t; 1];
    end
  end
end
classdef DE_product_code < DE_det_gpc
  methods
    function obj = DE_product_code(t)
      % t : erasure-correcting capability of the component codes;
      %     can also be a length-2 vector to specify row/column codes
      %     separately
      
      obj.eta = [0 1; 1 0];
      obj.L = 2;
      obj.gamma = [1 1];
      
      if(length(t) == 1)
        obj.tau{1} = [t; 1];
        obj.tau{2} = [t; 1];
      elseif(length(t) == 2)
        obj.tau{1} = [t(1); 1];
        obj.tau{2} = [t(2); 1];
      else
        error('DE_product_code: length of input argument should be 1 or 2')
      end
    end
    
    function schedule = get_rowcolumn_schedule(obj, max_iterations)
      % max_iter : maximum number of decoding iterations; 
      %    1 iterations corresponds to 2 half-iterations (row+column
      %    decoding)
      
      schedule = cell(2*max_iterations, 2); % first col: active
      
      for i = 1:max_iterations
        schedule{2*i-1, 1} = 1;
        schedule{2*i-1, 2} = 2;
        schedule{2*i, 1} = 2;
        schedule{2*i, 2} = 1;
      end
    end
  end
end


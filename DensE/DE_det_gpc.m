classdef DE_det_gpc < handle
  properties
    L % number of positions
    eta % position connectivity matrix
    gamma % relative number of component codes at the positions
    tau % error-correcting capabilities 
    
    % derived parameters
    Lp % number of bit positions
    BitPosInd % 
  end
  
  methods
    function obj = DE_det_gpc()
      %
    end
    
    function set_derived_parameters(obj)
      obj.Lp = sum(sum(tril(obj.eta)));
      obj.BitPosInd = find(tril(obj.eta));
    end 
  end
end
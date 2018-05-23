classdef DE_staircase_code < DE_det_gpc
  methods
    function obj = DE_staircase_code(t, L)
      % t : erasure-correcting capability
      % L : number of spatial positions
      
      eta = zeros(L, L);
      for i = 1:(L-1)
        eta(i, i+1) = 1;
        eta(i+1, i) = 1;
      end
      obj.eta = eta;
      obj.L = L;
      obj.gamma = 0.5*ones(1, L); % not a distribution
      
      tau = cell(1, L); 
      for i = 1:L
        tau{i} = [t; 1];
      end
      
      obj.tau = tau;
      
      obj.set_derived_parameters(); 
    end
    
    function schedule = get_window_decoding_schedule(obj, maxRounds, W, rowcolumn)
      % maxRounds : maximum number of rounds per window
      %   if rowcolumn = 1 => then 1 round includes row+column decoding
      %   if rowcolumn = 0 => 1 round is 1 iteration
      % 
      % W : window size in terms of the number of 
      % rowcolumn : (boolean) alternate between rows and columns
      %   defaults to 1
      
      if(nargin == 3)
        rowcolumn = 1;
      end
      
      L = obj.L; 
      
      totWDconfs = L + W - 1; % tot window decoder configurations
      maxIter = totWDconfs * maxRounds; % in each conf., we do iterations
      if(rowcolumn)
        maxIter = 2*maxIter;
      end
      rows = 1:2:L;
      cols = 2:2:L; 
      
      schedule = cell(maxIter, 2); % first col: active
      for i = 1:totWDconfs
        if(i < W) % beginning
          Active = 1:i; 
        elseif(i > L) % end
          Active = i-W+1:L;
        else % steady state
          Active = (1:W) + i-W;
        end
        
        if(rowcolumn)
          ActiveRows = intersect(Active, rows); 
          ActiveCols = intersect(Active, cols); 
          InActiveRows = setdiff(1:L, ActiveRows);  
          InActiveCols = setdiff(1:L, ActiveCols); 
          for j = 1:maxRounds
            schedule{2*maxRounds*(i-1)+2*(j-1)+1, 1} = ActiveRows;
            schedule{2*maxRounds*(i-1)+2*(j-1)+1, 2} = InActiveRows;
            schedule{2*maxRounds*(i-1)+2*(j-1)+2, 1} = ActiveCols;
            schedule{2*maxRounds*(i-1)+2*(j-1)+2, 2} = InActiveCols;
          end
        else
          InActive = setdiff(1:L, Active); 
          for j = 1:maxRounds
            schedule{maxRounds*(i-1)+j, 1} = Active;
            schedule{maxRounds*(i-1)+j, 2} = InActive;
          end
        end
      end
    end
  end
end
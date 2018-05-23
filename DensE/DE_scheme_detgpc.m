classdef DE_scheme_detgpc < DE_scheme
  properties 
    gpc
    schedule
    
    x % parameter used for recursion
    use_exit_criterion % faster density evolution but does not work for window decoding
  end
  
  methods 
    function obj = DE_scheme_detgpc(p_gpc, p_use_exit_criterion) 
      obj.gpc = p_gpc;
      obj.schedule = {};
      
      if(nargin == 1)
        p_use_exit_criterion = 0;
      end
      obj.use_exit_criterion = p_use_exit_criterion;
      
      obj.nIter = 0;
    end
    
    function set_schedule(obj, p_schedule)
      obj.schedule = p_schedule;
    end
    
    function set_max_iterations(obj, p_max_iterations)
      obj.max_iterations = p_max_iterations;
      
      % expected fraction of CNs that fail to decode at iteration l
      % (these are not bit error probabilities)
      obj.errProb = zeros(p_max_iterations+1, obj.gpc.L); % z_i in the paper
      obj.errProb_avg = zeros(p_max_iterations+1, 1);
      obj.x = zeros(p_max_iterations+1, obj.gpc.L); % recursive parameter
      
%       obj.BitErrProb = zeros(p_maxIter+1, obj.gpc.L^2);
%       obj.BitErrProb_avg = zeros(p_maxIter+1, 1); 

      % check if a schedule is provided, otherwise, set the default
      % schedule: all CNs are decoded in every iteration
      if(isempty(obj.schedule))
        obj.schedule = cell(p_max_iterations, 2); % first column: active positions
      
        for i = 1:p_max_iterations
          obj.schedule{i, 1} = 1:obj.gpc.L; % active
          obj.schedule{i, 2} = []; % inactive
        end
      end
    end
    
    function tmp = get_final_vn_error_rate_avg(obj)
      x = obj.x(obj.nIter+1, :);
      eta = obj.gpc.eta;
      gamma = obj.gpc.gamma; 
      
      A = (x.*gamma)*eta*(x.*gamma)';
      B = gamma*eta*gamma';
      tmp = A/B; 
    end
    
    function tmp = get_vn_error_rate(obj, iter)
      % iter : iteration number
      
      x = obj.x(iter+1, :);
      eta = obj.gpc.eta;
      gamma = obj.gpc.gamma; 
      L = length(gamma); 
      
      Lp = sum(sum(eta))/2; % number of VN positions
      
      BitPosInd = find(tril(eta)); 
      
      tmp = zeros(L, L);
      for i = 1:L
        for j = 1:i
          if(eta(i,j))
            tmp(i,j) = x(i) * x(j); 
          end
        end
      end
      
      tmp = tmp(BitPosInd); 
    end
   
    function success = density_evolution(obj, c)
      L = obj.gpc.L;
      eta = obj.gpc.eta;
      gamma = obj.gpc.gamma;
      tau = obj.gpc.tau;
      schedule = obj.schedule;
      
      x = ones(1,L);
      errProb = zeros(size(obj.errProb));
      errProb(1, :) = x;
      obj.errProb_avg(1) = 1;
      obj.x(1, :) = x;
      
      iter = 1;
      success = 0;
      while(iter <= obj.max_iterations)
        x_tmp = c*eta*(gamma.*x)';
        x_prev = x;
        
        for i = schedule{iter, 1} % active
          t_distr = tau{i};
          tmp1 = 0;
          tmp2 = 0;
          for j = 1:size(t_distr, 2)
            tmp1 = tmp1 + t_distr(2, j) * MyPsi(t_distr(1, j)  , x_tmp(i)); 
            tmp2 = tmp2 + t_distr(2, j) * MyPsi(t_distr(1, j)+1, x_tmp(i)); 
          end
          x(i) = tmp1; % used for the recursion
          errProb(iter+1, i) = tmp2; % used for exit-criterion
        end
         
        % inactive
        x(schedule{iter, 2}) = x_prev(schedule{iter, 2});
        errProb(iter+1, schedule{iter, 2}) = errProb(iter, schedule{iter, 2}); 
        
         
        obj.x(iter+1, :) = x; 
        obj.errProb_avg(iter+1) = gamma/sum(gamma)*errProb(iter+1, :)';
        
        % Calculate mean error probability
        errProbThis = obj.errProb_avg(iter+1); 
        errProbPrev = obj.errProb_avg(iter);

        iter = iter + 1;
        
        if(obj.use_exit_criterion)
          if(errProbThis < obj.target_error_rate)
            success = 1; break;
          elseif(errProbThis == errProbPrev) 
            success = 0; break;
          end
        end
      end % end while 
      
      if(errProbThis < obj.target_error_rate)
        success = 1;
      end
      
      obj.nIter = iter - 1; 
      
      obj.errProb = errProb;
    end
  end
end
clear
clc

addpath('../DensE/')

p_r = 0.0128:0.00001:0.0137; % desired plotting range

n = 512; % component code length
t = 4;
max_iterations = 10; % row/column iterations

% convert to effective channel quality c, where p = c/n
c_r = p_r*n;

code = DE_product_code(t); 
scheme = DE_scheme_detgpc(code);
schedule = code.get_rowcolumn_schedule(max_iterations); % first column: active positions
scheme.set_schedule(schedule);

% the base class combines the channel and coding scheme information
DE_obj = DE_base(DE_channel_gpc_bec, scheme, size(schedule, 1), 1e-10); 

z = zeros(1, length(c_r)); % scaled error rate
for i = 1:length(c_r)
  DE_obj.scheme.density_evolution(c_r(i)); % run DE for a specific channel parameters
  z(i) = DE_obj.scheme.get_final_vn_error_rate_avg 
end

BER = c_r/n.*z;

return

hold on
plot(p_r, BER, 'b-')

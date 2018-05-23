% staircase code
%
% component code: extended BCH (n=512, k=493, t=2), shortened by 284 bits
% => 114x114 staircase blocks
%
% decoder: window decoder with size W=8 and l=7 iterations per window
%
% assumes a binary-input AWGN channel + idealized bounded-distance decoding 
% (no miscorrections)

clear
clc

addpath('../DensE/')

EsNo_r = 6.6:0.002:6.71; % desired plotting range

n = 228; % effective component code length
t = 2; 
W = 8;
max_iterations = 7;

% convert to BSC crossover probability
p_r = qfunc(sqrt(10.^(EsNo_r/10))); 

% convert to effective channel quality c, where p = c/n
c_r = p_r*n;

L = 100; % number of spatial positions
scc = DE_staircase_code(t, L);
schedule = scc.get_window_decoding_schedule(max_iterations, W); 
scheme = DE_scheme_detgpc(scc);
scheme.set_schedule(schedule);

gpc_sc = DE_base(DE_channel_gpc_bec, scheme, size(schedule, 1), 1e-10); 

z_sc = zeros(1, length(c_r)); % scaled error rate
for i = 1:length(c_r)
  gpc_sc.scheme.density_evolution(c_r(i)); 
  z_sc(i) = gpc_sc.scheme.get_final_vn_error_rate_avg 
end

BER = c_r/n.*z_sc;

return

hold on
plot(EsNo_r, BER, 'r--')



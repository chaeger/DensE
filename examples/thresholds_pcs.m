clc
clear 

addpath('../DensE/')

max_iterations = 100;
target_error_rate = 1e-10; % target error rate that counts as "successful decoding"
t = 4; % erasure-correcting capability of the component codes

code = DE_product_code(t); 
scheme = DE_scheme_detgpc(code);
schedule = code.get_rowcolumn_schedule(max_iterations); % first column: active positions
scheme.set_schedule(schedule);

% the base class combines the channel and coding scheme information
DE_obj = DE_base(DE_channel_gpc_bec, scheme, size(schedule, 1), target_error_rate); 
thr = DE_obj.find_threshold() % thr = 6.79
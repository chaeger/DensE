clc
clear 

addpath('../DensE/')

max_iterations = 1000;
target_error_rate = 1e-10; % target error rate that counts as "successful decoding"
t = 4; % erasure-correcting capability of the component codes

code = DE_half_product_code(t); 
scheme = DE_scheme_detgpc(code);

% the base class combines the channel and coding scheme information
DE_obj = DE_base(DE_channel_gpc_bec, scheme, max_iterations, target_error_rate); 
thr = DE_obj.find_threshold() % thr = 6.79
# DensE: A MATLAB toolbox for density evolution

This toolbox is a collection of MATLAB classes and routines that can
be used to analyze iterative decoding schemes via density evolution. 

The toolbox is currently limited to deterministic generalized product
codes under iterative bounded-distance decoding. It can be used to
predict the asymptotic performance of product codes, staircase codes,
or other related code classes. 

## Getting Started & Examples

All MATLAB files can be found in the folder `DensE`. To install the
toolbox, simply download this folder and add it to MATLAB's path
variable via `addpath('path_to_DensE')`. 

In the following, several examples are provided to illustrate the
basic functionality of the toolbox. 

### Computing Thresholds

The toolbox can be used to numerically compute decoding thresholds. An
example for so-called half-product codes is given below (see 
`examples/thresholds_hpcs.m`). The threshold is given in terms of the
expected number of erasures per component code c, which is related to
the erasure probability as p=c/n, where n is the component code length. 

```Matlab
max_iterations = 1000;
target_error_rate = 1e-10; % target error rate that counts as "successful decoding"
t = 4; % erasure-correcting capability of the component codes

code = DE_half_product_code(t); 
scheme = DE_scheme_detgpc(code);

% the base class combines the channel and coding scheme information
DE_obj = DE_base(DE_channel_gpc_bec, scheme, max_iterations, target_error_rate); 
thr = DE_obj.find_threshold() % thr = 6.79
```

Decoding thresholds of half-product codes (and product codes)
correspond exactly to the [existence thresholds of cores in random
graphs](https://www.sciencedirect.com/science/article/pii/S0095895696900362).
For example, 6.79 is the threshold for a 5-core and, in general,
decoding with t-erasure-correcting component codes corresponds to the
(t+1)-core. This was first observed in [a 2007 paper by Justesen and
Høhold](https://ieeexplore.ieee.org/abstract/document/4313069/). 

### Predicting The Waterfall Behavior in Bit Error Rate Simulation Plots

Density evolution can be used to predict the waterfall behavior of
iterative coding schemes. For example, the following figure shows the
performance of a product code together with the density evolution
prediction (see `examples/waterfall_pcs.m`):

<p align="center"> 
<img src="http://www.christianhaeger.de/waterfall_pc.jpg">
</p>

The product code threshold that can be inferred from the above figure
is roughly 0.013*512=6.66. This is slightly lower than the above value
of 6.79 due to the lower number of iterations. 

Another example for a staircase code is shown below. 

<p align="center"> 
<img src="http://www.christianhaeger.de/waterfall_staircase.jpg">
</p>

The simulations assume idealized decoding where no miscorrections
occur in the component decoding. 

### More Advanced Topics

The toolbox can also be used to visualize and analyze decoding
schedules. For example, the following animation shows the wave-like
decoding behavior of a staircase code when decoded with a window
schedule below the threshold (see `examples/staircase_wave.m`):

<p align="center"> 
<img src="http://www.christianhaeger.de/staircase_wave1.gif">
</p>

When decoding above the threshold, the window moves too fast in
relation to the speed of the decoding wave and the decoder gets stuck
eventually: 

<p align="center"> 
<img src="http://www.christianhaeger.de/staircase_wave2.gif">
</p>

## Additional Information

The toolbox is based on joint work with [Henry D.
Pfister](http://pfister.ee.duke.edu), [Alexandre Graell i
Amat](https://sites.google.com/site/agraellamat/), and [Fredrik
Brännström](https://www.chalmers.se/en/staff/Pages/fredrik-brannstrom.aspx).
If you decide to use the toolbox for your research, please make sure
to cite our paper:

* C. Häger, Henry D. Pfister, A. Graell i Amat, F.
Brännström, "[Density Evolution for Deterministic
Generalized Product Codes on the Binary Erasure Channel at High
Rates](http://arxiv.org/pdf/1512.00433v2.pdf)", *IEEE Trans. Inf.
Theory*, vol. 63, no. 7, pp. 4357-4378, July 2017



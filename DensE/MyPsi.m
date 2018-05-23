function x = MyPsi(t, c)
% MyPsi Upper tail probability of a Poisson random variable
%   MyPsi(t, c) is the probability that the value of a Pois(c) random 
%   variable equals or exceeds t:
%
%   MyPsi(t, c) = Pr(Pois(c) >= t)
% 
x = 1 - gammainc(c, t, 'upper');
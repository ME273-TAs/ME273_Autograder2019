function [y] = evalfit(x, b)

%--------------------------------------------------------------
% FILE: evalfit.m
% AUTHOR: Douglas Cook 
% DATE: 2/3/2018
% 
% PURPOSE: A function that evaluates a polynomial fit at certain sample points
%
%
% INPUTS: 
% x - x sample point(s)
% b - a vector of polynomial coefficients: [b0, b1, b2, .... bn], where the
% polynomial is y = b0 + b1*x + b2*x^2 + ..... bn*x^n];
% 
% OUTPUT: y data point(s) 
%
% NOTES: 
%
%
% VERSION HISTORY
% V1 - 
% V2 - 
% V3 - 
% 
%--------------------------------------------------------------
y = zeros(1,length(x));

for i = 1:length(b)
    
  y = y + b(i)*x.^(i-1);
  
end
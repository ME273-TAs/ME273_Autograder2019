function [yprime] = Fwd_Deriv_4351(x, y)

%=========================================================BEGIN-HEADER=====
% FILE:     Fwd_Deriv_4351.m
% AUTHOR:   Jared Hale
% DATE:     Jan 24, 2019
% 
% PURPOSE:  Compute the second-order accurate numerical derivative of given
%           x and y vectors.
%
%
% INPUTS:   x, y
% 
% 
% OUTPUT:   yprime
%
%
% NOTES:    for the last 2 values, since the Numerical derivative cannot be
%           calculated, return values NaN. a is also a vector of the same
%           length as x and y.
%
%
% VERSION HISTORY
% V1 - Original
% 
%==========================================================END-HEADER======

yprime = ones(1, length(x)); % create vector a containing 1's that is the same dimensions as x and y
yprime(end) = NaN;           % fill the last entry with 'NaN'
yprime(end - 1) = NaN;       % fill the second to last entry with 'NaN'
h = x(2) - x(1);        % define step size h
for i = 1:(length(x) - 2)                   % for the length of x -2, repeat the following code
    Numerator = -y(i+2) + 4*y(i+1) - 3*y(i); % Define the Numerator to be
                                            % equal to
                                            % -y(i+2)+4*y(i+1)-3*y(i)
    yprime(i) = Numerator/ (2*h);                % calculate the derivative and
                                            % store it in vector a
end                                         % end function


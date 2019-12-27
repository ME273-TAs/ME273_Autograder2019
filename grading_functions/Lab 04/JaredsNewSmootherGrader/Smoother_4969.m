function [ys, e] = Smoother_4969(x, y, p, w)

%===================================================================BEGIN-HEADER=====
% FILE:     Smoother_4969.m
% AUTHOR:   Josh Vause
% DATE:   2/4/2019
% 
% PURPOSE: To smooth out data end reduce noise
%
%
% INPUTS: Vector of x values
%         Vector of y values
%         Degree p of fitting polynomial
%         Number points w in a half window
%
% OUTPUT: Vector of smoothed y values ys
%         Vector of residuals e
%
% NOTES: None
%
%
% VERSION HISTORY
% V1 - Original
% 
%===================================================================END-HEADER======

function [b] = Regression(xR,yR,pR) % Function for performing regression
    Z = zeros(length(xR),pR+1); % Create a matrix
    yR = yR(:); % Convert x to column vector
    xR = xR(:); % Convert y to column vector

    for iR = 1:length(xR) % Loop for filling matrix rows
        for jR = 1:(pR+1) % Loop for filling matrix columns
            Z(iR,jR) = xR(iR)^(jR-1); % Fill matrix for polynomial with x values
        end
    end

    b =((Z.' * Z)^-1)*(Z.')*yR; % Solve for coefficient vector

end

function [y] = evalfit(x, b) % Function for evaluating line fit
   
    y = zeros(1,length(x)); % Create vector for approximated values

    for i_eval = 1:length(b) % Loop for evaluating fit
    
        y = y + b(i_eval)*x.^(i_eval-1); % Fill vector with approximated values
  
    end

end

ys = zeros(length(y),1); % Create vector for smoothed y values

for i=1:length(x) % Loop for smoothing data
    if i == 1 || i == length(x) % Test if it is the first or last data point
        ys(i) = y(i); % Have smoothed point be equal to original
    elseif i <= w % Test if too few points at beginning for window
        delta_begin = i-1; % Number of points preceding current point
        xR = x(i-delta_begin:i+delta_begin); % Take window of x values
        yR = y(i-delta_begin:i+delta_begin); % Take window of y values
        [b] = Regression(xR,yR,p); % Get coefficient vector for window of data points
        y_eval = evalfit(xR,b); % Get vector of approximated y values
        ys(i) = y_eval(length(y_eval)/2 + .5); % Keep smoothed value at point being evaluated
    elseif i > w && i <= length(x)-w % Test if full window can be used
        xR = x(i-w:i+w); % Take window of x values
        yR = y(i-w:i+w); % Take window of y values
        [b] = Regression(xR,yR,p); % Get coefficient vector for window of data points
        y_eval = evalfit(xR,b); % Get vector of approximated y values
        ys(i) = y_eval(length(y_eval)/2 + .5); % Keep smoothed value at point being evaluated
    elseif i < length(x) % Get remaining points at end where full window cannot be used
        delta_end = length(x) - i; % Number of points left
        xR = x(i-delta_end:i+delta_end); % Take window of x values
        yR = y(i-delta_end:i+delta_end); % Take window of y values
        [b] = Regression(xR,yR,p); % Get coefficient vector for window of data points
        y_eval = evalfit(xR,b); % Get vector of approximated y values
        ys(i) = y_eval(length(y_eval)/2 + .5); % Keep smoothed value at point being evaluated
    else % In case points not covered
        error("Slipped through"); % Display error if test cases fail
    end
end
e = y(:) - ys; % Vector of residuals
end
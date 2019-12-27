function [ys, e] = Smoother_4628(x,y,p,w)

%===================================================================BEGIN-HEADER=====
% FILE:   Smoother_4628.m
% AUTHOR:  Mack Huntman 
% DATE:  January 31, 2019
% 
% PURPOSE: Write a code that thakes niosy data points and smooth them to be
%          able to evaluate them better 
%
%
%
% INPUTS: X and y data sets, a variable p indicating the degree of the 
%         smoothing polynomial,and a variable w that controls the number 
%         of points fit on each side of x.
% 
% OUTPUT: A vector of smoothed values, ys, and a vector of residuals
% 
%
%
% NOTES: The window size, w, is smaller at the beginning and end and so
%        this smoothing function will be less accurate near the ends.
%
%
% VERSION HISTORY
% V1 - 
% V2 -  
% V3 - 
% 
%===================================================================END-HEADER======

y = y(:);                                                                     % Constrains y data to always be a colomn vector
x = x(:);                                                                     % Constrains x data to always be a colomn vector
ys(1) = y(1);                                                                 % Can't smooth a single point and so the given value is the smoothed value

for i = 2:w                                                               % Window growing
    [b, r2, e] =  RegressionN_4628(x(1:i+(i-1)),y(1:i+(i-1)),p);              % Run regression N for the first points until center windows can run
    [ys(i)] = evalfit(x(i), b);                                               % Find the smoothed point for current window of points
end                                                                           % Closes the for loop for the growing window
    
for i = w+1:length(x)-w                                                   % Center where window is constant size
    [b, r2, e] =  RegressionN_4628(x(i-w:i+w),y(i-w:i+w),p);                  % Run Regression N fuction using current windows until shrinking needs to be used
    [ys(i)] = evalfit(x(i), b);                                               % Find the smoothed point for current section of points
end                                                                           % Closes the for loop for the central portion of the smoothing function

for i = length(x)-w+1:length(x)-1                                         % Window shrinking
    [b, r2, e] =  RegressionN_4628(x((i-(length(x)-i)):length(x)),y((i-(length(x)-i)):length(x)),p);  % Run Regression N fuction using current window until end of inputs
    [ys(i)] = evalfit(x(i), b);                                               % Find the smoothed point for current section of points
end                                                                           % Closes the shrinking for loop

ys(length(x)) = y(length(x));                                                 % Can't smooth a single point and so the given value is the smoothed value
ys = ys(:);
e = y - ys;                                                                   % This is the difference between smoothed value and given value

end                                                                           % End of the smoothing function

function [b, r2, e] =  RegressionN_4628(x,y,p)

%===================================================================BEGIN-HEADER=====
% FILE:     RegressionN_4628.m
% AUTHOR:  Mack Huntman 
% DATE:  January 31, 2019
% 
% PURPOSE: to write a code that can give a line of polynomial regression
% perfectly accurate to the order of polynomial chosen 
%
%
%
% INPUTS: x and y vectors of equal length, and a desired degree of
% polynomial
% 
% 
% OUTPUT: Regression coefficients,R^2 values, and vectors of residuals
%
%
% NOTES: this is very accurate for polynomials with no noise in the data
%
%
% VERSION HISTORY
% V1 - 
% V2 -  
% V3 - 
% 
%===================================================================END-HEADER======



y = y(:);                       % Constrains the y vector to be a colomn vector
x = x(:);                       % Constrains the x vector to be a colomn vector
z = zeros(length(x),p+1);       % Sets up the z matrix for the code using zeros

for i = 1:length(x)             % Use data from 1 to length of x in increments of 1 on the rows of the matrix
    for j = 1:p+1               % Use data from 1 to length of p + 1 in increments of 1 on the colomns of the matrix
       z(i,j) = x(i).^(j-1);    % Creats the z matrix position by position
    end                         % Closes the for loop inside the for loop
end                             % Closes the first for loop

b = inv(z'*z)*(z'*y);           % This is a colomn vector of the polynomial coeficients
yreg = evalfit(x,b);            % Regression line found using below contained function
e = y - yreg;                   % this is the residuals from the actual data to the line or regression
st = sum(((y)-mean(y)).^2);     % Helps find the R2 value
sr = sum((e).^2);               % Sum if the residuals squared
r2 = (st-sr)/st;                % Commonly used variable showing how accurate our line of regression was

end                             % Ends the RegressionN function

function [y] = evalfit(x, b)    % Fuction given to us by Dr. Cook

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
% NOTES: No notes for this self contained function
%
%
% VERSION HISTORY
% V1 - 
% V2 - 
% V3 - 
% 
%--------------------------------------------------------------
y = zeros(size(x));          % Gives a matrix the same size as x regardless of orientation

for i = 1:length(b)          % Takes in steps of one all data points from b vector 
    
  y = y + b(i)*x.^(i-1);     % Find the y data point for selected point 
  
end                          % Ends the for loop 

end                          % Ends the evalfit funtion


function [ys, e] = Smoother_4730(x,y,p,w)

%===================================================================BEGIN-HEADER=====
% FILE:     Smoother_4760.m
% AUTHOR:   Caleb Larson
% DATE:     2/6/19
% 
% PURPOSE: Takes noisy data and outputs it as smoothed data
%
%
% INPUTS: Vectors x and y of equal length, p representing the degree of
%         polynomial, and w which controls the number of points on each 
%         side of x
% 
% OUTPUT: This function returns a vector of smoothed values, ys and the
%         error e
%
%===================================================================END-HEADER======
x = x(:);                                                    % vector x is made a column vector
y = y(:);                                                    % vector y is made a column vector

ys(1) = y(1);                                                % the first term of ys is set to the first term of ys

for i = 2:w;                                                 % Window Growing for loop
    [b, r2, e] = RegressionN_4760(x(1:2*i-1),y(1:2*i-1),p);  % the regression loop is set for the first terms up to w
    [ys(i)] = evalfit(x(i),b);                               % evalfit assigns the smoothes values to ys
end

for i = w+1:length(x)-w;                                     % Center Window for loop
   [b, r2, e] = RegressionN_4760(x(i-w:i+w),y(i-w:i+w),p);   % the regression loop is set for all the middle terms
   [ys(i)] = evalfit(x(i),b);                                % evalfit assigns the smoothes values to ys
end

for i=length(x)-w+1:length(x)-1;                             % Window Shrinking for loop
    [b, r2, e] = RegressionN_4760(x(2*i-length(x):length(x)),y(2*i-length(x):length(x)),p); %the regression loop is set for terms lengthx - w
    [ys(i)] = evalfit(x(i),b);                               % evalfit assigns the smoothes values to ys
end
ys(length(x)) = y(length(x));                                % the last term of ys is set as the last term of y
y = y(:);                                                    % makes y a column vector
ys = ys(:);                                                  % makes ys a column vector

e = y - ys;                                                  % error is the defference from the actual value y to the smoothed value ys

end

function [b, r2, e] = RegressionN_4760(x,y,p)
x = x(:);                   % vector x is made a column vector
y = y(:);                   % vector y is made a column vector


for i = 1:length(x);        % the first for loop is started and i is defined
  for m = 1:p;              % the second for loop is started and m is defined. m is how the degree of regression is determined
   X(i,m) = x(i).^(m-1);    % the matrix X is defined in terms of the x vector raised to the power in realtion to m
  end
end

b = (X'*X)^-1*(X'*y);       % the equation for b is defined

e = y - X*b;                % the error equation is assigned to e

ybar = sum(y)/length(y);    % ybar is defined as the sum of all y values divided by the number of y values
Sr = sum((e).^2);           % Sr is defined as the sum of all the squared error values
St = sum((y-ybar).^2);      % St is defined bt it's equation
r2 = (St - Sr)/St;          % the formula for r2 is defined
end             % the regressionN function is defined

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

%--------------------------------------------------------------
y = zeros(size(x));         % y is defined as a vector of size x

for i = 1:length(b)         % for loop begins, defined from 1 to length b
    
  y = y + b(i)*x.^(i-1);    % the equation for evalfit
  
end
end                              % the function evalfit is defined

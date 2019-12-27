function [ys, e] = Smoother_4256(x,y,p,w)

%===================================================================BEGIN-HEADER=====
% FILE:     Smoother_4256.m
% AUTHOR:   William J De Leon
% DATE:     February 2, 2019
% 
% PURPOSE:  Take a group of noisy data and smooth it out using the regression formulas 
%
%
%
% INPUTS:   Vectors x and y. P is the degree of smoothing polynomial. W is
% the size of the window
% 
% 
% OUTPUT:   The derivatives in a vector the same lenght as x
%
%
% NOTES:     
%
%
% VERSION HISTORY
% V1 - Original
% V2 - Two header key phrases added to improve grading quality: "BEGIN-HEADER" and "END-HEADER" 
% V3 - Completed function
% 
%===================================================================END-HEADER======


for i = 2:length(x)-1       %begin for loop. start at 2 since it cant regress with just one point which is why we do length(x)-1 as well
     
    if i <= w               %this is the process for changing window sizes 
        
    tempw = i-1 ;               %description of temporary window 
    [b] = RegressionN_4256(x((i-tempw):(i+tempw)), y((i-tempw):(i+tempw)), p); %calling b from the regression function using the changing window size
    ys(i) = evalfit(x(i),b);    %use the evalfit fucntion with the b found previously to find the specific ys at the i'th point
    
    elseif i > w && i < (length(x)-w)  %this is what will hapeen once the function won't have a changing window 
        
    [b] = RegressionN_4256(x((i-w):(i+w)), y((i-w):(i+w)), p); %calling b from the regression function using the constant window size
    ys(i) = evalfit(x(i),b) ;   %use the evalfit function with the be previously found and place it into the ys vector
    
    elseif i >= (length(x)-w)   %last if statement for the changing window at the end
        
    tempw = length(x) - i ;     %relationship on how window size changes
    [b] = RegressionN_4256(x((i-tempw):(i+tempw)), y((i-tempw):(i+tempw)), p) ; %call b from regression funciton using the changing window size
    ys(i) = evalfit(x(i),b) ;   %use ealfit function with b for find the ys 
        
    end                         %end of if statements 
end                             %end of for loop 

ys(1) = y(1) ;                  %assing value for first point of vector 
ys(length(y)) = y(end) ;        %assign value for the last point of vector


e = y - ys ;                    %formula to find vector of residuals 


function [b, r2, e] = RegressionN_4256(x, y, p)

%===================================================================BEGIN-HEADER=====
% FILE:     RegressionN_4256.m
% AUTHOR:   William J De Leon
% DATE:     January 31, 2019
% 
% PURPOSE: To take the points from x and y and compute a simple regresion for the values.
%
%
% INPUTS:   vector x and vector y (both are same length), and p 
% 
% 
% OUTPUT:  b - regression coefficients 
%          r2 - the r squared value 
%          e - a vector of the residuals 
%
%
% NOTES:     
%
%
% VERSION HISTORY
% V1 - Original
% V2 - Two header key phrases added to improve grading quality: "BEGIN-HEADER" and "END-HEADER" 
% V3 - Completed function
% 
%===================================================================END-HEADER======

n = length(x) ;          %definition of n 
yb = sum(y)/n ;              %formula to find y bar

z = ones(length(x),p+1); %creates a matrix the size we want full of ones 

for i = 1:length(x)      %assigns a location for the row
 
    for j = 2:p+1        %assigns location for column, we start at 2 to have a column of ones
       
       z(i, j) = x(i).^(j-1) ;  %z matrix formula
       
    end                  %end of j for loop     
    
end                      %end of i for loop 

b = (inv(z' * z))*(z' * y') ; %linear algebra process to find b vector

e = y - evalfit(x,b) ;   %formula to find the vector of residuals 

sr = sum(e.^2) ;         %sr formula, based on e 
    
st = sum((y-yb).^2,'all') ; %formula to find st

r2 = (st - sr)/st ;      %formula to find r^2



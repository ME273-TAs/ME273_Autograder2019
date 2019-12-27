function [ys, e] = Smoother_2573(x,y,p,w) % Initiates a function with a name and calls for input variables

%===================================================================BEGIN-HEADER=====
% FILE:     Smoother_2573.m
% AUTHOR:   Stuart Myers 2573
% DATE:   1/31/2019
% 
% PURPOSE: Smooth out a rough set of data
%
%
% INPUTS: vector, x
%         vector, y
%         degree of polynomial fit, p
%         variable that controls number of points fit on each side of x, w
% 
% OUTPUT: b, r2, e
%
%
% NOTES: Calls on our regression function
%
%
% VERSION HISTORY
% V1 - Original
% V2 -  
% V3 - 
% 
%===================================================================END-HEADER======
Regression = RegressionN_2573(x,y,p); % creates a variable of regression function

for i = w+1 : length(x) % initiates a for loop for changing our window
    
    window = x(i-w:i+w); % defines our window range
    Regression(window); % makes regression happen
    
end % closes for loop


function [b, r2, e] = RegressionN_2573(x,y,p) % Initiates a function with a name and calls for input variables

%===================================================================BEGIN-HEADER=====
% FILE:     RegressionN_2573.m
% AUTHOR:   Stuart Myers 2573
% DATE:   1/31/2019
% 
% PURPOSE: Perform regression with any polynomial
%
%
% INPUTS: vector x
%         vector y
%         degree of polynomial fit p
% 
% OUTPUT: b, r2, e
%
%
% NOTES: Modifies equations 17.6 and 17.7 toward polynomial use
%
%
% VERSION HISTORY
% V1 - Original
% V2 -  
% V3 - 
% 
%===================================================================END-HEADER======

X(:,1) = x; % makes x a column vector
Y(:,1) = y; % makes y a column vector

for j = 1 : p + 1
    
    for i = 1 : length(X)
        
        Z(i,j) = X(i)^(j-1);
        
    end
    
end

ZT = Z';

b = [(ZT * Z)^(-1)] * ZT * Y

St = sum((Y - mean(Y)).^2);

yregression = zeros(1,length(x));
yactual = Y';
X1(1,:) = x
for i = 1 : length(b)
    
    yregression = b(i) * X1 .^ (i-1) + yregression;
    
end

Sr = sum((yactual - yregression).^2);

r2 = (St - Sr) / St

e = yactual - yregression









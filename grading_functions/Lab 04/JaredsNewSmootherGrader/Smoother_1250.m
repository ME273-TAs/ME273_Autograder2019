function [ys, e] = Smoother_1250(x,y,p,w)

%===================================================================BEGIN-HEADER=====
% FILE:    Smoother_1250.m
% AUTHOR:   Christian Graff
% DATE:   30 January 2018
% 
% PURPOSE: For each x value, this function will perform a regression on the w
% values on each side of x. The regression function is then evaluated at
% x and this becomes the smoothed value, ys.
%
%
% INPUTS: This function will accept x & y data sets, a variable p indicating the
% degree of the smoothing polynomial, and a variable w that controls
% how many data points to include in the regression. 
% 
% 
% OUTPUT: This function returns a vector of smoothed values, ys, and a
% vector of residuals e.
%
%
% NOTES: 
%
%
% VERSION HISTORY
% V1 - Started by writing a moving average
% V2 - Input the code from RegressionN_1250
% V3 - Used modular programming instead and created sections for clarity
% V4 - Removed my moving average code
% V4 - Created a modular program for evalfit rather than using the
% protected file
% V5 - Removed plotting
%===================================================================END-HEADER======

for i=1:length(x) %integers going across the length of x
    if i<=w %For when the index is less than or equal to the size of the window, and can't calcualte w behind
        [b]= RegressionN_1250(x(1:(w+i)),y(1:(w+i)),p); %Runs The regression function from 1 to w
        ys(i) = evalfit(x(i),b);
    elseif i>w && i<=(length(x)-w) %For when the index is in the middle of the domain
        [b]= RegressionN_1250(x((i-w):(i+w)),y((i-w):(i+w)),p); %Runs The regression function from 1 to w
        ys(i) = evalfit(x(i),b);
    elseif i>(length(x)-w) %For when the index is at the end of the domain and can no longer look w ahead
        [b]= RegressionN_1250(x((i-w):length(x)),y((i-w):length(x)),p); %Runs The regression function from 1 to w
        ys(i) = evalfit(x(i),b);
    end 
end
e = y - ys; %FIND THE RIGHT EQUATION FOR THE RESIDUALS!!!!!!
end 

%% This section is where the function RegressionN_1250.m will run %%
function [b] = RegressionN_1250(x,y,p)
yprime=y(:); %This puts y in column vector format for easier linear alegra calculations
xprime=x(:); %This puts x in column vector format for easier linear alegra calculations
for i=1:length(x) %Creates a for loop over the domain of x
    for j=1:p+1 %creates the exponents in the Z vector
        Z(i,j)=xprime(i)^(j-1); %Creates a vector Z of the exvalues to the power of exponents
    end 
end
b = (Z'*Z)^-1*(Z'*yprime); %The vector of coefficients
end

%% This is the evalfit function that we were given %%
function [ys]= evalfit(x,b) %uses the coefficients given to calculate the regressedy vales
ys = zeros(1,length(x)); %Predefines the variable ys
for i = 1:length(b) %runs a for loop along the length of b
  ys = ys + b(i)*x.^(i-1);  %multiplies b times a z vector and creates y 
end
end 


 
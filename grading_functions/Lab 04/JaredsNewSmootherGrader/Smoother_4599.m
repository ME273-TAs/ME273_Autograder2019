function [ys, e] = Smoother_4599(x, y, p, w)

%===================================================================BEGIN-HEADER=====
% FILE:     Smoother_4599.m
% AUTHOR:   Hunter Hoffmann
% DATE:   2-7-2019
% 
% PURPOSE: To create a smoothed out line from noisy data using a regression
% window
%
%
% INPUTS: x and y the data values inputed. p the order of polynomial
% regression used. w the size of the window used
% 
% 
% OUTPUT: ys represents the values of the smoothed out data
%
%
% NOTES: This program does not function as well when the window size is
% large relative the the length of the data provided
%
%
% VERSION HISTORY
% V1 - Original
% V2 - Two header key phrases added to improve grading quality: "BEGIN-HEADER" and "END-HEADER" 
% V3 - 
% 
%===================================================================END-HEADER======

n = length(x); %finds the length of x

smoothed = zeros(1,n); % sets the intial value of the function

smoothed(1) = y(1); %sets the first value of the smoothed out data

smoothed(end) = y(end); %sets the last vale of the smoothed out data

for i = 2:n-1 %defines the loop that will run once for every 
    
    if i == 2  %Find regression of second value using a polynomial of magnitude 2
        
        l = x(1:3); %takes the correct section of the x values for this window

        m = y(1:3); %takes the correct section of the y values for this window

        [b,~,~] = RegressionN_4599(l,m,2); %uses the Regression function to find regression of that window

        regressionline = evalfit(l,b); %calculates the values of the regression for that window

        smoothed(2) = regressionline(2); %sets the value for each window to the smoothed vector
        
    elseif i == (n -1)  %Find regression of second to last value using polynomial of magnitude 2
        
        l = x((end-2):end);     %takes the correct section of the x values for this window
    
        m = y((end-2):end); %takes the correct section of the y values for this window
    
        [b,~,~] = RegressionN_4599(l,m,2); %uses the Regression function to find regression of that window
    
        regressionline = evalfit(l,b); %calculates the values of the regression for that window
    
        smoothed(end-1) = regressionline(2); %sets the value for each window to the smoothed vector
    
    elseif i < (w+1)
        
        l = x(1:(2*i-1));   %takes the correct section of the x values for this window
        
        m = y(1:(2*i-1));   %takes the correct section of the y values for this window
        
        [b,~,~] = RegressionN_4599(l,m,p); %uses the Regression function to find regression of that window
        
        regressionline = evalfit(l,b); %calculates the values of the regression for that window
        
        smoothed(i) = regressionline(i); %sets the value for each window to the smoothed vector
        
    elseif i > (n-w)
        
        l = x((end - ((n-i)*2)):end); %takes the correct section of the x values for this window
        
        m = y((end - ((n-i)*2)):end); %takes the correct section of the y values for this window
        
        [b,~,~] = RegressionN_4599(l,m,p); %uses the Regression function to find regression of that window
        
        regressionline = evalfit(l,b); %calculates the values of the regression for that window
        
        smoothed(end - (n-i)) = regressionline(length(regressionline)-(n-i)); %sets the value for each window to the smoothed vector
        
    else
        
        l = x((i-w):(i+w)); %takes the correct section of the x values for this window
   
        m = y((i-w):(i+w)); %takes the correct section of the y values for this window
   
        [b,~,~] = RegressionN_4599(l,m,p); %uses the Regression function to find regression of that window
   
        regressionline = evalfit(l,b); %calculates the values of the regression for that window
   
        smoothed(i) = regressionline(w+1); %sets the value for each window to the smoothed vector
        
    end
    
end

ys = smoothed;  %sets the final output value

e = smoothed - y; %calculates the residual values

end


function [b, r2, e] = RegressionN_4599(x, y, p)

%===================================================================BEGIN-HEADER=====
% FILE:     RegressionN_4599.m
% AUTHOR:   Hunter Hoffmann
% DATE:   2/4/2019
% 
% PURPOSE: To create a linear regression of any length polynomial using the
% matrix method
%
%
% INPUTS: x and y - the data that is to be used in the linear regression
% and p the order of polynomial that is to be used.
% 
% 
% OUTPUT: the coefficients of the polynomial - b. the correlation
% coefficient r2 that tells you how well the model fits the data. and e is
% the residual values.
%
%
% NOTES:
%
%
% VERSION HISTORY
% V1 - Original
% V2 - Two header key phrases added to improve grading quality: "BEGIN-HEADER" and "END-HEADER" 
% V3 - 
% 
%===================================================================END-HEADER======

n = length(x);      %sets the length equal to length of x

xbar = ones(n,p);   %pre creates the matrix xbar

x = x(:)';          %ensures that the vector is a row vector

y = y(:)';          %same as previous line for y vector

for i = 1:n         %a loop that runs in order to create the columns
    
   for j = 1:p      %a loop that runs to creat the rows
       
       xbar(i,j+1) = x(i)^j;    %inputs the correct values into the matrix
        
   end
    
end

xsquare = xbar'*xbar;   %multiplies the matrix by itself transposed

xsquareinv = xsquare^-1;    %calculates the inverse of the matrix

b = xsquareinv * (xbar'*y'); %calculates the b matrix

yregress  = evalfit(x,b);   %calculates the values along the linear regression

e = (yregress - y);         %calculates the residuals

st = 0;                     %sets the initial value

for k = 1:n                 %for loop to calculate st
    
   sti = (y(i) - mean(y))^2;    %calculates one term of st
   
   st = sti + st;           %sums all the values of st
    
end

sr = 0;                     % sets inital value of sr

for l = 1:n                 %starts loop to calculate sr
    
    sri = (y(i) - yregress(i))^2; %calculates individual values of sr
    
    sr = sri + sr;          %sums all values of sr
    
end

r2 = (st - sr)/st;          %calculates the value of r2

end


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
    
  y = y + b(i)*x.^(i-1); %not my code
  
end

end

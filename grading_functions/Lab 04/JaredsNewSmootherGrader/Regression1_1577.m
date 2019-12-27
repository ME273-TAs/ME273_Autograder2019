function [b,r2,e] = Regression1_1577(x,y)

%===================================================================BEGIN-HEADER=====
% FILE:     Regression1_1577.m
% AUTHOR:   Taylor Quain
% DATE:     9/30/19
% 
% PURPOSE: A function that will compute the linear regression of a given
% set of vectors x and y of equal length
%
% INPUTS: x: x vector with either one colum or row
%         y: y vector with either one colum or row
% 
% OUTPUT: b:regression coefficients
%         r2:R^2 Value
%         e:a vector of reiduals
%
% NOTES: 
%
% VERSION HISTORY
% V1 - Original
% V2 - 
% 
%===================================================================END-HEADER======

[numRowx,numColx]=size(x);              %Number of rows and colums in x vector
[numRowy,numColy]=size(y);              %Number of rows and colums in y vector
if numColx==1                           %If x is a single colum vector
    x1=x;                               %Leave as is
else                                    %If x is a single row vector
    x1=x';                              %Transpose x
end                                     %End if statement
if numColy==1                           %If y is a single colum vector
    y1=y;                               %Leave as is
else                                    %If y is a single row vector
    y1=y';                              %Transpose y
end                                     %End if statement
vectorlength=length(x1);                %Number of units in vector
for b1=1:vectorlength                   %From 1 to vectorlength
    Value1(b1)=x1(b1)*y1(b1);           %Vector of sum of (x*y)
end                                     %End for loop
xiyi=sum(Value1);                       %Sum of (x*y)
for c=1:vectorlength                    %From 1 to vectorlength
    Value2(c)=(x1(c).^2);               %Vector of sum of (x^2)
end                                     %End for loop
xi2=sum(Value2);                        %Sum of (x^2)
for d=1:vectorlength                    %From 1 to vectorlength
    Value3(d)=(y1(d).^2);               %Vector of sum of (y^2)
end                                     %End for loop
yi2=sum(Value3);                        %Sum of (y^2)
xi=sum(x1);                             %Sum of x
yi=sum(y1);                             %Sum of y
xbar=xi/vectorlength;                   %Average value of x
ybar=yi/vectorlength;                   %Average value of y
a1=(vectorlength*xiyi-xi*yi)/(vectorlength*xi2-(xi^2));   %Normal equation coefficient a1
a0=ybar-a1*xbar;                        %Normal equation coefficient a0
r=(vectorlength*xiyi-xi*yi)/(sqrt(vectorlength*xi2-xi^2)*sqrt(vectorlength*yi2-yi^2));   %R value
for g=1:vectorlength                    %From 1 to vectorlength
    Error(g)=y(g)-a0-a1*x(g);           %Vector of residuals
end                                     %End for loop
b=[a0,a1]';                              %Regression coefficients
r2= r^2;                                %R^2 Value
e=Error';                                %Vector of residuals
end                                     %End function
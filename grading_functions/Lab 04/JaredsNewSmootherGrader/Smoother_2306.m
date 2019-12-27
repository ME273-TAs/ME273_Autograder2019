function [ys,e] = Smoother_2306(x, y, p, w)

%===================================================================BEGIN-HEADER=====
% FILE:    Smoother_2306.m
% AUTHOR:   Luke Hoose
% DATE:   1/22/19
% 
% PURPOSE: The purpose is to take a noisy set of data points and replace 
% this set with a new set of smoother data points using polinomial regression.
%
%
% INPUTS: The inputs are p, x, y, and w.  The value of p is the power of 
% the polinomial for regrssion.  The vector w is the number of points on 
% either side of the point we are looking at that we will take into
% consideration for the smoothing. x and y are the inderpendent and
% dependent variales of our data set.
% 
% 
% OUTPUT: ys is the new vector of dependent variable values from the
% smoothing. e is the error between the measured and modeled y-values.

% NOTES: The spacing can differ and the inputs can be input as either row
% or column vectors.
%
%
% VERSION HISTORY
% V1 - Rough sketch
% V2 - Final version 
% 
%===================================================================END-HEADER======
x=reshape(x,[],1);%make x a column
y=reshape(y,[],1);%make y a column
for i=1+w:length(x)-w%for loop for the section of window with constant width
   ys(i)=evalfit(x(i),RegressionN_2306(x(i-w:i+w),y(i-w:i+w),p));%regression and evaluation for ys
end
ys=ys;%make ys visible outside for loop
for i=1:w%for loop for the power of the polinomial regression at the beginning where window changes 
if 2*(i-1)<=p%creating a vector for the polinomial power for the beginning
        c(i)=2*(i-1);%generally the this is the power in the beginning unless it is greate than p
    else
        c(i)=p;%the power has a max of p
end
end
for i=1:w%for loop to create the values for ys where the window changes width
        ys(i)=evalfit(x(i),RegressionN_2306(x(1:2*i-1),y(1:2*i-1),c(i)));%calculating ys at the beginning
end
for i=1:w%for loop for the polinomial powers at the end
if 2*(w-i)<=p%generally the power is equal to this at the end
       d(i)=2*(w-i);%creating a vector of the powers called d
    else
        d(i)= p;%d has a max value of p
end
end
for i=1:w%for loop for the end section where the window changes width
         ys(length(x)-w+i)=evalfit(x(length(x)-w+i),RegressionN_2306(x(length(x)-2*w+2*i:length(x)),y(length(x)-2*w+2*i:length(x)),d(i)));%calculating ys at the end
end
   ys=reshape(ys,[],1);%making ys a column
   e=y-ys;%finding the residual vector
end
function [b,r2,e] = RegressionN_2306(x, y, p)%inputting the regression function
x=reshape(x,[],1);%making x a column
y=reshape(y,[],1);%making y a column
 for j=1:(p+1);%setting up a for loop for the columns of Z
    for i=1:length(x);%setting up a for loop for the rows of Z
           Z(i,j)=x(i,1).^(j-1);%creating the matrix of x-values, Z 
    end
 end
Z=Z;%making it so I can see Z while surpressing the for loop
b=inv(Z'*Z)*(Z'*y);%finding the b vector
end
function [y] = evalfit(x, b)%inputting the evalfit function

y = zeros(1,length(x));%creating the matrix y

for i = 1:length(b)%for finding the values of y
    
  y = y + b(i)*x.^(i-1);%finding the values of y
  
end
end
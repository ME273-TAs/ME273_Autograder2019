function [ys, e] = Smoother_4351(x, y, p, w)

%=========================================================BEGIN-HEADER=====
% FILE:     Smoother_4351.m
% AUTHOR:   Jared Hale
% DATE:     Feb 3, 2019
% 
% PURPOSE:  Calculate a linear equation for the line of best fit through
%           given x and y vectors.
%
%
% INPUTS:   x, y, p, w
% 
% 
% OUTPUT:   ys, e
%
%
% NOTES:    this function accepts an x and y vectors along with scalar
%           values p and w. It then uses embeded functions to create a
%           vector ys of values that are approximately close to the line of
%           best fit of pth order for the given values. Rather than using
%           the entire line all at once, variable w is used to determine
%           how many entries to the left and right of each entry are used.
%           For the regions wherein we are too close to use w entries to
%           the left or right of a value, we adjust the window size to
%           accommodate for that and shrink the window to fit the max
%           number of points on each side. And for the regions where there
%           are not enough points in the new window to approximate a pth
%           order polynomial accurately, the order is reduced to
%           accommodate the math as well. For the endpoints, no regression
%           is used and those values are passed through to ys.
%
% VERSION HISTORY
% V1 - Original
% V2 - Created local function WindowReg to simplify repeat code
%==========================================================END-HEADER======
x = x(:);                       % If necessary, transpose x to be a collumn vector
y = y(:);                       % If necessary, transpose y to be a collumn vector
n = length(x);                  % define variable n to be the length of x
ys = zeros(n,1);                % declare vector ys to be a column vector
                                % the same size as x and y
for i = 1:n                     % begin the for loop to fill in vector ys
    if i == 1                   % for the first entry of ys...
        ys(i) = y(i);           % set ys(1) equal to y(1)
    elseif i <= w && p > (2*i-2)                    % for the region
                                                    % wherein the window is
                                                    % changing size, and
                                                    % there are not enough
                                                    % points to use the pth
                                                    % order
                                                    % approxamation...
        ys = WindowReg(x,y,ys,(i-1),i,i);           % run WindowReg with
                                                    % window size i-1 and
                                                    % to the ith order
    elseif i <= w && p <= (2*i-2)                   % for the region where
                                                    % the window size is
                                                    % changing but there
                                                    % are enough points to
                                                    % use pth order...
        ys = WindowReg(x,y,ys,(i-1),p,i);           % run WindowReg with
                                                    % window size i-1 and
                                                    % order p
    elseif i > w && i <= (n-w)                      % for the region
                                                    % wherin we can use the
                                                    % full window size...
        ys = WindowReg(x,y,ys,w,p,i);               % run WindowReg with
                                                    % established w, p, and
                                                    % i
    elseif i > (n-w) && (2*n - 2*i) >= p && i ~=  n % for the region where
                                                    % the window size is
                                                    % changing but there
                                                    % are enough points to
                                                    % use pth order..
        ys = WindowReg(x,y,ys,(n-i),p,i);           % run WindowReg with
                                                    % window size n-1 and
                                                    % order p
    elseif i > (n-w) && (2*n - 2*i) < p && i ~=  n  % for the region
                                                    % wherein the window is
                                                    % changing size, and
                                                    % there are not enough
                                                    % points to use the pth
                                                    % order
                                                    % approxamation...
        ys = WindowReg(x,y,ys,(n-i),(n-i+1),i);     % run WindowReg with
                                                    % window size i-1 and
                                                    % to the n-1+1 order
    elseif i == n                                   % otherwise 1==n and...
        ys(i) = y(i);                               % ys(end) = y(end)
    end                                             % end if statements
end                                                 % end for loop
e = y - ys;                                         % set variable e to be
                                                    % equal to the
                                                    % differences between y
                                                    % and ys
end                                                 % end function 
                                                    % Smoother_4351







function [b] = Regression(xw, yw, p)

%=========================================================BEGIN-HEADER=====
% DATE:     Feb, 2019
% 
% PURPOSE:  Calculate a pth order equation for the line of best fit through
%           given x and y vectors.
%
%
% INPUTS:   x, y, p
% 
% 
% OUTPUT:   b
% 
% NOTES:    this function takes the given x and y vectors and calculates a 
%           pth order line of best fit using matrix algebra. The output is
%           given as vector b.
%
% VERSION HISTORY
% V1 - Original
%==========================================================END-HEADER======
n = length(xw);                 % define variable n to be the length of x
Z = zeros(n,p+1);               % declare matrix Z to have dimensions n x p+1
for i = 1:n                     % begin for loop to populate rows of matrix Z
    for j = 1:p+1               % begin for loop to populate collumns of matrix Z
        Z(i,j) = xw(i)^(j-1);   % populate each entry of Z with the appropriate value
    end                         % close loop
end                             % close loop
b = (Z'*Z)^(-1)*(Z'*yw);        % use matrix algebra to find vector b
end                             % end function Regression


function [ys] = WindowReg(x, y, ys, w, p, i)
%=========================================================BEGIN-HEADER=====
% FILE:     Regression
% DATE:     Feb, 2019
% 
% PURPOSE:  Calculate a pth order equation for the line of best fit through
%           given x and y vectors.
%
%
% INPUTS:   x, y, ys, w, p, i
% 
% 
% OUTPUT:   ys
%
%
% NOTES:    this function takes the vectors x, y, and ys and creates
%           vectors xw and yw to evaluate ys(i) for point i given desired
%           window size w and polynomial fit p.
%
% VERSION HISTORY
% V1 - Original
%==========================================================END-HEADER======
xw = x(i-w:i+w);            % define variable xw to be just the entries of 
                            % x surrounding x(i) in determined window size 
yw = y(i-w:i+w);            % define variable yw to be just the entries of 
                            % y surrounding y(i) in determined window size 
b = Regression(xw,yw,p);    % run function Regression to return variable b
A = zeros(1,p+1);           % preallocate the size of matrix A
for j = 1:(p+1)             % start for loop to fill in A
    A(1,j) = x(i)^(j-1);    % fill out A with x(i) to the j-i power
end                         % end loop
ys(i) = A*b;                % save new value A*b as ys(i)
end                         % end function WindowReg
function [Score, Feedback] = Smoother_Grader_V2(filename)

%--------------------------------------------------------------
% FILE: Smoother_Grader.m
% AUTHOR: Jared Oliphant
% DATE: 4 Feb 2019
%
% PURPOSE: Function for grading Lab 4, part 3: Smoother
% smoothed vector, error vector, and r2 value.
% 1st test will use a relatively small w and the second will be a large w
% in relation to the length of x and y. Highest value of p will be 2 to
% avoid issues with singular matrices on the caps.
%
% INPUTS:
%   filename - a filename corresponding to a student's code
%
%
% OUTPUT:
%   Score - a scalar between 0 and 1
%   Feedback - a character array of feedback, containing a grades breakdown.
%
%
% VERSION HISTORY
% V1 -
% V2 - Used new solution vectors with more values in the 'middle area'
%       (7 of 15, rather than 2 of 10). Included code that provided
%       solution. 
% V3 -
%
%--------------------------------------------------------------

% the TRY/CATCH structure is used to prevent code crashes
try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================|
    StudentFunction = filename(1:end-2);    % get function name     |
    %=================================================|
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    %dataset
    x = linspace(0,5,15);
    % y = -exp(x).*sin(x) + normrnd(0,0.08,1,length(x));
    y = [1.525380117791696
        -0.222340426211865
        -0.879970485500041
        -0.959923744968925
        -0.676419153352131
        -0.257426806091013
        0.038446208343574
        0.244712332848601
        0.414259255395328
        0.418554277569900
        0.378641665758025
        -0.151233828191096
        -0.388784106531723
        -0.889878525625737
        -0.771220913043844]';
    p = 2;    % REPLACE THIS INPUT?
    w = 4;    % REPLACE THIS INPUT?
    %[ys,e] = Smoother_XXXX(x,y,p,w)
    Solution_ys = [1.525380117791696
        -0.222340426211866
        -0.905530034313970
        -0.982131352241651
        -0.774391024926953
        -0.381698760876662
        -0.024648305680257
        0.278500079124202
        0.403342596097412
        0.391106905592976
        0.191015737886100
        -0.086644803373709
        -0.512141151856776
        -0.889878525604843
        -0.771220913043844]';% smoothed vector (row)
    Solution_e = [0
        0.000000000000001
        0.025559548813929
        0.022207607272726
        0.097971871574822
        0.124271954785649
        0.063094514023831
        -0.033787746275601
        0.010916659297916
        0.027447371976923
        0.187625927871925
        -0.064589024817387
        0.123357045325053
        -0.000000000020895
        0]';   % error vector (row)
    %=================================================
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = ['[Stud_ys,Stud_e] = ',StudentFunction,'(x,y,p,w);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    % ensure student solution is appropiate dimension
    Stud_ys = Stud_ys(:)';
    Stud_e = Stud_e(:)';
    %================================================================================
    %==================================================
    % GRADING SECTION - evaluate student work here.
    if length(Stud_ys) == length(Solution_ys)
        yscheck = abs(Solution_ys - Stud_ys) < .01;
        scoreys = 1 - .03*(length(x) - nnz(yscheck));
        feedbackys = [num2str(nnz(yscheck)),' out of ',num2str(length(x)),' of your smooth vector were accurate.'];
    else
        scoreys = 0;
        feedbackys = 'Your ys vector is not the right length';
    end
    
    index = scoreys < 0;      % Checking the bounds of score
    scoreys(index) = 0;
    index = scoreys > 1;
    scoreys(index) = 1;
    
    
    if length(Stud_e) == length(Solution_e)
        echeck = abs(Solution_e - Stud_e) < .001;
        scoree = 1 - .02*(length(Solution_e)-nnz(echeck));                  % if all 9 errors are wrong should get .1 (10%)
        feedbacke = [num2str(nnz(echeck)),' out of ',num2str(length(Solution_e)),' of your error vector were accurate.' ];
    else
        scoree = 0;
        feedbacke = 'Your e vector is not the right length';
    end
    
    
    index = scoree < 0;      % Checking the bounds of score
    scoree(index) = 0;
    index = scoree > 1;
    scoree(index) = 1;
    
    
    %average all
    Score =(scoreys + scoree) / 2;
    S1 = num2str(round(100*(scoreys)));
    S2 = num2str(round(100*(scoree)));
    Feedback = ['Smoothed vector score:  ',S1,'  Smoothed vector feedback:  ',...
        feedbackys,'  Error vector score:  ',S2,...
        '  Error vector feedback  ',feedbacke];
    %
    %==================================================
    
    
    %====================================================================================
    % ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR
    
    %==============================================================
    % Zero score if the code doesn't run:
    Score = 0;      % give score of 0
    % An explanation of the zero score and the MATLAB error message.
    Feedback = regexprep(ERROR.message,'\n',' ');
    %==============================================================
    
    
    
end     %first iteration of check (3rd order)


end

%{
======================================================================
======================================================================
======================================================================
====== THE FOLLOWING FUNCTION WAS USED TO GENERATE THE SOLUTION ======
======================================================================
======================================================================
======================================================================


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


%}
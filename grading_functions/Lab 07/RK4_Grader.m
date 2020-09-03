function [Score, Feedback] = RK4_Grader(filename,finalGrade)
%--------------------------------------------------------------
% FILE: RK4_Grader.m   
% AUTHOR: Jared Oliphant
% DATE: 15 March 2018
% 
% PURPOSE: Function for grading Lab 9, part 1: 4th order Runge-Kutta method
%
% INPUTS: 
%   filename - a filename corresponding to a student's code
%   finalGrade - final grading flag
% 
% 
% OUTPUT: 
%   Score - a scalar between 0 and 1
%   Feedback - a character array of feedback, containing a grades breakdown.
%
% 
% VERSION HISTORY
% V1 - 
% V2 - 
% V3 - 
% 
%--------------------------------------------------------------

Feedback = '';
% the TRY/CATCH structure is used to prevent code crashes
try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================| 
    StudentFunction = filename(1:end-2)    % get function name     |
    %=================================================|
    
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    % TEST 1
    fh1 = @exampleode;
    Xrange1 = [0 4];
    y01 = 1;
    N1 = 8;
    xs1 = linspace(0,4,N1);                                            %solution to exampleode
    ys1 = [1  3.2849  2.7709  2.0171  2.3028  3.6281  4.7135  3.0000];       %in the book
    
    % TEST 2
    fh2 = @harderode;
    Xrange2 = [4 11];
    y02 = -2;
    N2 = 6;
    xs2 = linspace(4,11,N2);                                      %solution to harderode
    ys2 = [-2.0000    9.6303   22.4446   36.2574   52.3457   69.9811];       

    %=================================================
    
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    % TEST 1
    CallingString = ['[x1,y1] = ',StudentFunction,'(fh1, Xrange1, y01, N1);'];   % A string passed to eval.
    eval(CallingString)                                         % evaluate the function

    % TEST 2
    CallingString = ['[x2,y2] = ',StudentFunction,'(fh2, Xrange2, y02, N2);'];   % A string passed to eval.
    eval(CallingString)                                         % evaluate the function

    %================================================================================
    
    
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    tol = .01;
    if length(x1) == length(xs1) && length(y1) == length(ys1) && ...   %make sure all the vectors are the same length
            length(x2) == length(xs2) && length(y2) == length(ys2) 
        
        %TEST 1
        if norm(xs1- x1(:)') < tol && norm(ys1 -y1(:)') < tol          %make sure they are both row vectors before taking difference
            Score1 = 1;
            Feedback = [Feedback,'TEST1, Easy ODE: Both vectors matched the solution perfectly, well done!'];
        else
            Score1 = .5;
            Feedback = [Feedback,'TEST1, Easy ODE: Your output vectors, x and y, were not quite correct.  norm(xs-x) = ',num2str(norm(xs1- x1(:)')),'  norm(ys-y) =  ',num2str(norm(ys1-y1(:)'))];
        end
        
        %TEST 2
        if norm(xs1 - x1(:)') < tol && norm(ys2 - y2(:)') < tol   
            Score2 = 1;
            Feedback = [Feedback,'  --  TEST2, Harder ODE: Both vectors matched the solution perfectly, well done!'];
        else
            Score2 = .5;
            Feedback = [Feedback,'  --  TEST2, Harder ODE: Your output vectors, x and y, were not quite correct.  norm(xs-x) = ',num2str(norm(xs2- x2(:)')),'  norm(ys-y) =  ',num2str(norm(ys2-y2(:)'))];
        end

    else
        Score1 = .5;
        Score2 = .5;
        Feedback = [Feedback,'One or more of your output vectors are not the correct length, both x and y should have length N'];
    end
    %==================================================
    
    
%====================================================================================
% ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR  
    
    %==============================================================
    % Zero score if the code doesn't run:   
    Score1 = 0;      % give score of 0
    Score2 = 0;
    % An explanation of the zero score and the MATLAB error message. 
    Feedback = regexprep(ERROR.message,'\n',' ');     
    %==============================================================
    
   
    
end


%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE. 
% Note: Final score must between 0 and 1. 
    weight1 = 1;   % weight of easy ode
    weight2 = 1;   % weight of harder ode
    Score = (weight1*Score1+weight2*Score2)/(weight1+weight2);

    index = Score < 0;     % Checking the bounds of score
    Score(index) = 0;
    index = Score > 1;
    Score(index) = 1;
    % NORMALIZE THE SCORE (0 <= score <= 1)
%
%========================================================================
   
    
end

%needs to be able to accept vectors as well as scalars just in case
function dydx = exampleode(x,y)
   dydx = -2*x.^3 + 12*x.^2 - 20*x + 8.5;
end

%needs to be able to accept vectors as well as scalars just in case
function dydx = harderode(x,y)
    b = 2.45.^x-9*exp(cos(y));
    dydx = -(b.*x.^2 - 9.8*pi.*sin(y))./(b.*(2-x))+sin(x.*y);
end

function [Score, Feedback] = Fwd_Deriv_Grader(filename)

%--------------------------------------------------------------
% FILE: Fwd_Deriv_Grader.m
% AUTHOR: Jared Oliphant 
% DATE: 1/26/2019
% 
% PURPOSE: 
%
% INPUTS: 
% a filename corresponding to a student's code
% 
% 
% OUTPUT: 
% Score - a scalar between 0 and 1
% Feedback - a character array of feedback, containing grades breakdown.
%
% 
% VERSION HISTORY
% V1 - This version.
% V2 - 
% V3 - 
% 
%--------------------------------------------------------------

    Score = 0;
    Feedback = '';
    
    
    try
        f = filename(1:end-2) % get function name

        % Input Data and solution for testing student code
        x = 0:0.5:2;    % x pts.
        y = exp(x);     % y is it's own derivative
        Solution = [ 0.876603254341468      1.44527443139773      2.38285469704447    NaN    NaN]; 
        
        
        % Call student code---------------------------------------------------------- 
        eval(['yprime = ',f,'(x,y);'])    % evaluate the function
        yprime = yprime(:)';
      
        % GRADING SECTION------------------------------------------------------------
        if nnz(isnan(yprime)) == 2 && nnz(isnan(yprime) == [0 0 0 1 1]) == 5
            Feedback = [Feedback,' NaNs were placed in the proper locations. '];
            Score = Score + 1/3;
        else 
            Feedback = [Feedback,' Your function did not return NaNs as instructed. '];
        end
        
        if length(yprime) == length(x)
            Feedback = [Feedback,' Length of the output vector was correct. '];
            Score = Score + 1/3;
        else
            Feedback = [Feedback,' Length of the output vector was not correct, it should be the same length as the input vectors. '];
        end
        
        if norm(yprime(1:end-2) - Solution(1:end-2)) < .0001
            Feedback = [Feedback,' Your output matched the solution. '];
            Score = Score + 1/3;
        else
            Feedback = [Feedback,' Your output did not match the solution. '];
        end
        
        
        % NORMALIZE THE SCORE (0 <= score <= 1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    catch ERR
        % store error messages and zero scores if the code doesn't run.   
        Score = 0; % give score of 0
        errormessage = regexprep(ERR.message,'[\n\r]+','  ');   % strip newline characters from the error message
        Feedback = ['Score 0 because code failed. MATLAB Error Message: ',errormessage];
    end
    
end
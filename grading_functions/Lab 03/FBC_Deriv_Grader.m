function [Score, Feedback] = FBC_Deriv_Grader(filename)

%--------------------------------------------------------------
% FILE: FBC_Deriv_Grader.m
% AUTHOR: Douglas Cook 
% DATE: 2/6/2018
% 
% PURPOSE: Function for grading Lab 3, part III: Forward, Backward, and Central difference numerical derivative function.  
% The function uses y = exp(x) with x = [0 0.5 1.0 1.5 2.0] as the solution. The
% solution was obtained from the function DIFF_2087.m.
%
% INPUTS: 
% a filename corresponding to a student's code
% 
% 
% OUTPUT: 
% score - a scalar between 0 and 1
% fileFeedback - a character array of feedback, containing grades breakdown.
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
        y = 8.5*x.^2-3.466*x;       % derivative will be the same regardless how they did it
        Solution = [-3.4660    5.0340   13.5340   22.0340   30.5340]; 
        
        
        % Call student code---------------------------------------------------------- 
        eval(['yprime = ',f,'(x,y);'])    % evaluate the function
        yprime = yprime(:)';
      
        % GRADING SECTION------------------------------------------------------------
        if nnz(isnan(yprime)) == 0
            Score = Score + 1/3;
        else 
            Feedback = [Feedback,' Your function returned some NaNs in the result. '];
        end
        
        if length(yprime) == length(x)
            Feedback = [Feedback,' Length of the output vector was correct. '];
            Score = Score + 1/3;
        else
            Feedback = [Feedback,' Length of the output vector was not correct, it should be the same length as the input vectors. '];
        end
        
        if norm(yprime - Solution) < .01   % careful here because there are multiple correct ways to do this part
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
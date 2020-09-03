function [Score, Feedback] = XXXXXX_Grader(filename,finalGrade)

%--------------------------------------------------------------
% FILE: XXXXXXX_Grader.m    ------ replace XXXXX with the leading name of the student submission file --------
% AUTHOR: 
% DATE: 
% 
% PURPOSE: Function for grading Lab X, part XX: -----SHORT DESCRIPTION HERE-------
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


% the TRY/CATCH structure is used to prevent code crashes
try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================| 
    StudentFunction = filename(1:end-2);    % get function name     |
    %=================================================|
    
    
    
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    
    Solution = 12345;   % Obtained using _____________
    %=================================================
    
        
    
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = ['[I] = ',StudentFunction,'(x,y);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================
    
    
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    %
    %
    %==================================================
    
    
%====================================================================================
% ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR  
    
    %==============================================================
    % Zero score if the code doesn't run:   
    Score = 0;      % give score of 0
    % An explanation of the zero score and the MATLAB error message. 
    errormessage = regexprep(ERR.message,'[\n\r]+','  ');   % strip newline characters from the error message
    Feedback = ['Score 0 because code failed. MATLAB Error Message: ',errormessage];  
    %==============================================================
    
   
    
end


%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE. 
% Note: Final score must between 0 and 1. 
%
%
%
%========================================================================
   
    
end



function score = OutOfBounds(score)
    % Helper function the will bound the score from 0 to 1
    index = score < 0;     % Checking the bounds of score
    score(index) = 0;
    index = score > 1;
    score(index) = 1;
end



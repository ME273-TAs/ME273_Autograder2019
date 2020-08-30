function [Score, Feedback] = Secant_Grader(filename,finalGrade)

%--------------------------------------------------------------
% FILE: Secant_Grader.m   
% AUTHOR: Jared Oliphant
% DATE:   2/8/2019
% 
% PURPOSE: Function for grading Lab 5, part 2: Secant method; This grader
% must be careful because it was not specificed the order the guess vector
% [x0, x1] or [x1, x0]. we will assume [x0, x1] and have a wide tolerance
% for n
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

%% the TRY/CATCH structure is used to prevent code crashes
try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================| 
    StudentFunction = filename(1:end-2);    % get function name     |
    %=================================================|
    
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    guess = [10,8];
    tol = 0.0001;
    fh = @RandomFunction01;
    
    a = 2.286690806920445;
    b = -9.245222675208957;
    c = 3.081344065619803;
    parameters = struct('a',2.286690806920445,'b',-9.245222675208957,'c',3.081344065619803);
    save('parameters');

    Solution_xr = 9.842313615155344;  % exp(a) = 9.842313615175836
    Solution_yr = 2.175589715633227e-07;
    Solution_n = 6;
    %=================================================
    
    %================================================================================
    % Running student code
    CallingString = ['[Stud_xr,Stud_yr,Stud_n] = ',StudentFunction,'(fh,guess,tol);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================
    
    
    
    %% ==================================================
    % GRADING SECTION - evaluate student work here.
    if length(Stud_xr) == 1 && ~isnan(Stud_xr)
        score_xr = 1 - abs(Solution_xr - Stud_xr);
    else
        score_xr = 0;
    end
    
    score_xr = OutOfBounds(score_xr);    % Checking the bounds of score
    
    %------------------------------
    if length(Stud_yr) == 1 && ~isnan(Stud_yr)
        score_yr = 1 - Stud_yr;
    else
        score_yr = 0;
    end
    
    score_yr = OutOfBounds(score_yr);    % Checking the bounds of score
    
    %------------------------------
    if length(Stud_n) == 1
       if Stud_n <= 6
           score_n = 1;
       else
           score_n = 1 - 0.1*(Stud_n-6);  % Stud_n = 7; score_n = 0.9; -- Stud_n = 8; score_n = 0.8;
       end
    else
        score_n = 0;
    end
    
    score_n = OutOfBounds(score_n);    % Checking the bounds of score
    
    
    Feedback = ['The solution was: xr = ',num2str(Solution_xr),'  yr = ',...
            num2str(Solution_yr),'  n = ',num2str(Solution_n),'.  Your answer was: xr = ',...
            num2str(Stud_xr),'  yr = ',num2str(Stud_yr),'  n = ',num2str(Stud_n)];
    
        
    contents = fileread(filename);
    if contains(contents,"fh('init')")
        Feedback = ['It''s likely that you reintialized the Random_Function_01 inside your function, which means you were finding the wrong root...   ', Feedback];
    end    
    
    %==================================================
    Score = (score_xr + score_yr + score_n)/3;
    
%% ====================================================================================
% ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERR 
    
    %==============================================================
    % Zero score if the code doesn't run:   
    Score = 0;      % give score of 0
    % An explanation of the zero score and the MATLAB error message. 
    errormessage = regexprep(ERR.message,'[\n\r]+','  ');   % strip newline characters from the error message
    Feedback = ['Score 0 because code failed. MATLAB Error Message: ',errormessage,' Remember that guess will be a two element vector for Secant method.'];  
    %==============================================================
   
end




%%
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
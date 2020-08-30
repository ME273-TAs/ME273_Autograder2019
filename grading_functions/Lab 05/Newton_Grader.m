function [Score, Feedback] = Newton_Grader(filename)

%--------------------------------------------------------------
% FILE: Newton_Grader.m
% AUTHOR: Jared Oliphant
% DATE: 15 Feb 2018
%
% PURPOSE: Function for grading Lab 6, part 1: Newton method of root
% finding
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
% V2 -
% V3 -
%
%--------------------------------------------------------------
% the TRY/CATCH structure is used to prevent code crashes
try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================|
    StudentFunction = filename(1:end-2);    % get function name     |
    %=================================================
    
    
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    guess = 7;
    tol = .001;
    fh = @RandomFunction01;
    
    a = 2.186342827703302;
    b = 9.189848527858061;
    c = 1.245925593252695;
    parameters = struct('a',2.186342827703302,'b',9.189848527858061,'c',1.245925593252695);
    save('parameters');
    
    Solution_xr = exp(a);
    Solution_yr = 4.703147797451041e-05;
    Solution_yr = fh(8.902595181885875);
    Solution_n = 5;
    
    %================================================
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = ['[Stud_xr,Stud_yr,Stud_n] = ',StudentFunction,'(fh,guess,tol);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %     Stud_xr
    %     Stud_yr
    %     Stud_n
    %================================================================================
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    
    if abs(Stud_xr - Solution_xr) < .001 ...
            && abs(Stud_yr - Solution_yr) < .001 ...
            %             && Stud_n < Solution_n + 1
        Score = 1;
        Feedback = ['Well done! The solution was: xr = ',num2str(Solution_xr),'  yr = ',...
            num2str(Solution_yr),'  n = ',num2str(Solution_n),'.  Your answer was: xr = ',...
            num2str(Stud_xr),'  yr = ',num2str(Stud_yr),'  n = ',num2str(Stud_n)];
    else
        Score = 1 - abs(Stud_xr - Solution_xr)/5;
        Feedback = ['The solution was: xr = ',num2str(Solution_xr),'  yr = ',...
            num2str(Solution_yr),'  n = ',num2str(Solution_n),'.  Your answer was: xr = ',...
            num2str(Stud_xr),'  yr = ',num2str(Stud_yr),'  n = ',num2str(Stud_n)];
        
        contents = fileread(filename);
        if contains(contents,"RandomFunction01('init')")
            Feedback = ['It''s likely that you reintialized the Random_Function_01 inside your function, which means you were finding the wrong root...   ', Feedback];
        end
    end
    
    
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
    
    
end




%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE.
% Note: Final score must between 0 and 1.

% Score = sum(Score)/num_tests

index = Score < 0;     % Checking the bounds of score
Score(index) = 0;
index = Score > 1;
Score(index) = 1;
% NORMALIZE THE SCORE (0 <= score <= 1)


%
%========================================================================




end

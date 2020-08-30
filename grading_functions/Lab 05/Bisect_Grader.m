function [Score, Feedback] = Bisect_Grader(filename)

%--------------------------------------------------------------
% FILE: Bisect_Grader.m   
% AUTHOR: Jared Oliphant
% DATE: 21 Feb 2018
% 
% PURPOSE: Function for grading Lab 6, part 5: Bisect method
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
    % 
    tol = .01;
    guess = [5 10];
    fh = @RandomFunction01;
    
    
    a = 2.275364446936168;
    b = -6.847738366449034;
    c = 3.764742254084926;
    parameters = struct('a',2.275364446936168,'b',-6.847738366449034,'c',3.764742254084926);
    save('parameters')
    
    Solution_xr = exp(a);
    Solution_yr = -21.244479031593936;
    Solution_n = 13;


    %================================================   
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = ['[Stud_xr,Stud_yr,Stud_n] = ',StudentFunction,'(fh,guess,tol);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
  
    if abs(Stud_xr - Solution_xr) < .01 ...
            && abs(Stud_yr - Solution_yr) < .05 ...
%             && Stud_n < Solution_n + 1 
        Score = 1;
        Feedback = ['Well done! The exact solution was: xr = ',num2str(Solution_xr),'  yr = ',...
            num2str(Solution_yr),'  n = ',num2str(Solution_n),'.  Your answer was: xr = ',...
            num2str(Stud_xr),'  yr = ',num2str(Stud_yr),'  n = ',num2str(Stud_n)];
    else
        Score = 1 - abs(Stud_xr - Solution_xr)/5;
        Feedback = ['The exact solution was: xr = ',num2str(Solution_xr),'  yr = ',...
            num2str(Solution_yr),'  n = ',num2str(Solution_n),'.  Your answer was: xr = ',...
            num2str(Stud_xr),'  yr = ',num2str(Stud_yr),'  n = ',num2str(Stud_n)];
        
        % They found a root but it wasn't the one I was looking for
        if Stud_yr < tol && abs(Stud_xr - Solution_xr) > .1
            Feedback = ['It''s likely that you reintialized the Random_Function_01 inside your function   ',...
                Feedback];
        end
    end
    
    % They found the root but their iterations are wrong for some reason
    if abs(Stud_n - Solution_n) > 5 && abs(Stud_xr - Solution_xr) < .1
        Score = Score - .025;
        Feedback = ['Your n values were different from the solution, it''s likely your error and/or tolerance calculations may be off.   ', Feedback];
    end
    
    %==================================================
    
    
%====================================================================================
% ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR  
    
    %==============================================================
    % Zero score if the code doesn't run:   
    Score = 0;      % give score of 0
    % An explanation of the zero score and the MATLAB error message. 
    Feedback = [regexprep(ERROR.message,'\n',' ')];     
    %==============================================================
    
   


end

%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE. 
% Note: Final score must between 0 and 1.
   
    index = Score < 0;     % Checking the bounds of score
    Score(index) = 0;
    index = Score > 1;
    Score(index) = 1;
    % NORMALIZE THE SCORE (0 <= score <= 1)
%
%========================================================================
if isnan(Score)
    Score =0;
    Feedback = [Feedback,'   Your code returned NaN.'];
end
    
end
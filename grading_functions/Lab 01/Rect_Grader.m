function [score, Feedback] = Rect_Grader(filename,finalGrade)

%--------------------------------------------------------------
% FILE: FBC_Grader.m
% AUTHOR: Douglas Cook 
% DATE: 2/6/2018
% 
% PURPOSE: Function for grading Lab 4, part I: Trapezoidal integration.
%
% INPUTS: 
% a filename corresponding to a student's code
% finalGrade - final grading flag
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

disp(filename)
    
    try
        % save state in case student runs "clear" in their function
        f = filename(1:end-2); % get function name
        %save('gradingvars.mat'); % CALEB - I may be wrong, but I don't think we need this for functions.

        % Input Data and solution for testing student code
        if finalGrade
            x = 3:1:13;
            y = [0 2 0 4 0 8 0 4 0 2 0];    % A sawtooth function with increasing height.
            Solution = [20];   %#ok<*NBRAK> % Obtained by sum(y)
        else
            x = 0:1:10; %#ok<*NASGU>
            y = [0 1 0 2 0 3 0 4 0 5 0];    % A sawtooth function with increasing height.
            Solution = [15];   % Obtained by sum(y)
        end
        
        % Call student code---------------------------------------------------------- 
        eval(['[I] = ',f,'(x,y);'])    % evaluate the function
        % load('gradingvars.mat'); % CALEB - I may be wrong, but I don't think we need this for functions.
      
        % GRADING SECTION------------------------------------------------------------
        
        if length(I) == 1
            score = 1 - abs((I-Solution)/Solution);
            if finalGrade
                if I < (Solution - 0.1) || I > (Solution + 0.1)
                    Feedback = ['Your code produced an answer with a percent error of ', num2str((1-score)*100), '%'];
                else
                    Feedback = 'Your code calculated the correct value of the integral';
                end
            else
                if I < (Solution - 0.1) || I > (Solution + 0.1)
                    Feedback = ['The test function has an integral of ', num2str(Solution),'. Your code produced: ',num2str(I)];
                else
                    Feedback = 'Your code calculated the correct value of the integral';
                end
            end
        else
            score = 0;
            Feedback = ['Your result was not a scalar, but a vector of length ',num2str(length(I))];
        end
        
        index = score < 0;
        score(index) = 0;
        index = score > 1;
        score(index) = 1;
        % NORMALIZE THE SCORE (0 <= score <= 1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    catch ERR
        % store error messages and zero scores if the code doesn't run.   
        %load('gradingvars.mat'); % re-load grading script data and variables
        score = 0; % give score of 0
        errormessage = regexprep(ERR.message,'[\n\r]+','  ');  % strip newline characters from the error message
        Feedback = ['Score 0 because code failed. MATLAB Error Message: ',errormessage];
    end
    
end
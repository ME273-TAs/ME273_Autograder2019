function [score, Feedback] = Simpson13_Grader(filename)

%--------------------------------------------------------------
% FILE: Simpson13_Grader.m
% AUTHOR: Douglas Cook 
% DATE: 2/6/2018
% 
% PURPOSE: Function for grading Lab 4, part II: Simpson's 1/3 integration.
%
% INPUTS: 
% a filename corresponding to a student's code
% 
% 
% OUTPUT: 
% score - a scalar between 0 and 1
% Feedback - a character array of feedback, containing grades breakdown.
%
% 
% VERSION HISTORY
% V1 - This version.
% V2 - 
% V3 - 
% 
%--------------------------------------------------------------

ErrorMessage = '';
    
    %% PART I - testing the integration functionality
    try
        % save state in case student runs "clear" in their function
        f = filename(1:end-2); % get function name

        % Input Data and solution for testing student code
        x = linspace(0,pi,5);
        y = sin(x);    % A sine function from 0 to pi in 10 increment (11 data points).
        Solution = 2.004559754984421;   % Obtained by I = Simpson13_2087(x,y)
        
        % Call student code---------------------------------------------------------- 
        eval(['[I] = ',f,'(x,y);'])    % evaluate the function

        % GRADING SECTION------------------------------------------------------------
        
         if length(I) == 1                  % the result should be a scalar: length == 1
            if abs(I-Solution) > 0.001      % if the solution is outside of tolerance, the implementation was flawed in some way.
                score = (1 - abs((I-Solution)/Solution))*0.80;      % 20% penalty for flawed implementation.
                Feedback = ['The solution to the test case was 2.004. Your code produced: ',num2str(I),', indicating an error in your implementation.'];
            else
                score = 1 - abs((I-Solution)/Solution);     % The score will be essentially 1 at this point.
                Feedback = 'None';                          % No feedback required for a correct solution.
            end
        else
            score = 0;                      % Some students' code produces a vector instead of a scalar. They get zero and a message.
            Feedback = ['Your result was not a scalar, but a vector of length ',num2str(length(I))];
        end
        
        index = score < 0;      % insuring that scores are not less than 0
        score(index) = 0;
        index = score > 1;      % ... or greater than 1.
        score(index) = 1;
        % NORMALIZE THE SCORE (0 <= score <= 1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    catch ERR
        % store error messages and zero scores if the code doesn't run.   
        %load('gradingvars.mat'); % re-load grading script data and variables
        score = 0; % give score of 0
        errormessage = regexprep(ERR.message,'[\n\r]+','  ');   % strip newline characters from the error message
        Feedback = ['Score 0 because code failed. MATLAB Error Message: ',errormessage];
        ErrorMessage = ERR.message;          % Save the error message for later use (see below)
    end
    
    score1 = score;             % assigning score1 to be the score of the first part
    Feedback1 = Feedback;       % ditto for Feedback
    
    %% PART II - testing the error message functionality 
    try
        % save state in case student runs "clear" in their function
        f = filename(1:end-2); % get function name
        %save('gradingvars.mat'); % CALEB - I may be wrong, but I don't think we need this for functions.

        % Input Data and solution for testing student code
        x = linspace(0,pi,6);
        y = sin(x);    % A sine function from 0 to pi in 10 increment (11 data points).
        Solution = 2.004559754984421;   % Obtained by I = Simpson13_2087(x,y)
        
        % Call student code---------------------------------------------------------- 
        eval(['[I] = ',f,'(x,y);'])    % evaluate the function
        % load('gradingvars.mat'); % CALEB - I may be wrong, but I don't think we need this for functions.
      
        % GRADING SECTION------------------------------------------------------------
        
        
        % In this case, the code SHOULD have thrown an error. If it doesn't, the
        % student gets a penalty and a feedback message.
        score = (1 - abs((I-Solution)/Solution))*0.8;
        Feedback = ['When an ODD number of segments were used, your code produced an integral of ',num2str(I), ' - it should have produced an error message instead.' ];
        
        catch ERR
            
            if strcmp(ERR,ErrorMessage)==1      % If both approaches produce the same error, the student's code is flawed.
                score = 0;
                Feedback = 'Your code failed to run. See previous error message.';
            else                                % This is what should have happened. Student gets full credit and a nice message.
                score = 1;  
                Feedback = ['The error message functionality was successful.'] ;
            end
                
        
        
       
        
        
    end
  
    
    index = score < 0;      % Checking the bounds of score
    score(index) = 0;
    index = score > 1;
    score(index) = 1;
    % NORMALIZE THE SCORE (0 <= score <= 1)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    score2 = score;             % score2 is the second score
    Feedback2 = Feedback;       % ditto for Feedback
    
    %% PART III - Combining Scores
    score = mean([score1,score2]);  % the final score is the average of the two parts.
    score1 = round(score1*100);     % Convert individual scores to a percentage and round.
    score2 = round(score2*100);     
    
    Feedback = ['Integration score: ',num2str(score1),'. Integration Feedback: ', Feedback1, '   -   Error message score: ',num2str(score2),'. Error message feedback: ', Feedback2];
    

    
end
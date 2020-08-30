function [Score, Feedback] = AdaptiveInt_Grader(filename,finalGrade)

%--------------------------------------------------------------
% FILE: AdaptiveInt_Grader.m
% AUTHOR: Jared Oliphant
% DATE: 1/15/2019
%
% PURPOSE: Function for grading Lab 02, part 04: AdaptiveInt
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
    x = linspace(2,3,6);  % 5 segments, probably should do some combination of 1/3 and 3/8
    y = sinh(x);
    %     3/8 then 1/3        OR   1/3 then 3/8
    %     I = 6.305555055682230   6.305571545250893
    Solution = 6.3055;   % Obtained using _____________
    trapzSolution = 6.326470526;   % if trapezoid is used the whole way
    %=================================================
    
    
    
    %================================================================================
    % Running student code
    CallingString = ['[I] = ',StudentFunction,'(x,y);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================
    
    
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    %
    if length(I) == 1                  % the result should be a scalar: length == 1
        if abs(I-Solution) > 0.01      % if the solution is outside of tolerance, the implementation was flawed in some way.
            score = (1 - abs((I-Solution)/Solution))*0.80;      % 20% penalty for flawed implementation.
            Feedback = ['Test 1:  The solution to the test case was 6.3055. Your code produced: ',num2str(I),', indicating an error in your implementation.'];
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
    Score = score;
    
    
    %
    %==================================================
    
    
    %====================================================================================
    % ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERR
    
    %==============================================================
    % Zero score if the code doesn't run:
    Score = 0;      % give score of 0
    % An explanation of the zero score and the MATLAB error message.
    errormessage = regexprep(ERR.message,'[\n\r]+','  ');   % strip newline characters from the error message
    Feedback = ['Score 0 because code failed. MATLAB Error Message: ',errormessage];
    %==============================================================
    
    
    
end


score1 = Score;
feedback1 = Feedback;

if isnan(score1)
    score1 = 0;
    feedback1 = strcat(feedback1,"    Your code return NaN");
end

% TEST 2
%=================================================|
%=================================================|
try
    
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    x = linspace(2,3,7);  % 6 segments, can do 1/3 or 3/8 the whole way
    y = tanh(x);
    %     1/3 all the way or 3/8 all the way (both work)
    %
    % I = 0.984324847043404   0.984323723979905
    Solution = 0.98432;   % Obtained using _____________
    trapzSolution = 0.984185280483955;   % if trapezoid is used the whole way
    %=================================================
    
    
    
    %================================================================================
    % Running student code
    CallingString = ['[I] = ',StudentFunction,'(x,y);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================
    
    
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    %
    if length(I) == 1                  % the result should be a scalar: length == 1
        if abs(I-Solution) > 0.01      % if the solution is outside of tolerance, the implementation was flawed in some way.
            score = (1 - abs((I-Solution)/Solution))*0.80;      % 20% penalty for flawed implementation.
            Feedback = ['Test 2:  The solution to the test case was 0.9843. Your code produced: ',num2str(I),', indicating an error in your implementation.'];
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
    Score = score;
    %
    %==================================================
    
    
    %====================================================================================
    % ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERR
    
    %==============================================================
    % Zero score if the code doesn't run:
    Score = 0;      % give score of 0
    % An explanation of the zero score and the MATLAB error message.
    errormessage = regexprep(ERR.message,'[\n\r]+','  ');   % strip newline characters from the error message
    Feedback = ['Score 0 because code failed. MATLAB Error Message: ',errormessage];
    %==============================================================
    
    
    
end


score2 = Score;
feedback2 = Feedback;


%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE.
% Note: Final score must between 0 and 1.

Score = mean([score1, score2]);
Feedback = strcat("Test 1: ",feedback1,"Test 2: ",feedback2);

%========================================================================



end
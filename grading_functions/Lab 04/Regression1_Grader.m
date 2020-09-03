function [Score, Feedback] = Regression1_Grader(filename,finalGrade)

%--------------------------------------------------------------
% FILE: Regression1_Grader.m
% AUTHOR: Jared Oliphant
% DATE: 12 Feb 2018
%
% PURPOSE: Function for grading Lab 5, part 1: Linear regression
% coefficients, error vector, and r2 value.
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
    %=================================================
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    %dataset
    x =[0.02; 0.19; 1.85;  2.57; 3.51;  4.03;  4.04; 4.08; 4.84];
    y =[0.01; 0.18; 1.26; 1.95;  2.98; 3.00;  3.03;  3.19; 4.64];
    x = x';
    y = y';
    %[b,r2,e] = Regression1_6661(x,y)
    % Obtained using Regression1_6661.m and confirmed with polyfit(x,y,1)
    % and fitlm(x,y)   (polyfit gives slope then intercept, but lab handout
    % says to put it in the intercept then slope order)
    Solution_b = [-0.124911249561817  0.850147283965633];      %intercept then slope (a0, a1)
    Solution_r2 = 0.961880351728390;
    Solution_e = [ 0.117908303882504;
        0.143383265608346;
        -0.187861225774604;
        -0.109967270229859;
        0.120894282842447;
        -0.301182304819683;
        -0.279683777659339;
        -0.153689669017965;
        0.650198395168155];
    %================================================
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = ['[Stud_b,Stud_r2,Stud_e] = ',StudentFunction,'(x,y);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    Stud_b = Stud_b(:)'; % ensure it is a row vector like the solution
    Stud_e = Stud_e(:);    % ensure it is a column vector like the solution (if a matrix is returned this will reshape it into a long row)
    %================================================================================
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    
    % check the b vector
    if length(Stud_b) == 2
        if abs(Stud_b(2)-Solution_b(1)) < .0001
            scoreb1 = .9*(1 - abs((Stud_b(1)-Solution_b(2))/Solution_b(2)));     % 10% reduction for flipped vector
            scoreb2 = .9*(1 - abs((Stud_b(2)-Solution_b(1))/Solution_b(1)));
            feedbackb = 'Your b vector came out in the order [a1 a0] when it should have been [a0 a1], see lab handout.';
        else
            scoreb1 = 1 - abs((Stud_b(1)-Solution_b(1))/Solution_b(1));   %penalized by how far off from solution
            scoreb2 = 1 - abs((Stud_b(2)-Solution_b(2))/Solution_b(2));
            feedbackb = 'none.';
        end
    else
        scoreb1 = 0;
        scoreb2 = 0;
        feedbackb = 'Your b vector was not the proper length';
    end
    
    index = scoreb1 < 0;      % Checking the bounds of score
    scoreb1(index) = 0;
    index = scoreb1 > 1;
    scoreb1(index) = 1;
    
    index = scoreb2 < 0;      % Checking the bounds of score
    scoreb2(index) = 0;
    index = scoreb2 > 1;
    scoreb2(index) = 1;
    
    
    % check the r2 value
    if length(Stud_r2) == 1
        scorer2 = 1 - abs((Stud_r2-Solution_r2)/Solution_r2);
        feedbackr2 = ['Your r^2 value came out as ',num2str(Stud_r2),' and the correct answer was ',num2str(Solution_r2)];
    else
        scorer2 = 0;
        feedbackr2 = 'Your r^2 output had more than one element in it';
    end
    
    index = scorer2 < 0;      % Checking the bounds of score
    scorer2(index) = 0;
    index = scorer2 > 1;
    scorer2(index) = 1;
    
    
    % check the e vector
    if length(Stud_e) == 9
        echeck = abs(Solution_e - Stud_e) < .0001;
        scoree = 1 - .1*(9-nnz(echeck));                  % if all 9 errors are wrong should get .1 (10%)
        feedbacke = [num2str(nnz(echeck)),' out of 9 of your error vector were accurate.'];
    else
        scoree = 0 ;
        feedbacke = 'The length of your e vector should be the same as the length of the input data. In your case, it wasn''t.';
    end
    
    index = scoree < 0;      % Checking the bounds of score
    scoree(index) = 0;
    index = scoree > 1;
    scoree(index) = 1;
    %
    
    
    % average all scores together and concatenate Feedback
    Score =( scoreb1 + scoreb2 + scorer2 + scoree ) / 4;   %average the 4 scores
    S1 = num2str(round(100*((scoreb1 + scoreb2)/2)));
    S2 = num2str(round(100*(scorer2)));
    S3 = num2str(round(100*(scoree)));
    Feedback = ['Regression coefficient score:  ',S1,'  Regression coefficient feedback:  ',...
        feedbackb,'  R^2 score:  ',S2,'  R^2 feedback  ',feedbackr2,'  Error vector score:  ',S3,...
        '  Error vector feedback  ',feedbacke];
    
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

index = Score < 0;     % Checking the bounds of score
Score(index) = 0;
index = Score > 1;
Score(index) = 1;
% NORMALIZE THE SCORE (0 <= score <= 1)
%
%========================================================================


end
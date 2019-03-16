function [Score, Feedback] = RegressionN_Grader(filename)

%--------------------------------------------------------------
% FILE: RegressionN_Grader.m
% AUTHOR: Jared Oliphant
% DATE: 12 Feb 2018
%
% PURPOSE: Function for grading Lab 5, part 2: Nth order regression
% coefficients, error vector, and r2 value.
% Two tests are performed with the same dataset. 3rd order and a 7th order
% regression. The for the high order case, the tolerance for e vector is
% bigger and we only look at one of the values of the vector b.
% The first test will run with coloumn vector inputs and the second will be
% a row vector
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
    StudentFunction = filename(1:end-2);   % get function name     |
    %=================================================|
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    %dataset
    x =[0.02  0.14  0.19  1.26  1.95  2.98  3.04  3.20  4.65];
    y =[-19.89  -0.63  -0.18   2.02   4.68  14.14  20.23  44.89  66.01];
    x = x';
    y = y';    % feed in column vectors
    %[b,r2,e] = RegressionN_6661(x,y,3)
    % Obtained using RegressionN_6661.m (3rd order) and confirmed with polyfit(x,y,3)
    % (polyfit gives reverse order from RegressionN function)
    Solution_b = [-8.081643230677821;
        5.479010132917747;
        0.826503727638483;
        0.317756606816676];      % (a0, a1, a2, a3)
    Solution_r2 = 0.882782038324157;
    Solution_e = [ -11.918270115524443;
        6.667510414878517;
        6.828615028289545;
        1.250300455085089;
        -3.421332472826917;
        -9.854471866438779;
        -4.909965973709195;
        16.563164142154122;
        -1.205549611907941];
    %=================================================
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = ['[Stud_b,Stud_r2,Stud_e] = ',StudentFunction,'(x,y,3);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    Stud_b = Stud_b(:);  % ensure it is a column like the solution
    Stud_e = Stud_e(:);  % ensure it is a column like the solution
    %================================================================================
    %==================================================
    % GRADING SECTION - evaluate student work here.
    
    % check for NaN values that occur if the student did something weird...
    if nnz(isnan(Stud_b)) || nnz(isnan(Stud_r2)) || nnz(isnan(Stud_e))
        Score = 0;
        Feedback = 'Result contained NaN values';
        return
    end
    
    if length(Stud_b) == 4
        scoreb1 = 1 - abs((Stud_b(1)-Solution_b(1))/Solution_b(1));   %penalized by how far off from solution
        scoreb2 = 1 - abs((Stud_b(2)-Solution_b(2))/Solution_b(2));
        scoreb3 = 1 - abs((Stud_b(3)-Solution_b(3))/Solution_b(3));
        scoreb4 = 1 - abs((Stud_b(4)-Solution_b(4))/Solution_b(4));
        feedbackb = 'none.';
    else
        feedbackb = 'b vector not right length; cannot evaluate it.';
        scoreb1 = 0;
        scoreb2 = 0;
        scoreb3 = 0;
        scoreb4 = 0;
    end
    
    if length(Stud_r2) ~= 1
        scorer2 = 0;
        feedbackr2 = ['Your r^2 value has more than one value it it, cannot evaluate it'];
    else
        scorer2 = 1 - 10*abs((Stud_r2-Solution_r2)/Solution_r2);
        feedbackr2 = ['Your r^2 value came out as ',num2str(Stud_r2),' and the correct answer was ',num2str(Solution_r2),'.'];
    end
    
    index = scorer2 < 0;      % Checking the bounds of score
    scorer2(index) = 0;
    index = scorer2 > 1;
    scorer2(index) = 1;
    
    if length(Stud_e) == 9
        echeck = abs(Solution_e - Stud_e) < .000001;
        scoree = 1 - .1*(9-nnz(echeck));                  % if all 9 errors are wrong should get .1 (10%)
        feedbacke = [num2str(nnz(echeck)),' out of 9 of your error vector were accurate.'];
    else
        scoree = 0 ;
        feedbacke = 'The length of your e vector should be the same as the length of the input data. In your case, it wasn''t.';
    end
    
    
    %average all
    Score =( scoreb1 + scoreb2  + scoreb3 + scoreb4 + scorer2+ scoree ) / 6;
    S1 = num2str(round(100*((scoreb1 + scoreb2 + scoreb3 + scoreb4)/4)));
    S2 = num2str(round(100*(scorer2)));
    S3 = num2str(round(100*(scoree)));
    Feedback = ['Regression coefficient score:  ',S1,'  Regression coefficient feedback:  ',...
        feedbackb,'  R^2 score:  ',S2,'  R^2 feedback  ',feedbackr2,'  Error vector score:  ',S3,...
        '  Error vector feedback  ',feedbacke];
    %
    %==================================================
    
    
    %====================================================================================
    % ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR
    
    %==============================================================
    % Zero score if the code doesn't run:
    Score = 0;      % give score of 0
    % An explanation of the zero score and the MATLAB error message.
    Feedback = regexprep(ERROR.message,'\n',' ');
    Feedback = [Feedback,'   Your code likely could not handle column vectors, see lab handout'];
    %==============================================================
    
    
    
end     %first iteration of check (3rd order)

Score1 = Score;     %ditto the score and feedback from first test.
Feedback1 = Feedback;

%======================================================
%This will use the same data for a much higher polynomial
%Just going to check one value of the b, instead of the whole vector
% the TRY/CATCH structure is used to prevent code crashes
try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================|
    StudentFunction = filename(1:end-2);    % get function name     |
    %=================================================|
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    %same dataset
    x =[0.02  0.14  0.19  1.26  1.95  2.98  3.04  3.20  4.65];
    y =[-19.89  -0.63  -0.18   2.02   4.68  14.14  20.23  44.89  66.01];
    x = x;
    y = y;    % feed in row vectors
    %[b,r2,e] = RegressionN_6661(x,y,7)
    % Obtained using RegressionN_6661.m (7th order) and confirmed with polyfit(x,y,7)
    % (polyfit gives reverse order from RegressionN function)
    Solution_b = [-25.657838448543;
        319.747788189500;
        -1277.406838463322;
        1881.781410367059;
        -1290.135462901733;
        446.195367681970;
        -75.396728608391;
        4.943100333726];      % (a0, a1, a2, a3, a4, a5, a6, a7, a8)
    Solution_r2 = 0.999490038623766;
    Solution_e = [  -0.131003832476267;
        0.608897419219856;
        -0.492655165862412;
        0.040778200601455;
        -0.052376006940626;
        0.919207068178949;
        -1.124840540689110;
        0.232246213222098;
        -0.000253354994342];
    %=================================================
    
    
    
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = ['[Stud_b,Stud_r2,Stud_e] = ',StudentFunction,'(x,y,7);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    Stud_b = Stud_b(:);  % ensure it is a column like the solution
    Stud_e = Stud_e(:);  % ensure it is a column like the solution
    %================================================================================
    
    
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    
    % check for NaN values that occur if the student did something weird...
    if nnz(isnan(Stud_b)) || nnz(isnan(Stud_r2)) || nnz(isnan(Stud_e))
        Score = 0;
        Feedback = 'Result contained NaN values';
        return
    end
    
    if length(Stud_b) == 8
        scoreb = 1 - abs((Stud_b(5)-Solution_b(5))/Solution_b(5));   %just checking the 5th value of b
        feedbackb = 'none.';
    else
        feedbackb = 'b vector not right length; cannot evaluate it.';
        scoreb = 0;
    end
    
    index = scoreb < 0;      % Checking the bounds of score
    scoreb(index) = 0;
    index = scoreb > 1;
    scoreb(index) = 1;
    
    
    if length(Stud_r2) ~= 1
        scorer2 = 0;
        feedbackr2 = 'Your r^2 value has more than one value it it, cannot evaluate it';
    else
        scorer2 = 1 - 10*abs((Stud_r2-Solution_r2)/Solution_r2);
        feedbackr2 = ['Your r^2 value came out as ',num2str(Stud_r2),' and the correct answer was ',num2str(Solution_r2),'.'];
    end
    
    index = scorer2 < 0;      % Checking the bounds of score
    scorer2(index) = 0;
    index = scorer2 > 1;
    scorer2(index) = 1;
    
    if length(Stud_e) == 9
        echeck = abs(Solution_e - Stud_e) < .01;   %bigger error margin for the higher order case
        scoree = 1 - .1*(9-nnz(echeck));                  % if all 9 errors are wrong should get .1 (10%)
        feedbacke = [num2str(nnz(echeck)),' out of 9 of your error vector were accurate.'];
    else
        scoree = 0 ;
        feedbacke = 'The length of your e vector should be the same as the length of the input data. In your case, it wasn''t.';
    end
    
    
    %average all
    Score =( scoreb + scorer2+ scoree ) / 3;
    %concantinate
    S1 = num2str(round(100*(scoreb)));
    S2 = num2str(round(100*(scorer2)));
    S3 = num2str(round(100*(scoree)));
    Feedback = ['Regression coefficient score:  ',S1,'  Regression coefficient feedback:  ',...
        feedbackb,'  R^2 score:  ',S2,'  R^2 feedback  ',feedbackr2,'  Error vector score:  ',S3,...
        '  Error vector feedback  ',feedbacke];
    
    %
    %==================================================
    
    %====================================================================================
    % ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR
    
    %==============================================================
    % Zero score if the code doesn't run:
    Score = 0;      % give score of 0
    % An explanation of the zero score and the MATLAB error message.
    Feedback = regexprep(ERROR.message,'\n',' ');
    Feedback = [Feedback,'   Your code likely could not handle row vectors, see lab handout'];
    %==============================================================
    
end

Score2 = Score;    % ditto score
Feedback2 = Feedback;


%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE.
% Note: Final score must between 0 and 1.
if Score2 == 0   % the code failed for row vectors
    Score2 = Score1*.85;    % 15% penalty
elseif Score1 == 0  &&  Score2 ~= 0    % the code failed for column vectors but worked for row vectors
    Score1 = Score2*.85;
end

Score = (Score1 + Score2)/2;   %Average scores from two tests
Feedback = ['TEST 1: Column vectors 3rd order   ---  ',Feedback1,'   TEST 2: Row vectors 7th order  ---   ',Feedback2];
index = Score < 0;      % Checking the bounds of score
Score(index) = 0;
index = Score > 1;
Score(index) = 1;
% NORMALIZE THE SCORE (0 <= score <= 1)
%
%========================================================================


end
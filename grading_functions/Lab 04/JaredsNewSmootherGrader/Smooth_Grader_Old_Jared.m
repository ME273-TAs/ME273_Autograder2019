function [Score, Feedback] = Smooth_Grader_Old_Jared(filename)

%--------------------------------------------------------------
% FILE: Smoother_Grader.m   
% AUTHOR: Jared Oliphant
% DATE: 4 Feb 2019
% 
% PURPOSE: Function for grading Lab 4, part 3: Smoother
% smoothed vector, error vector, and r2 value. 
% 1st test will use a relatively small w and the second will be a large w
% in relation to the length of x and y. Highest value of p will be 2 to
% avoid issues with singular matrices on the caps.
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
    %=================================================|
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    %dataset
    x = linspace(0,3,10);
    % y = -exp(x).*sin(x) + normrnd(0,0.08,1,length(x));
    y = [    0.088575939633936
              -0.471484192945957
              -1.294133340400155
              -2.267639325866914
              -3.562326633612929
              -5.365907265640429
              -6.738237319667626
              -7.376262278069276
              -6.734639339561600
              -2.784435470130140]';
     p = 2;
     w = 4;
   %[ys,e] = Smoother_XXXX(x,y,p,w)
    Solution_ys = [    0.088575939633936
                  -0.471484192945957
                  -1.269957055160574
                  -2.344051749563746
                  -3.921871698107942
                  -5.597227919040316
                  -6.876544134641003
                  -7.503427155160473
                  -6.734639339561610
                  -2.784435470130140]';% smoothed vector (row)
    Solution_e = [             0
              0.000000000000000
              -0.024176285239581
               0.076412423696832
               0.359545064495014
               0.231320653399887
               0.138306814973377
               0.127164877091198
               0.000000000000011
                               0]';   % error vector (row)
    %=================================================
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = ['[Stud_ys,Stud_e] = ',StudentFunction,'(x,y,p,w);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    % ensure student solution is appropiate dimension
    Stud_ys = Stud_ys(:)';
    Stud_e = Stud_e(:)';
    %================================================================================
    %==================================================
    % GRADING SECTION - evaluate student work here.
    if length(Stud_ys) == length(Solution_ys)
        yscheck = abs(Solution_ys - Stud_ys) < .001;
        scoreys = 1 - .05*(length(x) - nnz(yscheck));
        feedbackys = [num2str(nnz(yscheck)),' out of ',num2str(length(x)),' of your smooth vector were accurate.'];
    else
        scoreys = 0; 
        feedbackys = 'Your ys vector is not the right length';
    end
    
    index = scoreys < 0;      % Checking the bounds of score
    scoreys(index) = 0;
    index = scoreys > 1;
    scoreys(index) = 1;
    
    
    if length(Stud_e) == length(Solution_e)
        echeck = abs(Solution_e - Stud_e) < .001;
        scoree = 1 - .02*(length(Solution_e)-nnz(echeck));                  % if all 9 errors are wrong should get .1 (10%)
        feedbacke = [num2str(nnz(echeck)),' out of ',num2str(length(Solution_e)),' of your error vector were accurate.' ];
    else
        scoree = 0;
        feedbacke = 'Your e vector is not the right length';
    end
    
    
    index = scoree < 0;      % Checking the bounds of score
    scoree(index) = 0;
    index = scoree > 1;
    scoree(index) = 1;
    
    
    %average all 
    Score =(scoreys + scoree) / 2;
    S1 = num2str(round(100*(scoreys)));
    S2 = num2str(round(100*(scoree)));
    Feedback = ['Smoothed vector score:  ',S1,'  Smoothed vector feedback:  ',...
    feedbackys,'  Error vector score:  ',S2,...
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
    %==============================================================
    
   
    
end     %first iteration of check (3rd order) 


end
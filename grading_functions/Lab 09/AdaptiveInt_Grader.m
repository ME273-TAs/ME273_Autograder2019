function [Score, Feedback] = AdaptiveInt_Grader(filename,finalGrade)
%--------------------------------------------------------------
% FILE: AdaptiveInt_Grader.m (FOR C++ VERSION OF THIS ASSIGNMENT)
% AUTHOR: Jared Oliphant
% DATE: 3/15/2019
%
% PURPOSE: a grader file that will allow you compile and run .cpp files
% within MATLAB; Other than that it is essentially the same as the previous
% AdaptiveInt Grader for MATLAB
%
% INPUTS:
% a filename corresponding to a student's code
%   finalGrade - final grading flag
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
% Get everything ready
grade_dir = 'grading_directory';  % needed for writing and reading the files
Feedback = '';
Score = 0; % initialize the Score at zero
f = filename(1:end-4);   % take off .cpp
StudentID = f(end-3:end); % get the numbers out
cpp_file = [f,'.cpp'];    % name of .cpp file
exe_file = [f,'.exe'];    % name of .exe file


% create the dataset that will be read in by the c++ function
% (same data as the MATLAB version)
x = linspace(2,3,6);  % 5 segments, probably should do some combination of 1/3 and 3/8
y = sinh(x);
%     3/8 then 1/3        OR   1/3 then 3/8
%     I = 6.305555055682230   6.305571545250893
Solution = 6.3055;   % Obtained using _____________
% trapzSolution = 6.326470526;   % if trapezoid is used the whole way


% write out the comma delimited file without a newline character at the
% end to make it easy to read in to c++
data = [x', y'];   % two column data
dlmwrite_without_final_newline(fullfile(grade_dir,'Int_data.txt'),data,[],',');


% attempt to compile the .cpp into a .exe with the same name using the
% g++ compiler
[compile_status, compile_OUT] = system(['g++ ', ...
    fullfile(grade_dir,cpp_file),' -o ', ...
    fullfile(grade_dir,exe_file),' -std=c++11']);

% compile_status will return 0 if no errors occurred
if compile_status == 0
    
    % attempt to run the newly compiled .exe file
    [run_status, run_OUT] = system(['cd grading_directory && timeout 10 ./',exe_file,' && cd ..']);
    
    % if the run didn't throw any errors
    if run_status == 0
        % if the .exe run threw no errors the student should have produced a
        % file named Int_XXXX.txt
        % read it in and use it as their solution
        try
            resultFile = fullfile(grade_dir,['Int_',StudentID,'.txt']);
            I = load(resultFile);  % should be a single scalar value
            
            
            %==================================================
            % GRADING SECTION - evaluate student work here.
            if length(I) == 1                  % the result should be a scalar: length == 1
                if abs(I-Solution) > 0.01      % if the solution is outside of tolerance, the implementation was flawed in some way.
                    score = (1 - abs((I-Solution)/Solution))*0.80;      % 20% penalty for flawed implementation.
                    Feedback = ['Test 1:  The solution to the test case was 6.3055. Your code produced: ',num2str(I),', indicating an error in your implementation.'];
                else
                    score = 1 - abs((I-Solution)/Solution);     % The score will be essentially 1 at this point.
                    Feedback = 'None';                          % No feedback required for a correct solution.
                end
            else
                score = 0;         % Some students' code produces a vector instead of a scalar. They get zero and a message.
                Feedback = ['Your result was not a scalar, but a vector of length ',num2str(length(I))];
            end
            
            index = score < 0;      % insuring that scores are not less than 0
            score(index) = 0;
            index = score > 1;      % ... or greater than 1.
            score(index) = 1;
            Score = score;
            
            
        catch ERR
            % if the student didn't write out a file as instructed
            Feedback = regexprep(ERR.message,'[\n\r]+','  ');
        end
        
    elseif run_status == 124
        Feedback = ['Runtime Error: Your code did not complete in 10 seconds which likely indicates an infinite while loop, or some other error.'];
        
    else 
        % the run of their code didn't complete right; run_OUT should
        % contain an error description
        Feedback = ['Test 1 Runtime Error: ',regexprep(run_OUT,'[\n\r]+',' ')];

        % no return (let them attempt to run again for TEST 2)
    end
    
else
    %compile_OUT should contain the compile error here
    Feedback = ['Compile Error: ',regexprep(compile_OUT,'[\n\r]+',' ')];
    % clean up
    delete(fullfile(grade_dir,'*.exe'))  % delete all .exe files when finished with them
    delete(fullfile(grade_dir,'Int_data.txt')) % delete the input file just in case
    
    if length(Feedback) > 2000
        Feedback = [Feedback(1:2000),'  OUTPUT TRUNCATED'];
    end
    return;   % don't need to do TEST 2 is compile failed
end



% score and feedback for TEST 1
score1 = Score;
feedback1 = Feedback;

if isnan(score1)
    score1 = 0;
    feedback1 = strcat(feedback1,'    Your code returned NaN');
end



% clean up
try
    delete(resultFile) % delete the generated .txt file
    delete(fullfile(grade_dir,'Int_data.txt')) % delete the input file just in case
catch DELERR
    disp(DELERR.message)
end



% TEST 2
%=================================================|
%=================================================|
% create the dataset that will be read in by the c++ function
% (same data as the MATLAB version)
x = linspace(2,3,7);  % 6 segments, can do 1/3 or 3/8 the whole way
y = tanh(x);
%     1/3 all the way or 3/8 all the way (both work)
%
% I = 0.984324847043404   0.984323723979905
Solution = 0.98432;   % Obtained using _____________
% trapzSolution = 0.984185280483955;   % if trapezoid is used the whole way


% write out the comma delimited file without a newline character at the
% end to make it easy to read in to c++
data = [x', y'];   % two column data
dlmwrite_without_final_newline(fullfile(grade_dir,'Int_data.txt'),data,[],',');


% don't need to compile again..
% attempt to run the compiled .exe file AGAIN with new data inputs
[run_status, run_OUT] = system(['cd grading_directory && timeout 10 ./',exe_file,' && cd ..']);

% if the run didn't throw any errors
if run_status == 0
    % if the .exe run threw no errors the student should have produced a
    % file named Int_XXXX.txt
    % read it in and use it as their solution
    try
        resultFile = fullfile(grade_dir,['Int_',StudentID,'.txt']);
        I = load(resultFile);  % should be a single scalar value
        
        
        %==================================================
        % GRADING SECTION - evaluate student work here.
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
        
        
    catch ERR
        % if the student didn't write out a file as instructed
        Feedback = regexprep(ERR.message,'[\n\r]+',' ');
    end
    
elseif run_status == 124
    Feedback = ['Runtime Error: Your code did not complete in 10 seconds which likely indicates an infinite while loop, or some other error.'];
          
else
    % the run of their code didn't complete right; run_OUT should
    % contain an error description
    Feedback = ['Test 2 Runtime Error: ',regexprep(run_OUT,'[\n\r]+',' ')];
end



% score and feedback for TEST 2
score2 = Score;
feedback2 = Feedback;

if isnan(score2)
    score2 = 0;
    feedback2 = strcat(feedback2,'    Your code return NaN');
end



%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE.
% Note: Final score must between 0 and 1.

Score = mean([score1, score2]);
Feedback = strcat('Test 1: ',feedback1,'Test 2: ',feedback2);

%========================================================================



% clean up
try
    delete(fullfile(grade_dir,'*.exe'))  % delete all .exe files when finished with them
    delete(fullfile(grade_dir,'Int_data.txt')) % delete the input file just in case
    delete(resultFile)  % delete the generated .txt file
catch DELERR
    disp(DELERR.message)
end


if length(Feedback) > 2000
    Feedback = [Feedback(1:2000),'  OUTPUT TRUNCATED'];
end


end





function dlmwrite_without_final_newline(YourFileName, YourMatrix, precision, delimiter)
%write numeric data out in delimited format, but with
%no end-of-line character on the last line
%* YourFileName - name of file
%* YourMatrix - numeric array of data
%* precision - format to write data with, or empty; default is '%.15g'
%* delimiter - delimiter to use between fields, or empty; default is ','
if ~exist('precision', 'var') || isempty(precision)
    precision = '%.15g';
end
if ~exist('delimiter', 'var') || isempty(delimiter)
    delimiter = ',';
end
cols = size(YourMatrix,2);
last_line_fmt = [repmat([precision delimiter], 1, cols-1), precision];
line_fmt = [last_line_fmt '\n'];
[fid, message] = fopen(YourFileName, 'w');
if fid < 0
    error('Failed to open file "%s" because "%s"', YourFileName, message);
end
fprintf(fid, line_fmt, YourMatrix(1:end-1, :).' );  %transpose is important here
fprintf(fid, last_line_fmt, YourMatrix(end,:) );
fclose(fid);
end
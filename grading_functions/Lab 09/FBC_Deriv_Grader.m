function [Score, Feedback] = FBC_Deriv_Grader(filename,finalGrade)
%--------------------------------------------------------------
% FILE: FBC_Deriv_Grader.m (FOR C++ VERSION OF THIS ASSIGNMENT)
% AUTHOR: Jared Oliphant
% DATE: 3/15/2019
%
% PURPOSE: a grader file that will allow you compile and run .cpp files
% within MATLAB; Other than that it is essentially the same as the previous
% FBC_Deriv Grader for MATLAB
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
x = 0:0.5:2;    % x pts.
y = 8.5*x.^2-3.466*x;       % derivative will be the same regardless how they did it
data = [x', y'];   % two column data

% write out the comma delimited file without a newline character at the 
% end to make it easy to read in to c++
dlmwrite_without_final_newline(fullfile(grade_dir,'FBC_data.txt'),data,[],',');
dlmwrite_without_final_newline(fullfile(grade_dir,'Der_data.txt'),data,[],',');

% solution to the differentiation (same as the MATLAB version)
Solution = [-3.4660    5.0340   13.5340   22.0340   30.5340];

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
        % file named Der_XXXX.txt, 2 columns comma delimited
        % read it in and use it as their solution
        try
            resultFile = fullfile(grade_dir,['Der_',StudentID,'.txt']);
            StudentResult = load(resultFile);
            % break into x and yprime values (2 columns)
            StudentResult_x = StudentResult(:,1);
            StudentResult_yp = StudentResult(:,2);
            
            % make it a row vector
            StudentResult_yp = StudentResult_yp(:)';
            
            % GRADING SECTION------------------------------------------------------------
            if nnz(isnan(StudentResult_yp)) == 0
                Score = Score + 1/3;
            else
                Feedback = [Feedback,' Your function returned some NaNs in the result. '];
            end
            
            if length(StudentResult_yp) == length(x)
                Feedback = [Feedback,' Length of the output vector was correct. '];
                Score = Score + 1/3;
            else
                Feedback = [Feedback,' Length of the output vector was not correct, it should be the same length as the input vectors. '];
            end
            
            if norm(StudentResult_yp - Solution) < .01   % careful here because there are multiple correct ways to do this part
                Feedback = [Feedback,' Your output matched the solution. '];
                Score = Score + 1/3;
            else
                Feedback = [Feedback,' Your output did not match the solution. '];
            end
            
            
        catch ERR
            % if the student didn't write out a file as instructed
            Feedback = regexprep(ERR.message,'[\n\r]+',' ');
        end
        
    elseif run_status == 124
        Feedback = ['Runtime Error: Your code did not complete in 10 seconds which likely indicates an infinite while loop, or some other error.'];
        
    else
            
        % the run of their code didn't complete right; run_OUT should
        % contain an error description
        Feedback = ['Runtime Error: ',regexprep(run_OUT,'[\n\r]+',' ')];
        Score = .4;
    end
    
else
    %compile_OUT should contain the compile error here
    Feedback = ['Compile Error: ',regexprep(compile_OUT,'[\n\r]+',' ')];
end

% clean up
try
    delete(fullfile(grade_dir,'*.exe'))  % delete all .exe files when finished with them
    delete(fullfile(grade_dir,'FBC_data.txt')) % delete the input file just in case
    delete(fullfile(grade_dir,'Der_data.txt')) % delete the input file just in case
    delete(resultFile) % delete the generated .txt file
catch DELERR
    disp(DELERR.message);
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
function [Score, Feedback] = Plate_Grader(filename)
%--------------------------------------------------------------
% FILE: Plate_Grader.m
% AUTHOR: Jared Oliphant
% DATE: 3/28/2019
%
% PURPOSE: a grader file that will allow you compile and run .cpp files
% within MATLAB;
%
% INPUTS:
% a filename corresponding to a student's code
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

filename = 'Plate_2342.cpp'
grade_dir = '';


% grade_dir = 'grading_directory';  % needed for writing and reading the files
Feedback = '';
Score = 0; % initialize the Score at zero
f = filename(1:end-4);   % take off .cpp
StudentID = f(end-3:end); % get the numbers out
cpp_file = [f,'.cpp'];    % name of .cpp file
exe_file = [f,'.exe'];    % name of .exe file


% create the dataset that will be read in by the c++ function
top = 0:25;
bottom = 0:25;
left = zeros(size(top));
right = 25*ones(size(top));
data = [top' bottom' left' right'];   %% 4 columns of temp data

% write out the file without a newline character at the
% end to make it easy to read in to c++
dlmwrite_without_final_newline(fullfile(grade_dir,'plate_temperatures.txt'),data,[],'\t');

% solution
Solution = [];

% attempt to compile the .cpp into a .exe with the same name using the
% g++ compiler
[compile_status, compile_OUT] = system(['g++ ', ...
    fullfile(grade_dir,cpp_file),' -o ', ...
    fullfile(grade_dir,exe_file),' -std=c++11']);

% compile_status will return 0 if no errors occurred
if compile_status == 0
    Score = Score + 0.4;   % points for compiling with no errors
    Feedback = [Feedback,' Your code compiled with no errors.'];
    % attempt to run the newly compiled .exe file
    [run_status, run_OUT] = system(['cd grading_directory && timeout 10 ./',exe_file,' && cd ..']);
    % if the run didn't throw any errors
    if run_status == 0
        Score = Score + 0.1; % points for running with no errors
        Feedback = [Feedback,' Your code ran with no errors.'];
        % if the .exe run threw no errors the student should have produced a
        % file named Plate_XXXX.txt
        % read it in and use it as their solution
        try
            resultFile = fullfile(grade_dir,['Plate_',StudentID,'.txt']);
            StudentSolution = load(resultFile);   % should be a csv file
            Score = Score + 0.2; % points for writing out a file
            Feedback = [Feedback,' You wrote out the proper file.'];
            
            if norm(StudentSolution - Solution) < 0.1
                Score = Score + 0.3; % points for having the correct answer within
                Feedback = [Feedback,' You got the right answer.'];
            end
            
            
        catch ERR
            % if the student didn't write out a file as instructed
            Feedback = regexprep(ERR.message,'[\n\r]+',' ');
        end
        
    elseif run_status == 124
        Feedback = 'Runtime Error: Your code did not complete in 10 seconds which likely indicates an infinite while loop, or some other error.';
        
    else
        
        % the run of their code didn't complete right; run_OUT should
        % contain an error description
        Feedback = [Feedback,'  Runtime Error: ',regexprep(run_OUT,'[\n\r]+',' ')];
    end
    
else
    %compile_OUT should contain the compile error here
    Feedback = [Feedback, '  Compile Error: ',regexprep(compile_OUT,'[\n\r]+',' ')];
end

% clean up
try
    delete(fullfile(grade_dir,'*.exe'))  % delete all .exe files when finished with them
    delete(fullfile(grade_dir,'plate_temperatures.txt')) % delete the input file just in case
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
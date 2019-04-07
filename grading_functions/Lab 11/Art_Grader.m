function [Score, Feedback] = Art_Grader(filename)
%--------------------------------------------------------------
% FILE:  Art_Grader.m 
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
grade_dir = 'grading_directory';  % needed for writing and reading the files
Feedback = '';
Score = 0; % initialize the Score at zero
f = filename(1:end-4);   % take off .cpp
StudentID = f(end-3:end); % get the numbers out
cpp_file = [f,'.cpp'];    % name of .cpp file
exe_file = [f,'.exe'];    % name of .exe file


% create the dataset that will be read in by the c++ function
rgbimage = imread('GradeImage.jpg');
grayimage = rgb2gray(rgbimage);
smaller = imresize(grayimage,0.25);
data = 255 - smaller;  

% write out the file without a newline character at the
% end to make it easy to read in to c++
inputFileName = fullfile(grade_dir,'Input.txt');
dlmwrite_without_final_newline(inputFileName,data,[],' ');
% append the size of the matrix to the top of the data file
S = fileread(inputFileName);
S = [num2str(size(data,1)),' ',num2str(size(data,2)),char(10),S];
FID = fopen(inputFileName, 'w');
fwrite(FID, S, 'char');
fclose(FID);

% be nice and write another one with lower case name
inputFileName = fullfile(grade_dir,'input.txt');
dlmwrite_without_final_newline(inputFileName,data,[],' ');
% append the size of the matrix to the top of the data file
S = fileread(inputFileName);
S = [num2str(size(data,1)),' ',num2str(size(data,2)),char(10),S];
FID = fopen(inputFileName, 'w');
fwrite(FID, S, 'char');
fclose(FID);


% write out the ascii mapping file as well just to be safe
asciimap = load('ASCII_mapping.txt');
dlmwrite_without_final_newline(fullfile(grade_dir,'ASCII_mapping.txt'),asciimap,[],'\t');

% to going to actually check the solution in this case
% Solution = []

% attempt to compile the .cpp into a .exe with the same name using the
% g++ compiler
[compile_status, compile_OUT] = system(['g++ ', ...
    fullfile(grade_dir,cpp_file),' -o ', ...
    fullfile(grade_dir,exe_file),' -std=c++11']);

% compile_status will return 0 if no errors occurred
if compile_status == 0
    Score = Score + 0.5;   % points for compiling with no errors
    Feedback = [Feedback,' Your code compiled with no errors.'];
    % attempt to run the newly compiled .exe file
    [run_status, run_OUT] = system(['cd grading_directory && timeout 10 ./',exe_file,' && cd ..']);
    % if the run didn't throw any errors
    if run_status == 0
        Score = Score + 0.3; % points for running with no errors
        Feedback = [Feedback,' Your code ran with no errors.'];
        % if the .exe run threw no errors the student should have produced a
        % file named ASCII_XXXX.txt
        % read it in and use it as their solution
        try
            resultFile = fullfile(grade_dir,['ASCII_',StudentID,'.txt']);
            content = readFileIntoCell(resultFile);
            if length(content) == size(data,1) && ~isempty(content{23})
                Score = Score + 0.2; % points for writing out a file with stuff in it
                Feedback = [Feedback,' You wrote out the proper file.'];  
            else
                Feedback = [Feedback,' The file you wrote out didn''t have the expected size or was empty'];
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
    delete(fullfile(grade_dir,'Input.txt')) % delete the input file just in case
    delete(resultFile) % delete the generated .txt file
catch DELERR
%     disp(DELERR.message);
end


if length(Feedback) > 2000
    Feedback = [Feedback(1:2000),'  OUTPUT TRUNCATED'];
end

end



function content = readFileIntoCell(filename)
f = fopen(filename);        % open the file
test = 1;                   % initialize the test variable
i = 1;                      % initialize i: the variable for which row of the file is being examined
content = {};      
while test == 1             % loop through the lines of the file
    
    tline = fgetl(f);       % get a line of text
    if tline == -1          % if the end of file is reached, BREAK
        break
    elseif isempty(tline)   % loop around if the line contains nothing
        continue
    else
        content{i,1} = strtrim(tline);  % trim out inital and ending space characters
    end
    
    i = i + 1;              % increment i
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
[fid, message] = fopen(YourFileName, 'w+');
if fid < 0
    error('Failed to open file "%s" because "%s"', YourFileName, message);
end
fprintf(fid, line_fmt, YourMatrix(1:end-1, :).' );  %transpose is important here
fprintf(fid, last_line_fmt, YourMatrix(end,:) );
fclose(fid);
end
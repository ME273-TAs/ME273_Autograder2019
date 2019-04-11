function outFile = rename_file(fileIn, assignmentName, language)

%============================================BEGIN-HEADER=====
% FILE: rename_file.m
% AUTHOR: Caleb Groves
% DATE: 16 May 2018
%
% PURPOSE: Rename a single file. 
%   Ex: Euler_9991 - Caleb Groves.m -> Euler_9991.m
%   OR  Euler_9991 - Jared Oliphant.cpp -> Euler_9991.cpp    
%   
%
% INPUTS:
%   fileIn: file structure to be renamed
%   assignmentName: name of assignment to append to front of filename
%
%
% OUTPUTS:
%   outFile: renamed file structure
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

grade_dir = 'grading_directory'; % name of grading directory folder

% construct new filename
studentID = num2str(parseCourseID(fileIn.name));

if strcmp(language,'MATLAB')
    newName = strcat(assignmentName,'_',studentID,'.m');
elseif strcmp(language,'C++')
    newName = strcat(assignmentName,'_',studentID,'.cpp');
end


movefile(fullfile(grade_dir,fileIn.name),fullfile(grade_dir,newName))
outFile = dir(fullfile(grade_dir,newName));


end
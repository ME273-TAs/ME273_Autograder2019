function outFile = rename_file(fileIn, assignmentName)

%============================================BEGIN-HEADER=====
% FILE: rename_file.m
% AUTHOR: Caleb Groves
% DATE: 16 May 2018
%
% PURPOSE: Rename a single file. 
%   Ex: Euler_9991 - Caleb Groves.m -> Euler_9991.m
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

% construct new filename
studentID = num2str(parseCourseID(fileIn.name));
newName = strcat(assignmentName,'_',studentID,'.m');

movefile(fullfile(fileIn.folder,fileIn.name),fullfile(fileIn.folder,newName));

outFile = dir(fullfile(fileIn.folder,newName));


end
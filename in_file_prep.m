function subFiles = in_file_prep(sub_dir)

%============================================BEGIN-HEADER=====
% FILE: in_file_prep.m
% AUTHOR: Caleb Groves
% DATE: May 16, 2018
%
% PURPOSE:
%   Prepares a directory of student submissions downloaded from Google
%   Drive to be read as Matlab functions and graded. 
%
% INPUTS:
%   Directory of the student submissions to be read
%
%
% OUTPUTS:
%   Array of files with underscores in their names
%
%
% NOTES:
%   Creates a grading directory.
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

grade_dir = 'grading_directory'; % name of grading directory folder

if ~exist('dummy','dir')
    mkdir('dummy');
end

if strcmp(sub_dir,'')
    sub_dir = 'dummy';
end

% Clear the grading directory if it exists, create it if not
if ~exist(grade_dir,'dir')
    mkdir(grade_dir);
end

oldFiles = dir(fullfile(grade_dir,'*_*'));

for i = 1:length(oldFiles)
    delete(fullfile(oldFiles(i).folder,oldFiles(i).name));
end

% Get all files is submission directory with submission tag
subFiles = dir(fullfile(sub_dir,'*_*'));

% Copy the files over to the grading directory
for i = 1:length(subFiles)
    copyfile(fullfile(subFiles(i).folder,subFiles(i).name),grade_dir);
end

% In the grading directory:
subFiles = dir(fullfile(grade_dir,'*_*'));

% end of function
end


function [] = orig_check(currentLab,f,filename)

%============================================BEGIN-HEADER=====
% FILE: orig_check.m
% AUTHOR: Jared Hale
% DATE: 7 Sep 2020
%
% PURPOSE: Fill a separate directory with student's submitted code to be
%   uploaded to SimiCheck for an analysis of who is copying who
%
% INPUTS:   currentLab - structure containing the current lab number
%           f - information about the file currently being graded
%           filename - easily accessed filename from f
%
% OUTPUTS:  none - files are copied over to a new directory
%
%
% NOTES:    any files already in the directory that have the same filename
%           as the file passed in will be deleted
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% Collect path/file names
gradedPath = ['../GradedLabs/Lab',num2str(currentLab.num),'Graded/GradedCopies/'];
if ~isfolder(gradedPath)
    mkdir(gradedPath);
end

% figure out what the current lab part is
idx = strfind(filename,'_');
currentPart = filename(1:idx(end)-1);

% create subfolder if one does not exist for this part
partPath = [gradedPath,currentPart,'Submissions/'];
if ~isfolder(partPath)
    mkdir(partPath);
end

oldfile = [f.folder,'/',filename];
newfile = [partPath,filename];

% Check if newfile already exists
if isfile(newfile)
    delete(newfile) % delete newfile
end
    

% Copy the file over
copyfile(oldfile,newfile)
function logManualChanges(configVars, newGrades, oldGrades)
%============================================BEGIN-HEADER=====
% FILE: logManualChanges.m
% AUTHOR: Caleb Groves
% DATE: 14 August 2018
%
% PURPOSE:
%   This function logs the differences in student grade data between two
%   files.
%
% INPUTS:
%
%   configVars - program-wide configuration variables.
%
%   newGrades - this is a table for the lab grades that were read in from
%   the dynamic .csv file. It is now a static table.
%
%   oldGrade - this is a table for the lab grades that were read in from
%   the newest static .csv file in the Archives. It is now a static table.
%
%
% OUTPUTS:
%   None.
%
%
% NOTES: To be implemented later.
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

disp('Remember to write the logManualChanges.m function.');

% This function would become part of an unimplemented feature that would
% create a log file to record all of the grading actions that are taken.
% This log file would just be a text file in the LabXGraded directory, and
% functions could be altered to write out important information to it
% throughout the program.

% This particular function would check for changes between the most recent
% static file (supposedly untouched in the archives) and the dynamic .csv
% (where any manual edits would occur). Any changes detected in a student's
% grades, feedback, etc., would be written to the log file so that there is
% an explicit record of manual edits that are made.

% The trick is that at this point, both of the input arguments are Matlab
% tables with fields accessible through dot notation, but whose names are
% lab-part unique (i.e. newGrades.EulerScore,
% oldGrades.HeunCommentFeedback). In order to make this function general,
% the tables will probably have to be converted to cell arrays using the
% table2cell function, and then each line in each table compared to itself,
% and then changes written out to the log file.

% The function <getLabPart.m> might be useful here.

end
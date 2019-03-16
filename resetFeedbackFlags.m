function gradesTable = resetFeedbackFlags(gradesTable)
%============================================BEGIN-HEADER=====
% FILE: resetFeedbackFlags.m
% AUTHOR: Caleb Groves
% DATE: 11 August 2018
%
% PURPOSE:
%   This function merely goes through the grades table and sets the
%   feedback flags from 1 to 2.
%
% INPUTS:
%   gradesTable - table with field FeedbackFlag.
%
%
% OUTPUTS:
%   same
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

for i = 1:size(gradesTable,1)
    if gradesTable.FeedbackFlag(i) == 1
        gradesTable.FeedbackFlag(i) = 2;
    end
end
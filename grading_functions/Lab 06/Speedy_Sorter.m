function [Score, Feedback] = Speedy_Sorter(filename)

%--------------------------------------------------------------
% FILE: SpeedyV_Grader.m
% AUTHOR: Jared Hale
% DATE: 28 October 2019
%
% PURPOSE: Get all student submissions in one location.
%
% INPUTS:
%   filename - a filename corresponding to a student's code
%
%
% OUTPUT:
%   Score - a scalar between 0 and 1
%   Feedback - a character array of feedback, containing a grades breakdown.
%
%
% VERSION HISTORY
% V1 -
% V2 -
% V3 -
%
%--------------------------------------------------------------

copyfile(filename,'/Volumes/jaredhmt/groups/me-273/Autograder/Student Submissions/Lab06/All Submissions/Speedy_XXXX')


Score = "";
Feedback = "";


end
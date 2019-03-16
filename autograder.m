function master = autograder(labNum, dueDate, roster, configVars, labParts,...
    regrading, manualGrading, pseudoDate, varargin)
%============================================BEGIN-HEADER=====
% FILE: autograder.m
% AUTHOR: Caleb Groves
% DATE: 6 June 2018
%
% PURPOSE:
%   Ties together the grading of multiple lab parts and the overall grading
%   of the lab.
%
% INPUTS:
%   labNum - integer representing number for this lab
%
%   roster - structure containing two fields (name, path) for the .csv of
%   the class roster to link submissions to.
%
%   configVars - structure with configuration variables.
%
%   labParts - cell array of structs with the following fields: name
%   (character array), dueDate (datetime object), submissionsDir (character
%   string), graderfile (structure with fields name, path as character
%   arrays)
%
%   regrade - 0: original grading, 1: re-grading mode
%
%   pseudoDate - Matlab datetime that the autograder will interpret as
%   "now" (useful for retroactive grading).
%
%   varargin{1} - Matlab table structure with previous lab grades in it.
%
% OUTPUTS:
%   master - the table of complete lab grades and feedback.
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======    
% Deal with variable inputs
firstGrading = 1;

NORM_IN = 8; % specify number of non-variable inputs

if regrading && nargin == NORM_IN
    error('Cannot run in regrading mode without a previously graded lab file specified.');
elseif nargin == NORM_IN + 1
    firstGrading = 0;
end

% Setup containers for graded data
n = length(labParts);
partTables = cell(n,1);

% For each lab part
for i = 1:length(labParts)
    
    % Do in-file prep
    submissions = in_file_prep(labParts{i}.submissionsDir);
    
    % Call functions w/parameters depending on how the program is
    % running
    if firstGrading
        
        % Link the students to the submissions
        linked = roster_linker(submissions, roster, labParts{i}.name, ...
        configVars, regrading, manualGrading, dueDate, pseudoDate);
       
    else
        
        % Link the students to the submissions
        linked = roster_linker(submissions, roster, labParts{i}.name, ...
        configVars, regrading, manualGrading, dueDate, pseudoDate, varargin{1});
        
    end
    
    % do lab part grading
    graded = lab_part_grader(linked, labParts{i}.graderfile, configVars,...
        regrading, manualGrading, pseudoDate);
    
    partTables{i} = graded; % store graded lab
    
end

% compile all lab grades into one
master = lab_grader(labNum,partTables,configVars);

end % end of function
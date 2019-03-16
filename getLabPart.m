function prevGraded = getLabPart(partName, gradedTable, configVars)
%============================================BEGIN-HEADER=====
% FILE: getLabPart.m
% AUTHOR: Caleb Groves
% DATE: 6 July 2018
%
% PURPOSE:
%   This function reads in a .csv file of a previously graded lab and
%   creates a lab part table with that lab part's grades.
%
% INPUTS:
%   partName - character array with the given name for this lab part.
%
%   gradedTable - table structure with all the grades from this lab.
%
%   configVars - structure containing useful configuration variables
%
% OUTPUTS:
%   prevGraded - A Matlab table for this lab part with the following
%   fields: CourseID, Late, Score, CodeScore, CodeFeedback, HeaderScore,
%   HeaderFeedback, CommentScore, CommentFeedback, FeedbackFlag.
%
%
% NOTES:
%   This function depends highly on the ordering of the columns in the
%   graded file's .csv. Any changes to the way the compiled lab parts are
%   put together and written out will need to be changed here, as well.
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% % Read in the gradedFile as a table
% T = readtable(fullfile(gradedFile.path,gradedFile.name));

% Convert the table to a cell array
gradedArray = table2cell(gradedTable);

% Get the CourseID column
prevGraded = table; % initialize prevGraded table
prevGraded.CourseID = gradedArray(:,configVars.studentFields.CourseID);
prevGraded.FirstDeadline = gradedArray(:,configVars.studentFields.FirstDeadline);
prevGraded.FinalDeadline = gradedArray(:,configVars.studentFields.FinalDeadline);

% Go through each column and look for the lab partName match
n = size(gradedArray,2); % get number of columns
p = (n - configVars.studentFields.l)/configVars.partFields.p; % get number of lab parts for this lab

r = 0; % working index
j = 0;
for i = configVars.studentFields.l:configVars.partFields.pf:size(gradedArray,2)
    if strcmp(gradedArray(1,i),partName)
        r = i; % Keep that column index when found
        break;
    end
    j = j + 1; % increment part counter
end

% Check to see if lab part name was found in this file
if r == 0
    error(['Could not find lab part <',partName,'> in table passed in.']);
end

% Copy over the columns for code, header, and comment scores and feedback.
% Get the pertinent column indices
feedbackFlagCol = configVars.studentFields.FeedbackFlag;
lateCol = r + configVars.partFields.LateOffset;
codeCol = r + configVars.partFields.CodeScoreOffset;
headerCol = r + configVars.partFields.HeaderScoreOffset;
commentCol = r + configVars.partFields.CommentScoreOffset;
scoreCol = r + configVars.partFields.ScoreOffset;
codeFBCol = n - (p-j)*configVars.partFields.pb + configVars.partFields.CodeFBOffset;
headerFBCol = n - (p-j)*configVars.partFields.pb + configVars.partFields.HeaderFBOffset;
commentFBCol = n - (p-j)*configVars.partFields.pb + configVars.partFields.CommentFBOffset;

% Copy over the columns into the output table
prevGraded.FeedbackFlag = gradedArray(:,feedbackFlagCol);
prevGraded.Late = gradedArray(:,lateCol);
prevGraded.CodeScore = gradedArray(:,codeCol);
prevGraded.HeaderScore = gradedArray(:,headerCol);
prevGraded.CommentScore = gradedArray(:,commentCol);
prevGraded.CodeFeedback = gradedArray(:,codeFBCol);
prevGraded.HeaderFeedback = gradedArray(:,headerFBCol);
prevGraded.CommentFeedback = gradedArray(:,commentFBCol);
prevGraded.Score = gradedArray(:,scoreCol);
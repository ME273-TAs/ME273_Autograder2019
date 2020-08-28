function configVars = configAutograder(labNum)
%============================================BEGIN-HEADER=====
% FILE: configAutograder.m
% AUTHOR: Caleb Groves
% DATE: 11 August 2018
%
% PURPOSE:
%   This config function creates globally-scoped variables that will be
%   used throughout the program. It should be extensively commented in
%   order to enable edits corresponding to different semester grading
%   policies and section schedules.
%
% INPUTS:
%   labNum - integer value number of the current lab being graded.
%
%
% OUTPUTS:
%   configVars - structure containing useful data to pass around to most
%   (if not all) functions in the autograder.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

%% Grading Weights
% weights - a structure with three fields (code, header, comments)
% containing floats that add to 1.0. These are the grading weights of each
% of these items, respectively.
configVars.weights.code = 0.8;
configVars.weights.header = 0.1;
configVars.weights.comments = 0.1;

% added this field into weights to make the late penalty variable
% Jared Oliphant 1/22/2019
% see also 'dynamicToStatic.m' and 'get_lab_part_score.m' and
% 'gradingLogic.m'
configVars.weights.latePenalty = 1;

% added this field to allow the grader to output a .csv
% that will play nice with learning suite
% Jared Oliphant 2/6/2019
configVars.LearningSuitePoints = 25; 

% Catch any errors with the assignment of weights
if configVars.weights.code + configVars.weights.header + ...
        configVars.weights.comments ~= 1.0
    error('Fields of variable <weights> must add to 1.0');
end

%% Section Dates
% Structure with fields for the days of the week. The value represents the
% corresponding section number. Used primarily in getSectionDueDates to
% stagger the default due dates for each section; should be updated each
% semester.
% set section number to corresponding day of the week
configVars.sectionDays.Monday = 1;
configVars.sectionDays.Tuesday = 2;
configVars.sectionDays.Wednesday = 3;
configVars.sectionDays.Thursday = 4;
configVars.sectionDays.Friday = 5;

%% Part Fields
% These variables control how student data is written out to the .csv's.
% NOTE: IF ANY CHANGES ARE MADE TO THIS SECTION, CHANGES WILL PROBABLY ALSO
% NEED TO BE MADE TO THE FILE 'Autograder Feedback Giver.json' IN ORDER FOR
% THE GMAIL FEEDBACK SCRIPT TO MATCH THE RIGHT .CSV COLUMNS WITH THE RIGHT
% CONTENT.

% Part Fields
configVars.partFields.Front = {'Part','Late','Score','CodeScore','HeaderScore',...
    'CommentScore'};
configVars.partFields.Back = {'CodeFeedback','HeaderFeedback','CommentFeedback'};
configVars.partFields.pf = length(configVars.partFields.Front); % number of fields in front
configVars.partFields.pb = length(configVars.partFields.Back); % number of fields in back
configVars.partFields.p = configVars.partFields.pf + configVars.partFields.pb; % total number of Lab Part fields
configVars.partFields.LateOffset = 1;
configVars.partFields.ScoreOffset = 2;
configVars.partFields.CodeScoreOffset = 3;
configVars.partFields.HeaderScoreOffset = 4;
configVars.partFields.CommentScoreOffset = 5;
configVars.partFields.CodeFBOffset = 0; % from the back
configVars.partFields.HeaderFBOffset = 1;
configVars.partFields.CommentFBOffset = 2;

% Student Info Fields
% create lab score field
labScoreField = ['Lab',num2str(labNum),'Score'];

configVars.studentFields.Front = {'CourseID','LastName','FirstName','GoogleTag',...
    'SectionNumber',labScoreField,'FeedbackFlag','FirstDeadline',...
    'FinalDeadline'};
configVars.studentFields.Back = {'Email'};
configVars.studentFields.lf = length(configVars.studentFields.Front);
configVars.studentFields.lb = length(configVars.studentFields.Back);
configVars.studentFields.l = configVars.studentFields.lf + configVars.studentFields.lb; % total number of student info fields
configVars.studentFields.LabScore = 6;
configVars.studentFields.FeedbackFlag = 7;
configVars.studentFields.FirstDeadline = 8;
configVars.studentFields.FinalDeadline = 9;
configVars.studentFields.CourseID = 1;
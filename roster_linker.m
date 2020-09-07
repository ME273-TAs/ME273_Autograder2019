function linkedTable = roster_linker(currentLab, submissionsTable, roster, ...
    partName, configVars, finalGrading, manualGrading, pseudoDate, varargin)

%============================================BEGIN-HEADER=====
% FILE: roster_linker.m
% AUTHOR: Caleb Groves
% DATE: 18 May 2018
%
% PURPOSE:
%   Tries to match the submissionsTable.CourseID to the
%   rosterTable.CourseID for each submission. If it succeeds, it appends
%   all of the student information. If not, it writes an error message.
%
% INPUTS:
%   submissionsTable - array of files with underscores in their names.
% 
%   roster - structure containing two fields (name, path) for the .csv of
%   the class roster to link submissions to. The .csv is assumed to have
%   the following columns: LastName, FirstName, Email, SectionNumber,
%   CourseID.
%   
%   labNum - number of the lab
%
%   partName - character array of lab part name
%
%   configVars - structure containing useful configuration variables
%
%   regrading - an integer 1 or 0 indicating whether the program is being
%   run in regrading mode or not.
%
%   manualGrading - 1/0 to indicate if this is a manual grading run or not.
%
%   dueDate - Matlab datetime structure of the first chronological due date
%   for this current lab.
%
%   pseudoDate - Matlab datetime structure indicating what the program
%   interprets as "now", or "today"
%
% OUTPUTS:
%   linkedTable - Matlab table structure with the following fields:
%   CourseID, LastName, FirstName, GoogleTag, SectionNumber, PartName,
%   Email.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
% 10/31/2019 - Fixed an issue where changing the dynamic graded file could
%   affect the year of the due date. Added logic to catch this and change
%   the due date year to the current year. -Jared Hale
%
%==============================================END-HEADER======
% Initialize variables for first time grading
firstTimeGrading = 1;
prevGraded = 'none';

NORM_IN = 8; % normal amount of function arguments

% Check to see if a previously graded file is being passed in
if nargin == NORM_IN + 1
    firstTimeGrading = 0;
    prevGraded = getLabPart(partName, varargin{1}, configVars);
end

% Read roster file into a Matlab table
addpath(roster.path);
rosterTable = readtable(roster.name);
rmpath(roster.path); % remove roster path

% get number of submissions
n = size(submissionsTable,1);

% Add on pertinent fields to roster table from graded submissions table
m = size(rosterTable,1);

% initialize general part of table
rosterTable.PartName = cell(m,1);
rosterTable.GoogleTag = cell(m,1);
rosterTable.File = cell(m,1);
rosterTable.FirstDeadline = cell(m,1);
rosterTable.FinalDeadline = cell(m,1);
rosterTable.CurrentDeadline = cell(m,1);

% initialize new portion of table
rosterTable.FeedbackFlag = zeros(m,1);
rosterTable.Score = zeros(m,1);
rosterTable.NumSub = zeros(m,1);
rosterTable.LastSubmit = cell(m,1);
rosterTable.CodeScore = zeros(m,1);
rosterTable.HeaderScore = zeros(m,1);
rosterTable.CommentScore = zeros(m,1);
rosterTable.CodeFeedback = cell(m,1);
rosterTable.HeaderFeedback = cell(m,1);
rosterTable.CommentFeedback = cell(m,1);

% initialize old portion of table
rosterTable.OldFeedbackFlag = zeros(m,1);
rosterTable.OldScore = zeros(m,1);
rosterTable.OldNumSub = zeros(m,1);
rosterTable.OldLastSubmit = cell(m,1);
rosterTable.OldCodeScore = zeros(m,1);
rosterTable.OldHeaderScore = zeros(m,1);
rosterTable.OldCommentScore = zeros(m,1);
rosterTable.OldCodeFeedback = cell(m,1);
rosterTable.OldHeaderFeedback = cell(m,1);
rosterTable.OldCommentFeedback = cell(m,1);

% Go through each student in the roster table for two purposes:
% 1) To try and match a current student to the student from the file read
% in
% 2) To only assign the most recent submission from the submissionsTable
% array
for i = 1:m
    % label the lab part name regardless of whether or not there is a file
    % submission
    rosterTable.PartName{i} = partName;
    
    % Get or assign student submission deadlines
    
    match = 0; % matching student flag
    
    if ~firstTimeGrading % if there's a previously graded lab part
        
        for j = 1:size(prevGraded,1) % for each student in that file
            % if CourseID's match (student match)
            if rosterTable.CourseID(i) == prevGraded.CourseID{j}
                % set match flag
                match = 1; %#ok<NASGU>
                % When some changes are made to graded csv occasionally the
                % year will shift to 2000 years ago. This checks to make
                % sure the dates here are within the last two millenia
                if prevGraded.FirstDeadline{j}.Year < 2010
                    prevGraded.FirstDeadline{j}.Year = datetime('now').Year;
                    prevGraded.FinalDeadline{j}.Year = datetime('now').Year;
                    if isdatetime(prevGraded.SubDate{j}) 
                        prevGraded.SubDate{j}.Year = datetime('now').Year;
                    end
                end
                % copy over old student information 
                rosterTable.FirstDeadline{i} = ...
                    datetime(prevGraded.FirstDeadline{j});
                rosterTable.FinalDeadline{i} = ...
                    datetime(prevGraded.FinalDeadline{j});
                rosterTable.OldFeedbackFlag(i) = prevGraded.FeedbackFlag{j};
                rosterTable.OldScore(i) = prevGraded.Score{j};
                rosterTable.OldNumSub(i) = prevGraded.Late{j};
                rosterTable.OldLastSubmit{i} = prevGraded.SubDate{j};
                rosterTable.OldCodeScore(i) = prevGraded.CodeScore{j};
                rosterTable.OldHeaderScore(i) = prevGraded.HeaderScore{j};
                rosterTable.OldCommentScore(i) = prevGraded.CommentScore{j};
                rosterTable.OldCodeFeedback{i} = prevGraded.CodeFeedback{j};
                rosterTable.OldHeaderFeedback{i} = prevGraded.HeaderFeedback{j};
                rosterTable.OldCommentFeedback{i} = prevGraded.CommentFeedback{j};
                
                break; % exit this for-loop
            end
        end
    elseif firstTimeGrading || ~match
        % create deadlines based on student section number
        [rosterTable.FirstDeadline{i}, rosterTable.FinalDeadline{i}] = ...
            getSectionDueDates(rosterTable.SectionNumber(i), currentLab.dueDate, configVars);
    end
    
    % Choose which deadline to use as current
    rosterTable.CurrentDeadline{i} = rosterTable.FirstDeadline{i};
    if finalGrading
        rosterTable.CurrentDeadline{i} = rosterTable.FirstDeadline{i};
    end
    
    % Go through each row in the submissions table
    for j = 1:n
        % parse CourseID from filename
        if submissionsTable(j).name(1) == '.'
            % Hidden File Found, skip this file
        else
            submissionID = parseCourseID(submissionsTable(j).name);
            
            if rosterTable.CourseID(i) == submissionID % student match
                % Check to see if submission file should replace current file
                f = rosterTable.File{i};
                
                d = datetime(submissionsTable(j).date);
                
                % if the submission date is before the current deadline and it
                % was submitted before the pseudodate ("now")
                if (~manualGrading.flag && ...
                        d <= rosterTable.CurrentDeadline{i} && ...
                        d <= pseudoDate) || manualGrading.flag
                    
                    % if there exists a current file for this student and the
                    % submission date is newer than the current file's date OR
                    % if there's no file with this student at all
                    if (isstruct(f) && d > f.date) || ~isstruct(f)
                        
                        % rename file and assign to student
                        rosterTable.File{i} = rename_file(...
                            submissionsTable(j), partName, currentLab.language);
                        rosterTable.GoogleTag{i} = getGoogleTag(...
                            submissionsTable(j).name);
                    end
                end % before current deadline check
                
            end % course ID check
        end
    end % next submission
                    
end % roster loop

linkedTable = rosterTable; % create linked table
% end of function
end
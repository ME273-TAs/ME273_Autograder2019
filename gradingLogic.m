function [feedbackFlag, gradingAction, numSubmissions] = gradingLogic(File, ...
    ~, numSubmissions, lastSubDate, OldFeedbackFlag, OldScore, pseudoDate, ...
    finalGrading, ~, FirstDeadline, chances)
%============================================BEGIN-HEADER=====
% FILE: gradingLogic.m
% AUTHOR: Caleb Groves
% DATE: 4 August 2018
%
% PURPOSE:
%   This function embodies the logic to determine whether a particular file
%   is going to be graded, regraded, or whether old scores will be copied
%   over.
%
% INPUTS:
%   File - student's File structure
%   CurrentDeadline - student's current deadline
%   OldLate - late flag copied over from previous grading
%   OldFeedbackFlag - previous feedback flag
%   OldScore - previous score recorded for current lab part
%   pseudoDate - "now" for the program
%   finalGrading - regrade flag
%   configVars - configuration variables from configAutograder.m
%   FirstDeadline - the original deadline for this student -- used for
%   regrading mode
%
%
% OUTPUTS:
%   gradingAction - integer corresponding to specific grading actions
%   1 = feedback grading
%   2 = copy over the old scores and feedback
%   3 = final grading
%   4 = no-submit, 1st warning
%
%   feedbackFlag - new feedback flag to record
%
%
% NOTES:
%
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% if isstruct(File)
%     if datetime(File.date) > FirstDeadline
%         % this file is a resubmission
%         f = fopen('latesubmissions.txt','a+');
%         fprintf(f,'%s %s\r',[File.name, File.date]);
%         fclose(f);
%     end
% end

if isempty(lastSubDate)
    lastSubDate = datetime([2000,1,1,0,0,0]);
end

if isstruct(File) % filter students that haven't submitted
    if datetime(File.date) <= FirstDeadline % make sure file was submitted before deadline
        if finalGrading && (pseudoDate > FirstDeadline)...
                && numSubmissions < 10
            % if the grader is in finalGrading mode, the deadline has...
            % past, and finalGrading has not already occured for this...
            % student, set grading action
            gradingAction = 3;
            feedbackFlag = 1;
            numSubmissions = numSubmissions + 10; %preserve record of...
            % how many submissions student used by adding 10
        else % if the program is not running in finalGrading mode
            if numSubmissions < chances % if the student has not exceeded feedback limitations
                newFileDate = datetime(File.date,'Format','MM/dd/uuuu HH:mm');
                newFileDate.Second = 0;
                try
                    oldFileDate = datetime(lastSubDate,'InputFormat','MM/dd/uuuu HH:mm');
                    oldFileDate.Second = 0;
                catch
                    oldFileDate = datetime([2000,1,1,0,0,0]);
                end
                if newFileDate > oldFileDate % if a new file has been uploaded since last time
                    gradingAction = 1;
                    feedbackFlag = OldFeedbackFlag;
                    numSubmissions = numSubmissions + 1;
                else % if the file is the same as the last submission
                    gradingAction = 2;
                    feedbackFlag = OldFeedbackFlag;
                end
            else % if the student has exceeded feedback limitations
                gradingAction = 2; % copy over the old scores and feedback
                feedbackFlag = OldFeedbackFlag;
            end
        end
    else % if file was late, transfer old feedback and grade
        gradingAction = 2;
        feedbackFlag = OldFeedbackFlag;
    end
else % if no file was submitted
    if OldScore == 0
        gradingAction = 4; % no-submit, 1st warning
        if finalGrading && (pseudoDate > FirstDeadline) && numSubmissions < 10
            feedbackFlag = 1;
            numSubmissions = 10;
        else
            feedbackFlag = OldFeedbackFlag;
            numSubmissions = 0;
        end
    elseif OldScore ~= 0
        gradingAction = 2; % copy over the old scores and feedback
        if finalGrading && (pseudoDate > FirstDeadline) && numSubmissions < 10
            feedbackFlag = 1;
            numSubmissions = numSubmissions + 10;
        else
            feedbackFlag = OldFeedbackFlag;
        end
    end
    
end
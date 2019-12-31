function [feedbackFlag, gradingAction] = gradingLogic(File, ...
    CurrentDeadline, OldLate, OldFeedbackFlag, OldScore, pseudoDate, ...
    regrading, configVars, FirstDeadline)
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
%   regrading - regrade flag
%   configVars - configuration variables from configAutograder.m
%   FirstDeadline - the original deadline for this student -- used for
%   regrading mode
%
%
% OUTPUTS:
%   gradingAction - integer corresponding to specific grading actions
%   1 = normal grading
%   2 = copy over the old scores and feedback
%   3 = late grading
%   4 = no-submit, 1st warning
%   6 = late submission Feedback Grading - Added by Jared H. 12/28/19
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
if pseudoDate < CurrentDeadline  % 'now' is before this student's deadline
    feedbackFlag = OldFeedbackFlag;
    gradingAction = 2;
    return;
end

% if isstruct(File)
%     if datetime(File.date) > FirstDeadline
%         % this file is a resubmission
%         f = fopen('latesubmissions.txt','a+');
%         fprintf(f,'%s %s\r',[File.name, File.date]);
%         fclose(f);
%     end
% end

if isstruct(File) % filter students that haven't submitted
    if datetime(File.date) <= CurrentDeadline % make sure file was submitted before deadline
        if regrading
            % changed the following if statement to reflect new regrading policy
            % Jared Oliphant 1/22/2019
            % see also 'dynamicToStatic.m' and 'get_lab_part_score.m'
            % and 'configAutograder.m'
            if OldScore < configVars.weights.latePenalty && datetime(File.date) > FirstDeadline 
                % 12/28/19 Jared H ommit && ~OldLate to account for changes
                % made to code about late submissions still getting
                % feedback before final due date
                
                % if it satisfies the regrading criteria    (after the
                % firstDeadline means it is a resubmission.
                gradingAction = 3; % late grading
                feedbackFlag = 1;
            else % if it doesn't satisfy the regrading criteria
                gradingAction = 2;  % copy over the old scores and feedback
                feedbackFlag = OldFeedbackFlag;
            end
        else % if the program is not running in regrading mode
            if OldScore == 0 % if there is no score
                gradingAction = 1; % perform original grading
                feedbackFlag = 1;
            else % if there is a pre-existing score
                gradingAction = 2; % copy over the old scores and feedback
                feedbackFlag = OldFeedbackFlag;
            end
        end
        
    elseif OldScore == 0 && (datetime(File.date) <= FirstDeadline + 7)
        % Added by Jared Hale on Dec. 28, 2019.
        % This elseif will grade late submissions as they come in so
        % student's code can still be graded for feedback and a grade
        % before waiting a week for the resubmission deadline.
        gradingAction = 3;
        feedbackFlag = 1;
    else % if the file was submitted after the deadline
        gradingAction = 2; % copy over the old scores and feedback
        feedbackFlag = OldFeedbackFlag;
    end
else % if no file was submitted
    if OldFeedbackFlag == 0
        gradingAction = 4; % no-submit, 1st warning
        feedbackFlag = 1;
    elseif OldFeedbackFlag ~= 0
        gradingAction = 2; % copy over the old scores and feedback
        feedbackFlag = OldFeedbackFlag;
    end
    
end
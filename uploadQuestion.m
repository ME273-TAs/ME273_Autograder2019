function uploadQuestion(questionType)
%============================================BEGIN-HEADER=====
% FILE: uploadQuestion.m
% AUTHOR: Caleb Groves
% DATE: 14 August 2018
%
% PURPOSE:
%   Loops on a dialog box until user confirms that action has been
%   completed.
%
% INPUTS:
%   questionType - integer: 1 for Learning Suite question, 2 for Gmail
%   feedback question
%
%
% OUTPUTS:
%   None
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% select question and title
question = '';
title = '';

switch questionType
    case 1
        question = 'grades to Learning Suite?';
        title = 'Learning Suite';
    case 2
        question = 'to Google Drive and sent out feedback?';
        title = 'Gmail Feedback';
    otherwise
        error('Unknown questionType');
end

answer = 'No'; % initialize answer

% loop on dialog box
while strcmp(answer,'No')
    answer = questdlg(['Have you uploaded ',question],...
        [title, ' Upload Question'],'Yes','No','No');
end
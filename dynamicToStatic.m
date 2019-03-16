function gradesTable = dynamicToStatic(gradesTable, configVars)
%============================================BEGIN-HEADER=====
% FILE: dynamicToStatic.m
% AUTHOR: Caleb Groves
% DATE: 13 August 2018
%
% PURPOSE:
%   Converts a dynamic grades table to a static one.
%
% INPUTS:
%   Grades table.
%
%
% OUTPUTS:
%   Grades table (with scores set to be static).
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

gradesArray = table2cell(gradesTable);

% re-write the lab part scores
n = size(gradesArray,2); % get number of columns
p = (n - configVars.studentFields.l)/configVars.partFields.p; % get number of lab parts for this lab

for i = 1:size(gradesArray,1) % for each student
    a = zeros(p,1);
    
    for j = 1:p % for each lab part
        % get column for lab part score
        c = configVars.studentFields.lf + 1 + ...
            configVars.partFields.ScoreOffset + ...
            (j-1)*configVars.partFields.pf;
        % calculate and store static lab part score
        gradesArray{i,c} = configVars.weights.code*gradesArray{i,c+1} + ...
            configVars.weights.header*gradesArray{i,c+2} + ...
            configVars.weights.comments*gradesArray{i,c+3};
        
        % Apply resubmission grading policy: if marked as late,
        % changed this to make a variable late penalty from configVars
        % see also 'get_lab_part_score.m' and 'configAutograder.m' and
        % 'gradingLogic.m'
        if gradesArray{i,c-1} == 1 && gradesArray{i,c} > configVars.weights.latePenalty
            gradesArray{i,c} = configVars.weights.latePenalty; % haircut policy
        end
        
        a(j) = c; % store score reference for overall lab score later
    end
    
    % re-write the lab score
    gradesArray{i,configVars.studentFields.LabScore} = sum([gradesArray{i,a}])/p;
end

gradesTable = cell2table(gradesArray, 'VariableNames', ...
    gradesTable.Properties.VariableNames);
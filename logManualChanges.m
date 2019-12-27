function logManualChanges(configVars, newGrades, oldGrades)
%============================================BEGIN-HEADER=====
% FILE: logManualChanges.m
% AUTHOR: Caleb Groves
% DATE: 14 August 2018
%
% PURPOSE:
%   This function logs the differences in student grade data between two
%   files.
%
% INPUTS:
%
%   configVars - program-wide configuration variables.
%
%   newGrades - this is a table for the lab grades that were read in from
%   the dynamic .csv file. It is now a static table.
%
%   oldGrade - this is a table for the lab grades that were read in from
%   the newest static .csv file in the Archives. It is now a static table.
%
%
% OUTPUTS:
%   None.
%
%
% NOTES: To be implemented later.
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======
return

columnNames = oldGrades.Properties.VariableNames;
labnum = regexp(columnNames{6},'\d');
logfileName = ['Lab',num2str(labnum),'ChangeLog.txt'];
disp(['logging manual changes to ',logfileName]);
savelocation = fullfile('..','GradedLabs',['Lab',num2str(labnum),'Graded'],'Archives',logfileName);
fileID = fopen(savelocation,'w');  % a for append, w for write and delete old contents (will use w for debugging)

oldGradesCell = table2cell(oldGrades);
newGradesCell = table2cell(newGrades);

[row,col] = size(oldGradesCell);


% table always has the following first few columns:
% courseID, LastName, FirstName, GoogleTag, SectionNumber, LabXScore,
% FeedbackFlag, FirstDeadLine, FinalDeadline, ... followed by changing
% columns

% someone might edit the section number (5)

for i = 1:row
    for j = 5:col
        O = oldGradesCell{i,j};
        N = newGradesCell{i,j};
        if isa(O,'double') && isa(N,'double')
            if abs(O - N) > 0.0001
                fprintf(fileID,[columnNames{j},' different on row ',num2str(i),'\r\n']);
                fprintf(fileID,['Old value, New value\r\n',num2str(O),', ',num2str(N),'\r\n\r\n']);
                'not the same double!'
            end
        elseif (isa(O,'string') && isa(N,'string')) || (isa(O,'char') && isa(N,'char'))
            if ~strcmp(O,N)
                fprintf(fileID,[columnNames{j},' different on row ',num2str(i),'\r\n']);
                fprintf(fileID,['Old value, New value\r\n',O,', ',N,'\r\n\r\n']);
                'not the same string!'
            end
        elseif isa(O,'datetime') && isa(N,'datetime')
            if O ~= N
                fprintf(fileID,[columnNames{j},' different on row ',num2str(i),'\r\n']);
                fprintf(fileID,['Old value, New value\r\n',O,', ',N,'\r\n\r\n']);
                'not the same date!'
            end
        else
            'not the same data type!'
        end
    end
end


fclose(fileID);


% This function would become part of an unimplemented feature that would
% create a log file to record all of the grading actions that are taken.
% This log file would just be a text file in the LabXGraded directory, and
% functions could be altered to write out important information to it
% throughout the program.

% This particular function would check for changes between the most recent
% static file (supposedly untouched in the archives) and the dynamic .csv
% (where any manual edits would occur). Any changes detected in a student's
% grades, feedback, etc., would be written to the log file so that there is
% an explicit record of manual edits that are made.

% The trick is that at this point, both of the input arguments are Matlab
% tables with fields accessible through dot notation, but whose names are
% lab-part unique (i.e. newGrades.EulerScore,
% oldGrades.HeunCommentFeedback). In order to make this function general,
% the tables will probably have to be converted to cell arrays using the
% table2cell function, and then each line in each table compared to itself,
% and then changes written out to the log file.

% The function <getLabPart.m> might be useful here.

end

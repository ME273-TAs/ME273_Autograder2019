function outFile = programSetup(currentLab, labParts, roster, finalGrade, manualGrading, pseudoDate)
%============================================BEGIN-HEADER=====
% FILE: programSetup.m
% AUTHOR: Caleb Groves
% DATE: 11 July 2018
%
% PURPOSE:
%   This function calls the autograder function with the appropriate
%   arguments, based on its own inputs. Its primary function is to make
%   sure that original grading is always done before regrading.
%
% INPUTS:
%   labNum - integer representing number for this lab
%
%   roster - structure containing two fields (name, path) for the .csv of
%   the class roster to link submissions to.
%
%   weights - structure with fields code, header, and comments, whose
%   values add up to 1. Used in calculating lab part grades.
%
%   labParts - cell array of structs with the following fields: name
%   (character array), dueDate (datetime object), submissionsDir (character
%   string), graderfile (structure with fields name, path as character
%   arrays)
%
%   finalGrad - 0: feedback grading, 1: final-grading mode
%
%   pseudoDate - Matlab datetime that the autograder will interpret as
%   "now" (useful for retroactive grading).
%
%
% OUTPUTS:
%   outFile - structure with fields <name> and <path> for the file created
%   from this grading run.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======
% split some of the inputs
labNum = currentLab.num;

% run config file
configVars = configAutograder(labNum);

% check for compatability on this machine (C++ labs must be graded with
% linux)
if strcmp(currentLab.language,'C++') && ispc == 1
    uiwait(errordlg(['ERROR: The current grading system only allows compiling ',...
        'and running .cpp files on a Linux machine. You must use the Linux computers ',...
        'in the 4th floor CB CAEDM or the 1st floor EB CAEDM to grade this Lab. ',...
        'You can also access a linux machine via RGS. See caedm.et.byu.edu/wiki/index.php/RGS'],... 
        'C++ Lab Grading','modal'));
    return; 
end

% Get most recent file in the path for the lab files
[labPath, archivesPath, prevGraded] = getOrCreateLabRecord(labNum, ...
    configVars);

% If original grading (no file to read in)
if ischar(prevGraded)
    master = autograder(currentLab, roster, configVars, labParts, 0, ...
        manualGrading, pseudoDate); % call without passing in a file
else % if a table is read in
    master = autograder(currentLab, roster, configVars, labParts, 0, ...
        manualGrading, pseudoDate, prevGraded); % always do original grading first
end

if finalGrade % if we're going to perform final grading
    master = autograder(currentLab, roster, configVars, labParts, 1, ...
        manualGrading, pseudoDate, master); % run in regrading mode with output generated
    % by original grading run, above
end

%% Checkpoint

% Write out grades to appropriate folder location
% place a small icon on the dialog box that shows the current distibution
% (histogram) of the grades, buttondlg function comes from the file
% exchange:
% https://www.mathworks.com/matlabcentral/fileexchange/46401-specifying-icon-in-questdlg
S.Default = 'Yes'; 
S.IconString = 'custom'; 
S.IconData  = getHistogramFigure(master, currentLab.num);
answer = buttondlg('Do you want to accept this grading effort?','Checkpoint','Yes','No',S);
% answer = questdlg('Do you want to accept this grading effort?','Checkpoint',...
%     'Yes','No','No');

% Exit the program if not desired to save the grades
if strcmp(answer,'No')
    return;
end

%% File Writing
LSmaster = LSprep(master, configVars);  % convert the final master array to an array that has score 
                                        % out of 25 points so it will play nice with learning suite
                                        
% Replace Ungraded 0's with NaN's to prevent LS deceptions
for i = 1:height(LSmaster)
    if LSmaster{i,7} == 0
        LSmaster{i,6} = nan;
    end
end

% Write out static .csv in top level for uploads
uploadFile = fullfile(labPath,'ME273LabFeedback.csv');
writetable(LSmaster, uploadFile);

% Confirm that uploads to learning suite and gmail have been completed
if finalGrade
    uploadQuestion(1);
end
uploadQuestion(2);

% flip feedback flags
master = resetFeedbackFlags(master);

% delete upload file
delete(uploadFile);

% save static to archives
staticFilename = ['Lab',num2str(labNum),'Graded',datestr(pseudoDate,...
    '(yyyy-mm-dd HH-MM-SS)'),'.csv'];
writetable(master,fullfile(archivesPath,staticFilename));

% convert static to dynamic
outFile = staticToDynamic(master, configVars);

% save dynamic to top-level lab folder
dynamicFilename = ['Lab',num2str(labNum),'Graded_Current.csv'];
writetable(outFile,fullfile(labPath,dynamicFilename));


% % if we are running a C++ lab on the Linux machine, the default read-write
% % permissions are weird.
% if strcmp(currentLab.language,'C++') and ~ispc()
%     % [STATUS,MESSAGE,MESSAGEID] = fileattrib(FILE,ATTRIBS,USERS,'s')
%     [STATUS,MESSAGE,MESSAGEID] = fileattrib(staticFilename,'+w','g','s');  
%     [STATUS,MESSAGE,MESSAGEID] = fileattrib(dynamicFilename,'+w','g','s');
% elseif strcmp(currentLab.language,'C++')
%     error('you should be running this lab on a linux machine...')
% end

end % end of function



% helper function that will multiply the percentage score by the total
% number of points that learning suite likes
function alteredTable = LSprep(originalTable, configVars)
    
    LSpoints = configVars.LearningSuitePoints;   % should be 25 right now
    cellversion = table2cell(originalTable);   % convert to cell array
    for i = 1:size(cellversion,1)
        cellversion{i,6} = cellversion{i,6}*LSpoints;    % multiply each by the total number of points
    end

    headers = originalTable.Properties.VariableNames;    % original headers

    alteredTable = cell2table(cellversion,'VariableNames',headers);   % convert back to table

end
    

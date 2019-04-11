function [labPath, archivesPath, gradesTable] = ...
    getOrCreateLabRecord(labNum, configVars)
%============================================BEGIN-HEADER=====
% FILE: getOrCreateLabRecord.m
% AUTHOR: Caleb Groves
% DATE: 14 July 2018
%
% PURPOSE:
%   This function is meant to manage the file structures for the lab
%   specified. It will create directories and return the most recently
%   altered file corresponding to this lab, if it can find it.
%
% INPUTS:
%   labNum - integer for lab number
%
%
% OUTPUTS:
%   labPath - path to all graded lab files.
%
%   archivesPath - path to archived (static) lab files.
%
%   gradesTable - table structure with the most recent grades read for this
%   lab read into it; if there are no previous grading attempts, a
%   character string 'none'.
%
%
% NOTES:
%
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======
% Construct lab path
labFolder = ['Lab',num2str(labNum),'Graded'];
labPath = fullfile('..','GradedLabs',labFolder);
archivesPath = fullfile('..','GradedLabs',labFolder,'Archives');

% if not, make it
if ~exist(archivesPath,'dir')
    mkdir(archivesPath); % make lab path
    gradesTable = 'none'; % list recent file as none
    
    % % if we are running a C++ lab on the Linux machine, the default read-write
    % % permissions are weird.
    % if strcmp(currentLab.language,'C++') and ~ispc()
    %     % [STATUS,MESSAGE,MESSAGEID] = fileattrib(FILE,ATTRIBS,USERS,'s')
    %     [STATUS,MESSAGE,MESSAGEID] = fileattrib(archivesPath,'+w','g','s');
    %     [STATUS,MESSAGE,MESSAGEID] = fileattrib(archivesPath,'+w','g','s');
    % elseif strcmp(currentLab.language,'C++')
    %     error('you should be running this lab on a linux machine...')
    % end
    return; % exit function
end



% Get a list of .csv files in Archives
static_csvs = dir(fullfile(archivesPath,'*.csv'));

% Get the current editable .csv
dynamic_csv = dir(fullfile(labPath,['Lab',num2str(labNum),...
    'Graded_Current.csv']));

% if there are no files in Archives, leave this function
if isempty(static_csvs) && isempty(dynamic_csv)
    gradesTable = 'none';
    return;
elseif ~isempty(dynamic_csv) % if there is a dynamic file
    
    % if there's more than one match
    if length(dynamic_csv) > 1
        % throw an error
        error(['Multiple dynamic .csv files detected;',...
            ' delete one and then re-run.']);
    end
    
    % read in the current_csv to a table
    dynamicTable = readtable(fullfile(labPath,dynamic_csv.name));
    % convert dynamic to static
    % assign to prevGraded
    gradesTable = dynamicToStatic(dynamicTable, configVars);
    
    if ~isempty(static_csvs) % if there are static files
        
        % get the most recent static
        mostRecentStaticFile = getMostRecentStatic(static_csvs);
        mostRecentStatic = readtable(fullfile(archivesPath,...
            mostRecentStaticFile.name));
        % run the comparison between the current and archived .csv's and
        % log the changes
        logManualChanges(configVars, gradesTable, mostRecentStatic);
    end
    
    %     % archive a copy of the dynamic csv converted to static
    %     filename = ['Lab',num2str(labNum),'Graded',datestr(now, ...
    %         '(yyyy-mm-dd HH-MM-SS)'),'.csv'];
    %     writetable(dynamicTable,fullfile(archivesPath, filename));
    
elseif isempty(dynamic_csv) && ~isempty(static_csvs)
    
    % get the most recent archived static file
    % use that as prevGraded
    recentFile = getMostRecentStatic(static_csvs);
    
    gradesTable = readtable(fullfile(archivesPath,recentFile.name));
end

end % end of function

% Helper function - Get the most recent file
function recentFile = getMostRecentStatic(files)

% Find the most recent file
recentFile = files(1); % assume it's the first one

if length(files) > 1 % if the list is greater than one
    for i = 2:length(files) % compare dates between current assumed file and the next
        if datetime(files(i).date) > datetime(recentFile.date)
            recentFile = files(i); % choose the newest one
        end
    end
end

end
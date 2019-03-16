function googleTag = getGoogleTag(filename)
%============================================BEGIN-HEADER=====
% FILE: getGoogleTag.m
% AUTHOR: Caleb Groves
% DATE: 5 June 2018
%
% PURPOSE:
%   Parses a filename in order to get the Google username that Google Drive
%   appends to all file uploads.
%
% INPUTS:
%   Character array of filename uploaded to Google Drive.
%
% OUTPUTS:
%   Character array of Google username appended to file submission name
%
%
% NOTES:
%     Function assumes that Google username is separated by a hyphen and
%     then a space, and consists of the rest of the characters until the
%     end of the filename. The function also assumes that there is only 1
%     hyphen in the filename.
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% initialize the beginning and ending tag indices
ib = 0;
ie = 0;

% cycle through all characters in the filename
for i = 1:length(filename)
    % if the current character is a hyphen
    if strcmp(filename(i),'-')
        ib = i + 2; % take into account the space
    % or if it is a period
    elseif strcmp(filename(i),'.')
        ie = i - 1;
    end
end

% Check for improper filenames
if ib == 0 || ie == 0
    googleTag = 'Unknown';
else
    % extract the Google username tag
    googleTag = filename(ib:ie);
end

end % end function
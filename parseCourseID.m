%--------------------------------------------------------------
% FILE: parseCourseID.m
% AUTHOR: Caleb Groves
% DATE: 1/17/18
% 
% PURPOSE: Parse the name of a student's file submission in order to
% extract the last four digits of their BYU ID.
%
%
% INPUT: String containing the filename to parse.
%
%
% OUTPUT: Last four digits of student's BYU ID, if contained after the
% first underscore in the filename. Otherwise, throws an string 'ERROR'.
%
%
% NOTES: 
%
%--------------------------------------------------------------
function studentID = parseCourseID(filename)

    % start going through each letter in the filename
    for i = length(filename):-1:1
       
        % check to see if letter is underscore
        % we found the bug! when only looking from left to right
        % if you have a file name like 'Fwd_Deriv_1199' it finds the first
        % underscore and not the second one... -Jared 1/29/2019
        if filename(i) == '_'
            parsedID = filename(i+1:i+4);
            
            % check to see if any of the 4 digits are letters
            if any(isletter(parsedID))
                break; % send to bad ID catcher
            else % if not, then convert and exit
                studentID = str2num(parsedID);
                return;
            end
            
        end
    end
    
    studentID = -1234; % bad ID - to be caught in roster linker function
end
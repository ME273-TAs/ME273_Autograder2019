function [Score, Feedback] = Speedy_Grader(filename)

%--------------------------------------------------------------
% FILE: Speedy_Grader.m   
% AUTHOR: Jared Oliphant
% DATE: 5 March 2019
% 
% PURPOSE: Speedy Grading happened elsewhere! This code is only to input
% the saved scores and to place them with the particular student
% 
% INPUTS: 
%   filename - a filename corresponding to a student's code
% 
% 
% OUTPUT: 
%   Score - a scalar between 0 and 1
%   Feedback - a character array of feedback, containing a grades breakdown.
%
% 
% VERSION HISTORY
% V1 - 
% V2 - 
% V3 - 
% 
%--------------------------------------------------------------



% load the data for Speedy
speedyData = load('Speedy_Grades.mat')

% seperate into the IDs and the Scores
allIDs = speedyData.Speedy_IDnums
allScores = speedyData.Speedy_Scores;

% what is this student's ID number
studentNumber = str2double(filename(end-5:end-2));

% where can we find that id number in the array?
index = find(allIDs == studentNumber);

if ~isempty(index)
    % this student's score
    Score = allScores(index)
else
    error(['no score for student ',num2str(studentNumber)])
end


if isnan(Score)
    Score = 0;
    Feedback = "Your code either crashed, or did not produce a solution within the specified domain and tolerances. To test your code, initialize a RacingFunction, call your code using the syntax specified in the Lab Handout, and then check that your solution meets the criteria in the Lab Handout."
else
    Feedback = "";
end



end
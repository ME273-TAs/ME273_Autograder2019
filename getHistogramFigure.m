function [ImageArray] = getHistogramFigure(master,labnum)
%============================================BEGIN-HEADER=====
% FILE: getHistogramFigure.m
% AUTHOR: Jared Oliphant
% DATE: 9 April 2019
%
% PURPOSE:
%   This function extracts the scores from only the people that have been
%   graded, creates a histogram of the data and returns it as an image
%   array.
%
% INPUTS:
%   master - the master table for the lab
%   
%   labNum - integer representing number for this lab
%
% OUTPUTS:
%   ImageArray - RGB image array of a histogram
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======
% get the scores our the master table, based on labnum
eval(['scores = master.Lab',num2str(labnum),'Score;'])
% only want the scores for students how have been graded previous or who
% were graded right now
relevantScores = 100*scores(master.FeedbackFlag >= 1);
% create an invisible image
fig1 = figure('visible','off');
% and axes
ax = axes(fig1);
% and histogram on that axes
histogram(ax,relevantScores,'FaceColor','b')
xlim([-5,105])
% get the frame
F = getframe(fig1);
% convert the frame to an image array
[ImageArray, ~] = frame2im(F);

end
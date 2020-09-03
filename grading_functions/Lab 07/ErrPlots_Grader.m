function [Score, Feedback] = ErrPlots_Grader(filename,finalGrade)
%--------------------------------------------------------------
% FILE: ErrPlots_Grader.m
% AUTHOR: Jared Oliphant
% DATE: 3/15/2018
%
% PURPOSE: Function for grading Lab 9, part 3: Error plotting function
%
% INPUTS:
%   filename - a filename corresponding to a student's code
%   finalGrade - final grading flag
%
%
% OUTPUT:
%   Score - a scalar between 0 and 1
%   Feedback - a character array of feedback, containing a grades breakdown.
%
%
% VERSION HISTORY
% V1 - original
% V2 - Built in a error checker that will allow the students to flip the
% inputs 'N' and 'fhs' because the lab handout was a little too tricky and
% unfair.
% V3 -
%
%--------------------------------------------------------------
Feedback = '';
numweight = 0.3;     %percentage of score based on having the right number of axes (2)
logweight = 0.05;     %percentage of score based on having a log scale on 2nd plot
legendweight = 0.1; %percentage of score based on having any kind of legend on either plot
Score = 0.55;        %bonus to add up to 1
% the TRY/CATCH structure is used to prevent code crashes
try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================|
    StudentFunction = filename(1:end-2)    % get function name     |
    %=================================================|
    
    
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    fh = @odeproblem;
    Xrange = [0 1.4];
    y0 = -1;
    N = [3:10];           %vector of N steps
    fhs = @odesolution;
    %=================================================
    
    
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = [StudentFunction,'(fh, Xrange, y0, fhs, N);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    hLegend = findobj(gcf, 'Type', 'Legend');   %extracts the legend
    hAxes = findobj(gcf, 'Type', 'Axes');   %extracts the axes in backward order
    
    %should have 2 plots with 5 lines each;  should have 2 total axes
    if  length(hAxes) == 2
        Score = Score + numweight;
        Feedback = [Feedback,'Looks like you have the correct number of axes.'];
        
        %Extract the 2 plots
        Stepsz_plot = hAxes(2);
        Effort_plot = hAxes(1);
        
        %this section will check the yscale on both plots to make sure it
        %is log
        if string(Effort_plot.YScale) == "log" || string(Stepsz_plot.YScale) == "log"
            Score = Score + logweight;
            Feedback = [Feedback,'  --  Good job setting the yscale to ''log''.'];
        else
            Feedback = [Feedback,'  --  If you set the yscale on your plots to log it will likely be much more readable: use set(gca,''yscale'',''log'')'];
        end
        
    else % they didn't have the right number of lines / axes so the previous grading would have been impossible.
        Feedback = [Feedback,'Looks like you have an incorrect number of lines or axes.'];
    end
    
    
    %this check to see if a legend exists. it does not check the entries in
    %the legend.
    if ~isempty(hLegend)
        Score = Score + legendweight;
        Feedback = [Feedback,'  --  Good job on your legend.'];
    else
        Feedback = [Feedback,'  --  A legend would be a good idea in this scenario, otherwise the information is not communicated properly.'];
    end
    
    %==================================================
    
    
    %====================================================================================
    % ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR
    try
        %================================================================================
        % Running student code
        CallingString = [StudentFunction,'(fh, Xrange, y0, N, fhs);'];        % A string passed to eval.
        eval(CallingString)                                         % evaluate the function
        %================================================================================
        
        %==================================================
        % GRADING SECTION - evaluate student work here.
        hLegend = findobj(gcf, 'Type', 'Legend');   %extracts the legend
        hAxes = findobj(gcf, 'Type', 'Axes');   %extracts the axes in backward order
        
        %should have 2 plots with 5 lines each;  should have 2 total axes
        if  length(hAxes) == 2
            Score = Score + numweight;
            Feedback = [Feedback,'Looks like you have the correct number of axes.'];
            
            %Extract the 2 plots
            Stepsz_plot = hAxes(2);
            Effort_plot = hAxes(1);
            
            %this section will check the yscale on both plots to make sure it
            %is log
            if string(Effort_plot.YScale) == "log" || string(Stepsz_plot.YScale) == "log"
                Score = Score + logweight;
                Feedback = [Feedback,'  --  Good job setting the yscale to ''log''.'];
            else
                Feedback = [Feedback,'  --  If you set the yscale on your plots to log it will likely be much more readable: use set(gca,''yscale'',''log'')'];
            end
            
        else % they didn't have the right number of lines / axes so the previous grading would have been impossible.
            Feedback = [Feedback,'Looks like you have an incorrect number of lines or axes.'];
        end
        
        
        %this check to see if a legend exists. it does not check the entries in
        %the legend.
        if ~isempty(hLegend)
            Score = Score + legendweight;
            Feedback = [Feedback,'  --  Good job on your legend.'];
        else
            Feedback = [Feedback,'  --  A legend would be a good idea in this scenario, otherwise the information is not communicated properly.'];
        end
        Feedback = ['Careful about flipping your inputs to this function.  ',Feedback];
    catch ERR   % even the flipped inputs didn't fix their code all the way.
        %==============================================================
        % Zero score if the code doesn't run:
        Score = 0;      % give score of 0
        % An explanation of the zero score and the MATLAB error message.
        Feedback = regexprep(ERR.message,'\n',' ');   % second ERROR feedback message
        %==============================================================
    end
end

close all  % this will close the GUI as well as all open figures


%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE.
% Note: Final score must between 0 and 1.
index = Score < 0;     % Checking the bounds of score
Score(index) = 0;
index = Score > 1;
Score(index) = 1;
% NORMALIZE THE SCORE (0 <= score <= 1)
%
%========================================================================

Feedback
Score
end


%needs to be able to accept vectors as well as scalars just in case
function dydx = odeproblem(x,y)
dydx = (2*cos(x).^2-sin(x).^2+y.^2)./(2*cos(x));
end
%needs to be able to accept vectors as well as scalars
%some students wrote their code such that the @fhs function have 2 inputs,
%thus the varargin (variable number of input arguments
function y = odesolution(x,varargin)
y = sin(x) + 1./(-.5*sin(x)-cos(x));
end
function [Score, Feedback] = ODEcharts_Grader(filename)
%--------------------------------------------------------------
% FILE: ODEcharts_Grader.m   
% AUTHOR: Jared Oliphant
% DATE: 3/15/2018
% 
% PURPOSE: Function for grading Lab 9, part 2: ODE chart plotting function
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

Feedback = '';
numweight = 0.05;      %percentage of grade based on having the right number of axes and lines
Titleweight = 0.05;      %percentage of grade based on having all of the subplots with titles
Butweight = 0.05;      %percentage of grade based on their butcher solution
Eulweight = 0.05;      %percentage of grade based on their euler solution
SSRplotweight = 0.1;      %percentage of grade based on the Xticklabels and the log Yscale on the SSR plot
SSRweight = 0.2;      %percentage of grade based on the exactness of the SSR vector that they return
Score = 0.6;           %bonus to add up to 1
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
    N = 6;
    fhs = @odesolution;
    SSR_Solution = [0.236007079609592   0.000059393884433   0.001786386197498   ...
        0.000008123843983   0.000000008441636];   % 
    %=================================================

    % c = categorical({'apples','pears','oranges'});
    % prices = [1.23 0.99 2.3];
    % bar(c,prices)
    % This code runs fine in MATLAB 2017a but crashes in MATLAB 2018a.


	% the solution to the two solvers that we did not check already
    Eul_solution = [-1 -0.580000000000000 -0.273025436876599 -0.070100348590151  0.001515250692881 -0.136832340769474];
    But_solution = [-1 -0.633369706381932 -0.367409333915728 -0.217095029453371 -0.228906522286068 -0.523455032414607];

    %================================================================================
    % Running student code
    CallingString = ['[SSR] = ',StudentFunction,'(fh, Xrange, y0, N, fhs);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================

    %==================================================
    % GRADING SECTION - evaluate student work here.
    hAxes = findobj(gcf, 'Type', 'Axes');   %extracts the axes in backward order as well
   
    % should have 6 total axes
    if  length(hAxes) == 6 
        Score = Score + numweight;
        Feedback = [Feedback,'Looks like you have the correct number of axes'];
        
        %seperate each of the plots in order to check titles etc.
        % this makes the big assumption that the plots will be in this
        % exact order...
        Eul_plot = hAxes(6);
        Mid_plot = hAxes(5);
        Ral_plot = hAxes(4);
        RK4_plot = hAxes(3);
        But_plot = hAxes(2);
        SSR_plot = hAxes(1);
        
        % extract the lines from the Butcher and Euler graphs
        But_Lines = get(But_plot,'Children');
        Eul_Lines = get(Eul_plot,'Children');
        
        % search the butcher lines for one that matches the solution
        good = 0;
        for l = 1:length(But_Lines)
            currentLine = But_Lines(l);
            if length(currentLine) == 6
                if norm(currentLine(:)' - But_solution) < 0.1
                    good = 1;
                end
            end
        end
        if good == 1 
            Score = Score + Butweight;
        end
        
        % search the euler lines for one that matches the solution
        good = 0;
        for l = 1:length(Eul_Lines)
            currentLine = Eul_Lines(l);
            if length(currentLine) == 6
                if norm(currentLine(:)' - Eul_solution) < 0.1
                    good = 1;
                end
            end
        end
        if good == 1 
            Score = Score + Eulweight;
        end
        
        
        %check to see if every subplot has it's own title like the image in the
        %lab handout
        if ~isempty(Eul_plot.Title) &&  ~isempty(Mid_plot.Title) && ...
            ~isempty(Ral_plot.Title) &&  ~isempty(RK4_plot.Title) && ...
            ~isempty(But_plot.Title) &&  ~isempty(SSR_plot.Title)    %will return true if a title exists on every plot
        
            Score = Score + Titleweight;
            Feedback = [Feedback,'   ---   Good job on your titles'];

        else
            Feedback = [Feedback,'   ---   Some of your plots may be missing titles: use title(''text'')'];
        end 

        
        %check to see if the X labels on the bar chart are letters
        %as well as check to see if they used a log scale on the yaxis
        strings = string(SSR_plot.XTickLabel);
        if length(strings) == 5
            together = strcat(strings(1),strings(2),strings(3),strings(4),strings(5)); %concantenate all the labels together
            check = ~isempty(regexp(together,'[^\n]\D[^\n]*', 'once')); %should be true if they have any non-number in their x labels
        else
            check = 0;
        end
        if check == 1 && string(SSR_plot.YScale) == "log"
            Score = Score + SSRplotweight;
            Feedback = [Feedback,'   ---   Good job with the X label on the SSR bar chart as well as setting the Yscale to logarithmic.'];
        else
            Feedback = [Feedback,'   ---   Your SSR bar chart is missing the appropiate X labels and/or the Yscale was not logarithmic: use set(gca,''xticklabel'',{''E'',''H'',''M'',''R'',''4RK''})  and   set(gca,''yscale'',''log'')'];
        end
        
        
    else  %they didn't have the right number of axes and lines so it will be difficult to do much of the grading.
        Feedback = [Feedback,'Looks like you have the incorrect number of lines and axes'];
    end
  
   
    %This section checks the only output of the function to see if it
    %matches the solution.
    if length(SSR_Solution) == length(SSR)
        if norm(SSR_Solution - SSR(:)') < .05
            Score = Score + SSRweight;                                           
            Feedback = [Feedback,'   ---   Your SSR vector matched perfectly'];
        else
            Feedback = [Feedback,'   ---   Your SSR vector did not match the solution.   norm(SSR - SSRsol) = ',num2str(norm(SSR_Solution - SSR))];   %num2str(norm(SSR_Solution - SSR))
        end
    else
        Feedback = [Feedback,'   ---   Your SSR vector was not the right length, it should have one value per ODE solver method.'];
    end
    
    

        
    %==================================================
    
    
%====================================================================================
% ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR  
   
    %==============================================================
    %Zero score if the code doesn't run:   
    Score = 0;      % give score of 0
    %An explanation of the zero score and the MATLAB error message. 
    Feedback = regexprep(ERROR.message,'\n',' ');     
    %==============================================================
   
    
end


% close all figures (except the Grading GUI)
% figs2keep = [1];
% all_figs = findall(0, 'type', 'figure');
% delete(setdiff(all_figs, figs2keep));
close all

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
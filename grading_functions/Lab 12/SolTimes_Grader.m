function [Score, Feedback] =  SolTimes_Grader(filename,finalGrade)
%--------------------------------------------------------------
% FILE: SolTimes_Grader.m
% AUTHOR: Jared Oliphant
% DATE: 1 Apr 2018
%
% PURPOSE:
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
% V1 -
% V2 -
% V3 -
%
%--------------------------------------------------------------

Score = 0.25;                % bonus score (run without errors)
AxesLabelPoints = 0.1;       % has axes labels or title
HasLegendPoints = 0.1;       % has a legend
LegContentPoints = 0.1;      % legend contains 'rref' and 'linsolve'
LegSortedPoints = 0.1;       % 'rref' comes before 'linsolve'
NumLinesPoints = 0.1;        % has 2 lines in the graph
XDataPoints = 0.1;           % the xdata of those lines is MSizes
TimesMatrixPoints = 0.15;    % the returned matrix is 3x4


Feedback = '';
StudentFunction = filename(1:end-2);   % get function name

try
    
    MSizes = [5,10,15];
    % Methods: [ linsolve(), A\b, inv(A)*b, rref() ]
    Methods = [1,0,0,1];
    
    %================================================================================
    % Running student code
    close all
    CallingString = ['[StudentTimes] = ',StudentFunction,'(MSizes, Methods);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================
    
    Legend = findobj(gcf, 'Type', 'Legend');  %extracts the legend
    Plot = findobj(gcf, 'Type', 'Axes');      % extracts the plot
    Lines = get(Plot,'Children');             % get lines out of the plot
    xLabel = Plot.XLabel.String;              % get x label
    yLabel = Plot.YLabel.String;              % get y label
    title = Plot.Title.String;                % get title
    
    % get some points if they have any x and y labels
    if ~isempty(xLabel) && ~isempty(yLabel)
        Score = Score + AxesLabelPoints;
    else
        % they don't have axes labels but they have title, still give
        % points
        if ~isempty(title)
            Score = Score + AxesLabelPoints;
        else
            Feedback = [Feedback,' Missing one or both axis labels; also no Title.'];
        end
    end
    
    
    % get some points for having a legend
    if ~isempty(Legend)
        Score = Score + HasLegendPoints;
        
        % extract the strings from the legend
        legendStrings = Legend.String;
        Strings = "";
        for i = 1:length(legendStrings)
            Strings = strcat(Strings,legendStrings{i}," ");
        end
        
        % get some points if they have something in their legend that looks
        % right
        if contains(Strings,'rref','IgnoreCase',true) ...
                && contains(Strings,'linsolve','IgnoreCase',true) ...
                && length(legendStrings) == 2
            Score = Score + LegContentPoints;
            % rref should always be slower than linsolve for these matrix
            % sizes
            if strfind(upper(Strings),upper('rref')) < strfind(upper(Strings),upper('linsolve'))
                Score = Score + LegSortedPoints;
            else
                Feedback = [Feedback,' Incorrect ordering of legend entries.'];
            end
            
        else
            message = ['The grader thinks this student does NOT have the correct legend entries; ',...
                'if they have something that indicates rref and linsolve ONLY (in that order), ',...
                'enter YES, otherwise enter NO'];
            answer = questdlg(message,'Human Grading Question','Yes','No','No');
            if strcmp(answer,'Yes')
                Score = Score + (LegContentPoints + LegSortedPoints);
            else
                Feedback = [Feedback,' Missing or incorrect legend entries.'];
            end
        end
    else
        Feedback = [Feedback,' Missing a legend.'];
    end
    
    % get some points if they have the correct number of lines plotted
    if length(Lines) == 2
        Score = Score + NumLinesPoints;
        
        % get some points if they have proper data in the X
        if ~nnz(Lines(1).XData ~= MSizes) && ~nnz(Lines(2).XData ~= MSizes)
            Score = Score + XDataPoints;
        else
            Feedback = [Feedback,' The xdata of your plots is not the same as MSizes.'];
        end
        
    elseif length(Lines) > 2
        Feedback = [Feedback,' Plotted extra lines than those requested by Methods.'];
    else
        Feedback = [Feedback,' Didn''t plot enough lines as requested by Methods.'];
    end
    
    
    % get some point is they returned times matrix is the right size (3x4)
    if size(StudentTimes,1) == 3 && size(StudentTimes,2) == 4
        Score = Score + TimesMatrixPoints;
    else
        Feedback = [Feedback,' The returned times matrix was not the appropiate ',...
            'size. It should always have 4 columns regardless of what Methods were activated'];
    end
    
    
    
    %====================================================================================
    % ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR
    
    %==============================================================
    % Zero score if the code doesn't run:
    Score = 0;
    % Return the MATLAB error message.
    foundat = 1;
    % loop through the stack looking for the element that came from the
    % student's code, if we don't find it foundat = length(ERROR.stack)
    for i = 1:length(ERROR.stack)
        if strcmp(ERROR.stack(i).name,StudentFunction)
            foundat = i;
            break;
        end
    end
    % hopefully more helpful Feedback Error message
    Feedback = ['Your code had an error that originated from ''',...
        ERROR.stack(foundat).name,''' on line ',...
        num2str(ERROR.stack(foundat).line),'. >>> Message: ',...
        regexprep(ERROR.message,'[\n\r]+',' ')];
    
    %==============================================================
    
end
close(gcf)

end
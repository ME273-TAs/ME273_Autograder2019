classdef guiDatePicker < handle

%============================================BEGIN-HEADER=====
% FILE: guiDatePicker.m
% AUTHOR: Caleb Groves
% DATE: 14 August 2018
%
% PURPOSE:
%   Creates a date picker gui panel with a default check button.
%
% INPUTS:
%   The parent, title, x and y position, and default date (in Matlab
%   datetime) for the date picker panel.
%
%
% OUTPUTS:
%   Handle for the panel.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======
    
    properties
        panel
        edit
        checkButton
        defaultDate
    end
    
    methods
        
        % Constructor
        function self = guiDatePicker(parent, title, posx, posy,...
                defaultDate)
            
            self.defaultDate = defaultDate;
            % Panel
            self.panel = uipanel(parent, 'Title', title, 'Position', ...
                [posx posy .8 .1]);

            % Text edit box
            self.edit = uicontrol(self.panel, 'Style', 'edit', 'Enable', ...
                'off', 'Units', 'Normalized', 'Position', [0.35 .25 .5 .5]);

            % Checkbutton
            self.checkButton = uicontrol(self.panel, 'Style', 'checkbox', ...
                'Units', 'Normalized', 'String', 'Default', ...
                'Position', [.1 0 .2 1], 'Value', 1, 'Callback', ...
                @self.changeDate, 'CreateFcn', @self.changeDate);

        end % end constructor

        % Callback function for checkbox
        function changeDate(self, hObject, ~)

            % if the check box is checked
            if hObject.Value == 1
                % then date displayed is the default
                self.edit.String = datestr(self.defaultDate);
                self.edit.Enable = 'off';
            else % if it's not checked
                % allow the user to specify
                self.edit.String = datestr(uigetdate(self.defaultDate));
                self.edit.Enable = 'on';
            end

        end
        
        % Function for resetting the default date
        function resetDefaultDate(self,newDefaultDate)
            
            self.checkButton.Value = 1;
            self.defaultDate = newDefaultDate;
            
            self.edit.String = datestr(self.defaultDate);
            self.edit.Enable = 'off';
    
        end % end function resetDefaultDate

    end % end methods
    
end % end classdef
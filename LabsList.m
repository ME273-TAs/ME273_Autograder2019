classdef LabsList < handle
    %LabsList - Class for holding and accessing Lab objects. Useful with
    %the AutograderGUI.m class for creating the dropdown menu for selecting
    %a lab.
    %   Contains a cell array property 'labs' that stores Lab objects, and
    %   a counter 'numLabs' that keeps track of the length of the cell
    %   array. 
    %   Has methods for accessing the labs, adding labs, and adding lab
    %   parts to the most recently added lab.
    
    properties
        labs
        numLabs
    end
    
    methods
        % Constructor
        function self = LabsList
            % Initialize with no labs
            self.labs = cell(0,1);
            % set counter
            self.numLabs = 0;
        end % end constructor
        
        % Function for adding a lab to the end of the list
        function addLab(self, num, dueDate, language)
            self.numLabs = self.numLabs + 1; % increment counter
            self.labs{end+1} = Lab(num, dueDate, language); % add on lab to cell array
        end % end function addLab
        
        % This function adds a lab part to the last-added lab in the list.
        % It assigns the default path for graderFile's to be in
        % 'grading_functions'.
        function addLabPart(self, name, graderFileName)
            self.labs{end}.addLabPart(name, graderFileName, ...
                fullfile('grading_functions')); % 
        end % end function addLabPart
        
        % Returns an array of all of the lab numbers currently assigned.
        function labNums = getLabNumbers(self)
            % initialize array
            labNums = zeros(self.numLabs,1);
            % get each lab number
            for i = 1:self.numLabs
                labNums(i) = self.labs{i}.num;
            end
        end % end function getLabNumbers
        
        % Returns the lab whose number matches the input integer 'num'.
        function lab = getLab(self, num)
            lab = 0; % initialize lab as an integer
            
            % go through all currently held labs
            for i = 1:self.numLabs
                % if num matches the current lab's number
                if num == self.labs{i}.num
                    lab = self.labs{i}; % assign matching Lab to lab variable
                end
            end
            
            % if 'lab' variable is still an integer
            if isinteger(lab)
                % it was never matched, and that's an error
                error('Invalid lab number');
            end
        end % end function getlab
    end
    
end


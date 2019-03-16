classdef AutograderGUI < handle
    %AutograderGUI - object that creates the visual interface for running
    %the ME273 autograder.
    %   An object of this class creates a graphical user interface that
    %   guides a user through the selection of parameters for running the
    %   function programSetup.m, which is the main top-level function for
    %   the ME273 autograder program. This class requires a labsList
    %   object for initialization. This class needs only to be initialized
    %   and it will call all of the necessary functions in order to create
    %   the GUI and start the autograding process.
    %
    %   NOTE: Only up to five (5) lab subassignments will be displayed
    %   using this version of the AutograderGUI. A future implementation
    %   could integrate a scrollbar into the GUI in order to allow you to
    %   add more than five (5) lab subassignments.
    
    properties
        labsList
        currentLab
        fig
        settingsGUI
        labPartsGUI
    end
    
    methods
        
        % Constructor - called when this class is instantiated.
        function self = AutograderGUI(labsList)
            % Initialize labs list
            self.labsList = labsList;
            
            % create figure for gui
            self.fig = figure('Visible','off','NumberTitle','off','Name',...
                'ME273 Autograder','Position',[100 124 1200 650],...
                'Resize','off');
            
            % set current lab to nothing
            self.currentLab = nan;
            
            % check to see if roster exists
            if ~exist('roster.csv','file')
                out = selectRosterFile(self,0,0,1);
                
                % if no file was selected
                if out == -1
                    % destroy the GUI
                    delete(self.fig);
                    return; % exit the program
                end
            end
            
            % create dummy directory
            if ~isdir('dummy')
                mkdir('dummy');
            end
            
            
            % initialize and configure the main panels for the gui
            self.labPartsGUI = makeLabPartsGUI(self);
            self.settingsGUI = makeSettingsGUI(self);
            
            % show the figure
            self.fig.Visible = 'on';
            
        end
        
        % Creates the panel for the overall lab settings
        function gui = makeSettingsGUI(self)
            gui.panel = uipanel(self.fig, 'Title', 'Lab Settings', ...
            'Position',[0 0 .5 1]);

            % Lab selection
            gui.select_lab.panel = uipanel(gui.panel, 'Title', 'Select Lab',...
            'Position',[.1 .85 .8 .1]);

            % set callback for lab select dropdown box
            labBoxCallback = @self.updatePartMger;

            gui.select_lab.box = uicontrol(gui.select_lab.panel, 'Style', ...
            'popup', 'String', self.labsList.getLabNumbers(), 'Units', 'Normalized',...
            'Position', [0.4 0.1 0.3 0.8],'callback',labBoxCallback,...
            'createfcn',labBoxCallback);

            gui.select_lab.text = uicontrol(gui.select_lab.panel, 'Style',...
            'text', 'String', 'Lab Number:', 'Units', 'Normalized', ...
            'Position', [0.0 0.05 0.3 0.8]);

            % Due Date
            gui.due_date = guiDatePicker(gui.panel, 'Monday Due Date', ...
            .1, .75, self.currentLab.dueDate);

            gui.pseudo_date = guiDatePicker(gui.panel, 'Psuedo Date', ...
            .1, .65, datetime(datestr(now)));
        
            % Roster file settings
            gui.roster_file = uicontrol(gui.panel,'Style','pushbutton',...
                'String', 'Select New Student Roster...', 'Units', 'Normalized', 'Position', ...
                [.25 .55 .5 .05],'callback',{@self.selectRosterFile, 2});

            % Manual grading options
            gui.grading_opts.panel = uibuttongroup(gui.panel, 'Title', ...
            'Grading Options', 'Position', [.1 .25 .8 .25]);

            gui.grading_opts.original_grading = uicontrol(gui.grading_opts.panel,...
            'Style', 'radiobutton', 'String','Original','Units','Normalized',...
            'Position',[.1 .8 .8 .1], 'Value', 1);

            gui.grading_opts.resubmission_grading = uicontrol(gui.grading_opts.panel,...
            'Style', 'radiobutton', 'String','Resubmission','Units','Normalized',...
            'Position',[.1 .6 .8 .1], 'Value', 0);

            gui.grading_opts.manual = uicontrol(gui.grading_opts.panel,...
            'Style', 'checkbox', 'String','Manual','Units','Normalized',...
            'Position',[.1 .4 .6 .1]);

            % Grade button
            gui.grade = uicontrol(gui.panel, 'Style', 'pushbutton', ...
                'String', 'GRADE', 'Units', 'Normalized', 'Position', ...
                [.25 .1 .5 .1],'callback',@self.gradeLab);
        end
        
        % Creates the panel for the lab part settings
        function gui = makeLabPartsGUI(self)
            % create the uipanel for this side of the figure
            gui.panel = uipanel(self.fig, 'Title', 'Lab Parts', ...
                'Position', [.5 0 .5 1]);
            % initialize the lab parts cell structure      
            gui.parts = cell(0,1);
            
        end
        
        % Callback function for the dropdown lab selector box. Updates the
        % current lab that the gui displays and prepares for grading.
        function updatePartMger(self,hObject,~)
            % get the selected lab number
            idx = hObject.Value;
            labNum = str2num(hObject.String(idx));
            
            % get that lab from the labs list
            self.currentLab = self.labsList.getLab(labNum);
            
            % if there are more than 5 parts we need to make the figure
            % slightly taller [x,y,width,height]
%             if self.currentLab.numParts > 5
%                 set(self.fig, 'Position',[100 124 1200 800]);
%             else
%                 set(self.fig, 'Position',[100 124 1200 650]);
%             end
            
            % update duedate picker
            try
                self.settingsGUI.due_date.resetDefaultDate(...
                    self.currentLab.dueDate);
            catch
            end
            
            % create the appropriate lab panels
            createLabPartPanels(self);

        end
        
        % Uses the current lab selected to create and display the lab part
        % panels in the gui
        function createLabPartPanels(self)        
            
            % delete the old lab part panels
            h = self.labPartsGUI.panel.Children;
            
            delete(h);
            
            % get number of lab parts
            n = self.currentLab.numParts;
            
            % reset the number of lab part panels
            self.labPartsGUI.parts = cell(n,1);
            
            % for each lab part in the current lab
            for i = 1:n
                % get parameters for panel creation
                parent = self.labPartsGUI.panel;
                name = self.currentLab.parts{i}.name;
                defaultGrader = self.currentLab.parts{i}.graderFile;
                
                % calculate the vertical position of this panel
%                 if n > 5
%                     posy = 1 - i*1/n;
%                 else
%                     posy = 1 -  i*0.2;
%                 end
                
                posy = 1 -  i*0.2;
                
                % create a lab part panel and store it
                self.labPartsGUI.parts{i} = getLabPartPanel(parent, ...
                    name, defaultGrader, posy, n);
                
            end % end for
            
        end % end function
        
        % Grade lab function - called when Grade button is pushed
        function gradeLab(self,~,~)
            
            % change button text
%             self.settingsGUI.grade.String = 'Busy Grading...';
%             self.settingsGUI.grade.Enable = 'off';
%             self.settingsGUI.grade.BackgroundColor = 'red';
           
            % Get all of the arguments for programSetup.m
            % Lab number
            labNum = self.currentLab.num;
            
            % Get dates from edit boxes
            try
                dueDate = datetime(self.settingsGUI.due_date.edit.String);
                pseudoDate = datetime(self.settingsGUI.pseudo_date.edit.String);
            catch % if it failed, assume a formatting error
                errordlg(['One of the dates is formatted incorrectly. ',...
                    'Please fix to be YYYY-MM-DD HH:MM:SS format, or ',...
                    'just use the datetime picker.']);
                return; % exit the function
            end
            
            % set roster
            roster.name = 'roster.csv';
            roster.path = '';
            
            % regrading and manual grading
            regrade = self.settingsGUI.grading_opts.resubmission_grading.Value;
            manual.flag = self.settingsGUI.grading_opts.manual.Value;
            manual.feedbackFlag = 2;
            
            if regrade
                manual.gradingAction = 3;
            else
                manual.gradingAction = 1;
            end
            
            % Get lab part data
            n = self.currentLab.numParts;
            
            labParts = cell(n,1);
            
            for i = 1:n
                % get lab part name
                labParts{i}.name = self.currentLab.parts{i}.name;
                % get current submissions directory
                labParts{i}.submissionsDir = ...
                    self.labPartsGUI.parts{i}.sub.edit.String;
                
                % show an error if the submissions directory is blank
                if ~isdir(labParts{i}.submissionsDir)
                    uiwait(msgbox(['There must be a submissions directory ',...
                        'for lab subassignment ',labParts{i}.name,...
                        ' or the box ''None'' must be ',...
                        'checked.'],'Submissions Directory Error','error',...
                        'modal'));
                    return;
                end
                
                % get selected grader file
                graderFileFull = self.labPartsGUI.parts{i}.grader.edit.String;
                
                % check to make sure file exists
                try % if the selected grader file exists this won't throw an error
                    finfo(graderFileFull);
                catch % if the selected grader file doesn't exist
                    % Show an error box
                    uiwait(msgbox(['Unable to find grader file for ',...
                        labParts{i}.name, '. Please select a valid ',...
                        'grader file.'],'Grader File Error','error',...
                        'modal'));
                    return; % exit the function
                end
                
                % separate out the file from its name and path
                [filepath, name, ext] = fileparts(graderFileFull);
                
                % assign the name and path to the labParts fields
                labParts{i}.graderfile.name = strcat(name,ext);
                labParts{i}.graderfile.path = filepath;
            end
            
            % Call programSetup            
            programSetup(self.currentLab, labParts, roster, regrade, manual, pseudoDate);
            
            % show finished message
            uiwait(msgbox(['Lab ',num2str(labNum),' grading complete!'],...
                'Grading Complete','help','modal'));
            self.settingsGUI.grade.String = 'Grade';
            self.settingsGUI.grade.Enable = 'on';
            self.settingsGUI.grade.BackgroundColor = 'white';

        end % end function gradeLab
        
        % Allows the user to select a .csv file to use as the roster. Uses
        % dialog boxes to prompt the user for a file, and then copies that
        % file into the autograder_core directory as 'roster.csv'.
        % Overwrites any previous 'roster.csv' file in this directory.
        % Throws an error if the process is cancelled and no roster can be
        % found.
        function out = selectRosterFile(~,~,~,mode)
                      
            % prompt user to select a file
            % give some info
            uiwait(msgbox(['In order for the ME273 autograder to run,'...
                ,' the program needs a current roster of the students enrolled ',...
                ' in the course, in the form of a .csv file. The file should ',...
                'have the following columns (in any order): ',...
                'Last Name, First Name, Section Number, Email, CourseID.',...
                ' The CourseID column should be a unique 4-digit number assigned ',...
                'to the student for the duration of the course, and the ',...
                'email should be the one listed for the student on their ',...
                'official BYU contact information.'],...
                'Roster File Selection Prompt','warn','modal'));
            
            
            % get file through dialog box
            [filename, path] = uigetfile('*.csv');
            
            % deal with a cancelled file selection
            if isnumeric(filename) && isnumeric(path) % no file selected
                if mode == 1 % no roster on startup
                    % display an error message
                    uiwait(msgbox(['This program must have a roster ',...
                        'file in order to run.'],'Roster Error',...
                        'error','modal'));
                    out = -1;
                    return;
                else % no roster on button click
                    out = 0;
                    return; % just forget it
                end
            elseif strcmp(filename,'roster.csv') && contains(path,'autograder_core')
                uiwait(msgbox(['Existing roster has been selected.',...
                    ' No changes will be made.'],'Roster Selection',...
                    'warn','modal'));
                out = 0;
                return;
            else
                uiwait(msgbox([fullfile(path,filename),' will replace ',...
                    'the old roster file.'],'Roster Replacement','help','modal'));
            end
            
            % delete the old roster
            delete('roster.csv');
            
            % copy file to main dir as 'roster.csv'
            copyfile(fullfile(path,filename),'roster.csv');
            
            % output code
            out = 1;
            
        end % end function selectRosterFile
        
    end % end methods
    
end % end class
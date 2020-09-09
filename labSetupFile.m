function L = labSetupFile()
%============================================BEGIN-HEADER=====
% FILE: labSetupfile
% AUTHOR: Caleb Groves
% DATE: 15 August 2018
%
% PURPOSE:
%   This file is used to specify and organize the lab assignments in a way
%   that the rest of the program can interpret them.
%
% INPUTS: none
%
% OUTPUTS:
%   Returns a LabsList object, which contains all of the pertinent
%   information and functions necessary for the GUI to read in the labs.
%
% ---EXAMPLE:
% Lab 1
% L.addLab(1,datetime(2018,1,26,16,0,0),'MATLAB');
% the integer value is used as a unique integer identifier - could be negative or strange numbers for test labs
% The datetime object is a way to specify the lab's default due date: year,
% month, day, hour (24 hour scheme), minute, second.
% The last input is a character array specifying the language used for the lab.
% L.addLabPart('Newton','Newton_Grader.m'));  % "Newton" is the name of this subassignment. "Netwon_Grader.m" is the name of the grading routine
% L.addLabPart('Bisect','Bisect_Grader.m');   % Similar as above
%
% To include assignment-level subfolders by default:
% L.addLabPart('Newton',fullfile('Lab 01','Newton_Grader.m'));  % This approach will bring up the "Lab 01" subfolder in the GUI.
% L.addLabPart('Bisect',fullfile('Lab 01','Bisect_Grader.m'));
%
% NOTES:
%  - THIS FILE DOES NOT NEED TO BE RUN, just saved.
%
%  - LIMITATIONS: Currently, only five (5) lab subassignments will show up
%   in the GUI (as of v4.0.1); a future implementation should alter
%   AutograderGUI.m in order to display all of the lab subassignments
%   (using a scrollbar or something).
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======
% Create labs list object
L = LabsList();


%{
      ------- FORMAT FOR SETTING UP LABS -------
% Lab X
L.addLab( LABNUMBER , DUE DATE , LANGUAGE , CHANCES)
L.addLabPart( PARTNAME , LOCATION OF PARTGRADERFILE )

                -------- Lab --------
LABNUMBER - The corresponding Lab Number
DUE DATE - Format as a datetime input with the date and time (1600 hrs) of
            the due date of the MONDAY lab section
LANGUAGE - 'MATLAB' or 'C++', whichever language is used in Lab X
CHANCES - The number of chances allotted to the students to use for free
            feedback. Typ. 2 or 1

              -------- Lab Part --------
PARTNAME - A unique part name to identify the lab part. This will show up
            in the GUI, Feedback CSVs, Dynamic CSVs, Static CSVs, and the
            Feedback Spreadsheet that the students will see. Should be
            descriptive
LOCATION OF PARTGRADERFILE - Where in the autograder structure
            (specifically in grading_functions) to find the LabPartGrader
            file. Formatted using fullfile which will handle formatting the
            path to the grader file. What is needed:
                folder(s) within grading_functions where the grader file is
                        contained
                file name of the respective part grader (including .m)
            more info can be found in the fullfile documentation
%}

% Lab 1
L.addLab(1,datetime(2020,9,07,16,0,0),'MATLAB',2);            % the integers a unique integer identifier - could be negative or strange numbers for test labs
L.addLabPart('Rect',fullfile('Lab 01','Rect_Grader.m'));              % This approach will bring up the "Lab 01" subfolder in the GUI.
%L.addLabPart('Trapezoid',fullfile('Lab 01','Trapezoid_Grader.m'));  %This part was removed from lab 1 as of Fall 2020

% Lab 2
L.addLab(2,datetime(2020,9,14,16,0,0),'MATLAB',2);
L.addLabPart('Trapezoid',fullfile('Lab 02','Trapezoid_Grader.m'));
L.addLabPart('Simpson13',fullfile('Lab 02','Simpson13_Grader.m'));
L.addLabPart('Simpson38',fullfile('Lab 02','Simpson38_Grader.m'));
L.addLabPart('AdaptiveInt',fullfile('Lab 02','AdaptiveInt_Grader.m'));

% Lab 3
L.addLab(3,datetime(2019,9,28,16,0,0),'MATLAB',2);
L.addLabPart('Fwd_Deriv',fullfile('Lab 03','Fwd_Deriv_Grader.m'));
L.addLabPart('Bkwd_Deriv',fullfile('Lab 03','Bkwd_Deriv_Grader.m'));
L.addLabPart('Central_Deriv',fullfile('Lab 03','Central_Deriv_Grader.m'));
L.addLabPart('FBC_Deriv',fullfile('Lab 03','FBC_Deriv_Grader.m'));

% Lab 4
L.addLab(4,datetime(2019,10,5,16,0,0),'MATLAB',2);
L.addLabPart('Regression1',fullfile('Lab 04','Regression1_Grader.m'));
L.addLabPart('RegressionN',fullfile('Lab 04','RegressionN_Grader.m'));
L.addLabPart('Smoother',fullfile('Lab 04','Smoother_Grader_V2.m'));

% Lab 5
L.addLab(5,datetime(2020,09,24,15,40,0),'MATLAB',3);
L.addLabPart('Newton',fullfile('Lab 05','Newton_Grader.m'));
L.addLabPart('Secant',fullfile('Lab 05','Secant_Grader.m'));
L.addLabPart('FP',fullfile('Lab 05','FP_Grader.m'));
L.addLabPart('Bisect',fullfile('Lab 05','Bisect_Grader.m'));

% Lab 6
L.addLab(6,datetime(2019,10,19,16,0,0),'MATLAB',1);
L.addLabPart('Speedy',fullfile('Lab 06','Speedy_Grader.m'));
L.addLabPart('SpeedyV',fullfile('Lab 06','SpeedyV_Grader.m'));

% Lab 7
L.addLab(7,datetime(2019,10,26,16,0,0),'MATLAB',1);
L.addLabPart('Midpoint',fullfile('Lab 07','Midpoint_Grader.m'));
L.addLabPart('Ralston',fullfile('Lab 07','Ralston_Grader.m'));
L.addLabPart('RK4',fullfile('Lab 07','RK4_Grader.m'));
L.addLabPart('ODEcharts',fullfile('Lab 07','ODEcharts_Grader.m'));
L.addLabPart('ErrPlots',fullfile('Lab 07','ErrPlots_Grader.m'));

% Lab 8 was just a pass off: 'Welcome to C++'

% Lab 9
L.addLab(9,datetime(2019,11,9,16,0,0),'C++',2);
L.addLabPart('FBC_Deriv',fullfile('Lab 09','FBC_Deriv_Grader.m'));
L.addLabPart('AdaptiveInt',fullfile('Lab 09','AdaptiveInt_Grader.m'));

% Lab 10
L.addLab(10,datetime(2019,11,16,16,0,0),'C++',2);
L.addLabPart('Secant',fullfile('Lab 10','Secant_Grader.m'));
L.addLabPart('FP',fullfile('Lab 10','FP_Grader.m'));
L.addLabPart('Bisect',fullfile('Lab 10','Bisect_Grader.m'));

% Lab 11
L.addLab(11,datetime(2019,11,30,16,0,0),'C++',1);
L.addLabPart('Art',fullfile('Lab 11','Art_Grader.m'));
L.addLabPart('Plate',fullfile('Lab 11','Plate_Grader.m'));

% Lab 12
L.addLab(12,datetime(2019,12,7,16,0,0),'MATLAB',1);
L.addLabPart('ImageRecon',fullfile('Lab 12','ImageRecon_Grader.m'));
L.addLabPart('SolTimes',fullfile('Lab 12','SolTimes_Grader.m'));


function [Score, Feedback] = ImageRecon_Grader(filename,finalGrade)
%--------------------------------------------------------------
% FILE: ImageRecon_Grader.m
% AUTHOR: Jared Oliphant
% DATE: 12 March 2018
%
% PURPOSE: Function for grading Lab 8, part 2: Image decryption section
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

% the TRY/CATCH structure is used to prevent code crashes
try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================|
    StudentFunction = filename(1:end-2);   % get function name     |
    filetext = fileread(filename);         % get the function as a string to check for text inside
    load('system8.mat')                    % load up the encrypted image
    
    %=================================================|
    
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    tic
    Solution(:,:,1) = A\B1;
    Solution(:,:,2) = A\B2;
    Solution(:,:,3) = A\B3;
    solutiontime = toc;
    %================================================
    
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    close all
    tic
    CallingString = ['[Student_I] = ',StudentFunction,'(A,B1,B2,B3);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    studenttime = toc;
    %================================================================================
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    
    %check the student versus the solution
    if norm(Student_I(:,:,1)-Solution(:,:,1)) < 0.1 && ...
            norm(Student_I(:,:,2)-Solution(:,:,2)) < 0.1 && ...
            norm(Student_I(:,:,3)-Solution(:,:,3)) < 0.1
        Score = 1;
        Feedback = 'Your [I] array matched the solution perfectly, well done!   ';
    else
        Score = .5;
        Feedback = ['Your [I] array did not match the solution, review the lab',...
            'handout.   norm(diff()) = [',num2str(norm(Student_I(:,:,1)-Solution(:,:,1))),...
            ', ',num2str(norm(Student_I(:,:,2)-Solution(:,:,2))),', ',...
            num2str(norm(Student_I(:,:,3)-Solution(:,:,3))),']'];
    end
    
    %check to see if any of the solver expressions are present in the function
    use_linsolve = ~isempty(regexp(filetext,'[^\n]*linsolve[^\n]*', 'once'));
    use_rref = ~isempty(regexp(filetext,'[^\n]*rref[^\n]*', 'once'));
    use_inverse = ~isempty(regexp(filetext,'[^\n]*inv[^\n]*', 'once'));
    use_forloop = ~isempty(regexp(filetext,'\nfor\s[^\n]*','once'));
    
    
    %give feedback according to predicted time based on what method was
    %used
    if use_linsolve == 1
        Feedback = [Feedback,'--- Timing: Grader solution time: ',...
            num2str(solutiontime),'  Your solution time: ',...
            num2str(studenttime),'  ---   Your Image Reconstruction function ',...
            'used linsolve() to solve each linear system. In general, this ',...
            'method is fastest ONLY if we know something about the matrix to ',...
            'be solved and can pass in solver options. In this case, mldivide() ',...
            'or A\b might be slightly faster.'];
    elseif use_inverse == 1
        Feedback = [Feedback,'--- Timing: Grader solution time: ',...
            num2str(solutiontime),'  Your solution time: ',...
            num2str(studenttime),'  ---   Your Image Reconstruction function ',...
            'used inv(A)*b to solve each linear system. To achieve faster ',...
            'solution times, mldivide() or A\b should be used.'];
    elseif use_rref == 1
        Feedback = [Feedback,'--- Timing: Grader solution time: ',...
            num2str(solutiontime),'  Your solution time: ',...
            num2str(studenttime),'  ---   Your Image Reconstruction function ',...
            'used rref to solve each linear system, which is the slowest solver ',...
            'technique. To achieve faster solution times, mldivide() or A\b should ',...
            'be used.'];
    else
        Feedback = [Feedback,'--- Timing: Grader solution time: ',...
            num2str(solutiontime),'  Your solution time: ',...
            num2str(studenttime),'  ---   Your Image Reconstruction function ',...
            'likely used mldivide() or A\b to solve each linear system, which is ',...
            'a fast solver technique. Good job!!'];
    end
    
    if use_forloop == 1
        Feedback = [Feedback,'   --- It also looks like you utilized a for ',...
            'loop instead of vectorization. If you vectorize you should notice ',...
            'a marked performance increase.'];
    end
    
    % %====================================================================================
    % % ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
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
    
    %%==============================================================
    
end


end
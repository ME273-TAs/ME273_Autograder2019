%  GRADING COMPARISONS
clear
clc

id_273 = [1250, 2306, 2573, 4256, 4351, 4599, 4628, 4730, 4969];

for i = 1:length(id_273)
    filename = strcat('Smoother_', num2str(id_273(i)), '.m');
    [Score(i,1), Feedback{i,1}] = Smooth_Grader_Old_Jared(filename);
    
end

% disp(Score)


%%%%% FIND NEW INPUTS

% % x = linspace(0,5,15);
% % y = 1 * (0.102 * x.^4 - 1.21 * x.^3 + 4.6 * x.^2 - 5.97 * x + 1.3) + 0.3 *rand(size(x));
% % 
% % plot(x,y)
% % 
% % for i = 1:length(id_273)
% %     fnString = strcat('[ys_', num2str(id_273(i)), ', e_', num2str(id_273(i)) ,'] = Smoother_', num2str(id_273(i)), '(x,y,2,4);');
% %     eval(fnString);
% %     hold on
% %     Y = eval(strcat('ys_', num2str(id_273(i))));
% %     plot(x,Y)
% %     clear Y
% %     hold off
% % end


for i = 1:length(id_273)
    filename = strcat('Smoother_', num2str(id_273(i)), '.m');
    [Score2(i,1), Feedback{i,2}] = Smooth_Grader_New_Jared(filename);
    
end

Difference = Score - Score2;
disp(Difference)

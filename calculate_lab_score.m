% Helper function calculate_lab_score
function lab_score = calculate_lab_score(n, configVars)

lab_score = '=(';

for i = 1:n
    lab_score = [lab_score,'RC[',num2str(configVars.partFields.pf + ...
        (i - 1)*configVars.partFields.pf),']+'];
end

lab_score = [lab_score,'0)/',num2str(n)];

end
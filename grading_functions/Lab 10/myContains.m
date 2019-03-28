function [result] = myContains(bigString, phrase, ignorecase)
result = 0;
if ignorecase
    phrase = upper(phrase);
    bigString = upper(bigString);
    
    for i = 1:length(bigString)-length(phrase)
        if strcmp(phrase,bigString(i:i+length(phrase)-1))
            result = 1;
            return
        end
    end
else
    
    for i = 1:length(bigString)-length(phrase)
        if strcmp(phrase,bigString(i:i+length(phrase)-1))
            result = 1;
            return
        end
    end
end



end
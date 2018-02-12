function asciiExportRules(filenameRules, rulesMat)

%   Output the rules matrix.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-01-29

    dlmwrite(filenameRules, rulesMat, ' ');
end

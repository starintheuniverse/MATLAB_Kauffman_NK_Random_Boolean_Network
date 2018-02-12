function rulesMat = asciiImportRules(filenameRules)

%   Import the rules matrix.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-02-09

    rulesMat = dlmread(filenameRules);
end

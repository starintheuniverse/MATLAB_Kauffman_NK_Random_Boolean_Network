function rulesJoined = asciiExportRulesStr(rulesMat, numsInputs)

%   Output the rules matrix.
%
%   [2018-03-13] New: Every row, rather than a column, is the rule for one node.
%   [2018-03-13] New: The zero-padding can be omitted at the ends of lines,
%                     by controlling numsInputs.
%
%   Inputs
%       rulesMat    - The rules matrix, in which every column is a rule for one node.
%       numsInputs  - A list of the numbers of inputs per node.
%                     Allows omission of fake inputs (the zero-padding).

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-01-29
%   Modified:   2018-03-13


    mSize = size(rulesMat);
    numNodes = length(numsInputs);

    columnSizes = 2.^numsInputs(:)';
    rStarts = sub2ind(mSize, ones(1,numNodes), 1:numNodes);
    rEnds = sub2ind(mSize, columnSizes, 1:numNodes);

    rulesLines = arrayfun(@(rStart, rEnd) [num2str(rulesMat(rStart:rEnd)) newline], ...
            rStarts, rEnds, 'UniformOutput',false);
    rulesJoined = horzcat(rulesLines{:});
end

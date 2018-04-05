function rulesMat = asciiImportRulesStr(str)

%   Import the rules matrix. Each line is interpreted as the rule for one node.
%   That is, each line will become a column in the rules matrix.
%   Not all lines need to have the same length, but the lengths should be
%   powers of two. This function does not check that this is so.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-02-09
%   Modified:   2018-03-13

    lineCells = cellfun(@strtrim, strsplit(str, '\n'), 'UniformOutput',false);
    nonblankLineCells = lineCells(~cellfun('isempty', lineCells));

    dataInCells = cellfun(@(line) sscanf(line, '%d'), nonblankLineCells, ...
            'UniformOutput',false);

    sizeHeight = max(cellfun(@numel, dataInCells));
    sizeWidth = numel(dataInCells);

    rulesMat = zeros(sizeHeight, sizeWidth, 'int8');
    for colIdx = 1:sizeWidth
        dataCol = dataInCells{colIdx};
        rulesMat(1:numel(dataCol), colIdx) = dataCol;
    end
end

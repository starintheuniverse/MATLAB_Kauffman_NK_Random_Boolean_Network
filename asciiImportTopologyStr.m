function nodeConn = asciiImportTopologyStr(str, node)

%   Read an ascii adjacency list and update the 'input' field of the node struct-array.
%   It is important for each line of data to end with ';'.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-02-09
%   Modified:   2018-03-13

%   Based on example at
%   https://www.mathworks.com/help/matlab/import_export/import-text-data-files-with-low-level-io.html


    nodeConn = node;

    %%fileId = fopen(filenameTopology);
    %%nodeIdx = 1;
    %%fileLine = fgetl(fileId);
    %%while (ischar(fileLine))

    strLineCells = cellfun(@strtrim, strsplit(str, '\n'), 'UniformOutput',false);

    % Ignore lines that don't contain ';'.
    contentLineCells = strLineCells(cellfun(@(line) any(line==';'), strLineCells));

    nodeIdx = 1;
    for l = 1:length(contentLineCells) 
        nodeConn(nodeIdx).input = sscanf(contentLineCells{l}, '%d')';      % Input field is a row vector.
        nodeIdx = nodeIdx + 1;
    end
end

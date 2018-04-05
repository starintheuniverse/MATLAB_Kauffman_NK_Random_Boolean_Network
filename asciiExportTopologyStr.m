function str = asciiExportTopologyStr(nodeConn)

%   Extract and string-ify the adjacency list. nodeConn must be a node array-struct with 'input' initialized.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-02-09
%   Modified:   2018-03-09

    adjacencyList = {nodeConn.input}.';     % Gets a Nx1 cell array, each cell holds a row of [int]s.

    % New way, with classic char vectors, and num2str.
    adjacencyLines = cellfun(@(row) [num2str(row, '%d ') ' ;' newline], adjacencyList, 'UniformOutput',false);
    adjacencyJoined = horzcat(adjacencyLines{:});

    str = adjacencyJoined;
end

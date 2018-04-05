function asciiExportTopology(filenameTopology, nodeConn)

%   Extract and output adjacency list. nodeConn must be a node array-struct with 'input' initialized.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-02-09
%   Modified:   2018-03-09

    adjacencyList = {nodeConn.input}.';     % Gets a Nx1 cell array, each cell holds a row of [int]s.

    % Old way, with string and strjoin.
%%    adjacencyStrings = cellfun(@strjoin, cellfun(@string, adjacencyList, ...
%%            'UniformOutput',false), 'UniformOutput',false);
%%    adjacencyJoined = strjoin(string(adjacencyStrings), '\n');

    % New way, with classic char vectors and sprintf.
    adjacencyLines = cellfun(@(row) [sprintf('%d ', row) ' ;\n'], adjacencyList, 'UniformOutput',false);
    adjacencyJoined = horzcat(adjacencyLines{:});

    fileTopology = fopen(filenameTopology, 'w');
    fprintf(fileTopology, adjacencyJoined);
    fclose(fileTopology);
end

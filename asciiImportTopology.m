function nodeConn = asciiImportTopology(filenameTopology, node)

%   Read an ascii adjacency list and update the 'input' field of the node struct-array.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-02-09

%   Based on example at
%   https://www.mathworks.com/help/matlab/import_export/import-text-data-files-with-low-level-io.html


    nodeConn = node;

    fileId = fopen(filenameTopology);
    nodeIdx = 1;
    fileLine = fgetl(fileId);
    while (ischar(fileLine))
        nodeConn(nodeIdx).input = sscanf(fileLine, '%d')';      % Input field is a row vector.
        nodeIdx = nodeIdx + 1;
        fileLine = fgetl(fileId);
    end
    fclose(fileId);

end

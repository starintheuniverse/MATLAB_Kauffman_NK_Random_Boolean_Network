function nodeUpdated = displayTopologyCascade(node, connectionMatrix, optionString, varargin)

% DISPLAYTOPOLOGYCASCADE Visualize network topology & cued-for-update status, set xy-components and "ouput" field in node structure-array.
%   
%   DISPLAYTOPOLOGY(NODE, CONNECTIONMATRIX, OPTIONSTRING) displays the network topology defined by CONNECTIONMATRIX and updates
%   the x and y components in the node structure-array. OPTIONSTRING must be set to 'arrow' or 'line' and defines whether the
%   network connections are represented as arrows or as lines. For networks with nodes > 50 it is recommended to use 'line'.
%   Furthermore, the "output" field in the node structure-array is updated.
%
%   DISPLAYTOPOLOGY(NODE, CONNECTIONMATRIX, OPTIONSTRING, SAVEFLAG) displays the network topology defined by CONNECTIONMATRIX and updates
%   the x and y components in the node structure-array. OPTIONSTRING must be set to 'arrow' or 'line' and defines whether the
%   network connections are represented as arrows or as lines. For networks with nodes > 50 it is recommended to use 'line'.
%   Furthermore, the "output" field in the node structure-array is updated. If SAVEFLAG is set, the figure is saved to the disk.
%
%
%   Input:
%       node               -  1 x n structure-array containing node information ("cued" field required)
%       connectionMatrix   -  n x n adjacent matrix (defined as in graph theory)
%       optionString       -  must be set to either 'arrow' or 'line'
%       saveFlag           - (Optional) Flag: 1 - Figure will be saved to disk  0 - no saving
%
%
%   Output: 
%       node               -  1 x n structure-array containing updated node information ("output" field)


%   Author: Masado Ishii (based on displayTopology.m by Christian Schwarzer, 20.01.2003)
%   CreationDate: 05.01.2018 LastModified: 08.01.2018


if(nargin == 3 | nargin == 4)
    
    % The save flag is used after displayTopology() is called.
    if(nargin == 4)
        saveFlag = varargin{1};
    else
        saveFlag = 0;
    end

    % Rely on error-checking in displayTopology(). An error() is made for either of:
    %   *  length(connectionMatrix) ~= length(node)
    %   *  (~strcmp(optionString, 'arrow')) & (~strcmp(optionString, 'line'))
    
    % Draw the figure and capture updates to the node array-structure ("output" "x" "y" fields).
    % Defer saving of the figure (4th argument = false).
    nodeUpdated = displayTopology(node, connectionMatrix, optionString, false);

    % ...now nodeUpdated contains the xy-coordinates of the nodes, which are re-used next.

    % Draw light green translucent pentagons over cued nodes (1 = cued):
    cuedNodes = find([nodeUpdated.cued]);
    nodeX = [nodeUpdated(cuedNodes).x];
    nodeY = [nodeUpdated(cuedNodes).y];
    pentagonX = [1.0000 0.3090 -0.8090 -0.8090  0.3090];  % cos(2*pi/5*(0:4))
    pentagonY = [0.0000 1.0000  0.6180 -0.6180 -1.0000];  % sin(2*pi/5*(0:4))
    pentagonScale = 0.8;
    pentagonXData = pentagonScale.*pentagonX.' + nodeX;   % Each column is one pentagon (one node).
    pentagonYData = pentagonScale.*pentagonY.' + nodeY;   %
    patch('XData', pentagonXData, 'YData', pentagonYData, 'FaceColor', 'green', 'FaceAlpha', .25);
    
    % Add "cued" to legend, below "black" and "white."
    % [The "black" and "white" labels are at (n,-n) and (n,-n*.9), where
    % n = (# of nodes) is used as a scaling factor; see displayTopology.m.]
    n = length(connectionMatrix);
    text(n, -n*1.1, 'green poly = cued (CU)');
    
    % Optionally save figure, now that we've added the new elements.
    if(saveFlag)
        saveFigure(gcf);
    end
    
    
    
else
    error('Wrong number of arguments. Type: help displayTopologyCascade')    
end





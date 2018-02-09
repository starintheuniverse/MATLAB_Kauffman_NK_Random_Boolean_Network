function [nodeUpdated, timeStateMatrix, timeUpdateMatrix] = evolveCRBN(node, varargin)

% EVOLVECURBN Develop network gradually K discrete time-steps according to CURBN
% (Cascade-Update Random Boolean Network) update scheme.
%
%   EVOLVECURBN(NODE) advances all nodes in NODE one time-step in CURBN update mode.
%   
%   EVOLVECURBN(NODE, K) advances all nodes in NODE K time-steps in CURBN update mode.
% 
%   EVOLVECURBN(NODE, K, TK) advances all nodes in NODE K time-steps in CURBN update mode
%   and saves all TK steps all node-states and the timeStateMatrix to the disk.
%
%
%   Input:
%       node               - 1 x n structure-array containing node information
%       k                  - (Optional) Number of time-steps
%       tk                 - (Optional) Period for saving node-states/timeStateMatrix to disk.
%
%
%   Output: 
%       nodeUpdated        - 1 x n sturcture-array with updated node information
%                            ("lineNumber", "state", "nextState")                           
%       timeStateMatrix    - n x k+1 matrix containing calculated time-state evolution
%       timeUpdateMatrix   - n x k+1 matrix showing which nodes were to-be-updated every step



%   Based on EVOLVECRBN() and EVOLVEDGARBN() by Christian Schwarzer - SSC EPFL (20.01.2003).
%   Author: Masado Ishii - ECE PSU
%   CreationDate: 03.01.2018 LastModified: 08.02.2018


switch nargin
case 1
    k = 1;
    tk = inf;
case 2
    k = varargin{1};
    tk = inf;
case 3
    k = varargin{1};
    tk = varargin{2};  
otherwise
    error('Wrong number of arguments. Type: help evolveCURBN');
end

nodeUpdated = resetNodeStats(node);

timeStateMatrix = zeros(length(nodeUpdated), k+1);
timeStateMatrix(1:length(nodeUpdated),1) = getStateVector(nodeUpdated)';

% For every node that is cued on step i, we'll light its TUM entry for step i. (M.Ishii 08.02.2018)
timeUpdateMatrix = zeros(length(nodeUpdated), k+1);
timeUpdateMatrix(1:length(nodeUpdated),1) = logical([nodeUpdated.cued]');

% evolve network
for i=2:k+1
    
    nodeUpdated = setLUTLines(nodeUpdated);       % Each node reads and stores its inputs.
    nodeUpdated = setNodeNextState(nodeUpdated);  % Apply rule and set nextState (but not state).
    
    % Find which nodes get updated by Cascade Update. (M.Ishii 08.02.2018)
    % I.e. those nodes which were "cued" on the last time step.
    cuedVector = timeUpdateMatrix(:, i-1);
    nodeSelected = find(cuedVector);

    % Update state of every /cued/ node. (M.Ishii 08.01.2018)
    for j=1:length(nodeSelected)
        m = nodeSelected(j);
        nodeUpdated(m).state = nodeUpdated(m).nextState;
        nodeUpdated(m).nbUpdates = nodeUpdated(m).nbUpdates + 1;
    end

    % Updated cued-status for all nodes.  (M.Ishii 08.01.2018)
    % (Nodes which are not cued need to be told so.)
    for m=1:length(nodeUpdated)
        % Note, "input" field is preallocated in initNodes.m and initialized in assocNeighbours.m.
        nodeUpdated(m).cued = int8(any(cuedVector(nodeUpdated(m).input)));
    end
    
    % Record the state of all nodes at this time step.
    timeStateMatrix(:,i) = getStateVector(nodeUpdated)';

    % Record which nodes are cued to update next. (M.Ishii 08.02.2018)
    % Note, this is the block of to-be-updated nodes,
    % not the block of just-updated nodes.
    timeUpdateMatrix(:,i) = logical([nodeUpdated.cued]');
    
    if(mod(i-1,tk) == 0)
        saveMatrix(nodeUpdated);
        saveMatrix(timeStateMatrix(:,1:i));
        saveMatrix(timeUpdateMatrix(:,1:i));  % (M.Ishii 08.01.2018)
        i-1; % display current time-step for user information
    end

end


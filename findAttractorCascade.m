function  [attrLength, attrStartIdx, tsmOut, tumOut, nodeUpdated] = findAttractorCascade(node, tMax)

% FINDATTRACTOR Return attractor length and states in attractor. 
%
%   FINDATTRACTOR(NODE, TMAX) evolves all nodes in NODE in Cascade Update scheme until an
%   attractor is found. Returns attractor length, index (time+1) of first attractor state
%   and the time-state-matrix & time-update-matrix up to and including the end of the first
%   attractor cycle. If after TMAX steps no attractor is found, then the search is stopped
%   and ATTRLENGTH is set to INF.
%
%   Input:
%       node            - 1 x n structure-array containing node information
%       tMax            - Maximal number of time steps to search for attractor. Should be positive.
%
%   Output:  
%       attrLength      - Attractor length; if tMax has been reached before having found an attractor,
%                               then attrLength is set to INF.
%
%       attrStartIdx    - Index of entry into attractor, equal to 1 less than the time of entry.
%                               First index such that
%                               tsmOut(attrStartIdx) == tsmOut(attrStartIdx + attrLength).
%                               If no attractor is found within tMax time steps, then
%                               attrStartIdx is set to INF.
%    
%       tsmOut          - n x k+1 matrix conaining node-states for n nodes at k timesteps
%       tumOut          - n x k+1 matrix conaining node-updates for n nodes at k timesteps
%       nodeUpdated     - Node struct array reflecting network state at time k

%   Author:         Masado Ishii // Teuscher Lab - ECE PSU
%                   Header comments and some code adapted from findAttractor.m
%                       (Christian Schwarzer, SSC EPFL, 2003-01-20)
%
%   CreationDate:   2018-02-07
%   LastModified:   2018-02-08

%   Subfunctions:   function idx = scanForPriorMatch(tsm, tum, nowIdx)


%TODO after profiling / efficiency analysis, maybe use a hash table to detect hits, before scanning.
%   or maybe extend the table exponentially?

    n = length(node);

    % TODO e.g. this could all be put inside a loop, kEnlarge could double on each iteration.
    kMax = 1;
    kEnlarge = tMax;
    kMax = kMax + kEnlarge;     % Allocate large array now. Will chop off any unused columns at the end.
    tsmOut = zeros(n, kMax);
    tumOut = zeros(n, kMax);

    attractorFound = false;
    k = 2;
    nodeUpdated = node;
    while (k <= kMax)
        % Compute and record the next time step (as well as saving the current one).
        [nodeUpdated tsmOut(:, k-1:k) tumOut(:, k-1:k)] = evolveCURBN(nodeUpdated, 1);

        % Check if the couple (state + to-be-updated-block)
        % is a repetition of a previous moment.
        % TODO here is where we could apply some hashtable optimization.
        idxOfPriorMatch = scanForPriorMatch(tsmOut, tumOut, k);     

        k = k + 1;      % Placed here to make final k value consistent,
                        % regardless of reason for loop termination.

        % Act on the repetition test.
        if (~isempty(idxOfPriorMatch))
            attractorFound = true;
            break;
        end
    end

    % k is one larger than the last iteration.
    k = k - 1;

    % Output arguments.
    if (attractorFound)
        attrLength = k - idxOfPriorMatch;
        attrStartIdx = idxOfPriorMatch;
    else
        attrLength = Inf;
        attrStartIdx = Inf;
    end
    tsmOut = tsmOut(:, 1:k);
    tumOut = tumOut(:, 1:k);

end


%%% SUBFUNCTIONS %%%

% scanForPriorMatch()
function idx = scanForPriorMatch(tsm, tum, nowIdx)
    % Returns with a valid index, or empty if none found.
    equalityTSM = (tsm(:,1:nowIdx-1) == tsm(:,nowIdx));
    equalityTUM = (tum(:,1:nowIdx-1) == tum(:,nowIdx));
    matches= all([equalityTSM; equalityTUM], 1);   % Collapse 1st dimension.
    idx = find(matches, 1, 'last');                % Find last match.
end

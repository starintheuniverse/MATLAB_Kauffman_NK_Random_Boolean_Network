function tums = computeUpdatesSufficient(adjacencyMatrix, initUpdateSets)

% COMPUTEUPDATESUFFICIENT
%
%   Given a graph adjacency matrix and one or more possible about-to-update sets,
%   computes the trajectory of each update set until it enters a cycle.
%   Returns, for each trajectory, the shortest time-update-matrix such that its
%   length is a power of two and it also makes the cycle visible.
%
%   For use with Cascade Update scheme for Random Boolean Networks.
%   
%   Inputs
%       adjacencyMatrix  -  Adjacency matrix for the network topology. See note below.
%       initUpdateSets   -  Column vectors horzcat'd, each column vector is an update set.
%
%   Output
%       tums    - Cell array of time-update-matrices, each column is one time step.
%                 There is one cell for every given initial update set.
%
%   NOTE
%   An adjacency matrix can be equivalently represented by its transpose.
%   The convention for this input, adjacencyMatrix, is that each row
%   represents the parents of a node, and each column represents the
%   children of a node. The upshot is that the to-be-updated set can be
%   represented as a column vector, which, when left-multiplied by the
%   adjacency matrix, will produce the update set next in sequence.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-03-14


%   The Idea(s)
%
%   Fundamentally, computing the time update matrix reduces to computing and
%   comparing powers of the adjacency matrix.
%
%   We can horzcat the powers of of the matrix instead of pushing them in
%   the 3rd dimension. Then we can multiply many at once. The goal is to take
%   advantage of MATLAB's fast matrix multiplication and avoid MATLAB's slow nested
%   for-loops.
%
%   We can extend the number of time steps by _double_, before scanning for cycles.
%   This improves the amount of time spent scanning, from quadratic to linear
%   in the number of time steps computed.
%
%   Also, after each scan, we can remove the columns for any uIdx (update index)
%   which we know to be solved.

    N = size(adjacencyMatrix, 1);
    A = double(adjacencyMatrix);

    % Default parameter.
    if (nargin < 2)
        initUpdateSets = eye(N);
    end

    numVarieties = size(initUpdateSets, 2);

    tums = cell(numVarieties, 1);
    highestPower = A;

    % The trajectories which need to be resolved.
    seq = initUpdateSets;

    % The uIdx which are still active in seq.
    currentColIdxs = 1:numVarieties;

    while ~isempty(currentColIdxs)

        % Extend time by double.
        seq = horzcat(seq, min(1, highestPower*seq));
        highestPower = min(1, highestPower*highestPower);

        % dimensions
        tumWidth = numel(currentColIdxs);
        seqLength = size(seq, 2);
        tumLength = seqLength/tumWidth;

        % scan
        lastTimeStep = seq(:,end-tumWidth+1:end);
        attempt = all(seq(:,1:end-tumWidth) == lastTimeStep(:,1+mod(0:seqLength-tumWidth-1, tumWidth)), 1);
        successMask = any(reshape(attempt, tumWidth, tumLength-1), 2);

        % separate
        if any(successMask)
            successCols = currentColIdxs(successMask);
            seq3D = reshape(seq, N, tumWidth, tumLength);
            tums(successCols) = squeeze(num2cell(permute(seq3D(:,successMask,:), [1 3 2]), [1,2]));
            seq = reshape(seq3D(:,~successMask,:), N, []);
            currentColIdxs(successMask) = [];
        end
    end
end

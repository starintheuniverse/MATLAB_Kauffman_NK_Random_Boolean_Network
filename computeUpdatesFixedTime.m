function updateTrajectories = computeUpdatesFixedTime(adjacencyMatrix, initUpdateSets, delta_t)

% COMPUTEUPDATEFIXEDTIME
%
%   Given a graph adjacency matrix and one or more possible about-to-update sets,
%   computes the trajectory of each update set for delta_t time steps.
%
%   For use with Cascade Update scheme for Random Boolean Networks.
%   
%   Inputs
%       adjacencyMatrix  -  Adjacency matrix for the network topology. See note below.
%       initUpdateSets   -  Column vectors horzcat'd, each column vector is an update set.
%       delta_t          -  Number of additional time steps to compute.
%
%   Output
%       updateTrajectories  -  Matrix of update-set trajectories, arranged in
%                              (1 + detla_t) blocks. Each block is the same shape
%                              as initUpdateSets. The first block is equal to
%                              initUpdateSets, the next block is the collection of
%                              update-sets advanced by one time step, etc.
%
%   NOTE
%   An adjacency matrix can be equivalently represented by its transpose.
%   The convention for this input, adjacencyMatrix, is that each row
%   represents the parents of a node, and each column represents the
%   children of a node. The upshot is that the to-be-updated set can be
%   represented as a column vector, which, when left-multiplied by the
%   adjacency matrix, will produce the update set next in sequence.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-03-23


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

    N = size(adjacencyMatrix, 1);
    A = double(adjacencyMatrix);

    numVarieties = size(initUpdateSets, 2);

    highestPower = A;

    % Trajectories in progress.
    seq = initUpdateSets;

    % Length starts at 1, need to double it until it's at least 1+delta_t.
    for ii = 1:ceil(log2(1+delta_t))
        % Extend time by double.
        seq = horzcat(seq, min(1, highestPower*seq));
        highestPower = min(1, highestPower*highestPower);
    end

    updateTrajectories = seq(:, 1:numVarieties*(1+delta_t));
end

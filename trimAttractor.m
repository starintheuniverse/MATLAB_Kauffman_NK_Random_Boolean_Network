function [tsmTrimmed, cycleLength, cycleStartIdx] = trimAttractor(tsmIn)

% TRIMATTRACTOR Shorten the tail of a time-state-matrix to the first repetition of
% the cycle entry.
%
%   Assumes that a repeated state (column in the time-state-matrix) implies a cycle,
%   and at least one repeated state is present in the provided matrix.
%
%   Inputs
%       tsmIn   - Time state matrix, one column is one state is one time step.
%
%   Outputs
%       tsmTrimmed      - Same as tsmIn, but cuts off columns after the first
%                         repetition of cycle entry.
%
%       cycleLength     - Distance between two nearby repetitions of the same state.
%       cycleStartIdx   - The (1-based) index into tsmIn/tsmTrimmed where the
%                         attractor begins.
 
%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-03-14


    % Assuming that the tsmIn is not insanely long, the vectorized comparison
    % methods in MATLAB are very fast, despite their presumably linear time complexity.

    equalToLast = all(tsmIn == tsmIn(:,end), 1);
    first2Idx = find(equalToLast, 2);

    cycleLength = diff(first2Idx);
    
    cycleStartIdx = find( ...
            all(tsmIn(:,1:first2Idx(1)) == tsmIn(:,1+cycleLength:first2Idx(2)), 1) , 1);

    tsmTrimmed = tsmIn(:,1:cycleStartIdx+cycleLength);
end

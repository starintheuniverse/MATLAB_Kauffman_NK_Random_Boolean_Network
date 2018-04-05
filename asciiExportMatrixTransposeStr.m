function strOut = asciiExportMatrixTransposeStr(mat)

%   Output rectangular matrix to a multi-line string, in column-major order.
%
%   If used on a TSM, this represents each time step (tsm column) as a row in the string.
%
%   There is not an extra blank line at the end of the matrix. If matrix strings
%   are to be concatenated, this gives the caller the option of whether to
%   separate matrices by blank lines or not.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-01-29
%   Modified:   2018-03-13

    fmt = [repmat('%d ', 1, size(mat, 1)) '\n'];
    strOut = [sprintf(fmt, mat) newline];
end

function mat = matTransposeReadStr(str, elemFormatSpec)

% MATTRANSPOSEREADSTR  Read a matrix whose columns are stored as lines in a string.
%
%   As opposed to dlmread, which attempts to make the two representations look the same,
%   this method repsects the order that elements are stored in each representation.
%
%   If you want to use this with a file, you have to first read the entire file
%   as one character array.
%
%   Inputs:
%       str             - The string to be processed.
%       elemFormatSpec  - The format specifier to pass to sscanf.
%                         All elements must be of the same type.

%   Author:     Masado Ishii
%   Date:       2018-03-13
%   Modified:   2018-03-14

    if nargin < 2
        elemFormatSpec = '%f';
    end

    lineCells = cellfun(@strtrim, strsplit(str, '\n'), 'UniformOutput',false);
    nonblankLineCells = lineCells(~cellfun('isempty', lineCells));
    dataInCells = cellfun(@(line) sscanf(line, elemFormatSpec), nonblankLineCells, ...
            'UniformOutput',false);
    mat = horzcat(dataInCells{:});

end

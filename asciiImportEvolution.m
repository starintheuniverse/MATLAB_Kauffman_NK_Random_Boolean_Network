function tsmMat = asciiImportEvolution(filenameTSM)

%   Import the time-state-matrix or time-update-matrix.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-02-09

    tsmMat = dlmread(filenameTSM);
end

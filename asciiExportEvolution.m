function asciiExportEvolution(filenameTSM, tsmMat)

%   Output the time-state-matrix or time-update-matrix.

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-01-29

    dlmwrite(filenameTSM, tsmMat, ' ');
end

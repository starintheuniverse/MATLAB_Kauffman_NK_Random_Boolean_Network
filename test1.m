%% test1.m - Masado Ishii (08.01.2018)
%%
%% This script generates 5 small (n=10) CU-enabled networks and their evolutions 
%% over 5 time steps. The evolutions include update propagation according to
%% Casacde Update.
%%
%% The networks and their evolutions are hopefully small enough to verify by hand-simulation.


testCases = arrayfun(@generateTestCase, 1:5, 'UniformOutput',false);

function testCase = generateTestCase(unusedIndex)
    [node, conn, rule] = bsn(10, randi([2 3]), 'arrow');
    displayTopologyCascade(node, conn, 'arrow');
    figTopology = gcf;
    [nodeUpdate, tsm, tum] = evolveCURBN(node, 5);
    displayTimeStateMatrix(tsm);
    figTSM  = gcf;
    displayTimeStateMatrix(tum);
    figTUM  = gcf;
    testCase = struct('topology', figTopology, 'tsm', figTSM, 'tum', figTUM);
end

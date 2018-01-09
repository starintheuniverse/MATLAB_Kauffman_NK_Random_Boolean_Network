%% test2.m - Masado Ishii (08.01.2018)
%%
%% This test is a baseline measure to verify that CURBNs behave exactly
%% like CRBNs when all nodes are initialized to update on the first time step.
%% This script generates 100 small (n=20) CU-enabled networks, sets each node to
%% be cued for immediate update, and evolves the networks according to CURBN
%% over 100 time steps. The evolution matrices include cascade-update propagation.
%% For comparison, an alternative evolution for each network is captured, using
%% CRBN. Then the differences in the time-state-matrices are computed and output
%% for each network.


testCaseDifferences = arrayfun(@generateTestCase, 1:100, repmat(20,1,100), randi([2 3],1,100), 'UniformOutput',false);
%%testCaseDifferences = arrayfun(@generateTestCase, 1:5, repmat(20,1,5), randi([2 3],1,5), 'UniformOutput',false);  % Start small, 5 < 100.
showNumberNonzero = arrayfun(@(ca) nnz(ca{:}), testCaseDifferences)  % With no semicolon, the value will be printed.

function testCaseDiff = generateTestCase(index, n, K)
    %%%%             n  initialState          initialCued initialP     initialQ
    node = initNodes(n, int8(randi(1, 1, n)), ones(1, n), zeros(1, n), zeros(1, n));

    % Generate topology and rules randomly, given uniform K.
    conn = initConnections(n, K);
    rule = initRules(n, K);

    % Build the complete network.
    node = assocNeighbours(node, conn);
    node = assocRules(node, rule);

    % Evolve by CURBN and give feedback.
    [nodeUpdatedCURBN, tsmCURBN, tumCURBN] = evolveCURBN(node, 100);
    fprintf("Trial %d, CURBN done\n", index);

    % Evolve by CRBN and give feedback.
    [nodeUpdatedCRBN, tsmCRBN] = evolveCRBN(node, 100);
    fprintf("Trial %d, CRBN done\n", index);

    % Output difference.
    testCaseDiff = tsmCURBN - tsmCRBN;
end

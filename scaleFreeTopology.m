function conn = scaleFreeTopology(n, gamma, inDegUpper)

% SCALEFREETOPOLOGY Generate a connection matrix which follows a scale-free out-degree distribution in the ensemble limit.
%   
%   SCALEFREETOPOLOGY(N, GAMMA, INDEGUPPER) generates an n-by-n connection matrix that approximates
%   a power law distribution in the out-degrees of nodes and a Poisson distribution in the
%   in-degrees of nodes. The power law distribution has scaling exponent gamma. Each node will have
%   in-degree between 0 and inDegUpper. If inDegUpper is small, the in-degree distribution will
%   resemble a Poisson distribution up to inDegUpper but will be truncated.
%
%   Input:
%       n           - number of nodes in the network
%       gamma       - exponent of the power-law distribution (currently supported: positive & not equal to 1)
%       inDegUpper  - upper bound on the in-degree of any node
%
%   Output:
%       conn        - connection matrix (with repetition). conn(i,j) > 0 means i-->j.
%
%   Authors:        Masado Ishii - ECE PSU (Teuscher Lab)
%   Date:           2018-01-25
%   Last modified:  2018-02-05
%

%   Other References
%   ----------------
%   Bender, E. A., & Canfield, E. R. (1978). The asymptotic number of labeled graphs with given degree sequences. Journal of Combinatorial Theory, Series A, 24(3), 296-307.
%   Giacobini, M., Tomassini, M., De Los Rios, P., & Pestelacci, E. (2006). Dynamics of scalefree semi-synchronous Boolean networks. Artificial Life X, 1-7.


%   Notes
%   -----
%
%   Given an upper bound on the in-degree of nodes, the number of edges in the
%   network is bounded above by edgeUpper = N*degUpper. Then the power-law
%   distribution of out-degrees also has a cutoff, because we constrain
%       expected_total_out_degree = N*SUM_k{ k*P(k) } <= edgeUpper
%   , and this is a modest constraint. Is this cutoff a problem?
%
%   THE ORIGINAL POLICY, TO DEAL WITH THE ABOVE
%   Prof. Teuscher and I agreed on a policy to handle this. We want to keep the
%   in-degree upper bound, but we do not want to specify the cutoff for the out-
%   degree distribution. Instead, always draw from a pure power-law distribution 
%   until a sequence with acceptable total out-degree is generated. Then continue
%   as usual.
%
%   PROBLEM WITH THE ORIGINAL POLICY
%   When the degree exponent is very close to 1, huge out-degrees become likely.
%   It then takes practically forever to stumble upon an out-degree sequence with
%   sufficiently small total out-degree.
%
%   INTERIM SOLUTION
%   I use a finite cutoff for the out-degree distribution after all. However, I
%   use a cutoff that is sufficiently large to allow all out-degree sequences we
%   are interested in. For the occasional out-degree sequence whose sum is still
%   too large, I use the replacement policy from my original discussion with Prof.
%   Teuscher. Under the replacement policy, it turns out that a sufficiently large
%   but finite cutoff of out-degrees is equivalent to an infinite tail.


%TODO what really are the implications of rounding? E.g. we want <K> to be exact.


    % Algorithm 2
    % -----------
    % Determine the upper bound on number of links that would satisfy inDegUpper.
    % Generate an out-degree sequence d_i, one term per node i.
    % While numLinks := (the sum of the out-degree sequence) is too big:
    %   Regenerate the entire list.
    %   [It is not clear whether retaining part of the list would have statistical side-effects.]
    % Initialize the list of out-degree quotas as the out-degree sequence.
    % Initialize the list of committed in-degrees.
    % Initialize the set of nodes which still need oubound edges assigned.
    % Initialize the set of nodes which still have available input slots.
    % Initizliae the connection matrix.
    % For linkIdx in 1..numLinks:
    %   Randomly pick a pair (ii,jj) such that
    %           ii needs an oubound edge assigned and jj is not full of inputs already.
    %   Add 1 (ii,jj) to the adjacency matrix.
    %   Subtract 1 ii from out-degree quotas.
    %   If this causes quota of ii to be met, then remove ii from list of nodes still needing outbound edges.
    %   Add 1 jj to committed in-degrees.
    %   If this causes jj to reach inDegUpper, then remove jj from list of nodes with available inputs.


    % The sum of the in-degrees is equal to the number of links in a graph.
    % The same rule holds for the upper bounds.
    linkUpper = n.*inDegUpper;

    % Generate an out-degree sequence that isn't too crowded.
    kOutMin = 1;   % We decided that we don't need any nodes with 0 out-degree.
    outDegSeq = powerLawGeneratorDiscrete([1 n], gamma, kOutMin, linkUpper);       %Note, FINITE CUTOFF
    %numAttempts = 1;  %DEBUG
    while(sum(outDegSeq) > linkUpper)
        outDegSeq = powerLawGeneratorDiscrete([1 n], gamma, kOutMin, linkUpper);   %Note, FINITE CUTOFF
        %numAttempts = numAttempts + 1%; %DEBUG
    end

    % Disperse links randomly, with repetition, and so that inDeg <= inDegUpper for all nodes.
    %
    % The end result will be the connection matrix.
    % We keep track of the in-degrees and out-degrees of all nodes as we go.
    % This way we avoid summing over the entire matrix repeatedly.
    numLinks = sum(outDegSeq);
    outDegQuotas = outDegSeq;
    inDegrees = zeros(1,n);
    sourceCandidates = find(outDegQuotas);
    destCandidates = 1:n;
    conn = zeros(n);
    for linkIdx = 1:numLinks
        % Pick a link.
        source = sourceCandidates(randi(length(sourceCandidates), 1));
        dest = destCandidates(randi(length(destCandidates), 1));

        % Assign the link.
        conn(source, dest) = conn(source, dest) + 1;
        outDegQuotas(source) = outDegQuotas(source) - 1;
        inDegrees(dest) = inDegrees(dest) + 1;

        % Update sourceCandidates and destCandidates.
        if (outDegQuotas(source) == 0)
            sourceCandidates(sourceCandidates == source) = [];
        end
        if (inDegrees(dest) == inDegUpper)
            destCandidates(destCandidates == dest) = [];
        end
    end

end

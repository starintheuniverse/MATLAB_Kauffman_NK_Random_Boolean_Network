function k = powerLawGeneratorDiscrete(s, B, kmin, kmax)

% POWERLAWGENERATORDISCRETE
%   Sample a discrete random variable with power law distribution over kmin to kmax,
%   inclusive, with exponent B>1. That is, the probability mass function is
%           m(k) = 1/S * k^(-B),  where S = SUM_(kmin,kmax) {k^(-B)}
%
%
%   POWERLAWGENERATORDISCRETE(s, B, kmin, kmax) samples an array of size s from a power law distribution
%   over [kmin, kmax] with exponent B.
%
%   Inputs:
%       s       - [vector int]      Sizes to ouput, for example, [3 2] --> 3x2 matrix
%       B       - [scalar double]   Scaling exponent of the distribution
%       kmin    - [scalar int]      Minimum value to produce
%       kmax    - [scalar int]      Maximum value to produce
%
%   Author: Masado Ishii // Teuscher Lab, 2018-02-05
%   (Last change:                         2018-02-05)


    % Cache the cumulative mass function.
    persistent cmf B_p kmin_p kmax_p;
    if (isempty(cmf) || B_p ~= B || kmin_p ~= kmin || kmax_p ~= kmax)
        B_p = B;
        kmin_p = kmin;
        kmax_p = kmax;
        pmf = powerLawNormalized(-B, kmin, kmax);
        cmf = cumsum(pmf);
    end

    % Sample from the uniform distribution over [0,1). Make sure to initialize rng.
    Y = randInclude0(s);
    %Y = rand(s);   % This gives Y in (0,1).

    %TODO use binary search (i.e. findfirst() ) if hit performance bottleneck.
    k = arrayfun(@(y) find(y < cmf, 1), Y) + (kmin - 1);

end

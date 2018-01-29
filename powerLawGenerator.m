function k = powerLawGenerator(s, B, kmin, varargin)

% POWERLAWGENERATOR 
%   Sample a random variable with power law distribution over kmin to kmax,
%   with exponent B!=1. That is, the probability distribution function is
%           P(k) = (1-B) / (kmax^(1-B) - kmin^(1-B)) * k^(-B)
%
%       [zero if B>1 and kmax->infinity]---^
%
%
%   POWERLAWGENERATOR(s, B, kmin) samples an array of size s from a power law distribution
%   over [kmin, inf) with exponent B. If B and kmin are vectors, an additional dimension in
%   the output is created for each. The distribution is sampled once for every element of
%   the output array.
%
%   POWERLAWGENERATOR(s, B, kmin, kmax) samples an array of size s from a power law distribution
%   over [kmin, kmax] with exponent B. If B and kmin are vectors, an additional dimension in
%   the output is created for each. kmin and kmax are treated as parallel arrays and must have
%   the same length. The distribution is sampled once for every element of the output array.
%
%   Inputs:
%       s       - [vector int]      Sizes to ouput, for example, [3 2] --> 3x2 matrix
%       B       - [vector double]   Scaling exponent of the distribution
%       kmin    - [vector double]   Lower bound on values to produce
%       kmax    - [vector double]   (optional) Upper bound on values to produce, INF by default.
%
%   Author: Masado Ishii // Teuscher Lab, 2018-01-25
%   (Last change:                         2018-01-26)

%   References
%   ----------
%   http://mathworld.wolfram.com/RandomNumber.html


    % Use kmax if given, otherwise set kmax=infinity.
    if (nargin == 3)
        kmax = inf;
    elseif (nargin == 4)
        kmax = varargin{1};
    else
        error('Wrong number of arguments.');
    end
    

    % The formula from mathworld.com takes random numbers y sampled from the
    % uniform distribution over [0,1], and gives numbers sampled from a random
    % variable distributed as P(x) with support [x0,x1]. It is
    %
    %       x := ( (x1^(n+1) - x0^(n+1))*y + x0^(n+1) )^(1/(n+1))
    %
    % In our function, the variables are named
    %   x = k, x0 = kmin, x1 = kmax
    %   n = -B

    % Prepare the formula.
    % Extra syntax to make arrays if the inputs are vectors. (B varies down a column, k a row).
    oneMinusB = 1-B(:);
    offset = (kmin(:).').^oneMinusB;
    coefficient = (kmax(:).').^oneMinusB - offset;
    exponent = 1./oneMinusB;

    % If the inputs are vectors, make room for the dimensions specified in s.
    nd = length(s);
    offset = shiftdim(offset, -nd);
    coefficient = shiftdim(coefficient, -nd);
    exponent = shiftdim(exponent, -nd);

    % Sample from the uniform distribution over [0,1]. Make sure to initialize rng.
    y = rand([s(:)' length(B) length(kmin)]);

    % Now apply the formula.
    k = (coefficient.*y + offset).^exponent;

end

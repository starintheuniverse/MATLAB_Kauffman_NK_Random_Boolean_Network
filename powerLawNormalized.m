function pMassFunc = powerLawNormalized(gamma, kmin, kmax)

% POWERLAWNORMALIZED Probability mass function following a power law over [kmin, kmax]
% with exponent gamma.
%
%   Inputs:
%       gamma   - [scalar double] power law exponent, typically it should be negative
%       kmin    - [scalar int] minimum k for which p(k) is nonzero (finite, > 0)
%       kmax    - [scalar int] maximum k for which p(k) is nonzero (finite, >= kmin)
%
%   Outputs:
%       pMassFunc(t) == p(kmin+t-1), 1 <= t <= (kmax-kmin+1)
%           where p(k) is proportional to k^gamma.

%   Author: Masado Ishii // Teuscher Lab - ECE PSU
%   Date:   2018.02.01

    pMassFunc = (kmin:kmax).^gamma;
    pMassFunc = (1/sum(pMassFunc)).*pMassFunc;
end

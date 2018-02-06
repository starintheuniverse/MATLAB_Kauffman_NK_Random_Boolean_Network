function R = randInclude0(s)

% RANDINCLUDE0 Uniformly distributed pseudorandom numbers from the half-open interval [0,1),
% double precision.
%
%   Inputs:
%       s   - [vector int] size of output array
%
%   Outputs:
%       R   - [nd-array double] array of size s containing pseudorandom double-precision values

%   Author:     Masado Ishii // Teuscher Lab - ECE PSU
%   Date:       2018-02-06

%   References:
%       Code is based on forum answer and code example by Jan Simon
%       https://www.mathworks.com/matlabcentral/answers/13216-random-number-generation-open-closed-interval#answer_18116

%   Performance Notes
%   This method seems to take about 4 times longer than rand().
%       tic
%       for ii=1:1000000
%           rand(10);
%       end
%       toc                 % 3.903909 s
%       tic
%       for ii=1:1000000
%           randInclude0(10);
%       end
%       toc                 % 16.322956 s


    a = bitshift(randi([0 2^32-1], s), -5);     % 27 bits
    b = bitshift(randi([0 2^32-1], s), -6);     % 26 bits
    
    %    Upper 27 bits     Lower 26 bits   (a DOUBLE can represent 'significand' up to 53 bits of precision)
    %    |                 |
    %    |     2^26        |      2^53
    %    |     |           |      |
    R = (a .* 67108864.0 + b) ./ 9007199254740992.0;
end

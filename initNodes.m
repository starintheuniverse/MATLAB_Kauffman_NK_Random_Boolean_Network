function node = initNodes(n, varargin)

% INITNODES Generate structure-array containing node-state information.
%   
%   INITNODES(N) generates one-dimensional structure-array with N nodes
%   and randomly (uniformly distributed) sets initial node-states to 0 or 1.
%   The cued field will be set to 1 for a single random (uniformly distributed) node,
%   and to 0 for all other nodes. Update parameters
%   will randomly be set as follows: p = 1:4 ; q = 0; (as proposed by Gershenson)
%
%   INITNODES(N, PMAX, QMAX) generates one-dimensional structure-array with N nodes 
%   and randomly (uniformly distributed) sets initial node-states to 0 or 1.
%   The cued field will be set to 1 for a single random (uniformly distributed) node,
%   and to 0 for all other nodes. Update parameters
%   p and q are also set randomly. (p ~ U[1:PMAX], q ~ U[0:QMAX])
%
%   INITNODES(N, INITIALSTATE, INITIALP, INITIALQ) generates one-dimensional sructure-array 
%   with N nodes and sets initial node-states according to INITIALSTATE array.
%   The cued field will be set to 1 for a single random (uniformly distributed) node,
%   and to 0 for all other nodes. Update parameters
%   p and q are set according to the vectors INITIALP and INITIALQ
%
%   INITNODES(N, INITIALSTATE, INITIALCUED, INITIALP, INITIALQ) generates one-dimensional
%   structure-array with N nodes; sets initial node-states according to INITIALSTATE array; and
%   sets initial node update-cues according to INITIALCUED array. Update parameters
%   p and q are set according to the vectors INITIALP and INITIALQ.
%
%   Input:
%       n               - Number of nodes in the Random Boolean Network
%       initialState    - (Optional) Vector containing initial states of network nodes
%       initialCued     - (Optional) Vector containing update-cue statuses of nodes (Cascade Update)
%       initialP        - (Optional) Vector containing initial update parameters p
%       initialQ        - (Optional) Vector containing initial update parameters q
%       pMax            - (Optional) Maximum value of p
%       qMax            - (Optional) Maximum value of q
%
%   Output: 
%       node            - Structure-array of nodes
%
%         node.state        - Actual State (0 or 1)
%         node.nextState    - Next State   (0 or 1)
%         node.cued         - Cue to update on next time step (0 or 1) (Cascade Update)
%         node.nbUpdates    - Number of updates on this node
%         node.input        - Vector of indices to the incoming nodes
%         node.output       - Vector of indices to the outgoing nodes
%         node.p            - Update parameter p
%         node.q            - Update parameter q
%         node.lineNumber   - State-input-vector in decimal representation = LUT rownumber
%         node.rule         - Vector containing transition logic rule for this node

%   Authors: Christian Schwarzer - SSC EPFL
%            ====[Original RBN Toolbox (20.01.2003)]
%
%            Masado Ishii - ECE PSU
%            ====[Added "initialCued" input and "cued" output field, for Cascade Update (05.01.2018)]
%
%   CreationDate: 4.11.2002 LastModified: 05.01.2018

% no initialState vector given -> initialize at random
if (nargin == 1)
    initialState = randint(1,n,[0,1]);  
    initialCued  = circshift([1 zeros(1,n-1)], randi(n));  % Select random node (M.Ishii 05.01.2018)
    initialP     = randint(1,n,[1,4]);
    
    for i=1:n
        node(i).state        = int8(initialState(i));
        node(i).nextState    = int8(0);
        node(i).cued         = int8(initialCued(i));    % (M.Ishii 05.01.2018)
        node(i).nbUpdates    = 0;
        node(i).x            = 0;
        node(i).y            = 0;
        node(i).input        = [];
        node(i).output       = [];
        node(i).p            = initialP(i);
        node(i).q            = 0;
        node(i).lineNumber   = 0;
        node(i).rule         = [];
    end     

%n, pMax, qMax
elseif(nargin == 3)
    pMax = varargin{1};
    qMax = varargin{2};
    if(qMax >= pMax)
        error('pMax must be greater than qMax');    
    end
    
    initialState = randint(1,n,[0,1]);
    initialCued  = circshift([1 zeros(1,n-1)], randi(n));  % Select random node (M.Ishii 05.01.2018)
    initialP     = randint(1,n,[1,pMax]);
    initialQ     = randint(1,n,[1,qMax]);
    for i=1:n
        node(i).state        = int8(initialState(i));
        node(i).nextState    = int8(0);
        node(i).cued         = int8(initialCued(i));    % (M.Ishii 05.01.2018)
        node(i).nbUpdates    = 0;
        node(i).x            = 0;
        node(i).y            = 0;
        node(i).input        = [];
        node(i).output       = [];
        node(i).p            = initialP(i);
        node(i).q            = initialQ(i);
        node(i).lineNumber   = 0;
        node(i).rule         = [];
    end   
    
  
 

% use initialState, initialP, initialQ vectors    
elseif (nargin == 4)
    initialState = varargin{1};
    initialP     = varargin{2};
    initialQ     = varargin{3};
    if(n ~= length(initialState) | n~= length(initialP) | n~= length(initialQ))
       error('Length of initialState, initialP and initialQ vectors should correspond to number of nodes')
    end

    initialCued  = circshift([1 zeros(1,n-1)], randi(n));  % Select random node (M.Ishii 05.01.2018)
    for i=1:n
        node(i).state     = int8(initialState(i));
        node(i).nextState = int8(0);
        node(i).cued      = int8(initialCued(i));    % (M.Ishii 05.01.2018)
        node(i).nbUpdates = 0;
        node(i).x         = 0;
        node(i).y         = 0;
        node(i).input     = [];
        node(i).output    = [];
        node(i).p         = initialP(i);
        node(i).q         = initialQ(i);
    end   
        
% use initialState, initialCued, initialP, initialQ vectors    
elseif (nargin == 5)
    initialState = varargin{1};
    initialCued  = varargin{2};
    initialP     = varargin{3};
    initialQ     = varargin{4};
    if(n ~= length(initialState) | n~= length(initialCued) | n~= length(initialP) | n~= length(initialQ))
       error('Length of initialState, initialCued, initialP and initialQ vectors should correspond to number of nodes')
    end
    
    for i=1:n
        node(i).state     = int8(initialState(i));
        node(i).nextState = int8(0);
        node(i).cued      = int8(initialCued(i));    % (M.Ishii 05.01.2018)
        node(i).nbUpdates = 0;
        node(i).x         = 0;
        node(i).y         = 0;
        node(i).input     = [];
        node(i).output    = [];
        node(i).p         = initialP(i);
        node(i).q         = initialQ(i);
    end   

% wrong number of arguments    
else
    error('Wrong number of arguments. Type: help initNodes')
end






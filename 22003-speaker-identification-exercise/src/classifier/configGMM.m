function P = configGMM(varargin)
%configGMM   Configure a Gaussian mixture model (GMM) classifier.
%
%USAGE
%    P = configGMM
%    P = configGMM({'nGMMComponents',4}})
%    P = configGMM({'nGMMComponents',4,'nIterEM',5, .... }})
%
%INPUT ARGUMENTS
%    varargin : cell array consisting of parameter/value pairs 
%                    'method' - string specifying GMM training method
%                               'netlab'
%                               'matlab'
%            'nGMMComponents' - number of Gaussian components
%                   'nIterEM' - number of EM iterations
%                   'thresEM' - EM convergence threshold
%                    'cvType' - type of covariance matrix ('diag' or 'full')
%                'regularize' - regularization of covariance matrices
%               'bApplyPrior' - use class-dependent prior probability during
%                               classification
%
%OUTPUT ARGUMENTS
%           P : parameter struct that can be used to initialize the GMM
%               training 

%   Developed with Matlab 8.3.0.532 (R2014a). Please send bug reports to:
%   
%   Author  :  Tobias May, © 2015
%              Technical University of Denmark (DTU)
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2015/02/26
%   ***********************************************************************


%% CONFIGURE PARAMETERS
% 
% 
% Create default parameter struct
PRef = struct('label','GMM parameters','method','netlab',...
    'nGMMComponents',16,'nIterEM',5,'thresEM',1E-3,'cvType','full',...
    'regularize',1E-9,'bApplyPrior',true);

% Fields that shouldn't be changed
blocked = {'label'};

% Number of GMM models
nGMMs = numel(varargin);

% Replicate parameter struct
if nGMMs > 0
    P = repmat(PRef,[nGMMs 1]);
else
    P = PRef;
end

% Loop over the number of GMM models
for ii = 1 : nGMMs
    
    % Check if ii-th input is of type cell
    if iscell(varargin{ii})
        % Modify parameters
        P(ii) = parseCell2Struct(P(ii),varargin{ii},blocked);
    else
        error('The input must be a cell array with parameter/value pairs.')
    end
end


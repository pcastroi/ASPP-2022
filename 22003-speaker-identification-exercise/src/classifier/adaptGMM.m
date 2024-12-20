function gmmFinal = adaptGMM(data,labels,gmmUBM,nIter,thresEM)
%adaptGMM   Adapt GMM from a universal background model (UBM)


%% CHECK INPUT ARGUMENTS  
% 
% 
% Check for proper input arguments
if nargin < 3 || nargin > 5
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 4  || isempty(nIter);   nIter   = 5;    end
if nargin < 5  || isempty(thresEM); thresEM = 1E-3; end

% Determine feature observations
nObs = size(data,1);

% Check consistency
if nObs ~= length(labels)
    error('Mismatch between feature space and the number of class labels');
end


%% GMM PARAMETERS
% 
% 
% EM options
optEM     = foptions;
optEM(1)  = -1;
optEM(3)  = thresEM;  % EM threshold
optEM(5)  = true;     % Check covariance matrices 
optEM(8)  = true;     % Store log-error
optEM(14) = nIter;    % Maximum number of iterations

% Select N GMMs for model adaptation
selectGMMs = inf;


%% CONFIGURE UBM ADAPTATION
% 
% 
% Relevance factor [Mean Variance Prior]
r = [16 0 0];

% Adapt [Mean Variance Prior]
bAdapt = [true false false];

% Minimum component weight
minPriorGMM = 1E-5;

% Create UBM structure
paramUBM = struct('label','UBM configuration','bAdapt',bAdapt,...
                  'relevance',r,'selectGMMs',selectGMMs,...
                  'minPriorGMM',minPriorGMM);

% Find unique number of classes
classIdx = unique(labels);
nClasses = length(classIdx);

% Allocate GMM structure
gmmFinal = repmat(gmmUBM,[1 nClasses]);


%% PERFORM UBM ADAPTATION
% 
% 
% Loop over number of classes
for ii = 1 : nClasses

    % Find indices of ii-th class
    currClass = labels == classIdx(ii);
        
    % Adapt UBM model to class-dependent features
    gmmFinal(ii) = gmmmap(gmmUBM,data(currClass,:),optEM,paramUBM);
end

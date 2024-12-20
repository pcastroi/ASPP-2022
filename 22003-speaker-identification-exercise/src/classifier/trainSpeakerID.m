function [GMM_Model,prior] = trainSpeakerID(fSpace,labels,nGMMComponents)
%trainSpeakerID   Train speaker-specific feature distributions using GMMs


%% CHECK INPUT ARGUMENTS  
% 
% 
% Check for proper input arguments
if nargin < 2 || nargin > 3
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 3 || isempty(nGMMComponents); nGMMComponents = 16; end


%% PERFORM GMM TRAINING
% 
% 
% Initialize GMM parameters
P_GMM = configGMM({'nGMMComponents',nGMMComponents,'cvType','diag',...
    'nIterEM',5});

% Train UBM 
UBM_Model = trainGMM(fSpace,ones(size(labels)),P_GMM);
 
% Adapt speaker-specific GMMs
GMM_Model = adaptGMM(fSpace,labels,UBM_Model);

% Compute a priori probability of class occurence during training
prior = hist(labels,1:max(labels))/numel(labels);

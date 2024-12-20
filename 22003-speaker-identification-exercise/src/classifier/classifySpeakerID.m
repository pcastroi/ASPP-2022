function classIdx = classifySpeakerID(fSpace,labels,GMM_Models,prior)
%classifySpeakerID   Classify the most likely speaker identity.


%% CHECK INPUT ARGUMENTS  
% 
% 
% Check for proper input arguments
if nargin < 3 || nargin > 4
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 4 || isempty(prior)
    % Assume equal probability across speaker models
    prior = ones(1,length(GMM_Models))/length(GMM_Models); 
end


%% PERFORM CLASSIFICATION
% 
% 
% Number of classes
nClasses = max(labels(3,:));

% Number of sentences
nSentences = size(labels,2);

% Calculate frame-based probabilities
prob = classifyGMM(GMM_Models,fSpace,prior);

% Allocate memory
probSiD = zeros(nClasses,nSentences);

% File-based probabilities for all speaker
for ss = 1 : nSentences
    % Integrate probabilities across all frames
    probSiD(:,ss) = sum(log(prob(labels(1,ss):labels(2,ss),:)));
end

% Classification
classIdx = argmax(probSiD,1);

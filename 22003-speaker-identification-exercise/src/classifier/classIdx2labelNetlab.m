function label = classIdx2labelNetlab(classIdx,nClasses)
%classIdx2labelNetlab   Convert class labels to the NETLAB format

% Number of observations
nObs = length(classIdx);

% Allocate memory
label = zeros(nObs,nClasses);

% Create NETLAB label vector
for ii = 1 : nClasses
    label(:,ii) = classIdx==ii;
end
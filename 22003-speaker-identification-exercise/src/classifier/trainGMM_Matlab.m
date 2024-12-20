function gmmFinal = trainGMM_Matlab(data,labels,K,nIter,thresEM,cv,reg)
%trainGMM_Matlab   Train a Gaussian mixture model (GMM) classifier

%   Developed with Matlab 7.5.0.342 (R2007b). Please send bug reports to:
%   
%   Author  :  Tobias May, © 2009-2010 
%              University of Oldenburg and TU/e Eindhoven 
%              tobias.may@uni-oldenburg.de   t.may@tue.nl
%
%   History :
%   v.0.1   2009/11/23
%   v.0.2   2014/07/10 adopted to Matlab's gmdistribution
%   ***********************************************************************



%% ***********************  CHECK INPUT ARGUMENTS  ************************
% 
% 
% Set default values
if nargin < 3 || isempty(K);       K       = 4;      end
if nargin < 4 || isempty(nIter);   nIter   = 100;    end
if nargin < 5 || isempty(thresEM); thresEM = 1e-4;   end
if nargin < 6 || isempty(cv);      cv      = 'full'; end
if nargin < 7 || isempty(reg);     reg     = eps;    end

% KMeans options
optKMeans     = foptions;
optKMeans(1)  = -1;
optKMeans(5)  = true;     % Initialize centres from data
optKMeans(14) = 15;       % KMeans iterations

% EM options
opt.Display = 'off';
opt.MaxIter = nIter;
opt.TolFun  = thresEM;

% Determine feature space dimensions
[nObs, nFeatures] = size(data);

% Check consistency
if nObs ~= length(labels)
    error('Mismatch between feature space and the number of class labels');
end

% Find unique number of classes
classIdx = unique(labels);
nClasses = length(classIdx);

% Initialize GMM structure for each class
gmmFinal = repmat(gmm(nFeatures,K,cv),[nClasses 1]);

% Loop over number of classes
for ii = 1 : nClasses
    
    % Find indices of ii-th class
    currClass = labels == classIdx(ii);
    
    % Select feature space of current class
    currFeatSpace = data(currClass,:);
    
    % Initialize GMM components using kMeans clustering
    gmmFinal(ii) = gmminit(gmmFinal(ii),currFeatSpace,optKMeans);
    
    % Read out GMM parameters
    if isequal(cv,'diag')
        S.mu          = gmmFinal(ii).centres;
        S.Sigma       = permute(gmmFinal(ii).covars,[3 2 1]);
        S.PComponents = gmmFinal(ii).priors;
        CovType       = 'diagonal';
        bShareCov     = false;
    elseif isequal(cv,'full')
        S.mu          = gmmFinal(ii).centres;
        S.Sigma       = gmmFinal(ii).covars;
        S.PComponents = gmmFinal(ii).priors;
        CovType       = 'full';        
        bShareCov     = false;
    elseif isequal(cv,'tied')
        S.mu          = gmmFinal(ii).centres;
        S.Sigma       = gmmFinal(ii).covars;
        S.PComponents = gmmFinal(ii).priors;
        CovType       = 'full';
        bShareCov     = true;
    else
        error('Covariance ''%s'' is not supported!',cv);
    end
        
    if bShareCov
        S.Sigma = mean(gmmFinal(ii).covars,3);
    end
    
    % Train GMM model for individual classes
    obj = gmdistribution.fit(currFeatSpace,K,'Start',S,...
                             'CovType',CovType,'Regularize',reg,...
                             'Options',opt,'sharedcov',bShareCov);
%     obj = gmdistribution.fit(currFeatSpace,K,...
%                              'CovType',CovType,'Regularize',reg,...
%                              'Options',opt,'sharedcov',bShareCov,'replicates',5);                         
                     
                         
    % Create GMM structure 
    gmmFinal(ii).centres = obj.mu;
    if isequal(cv,'diag')
        gmmFinal(ii).covars = permute(obj.Sigma,[3 2 1]);
    else
        gmmFinal(ii).covars = obj.Sigma;
    end
    if bShareCov
        % Replicate covariance matrix
        gmmFinal(ii).covars = repmat(gmmFinal(ii).covars,[1 1 K]);
    end
    gmmFinal(ii).priors = obj.PComponents;
end


%   ***********************************************************************
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% 
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
% 
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.
%   ***********************************************************************
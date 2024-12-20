function [mix, options, ubm, errlog] = gmmmap(ubm, x, options, c)
%gmmmap   Adapt a GMM from a UBM using Maximum A Posteriori (MAP) criteria.
%
%	Description
%	[UBM, OPTIONS, ERRLOG] = GMMEM(UBM, X, OPTIONS) uses the Expectation
%	Maximization algorithm of Dempster et al. to estimate the parameters
%	of a Gaussian mixture model defined by a data structure MIX. The
%	matrix X represents the data whose expectation is maximized, with
%	each row corresponding to a vector.    The optional parameters have
%	the following interpretations.
%
%	OPTIONS(1) is set to 1 to display error values; also logs error
%	values in the return argument ERRLOG. If OPTIONS(1) is set to 0, then
%	only warning messages are displayed.  If OPTIONS(1) is -1, then
%	nothing is displayed.
%
%	OPTIONS(3) is a measure of the absolute precision required of the
%	error function at the solution. If the change in log likelihood
%	between two steps of the EM algorithm is less than this value, then
%	the function terminates.
%
%	OPTIONS(5) is set to 1 if a covariance matrix is reset to its
%	original value when any of its singular values are too small (less
%	than MIN_COVAR which has the value eps).   With the default value of
%	0 no action is taken.
%
%	OPTIONS(14) is the maximum number of iterations; default 100.
%
%	The optional return value OPTIONS contains the final error value
%	(i.e. data log likelihood) in OPTIONS(8).
%
%	See also
%	GMM, GMMINIT
%
%NOTE
%   If the MAP algorithm is configured to update the full GMM model,
%   including mean, variances and priors, and if furthermore all three
%   relevance factors are set to zero, the estimated GMM parameters will be
%   equal to the ML criterion (Expectation Maximization).

%	Copyright (c) Ian T Nabney (1996-2001)

%   Tobias May, 2009/02/25
%   ----------------------
%   Modified to match Reynold's approach to floor the covariance for
%   diagonal covariance represenation...


% Configure UBM
if nargin < 4 || isempty(c); c = configUBM; end

% Check that inputs are consistent
errstring = consist(ubm, 'gmm', x);

% Report error
if ~isempty(errstring)
    error(errstring);
end

% Get space feature dimension
[ndata, xdim] = size(x);

% Sort out the options
display = options(1);

% Number of iterations
if (options(14))
    niters = options(14);
else
    niters = 100;
end

% Store the error values 
if (nargout > 3)
    store  = 1;	
    errlog = zeros(1, niters);
else
    store = 0;
end

% Test log likelihood for termination
if options(3) > 0.0
    test = 1;	
else
    test = 0;
end

% Covariance flooring
if options(5) > 0
    if display >= 0 && c.bAdapt(2)
        disp('Covariance flooring is on');
    end
    % Minimum singular value of covariance matrix
    MIN_COVAR = options(5);
else
    % De-activate covariance flooring
    MIN_COVAR = 0;
end

% Reduce size of UBM
if c.selectGMMs < ubm.ncentres
    % Calculate probabilistic alignment of UBM and test vector
    post = gmmpost(ubm, x);
     
    % Rank Gaussian mixtures according to its probabilistic count
    [pVal,pIdx] = sort(sum(post,1),'descend'); %#ok
    
    % Select "selectGMMs" best Gaussian components
    sIdx = pIdx(1:c.selectGMMs);
    
    % --------------------------------------------------------
    % Adapt UBM to new size
    % --------------------------------------------------------
    ubm.ncentres = c.selectGMMs;
    ubm.nwts     = ubm.ncentres + ubm.ncentres * ubm.nin + ...
                   ubm.ncentres*ubm.nin;
    ubm.centres  = ubm.centres(sIdx,:);
    ubm.covars   = ubm.covars(sIdx,:);
    ubm.priors   = ubm.priors(sIdx);
    
    % Re-normalize priors
    ubm.priors   = ubm.priors/sum(ubm.priors);
end

% Initialize GMM model "mix" which should be adapted from the UBM
mix = ubm;

% Main loop of algorithm
for n = 1:niters
  
  % Calculate posteriors based on "old" parameters (Eq. 7)
  [post, act] = gmmpost(mix, x);
  
  % Calculate error value if needed
  if (display || store || test)
      % Compute data probability 
      prob = act*(mix.priors)';
      % Error value is negative log likelihood of data
      e = - sum(log(prob));
      if store
          errlog(n) = e;
      end
      if display > 0
          fprintf(1, 'Cycle %4d  Error %11.6f\n', n, e);
      end
      if test
          if (n > 1 && abs(e - eold) < options(3))
              options(8) = e;
              return;
          else
              eold = e;
          end
      end
  end
  
  % Probabilistic counts 
  ni = sum(post, 1); % (Eq. 8)
  ei = post' * x;    % (Eq. 9)

  % Compute data-dependent adaptation coefficient (Eq. 14)
  %
  % A low probabilistic count will deemphasize the adaptation of the
  % corresponding Gaussian component.
  alphaM = transpose(ni ./ (ni + c.relevance(1)));
  alphaV = transpose(ni ./ (ni + c.relevance(2)));
  alphaW = ni ./ (ni + c.relevance(3));

  % --------------------------------------------------------------
  % Check if enough data is available for updating GMM components
  % --------------------------------------------------------------
  % Prevent under-representated GMM components from beeing updated
  vIdx = (ni ./ ndata) >= c.minPriorGMM;
  
  % Adapt mixture priors (Eq. 11)
  if c.bAdapt(3) > 0
      mix.priors(vIdx) = alphaW(vIdx) .* (ni(vIdx) ./ ndata) + ...
                         (1-alphaW(vIdx)) .* ubm.priors(vIdx);
                     
      % Normalize weights
      mix.priors = mix.priors / sum(mix.priors);
  end
  
  % Adapt mixture mean (Eq. 12)
  if c.bAdapt(1) > 0
      mix.centres(vIdx,:) = repmat(alphaM(vIdx),[1 xdim]) .*   ...
                            (ei(vIdx,:) ./ (ni(vIdx)' *        ...
                            ones(1, mix.nin))) +               ...
                            repmat(1-alphaM(vIdx),[1 xdim]) .* ...
                            ubm.centres(vIdx,:);
  end
  
  % Adapt mixture covariance (Eq. 13)
  if c.bAdapt(2) > 0
      switch lower(mix.covar_type)
          case 'diag'
              % Loop over components which should be updated
              for j = find(vIdx)
                  diffs = x - (ones(ndata, 1) * mix.centres(j,:));
                  cvNew = sum((diffs.*diffs).*(post(:,j) * ...
                          ones(1,mix.nin)), 1)./ni(j);
                  
                  mix.covars(j,:) = alphaV(j) * cvNew + (1-alphaV(j)) * ...
                                    (ubm.covars(j,:)+ubm.centres(j,:).^2);
                                
                  % Covariance flooring
                  mix.covars(j,:) = mix.covars(j,:) + MIN_COVAR;
              end
          otherwise
              error(['Covariance type "',lower(mix.covar_type),...
                     '" is not recognized']);
      end
  end

end

% Store final error
options(8) = -sum(log(gmmprob(mix, x)));

if (display >= 0)
    fprintf(maxitmess);
end
  

function paramUBM = configUBM

% Select N GMMs for model adaptation
selectGMMs = inf;

% Relevance factor [Mean Variance Prior]
r = [16 0 0];

% Adapt [Mean Variance Prior]
bAdapt = [true false false];

% Minimum component weight
minPriorGMM = 1e-5;

% Create UBM structure
paramUBM = struct('label','UBM configuration','bAdapt',bAdapt,'relevance',r,...
                  'selectGMMs',selectGMMs,'minPriorGMM',minPriorGMM);
  
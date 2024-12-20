function prob = classifyGMM(mix,featSpace,prior)


%% CHECK INPUT ARGUMENTS  
% 
% 
% Check for proper input arguments
if nargin < 2 || nargin > 3
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Number of classes
nClasses = length(mix);

% Initialize equal prior probability of class presence
if nargin < 3 || isempty(prior); prior = ones(nClasses,1)/nClasses; end


%% PERFORM CLASSIFICATION
% 
% 
% Allocate memory
prob = zeros(size(featSpace,1),nClasses);

% Loop over number of classes
for jj = 1 : nClasses
    prob(:,jj) = prior(jj) * gmmprob(mix(jj),featSpace);
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
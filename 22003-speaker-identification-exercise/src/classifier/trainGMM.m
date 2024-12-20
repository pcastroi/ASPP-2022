function [C,P] = trainGMM(data,labels,varargin)
%trainGMM   Train a Gaussian mixture model (GMM) classifier


%   Developed with Matlab 7.5.0.342 (R2007b). Please send bug reports to:
%   
%   Author  :  Tobias May, © 2009-2010 
%              University of Oldenburg and TU/e Eindhoven 
%              tobias.may@uni-oldenburg.de   t.may@tue.nl
%
%   History :
%   v.0.1   2009/11/23
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS
% 
% 
% Check for proper input arguments
if nargin < 2
    help(mfilename);
    error('Wrong number of input arguments!')
end


%% CONFIGURE PARAMETERS
% 
% 
% Check if input is a struct
if numel(varargin) == 1 && isstruct(varargin{1})
    % Copy parameters
    P = varargin{1};
else
    % Parse varargin 
    P = configGMM(varargin{:});
end


%% PERFORM TRAINING
% 
% 
% Select method
switch lower(P.method)
    case 'netlab'
        C = trainGMM_Netlab(data,labels,P.nGMMComponents,P.nIterEM,...
            P.thresEM,P.cvType,P.regularize);
    case 'matlab'
        C = trainGMM_Matlab(data,labels,P.nGMMComponents,P.nIterEM,...
            P.thresEM,P.cvType,P.regularize);
    otherwise
        error('Method is not supported.')
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
function [tc,relres,iter,xrec] = gabgrouplasso(x,g,a,M,lambda,varargin)
%GABGROUPLASSO  Group LASSO regression in Gabor domain
%   Usage: [tc,xrec] = gabgrouplasso(x,g,a,M,group,lambda,C,maxit,tol)
%
%   GABGROUPLASSO has been deprecated. Please use FRAMEGROUPLASSO instead.
%
%   A call to GABGROUPLASSO(x,g,a,M,lambda) can be replaced by :
%
%     F=newframe('dgt',[],g,a,M);
%     tc=framegrouplasso(F,lambda);
%
%   Any additional parameters passed to GABGROUPLASSO can be passed to
%   FRAMEGROUPLASSO in the same manner.
%
%   See also: newframe, framegrouplasso
%
%   Url: http://ltfat.sourceforge.net/doc/deprecated/gabgrouplasso.php

% Copyright (C) 2005-2012 Peter L. Søndergaard.
% This file is part of LTFAT version 1.2.0
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

warning(['LTFAT: GABGROUPLASSO has been deprecated, please use FRAMEGROUPLASSO ' ...
         'instead. See the help on GABGROUPLASSO for more details.']);   

F=newframe('dgt',[],g,a,M);
[tc,relres,iter,xrec] = framegrouplasso(F,lambda,varargin{:});


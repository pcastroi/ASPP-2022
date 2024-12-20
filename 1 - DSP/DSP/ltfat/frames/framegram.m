function framegram(F,x,varargin);
%FRAMEGRAM  Easy visualization of energy in frame space
%   Usage: framegram(F,x);
%
%   framefram(F,x) plots the energy of the coefficients computes from
%   the input signal x using the frame F for analysis. This is
%   just a shorthand for:
%
%     plotframe(F,abs(frana(F,x)).^2);
%
%   Any additional arguments given to FRAMEGRAM are passed onto
%   PLOTFRAME.
%
%   See also: plotframe
%
%   Url: http://ltfat.sourceforge.net/doc/frames/framegram.php

% Copyright (C) 2005-2012 Peter L. S�ndergaard.
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
    
plotframe(F,abs(frana(F,x)).^2,varargin{:});

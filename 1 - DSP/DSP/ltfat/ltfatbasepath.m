function bp = ltfatbasepath;
%LTFATBASEPATH  The base path of the LTFAT installation
%   Usage: bp = ltfatbasepath;
%
%   LTFATBASEPATH returns the top level directory in which the LTFAT
%   files are installed.
%
%   See also: ltfatstart
%
%   Url: http://ltfat.sourceforge.net/doc/ltfatbasepath.php

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
  
f=mfilename('fullpath');

bp = f(1:end-13);



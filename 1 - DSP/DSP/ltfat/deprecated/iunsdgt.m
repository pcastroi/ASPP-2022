function f=iunsdgt(c,g,a,varargin)
%IUNSDGT  Inverse uniform nonstationary discrete Gabor transform
%   Usage:  f=iunsdgt(c,g,a,Ls);
%
%   Input parameters:
%         c     : Cell array of coefficients.
%         g     : Cell array of window functions.
%         a     : Vector of time positions of windows.
%         Ls    : Length of input signal.
%   Output parameters:
%         f     : Signal.
%
%   IUNSDGT(c,g,a,Ls) computes the nonstationary Gabor expansion of the 
%   input coefficients c.
%
%   IUNSDGT is used to invert the function NSDGT. Read the help of NSDGT
%   for details of variables format and usage.
%
%   For perfect reconstruction, the windows used must be dual windows of 
%   the ones used to generate the coefficients. The windows can be
%   generated unsing NSGABDUAL.
%
%   See also:  unsdgt, nsgabdual, nsgabtight
%
%   Demos:  demo_nsdgt
%
%   References:
%     F. Jaillet, M. D�rfler, and P. Balazs. LTFAT-note 10: Nonstationary
%     Gabor Frames. In Proceedings of SampTA, 2009.
%     
%     
%
%   Url: http://ltfat.sourceforge.net/doc/deprecated/iunsdgt.php

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

%   AUTHOR : Florent Jaillet
%   TESTING: TEST_NSDGT
%   REFERENCE: 
%   Last changed 2009-05

warning(['LTFAT: IUNSDGT has been deprecated, use INSDGT instead.']);  

f=insdgt(varargin{:});

  


function f=insdgtreal(c,g,a,M,varargin)
%INSDGTREAL  Inverse NSDGT for real-valued signals
%   Usage:  f=insdgt(c,g,a,M,Ls);
%
%   Input parameters:
%         c     : Cell array of coefficients.
%         g     : Cell array of window functions.
%         a     : Vector of time positions of windows.
%         M     : Vector of numbers of frequency channels.
%         Ls    : Length of input signal.
%   Output parameters:
%         f     : Signal.
%
%   insdgt(c,g,a,Ls) computes the inverse non-stationary Gabor transform
%   of the input coefficients c.
%
%   insdgt is used to invert the functions NSDGT and |unsdgt|_. Please
%   read the help of these functions for details of variables format and
%   usage.
%
%   For perfect reconstruction, the windows used must be dual windows of the
%   ones used to generate the coefficients. The windows can be generated
%   using NSGABDUAL or |nsgabtight|_.
%
%   See also:  nsdgt, nsgabdual, nsgabtight
%
%   Demos:  demo_nsdgt
%
%   References:
%     F. Jaillet, M. D�rfler, and P. Balazs. LTFAT-note 10: Nonstationary
%     Gabor Frames. In Proceedings of SampTA, 2009.
%     
%     
%
%   Url: http://ltfat.sourceforge.net/doc/nonstatgab/insdgtreal.php

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

%   AUTHOR : Florent Jaillet and Nicki Holighaus
%   TESTING: TEST_NSDGT
%   REFERENCE: 
%   Last changed 2009-05

if nargin<3
  error('%s: Too few input parameters.',upper(mfilename));
end;

if ~isnumeric(a)
  error('%s: a must be numeric.',upper(mfilename));
end;

definput.keyvals.Ls=[];
[flags,kv,Ls]=ltfatarghelper({'Ls'},definput,varargin);

timepos=cumsum(a)-a(1);
L=sum(a);

if iscell(c)
    % ---- invert the non-uniform case ---------
    
    N=length(c); % Number of time positions
    W=size(c{1},2); % Number of signal channels
    
else
    % ---- invert the uniform case ----------------
    [M2, N, W]=size(c);
    
end

[g,info]=nsgabwin(g,a,M);

f=zeros(L,W); % Initialisation of the result

for ii = 1:N
    Lg = length(g{ii});
    gt = g{ii};
    
    % This is an explicit fftshift
    idx=[Lg-floor(Lg/2)+1:Lg,1:ceil(Lg/2)];
    gt = gt(idx);
    
    win_range = mod(timepos(ii)+(-floor(Lg/2):ceil(Lg/2)-1),L)+1;
    
    if iscell(c)
        temp = ifftreal(c{ii},M(ii),1)*M(ii);
        idx = mod([M(ii)-floor(Lg/2)+1:M(ii),1:ceil(Lg/2)]-1,M(ii))+1;
    else
        temp = ifftreal(c(:,ii,:),M,1)*M;
        idx = mod([M-floor(Lg/2)+1:M,1:ceil(Lg/2)]-1,M)+1; 
    end
    temp = temp(idx,:);
    f(win_range,:) = f(win_range,:) + bsxfun(@times,temp,gt);
end

if ~isempty(Ls)
  f = f(1:sum(a),:);
end;



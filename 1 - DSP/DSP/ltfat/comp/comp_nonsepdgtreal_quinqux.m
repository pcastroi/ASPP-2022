function c=comp_nonsepdgtreal_quinqux(f,g,a,M)
%COMP_NONSEPDGTREAL_QUINQUX  Compute Non-separable Discrete Gabor transform
%   Usage:  c=comp_nonsepdgtreal_quinqux(f,g,a,M);
%
%   This is a computational subroutine, do not call it directly.
%
%   Url: http://ltfat.sourceforge.net/doc/comp/comp_nonsepdgtreal_quinqux.php

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

%   AUTHOR : Nicki Holighaus and Peter L. Søndergaard
%   TESTING: TEST_NONSEPDGT
%   REFERENCE: REF_NONSEPDGT

lt=[1 2];

L=size(f,1);
W=size(f,2);
N=L/a;
M2=floor(M/2)+1;

% ----- algorithm starts here, split into sub-lattices ---------------

c=zeros(M,N,W);

mwin=comp_nonsepwin2multi(g,a,M,[1 2],L);

% simple algorithm: split into sublattices

for ii=0:1
    c(:,ii+1:2:end,:)=comp_dgt(f,mwin(:,ii+1),2*a,M,[0 1],0,0,0);
end;

% Phase factor correction 
E = zeros(1,N);
for win=0:1
    for n=0:N/2-1
        E(win+n*2+1) = exp(-2*pi*i*a*n*rem(win,2)/M);
    end;
end;

c=bsxfun(@times,c(1:M2,:,:),E);


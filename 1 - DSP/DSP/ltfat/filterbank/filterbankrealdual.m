function gdout=filterbankrealdual(g,a,varargin);
%FILTERBANKREALDUAL  Dual filters of filterbank for real signals only 
%   Usage:  gd=filterbankdual(g,a);
%
%   filterabankdual(g,a) computes the canonical dual filters of g for a
%   channel subsampling rate of a (hop-size). The dual filters work only
%   for real-valued signals. Use this function on the common construction
%   where the filters in g only covers the positive frequencies.
%
%   The format of the filters g are described in the
%   help of FILTERBANK.
%
%   To actually invert the output of a filterbank, use the dual filters
%   together with 2*real(ifilterbank(...)).
%
%   See also: filterbank, ufilterbank, ifilterbank
%
%   Url: http://ltfat.sourceforge.net/doc/filterbank/filterbankrealdual.php

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

if nargin<2
  error('%s: Too few input parameters.',upper(mfilename));
end;

[a,M,longestfilter,lcm_a]=assert_filterbankinput(g,a);

definput.keyvals.L=[];
[flags,kv,L]=ltfatarghelper({'L'},definput,varargin);

if isempty(L)
  L=ceil(longestfilter/lcm_a)*lcm_a;
else
  if rem(L,lcm_a)>0
    error(['%s: Specified length L is incompatible with the length of ' ...
           'the time shifts. L = %i, lcm_a = %i'],upper(mfilename),L,lcm_a);
  end;
end;

if all(a==a(1))
  % Uniform filterbank, use polyphase representation
  a=a(1);
  
  G=zeros(L,M);
  for ii=1:M
    G(:,ii)=fft(fir2long(g{ii},L));
  end;
  
  N=L/a;
  
  % This is the original code
  %for k=0:a-1
  %  Ha(k+1,:) =      G(mod(w-k*N,L)+1,:);
  %  Hb(k+1,:) = conj(G(mod(k*N-w,L)+1,:));
  %end;
  
  gd=zeros(N,M);
  
  for w=0:N-1
    idx_a = mod(w-(0:a-1)*N,L)+1;
    idx_b = mod((0:a-1)*N-w,L)+1;
    Ha = G(idx_a,:);
    Hb = conj(G(idx_b,:));
    
    Ha=(Ha*Ha'+Hb*Hb')\Ha;
    
    gd(idx_a,:)=Ha;
  end;
  
  gd=ifft(gd)*a;
  
  if isreal(g)
    gd=real(gd);
  end;
  
  gdout=cell(1,M);
  for m=1:M
    gdout{m}=gd(:,m);
  end;
  
else

  error('Not implemented yet.');
  
end;


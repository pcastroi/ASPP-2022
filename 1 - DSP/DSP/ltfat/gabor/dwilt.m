function [c,Ls,g]=dwilt(f,g,M,L)
%DWILT  Discrete Wilson transform
%   Usage:  c=dwilt(f,g,M);
%           c=dwilt(f,g,M,L);
%           [c,Ls]=dwilt(...);
%
%   Input parameters:
%         f     : Input data
%         g     : Window function.
%         M     : Number of bands.
%         L     : Length of transform to do.
%   Output parameters:
%         c     : 2M xN array of coefficients.
%         Ls    : Length of input signal.
%
%   DWILT(f,g,M) computes a discrete Wilson transform with M bands and
%   window g.
%
%   The length of the transform will be the smallest possible that is
%   larger than the signal. f will be zero-extended to the length of the 
%   transform. If f is a matrix, the transformation is applied to each column.
%
%   The window g may be a vector of numerical values, a text string or a
%   cell array. See the help of WILWIN for more details.
%
%   DWILT(f,g,M,L) computes the Wilson transform as above, but does a
%   transform of length L. f will be cut or zero-extended to length L*
%   before the transform is done.
%
%   [c,Ls]=DWILT(f,g,M) or `[c,Ls]=dwilt(f,g,M,L)` additionally return the
%   length of the input signal f. This is handy for reconstruction:
%
%     [c,Ls]=dwilt(f,g,M);
%     fr=idwilt(c,gd,M,Ls);
%
%   will reconstruct the signal f no matter what the length of f is, provided
%   that gd is a dual Wilson window of g.
%
%   [c,Ls,g]=DWILT(...) additionally outputs the window used in the
%   transform. This is useful if the window was generated from a description
%   in a string or cell array.
%
%   A Wilson transform is also known as a maximally decimated, even-stacked
%   cosine modulated filter bank.
%
%   Use the function WIL2RECT to visualize the coefficients or to work
%   with the coefficients in the TF-plane.
%
%   Assume that the following code has been executed for a column vector f*:
%
%     c=dwilt(f,g,M);  % Compute a Wilson transform of f.
%     N=size(c,2)*2;   % Number of translation coefficients.
%
%   The following holds for m=0,...,M-1 and n=0,...,N/2-1:
%
%   If m=0:
%
%                    L-1 
%     c(m+1,n+1)   = sum f(l+1)*g(l-2*n*M+1)
%                    l=0  
%
%
%
%   If m is odd and less than M
%
%                    L-1 
%     c(m+1,n+1)   = sum f(l+1)*sqrt(2)*sin(pi*m/M*l)*g(k-2*n*M+1)
%                    l=0  
% 
%                    L-1 
%     c(m+M+1,n+1) = sum f(l+1)*sqrt(2)*cos(pi*m/M*l)*g(k-(2*n+1)*M+1)
%                    l=0  
%
%
%   If m is even and less than M
%
%                    L-1 
%     c(m+1,n+1)   = sum f(l+1)*sqrt(2)*cos(pi*m/M*l)*g(l-2*n*M+1)
%                    l=0  
% 
%                    L-1 
%     c(m+M+1,n+1) = sum f(l+1)*sqrt(2)*sin(pi*m/M*l)*g(l-(2*n+1)*M+1)
%                    l=0  
%
%
%   if m=M and M is even:
%
%                    L-1 
%     c(m+1,n+1)   = sum f(l+1)*(-1)^(l)*g(l-2*n*M+1)
%                    l=0
%
%
%   else if m=M and M is odd
%
%                    L-1 
%     c(m+1,n+1)   = sum f(l+1)*(-1)^l*g(l-(2*n+1)*M+1)
%                    l=0
%
%
%   See also:  idwilt, wilwin, wil2rect, dgt, wmdct, wilorth
%
%   References:
%     H. B�lcskei, H. G. Feichtinger, K. Gr�chenig, and F. Hlawatsch.
%     Discrete-time Wilson expansions. In Proc. IEEE-SP 1996 Int. Sympos.
%     Time-Frequency Time-Scale Analysis, june 1996.
%     
%     Y.-P. Lin and P. Vaidyanathan. Linear phase cosine modulated maximally
%     decimated filter banks with perfectreconstruction. IEEE Trans. Signal
%     Process., 43(11):2525-2539, 1995.
%     
%
%   Url: http://ltfat.sourceforge.net/doc/gabor/dwilt.php

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

%   AUTHOR : Peter L. S�ndergaard.
%   TESTING: TEST_DWILT
%   REFERENCE: REF_DWILT

error(nargchk(3,4,nargin));

if nargin<4
  L=[];
end;


assert_squarelat(M,M,1,'DWILT',0);

if ~isempty(L)
  if (prod(size(L))~=1 || ~isnumeric(L))
    error('%s: L must be a scalar','DWILT');
  end;
  
  if rem(L,1)~=0
    error('%s: L must be an integer','DWILT');
  end;
end;

% Change f to correct shape.
[f,Ls,W,wasrow,remembershape]=comp_sigreshape_pre(f,'DWILT',0);

if isempty(L)
  % Smallest length transform.
  Lsmallest=2*M;

  % Choose a transform length larger than the signal
  L=ceil(Ls/Lsmallest)*Lsmallest;
else

  if rem(L,2*M)~=0
    error('%s: The length of the transform must be divisable by 2*M = %i',...
          'DWILT',2*M);
  end;

end;

[g,info]=wilwin(g,M,L,'DWILT');

f=postpad(f,L);

% If the signal is single precision, make the window single precision as
% well to avoid mismatches.
if isa(f,'single')
  g=single(g);
end;

% Call the computational subroutines.
c=comp_dwilt(f,g,M,L);



function [a,M,L,N,Ngood]=gabimagepars(Ls,x,y)
%GABIMAGEPARS  Find Gabor parameters to generate image
%   Usage: [a,M,L,N,Ngood]=gabimagepars(Ls,x,y);
%
%   [a,M,L,N,Ngood]=GABIMAGEPARS(Ls,x,y) will compute a reasonable set of
%   parameters a, M and L to produce a nice Gabor 'image' of a signal
%   of length Ls. The approximate number of pixels in the time direction is
%   given as x and the number of pixels in the frequency direction is given
%   as y.
%
%   The output parameter Ngood contains the number of time steps (columns
%   in the coefficients matrix) that contains relevant information. The
%   columns from Ngood until N only contains information from a
%   zero-extension of the signal.
%
%   If you use this function to calculate a grid size for analysis of a
%   real-valued signal (using DGTREAL), please input twice of the desired
%   size y. This is because DGTREAL only returns half as many
%   coefficients in the frequency direction as DGT.
%
%   An example: We wish to compute a Gabor image of a real valued signal f*
%   of length 7500. The image should have an approximate resolution of
%   800 x600 pixels:
%
%     [f,fs]=linus; f=f(4001:4000+7500);
%     [a,M,L,N,Ngood] = gabimagepars(7500,800,2*600);
%     c = dgtreal(f,'gauss',a,M);
%     plotdgtreal(c,a,M,fs,90);
%
%   The size of c is N x(M/2)+1 equal to 801 x600 pixels. 
%
%   For this function to work properly, the specified numbers for x and
%   y must not be large prime numbers.
%  
%   See also: dgt, dgtreal, sgram
%
%   Url: http://ltfat.sourceforge.net/doc/gabor/gabimagepars.php

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

if min(x,y)>Ls
  % Small values case, just do an STFT
  M=Ls;
  N=Ls;
  a=1;
  Ngood=N;
  L=Ls;
else

  % Set M and N to be what the user specified
  M=y;
  N=x;

  % Determine the minimum transform size.
  K=lcm(M,N);
    
  % This L is good, but is it not the same as DGT will choose.
  Llong=ceil(Ls/K)*K;
  
  % Fix a from the long L
  a=Llong/N;
  
  % Now we have fixed a and M, so we can use the standard method of choosing L
  Lsmallest=lcm(a,M);
  L=ceil(Ls/Lsmallest)*Lsmallest;
  
  % We did not get N as desired.
  N=L/a;
  
  % Number of columns to display
  Ngood=ceil(Ls/a);
  
  if M<=a
    error('Fixme: Generate better code, this is not a frame');
  end;
  
end;


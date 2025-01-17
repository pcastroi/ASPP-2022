% LTFAT - Basic Fourier and DCT analysis.
%
%  Peter L. Søndergaard, 2008 - 2012.
%
%  Basic Fourier analysis
%    DFT            -  Unitary discrete Fourier transform.
%    IDFT           -  Inverse of DFT.
%    FFTREAL        -  FFT for real valued signals.
%    IFFTREAL       -  Inverse of FFTREAL.
%    FFTINDEX       -  Index of positive and negative frequencies.
%    NEXTFASTFFT    -  Next efficient FFT size.
%    MODCENT        -  Centered modulo operation.
%    PLOTFFT        -  Plot FFT coefficients.
%    PLOTFFTREAL    -  Plot FFTREAL coefficients.
%    CONVOLVE       -  Fast, non-periodic convolution.
%
%  Simple operations on periodic functions
%    INVOLUTE       -  Involution.
%    PEVEN          -  Even part of periodic function.
%    PODD           -  Odd part of periodic function.
%    PCONV          -  Periodic convolution.
%    PXCORR         -  Periodic cross correlation.
%    PFILT          -  Apply filter with periodic boundary conditions.
%    ISEVENFUNCTION -  Test if function is even.
%    MIDDLEPAD      -  Cut or extend even function.
%
%  Functions
%    EXPWAVE        -  Complex exponential wave.
%    PCHIRP         -  Periodic chirp.
%    SHAH           -  Shah distribution.
%    PHEAVISIDE     -  Periodic Heaviside function.
%    PRECT          -  Periodic rectangle function.
%    PSINC          -  Periodic sinc function.
%    HERMBASIS      -  Orthonormal basis of Hermite functions.
%
%  Window functions
%    PGAUSS         -  Periodic Gaussian.
%    PSECH          -  Periodic SECH.
%    PHERM          -  Periodic Hermite functions.
%    PBSPLINE       -  Periodic B-splines.
%    FIRWIN         -  FIR windows (Hanning,Hamming,Blackman,...).
%    FIRKAISER      -  FIR Kaiser-Bessel window.
%    FIR2LONG       -  Extend FIR window to LONG window.
%    LONG2FIR       -  Cut LONG window to FIR window.
%    MAGRESP        -  Magnitude response plot.
%
%  Approximation of continuous functions
%    FFTRESAMPLE    -  Fourier interpolation.
%    DCTRESAMPLE    -  Cosine interpolation.
%    PDERIV         -  Derivative of periodic function.
%
%  Cosine and Sine transforms.
%    DCTI           -  Discrete cosine transform type I
%    DCTII          -  Discrete cosine transform type II
%    DCTIII         -  Discrete cosine transform type III
%    DCTIV          -  Discrete cosine transform type IV
%    DSTI           -  Discrete sine transform type I
%    DSTII          -  Discrete sine transform type II
%    DSTIII         -  Discrete sine transform type III
%    DSTIV          -  Discrete sine transform type IV
%
%  For help, bug reports, suggestions etc. please send email to
%  ltfat-help@lists.sourceforge.net
%
%   Url: http://ltfat.sourceforge.net/doc/fourier/Contents.php

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



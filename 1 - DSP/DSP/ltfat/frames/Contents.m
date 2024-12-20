% LTFAT - Frames
%
%  Peter L. S�ndergaard, 2012.
%
%  Basic methods
%    FRAME             - Construct a new frame
%    FRAMEPAIR         - Construct a pair of frames
%    FRAMEDUAL         - The canonical dual frame
%    FRAMETIGHT        - The canonical tight frame
%    FRANA             - Frame analysis
%    FRSYN             - Frame synthesis
%    PLOTFRAME         - Plot frame coefficients
%    FRAMEGRAM         - Plot energy of signal in frame space
%    FRAMEACCEL        - Precompute arrays for faster application
%
%  Information about a frame
%    FRAMEBOUNDS       - Frame bounds
%    FRAMERED          - Redundancy of frame
%    FRAMEMATRIX       - Frame analysis operator matrix
%    FRAMELENGTH       - Length of frame to expand signal
%    FRAMELENGTHCOEF   - Length of frame given a set of coefficients
%
%  Coefficients conversions
%    FRAMECOEF2NATIVE  - Convert to native transform format
%    FRAMENATIVE2COEF  - Convert native to column format
%    FRAMECOEF2TF      - Convert to time-frequency plane layout
%    FRAMETF2COEF      - Convert TF-plane layout to native
%
%  Advanced methods on frames
%    FRSYNABS          - Frame synthesis from magnitude of coefficients
%    FRANAITER         - Iterative inversion of the synthesis frame
%    FRSYNITER         - Iterative inversion of the analysis frame
%    FRAMEMULEIGS      - Eigenpairs of a frame multiplier
%    FRAMELASSO        - LASSO threshholding using Landweber iterations.
%    FRAMEGROUPLASSO   - Group LASSO threshholding.
%
%  For help, bug reports, suggestions etc. please send email to
%  ltfat-help@lists.sourceforge.net
%
%   Url: http://ltfat.sourceforge.net/doc/frames/Contents.php

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


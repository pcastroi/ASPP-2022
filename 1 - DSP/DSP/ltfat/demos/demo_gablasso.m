%DEMO_GABLASSO  Sparse regression by Lasso method
%
%   Url: http://ltfat.sourceforge.net/doc/demos/demo_gablasso.php

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

% Signals
t=(0:511)/512;
x0 = sin(2*pi*64*t);
x=x0';
x=x+randn(size(x))/2;

% DCGT parameters
a=2;
M=128;

% Regression parameters
lambda = 0.08;
maxit=500;
tol=1e-4;

F=frametight(frame('dgtreal','gauss',a,M));

% LASSO
[tcl,relres,iter,xrecl] = framelasso(F,x,lambda,'maxit',maxit,'tol',tol);

% GLASSO
[tcgl,relres,iter,xrecgl] = framegrouplasso(F,x,lambda,'maxit',maxit,'tol',tol);

% Displays
figure(1);
subplot(2,2,1);plot(x0); axis tight; grid; title('Original')
subplot(2,2,2);plot(x); axis tight; grid; title('Noisy')
subplot(2,2,3);plot(real(xrecl)); axis tight; grid; title('LASSO')
subplot(2,2,4);plot(real(xrecgl)); axis tight; grid; title('GLASSO')

dr=80;

figure(2);
subplot(2,2,1);
framegram(F,x0,'dynrange',dr);
title('Original')

subplot(2,2,2); 
framegram(F,x,'dynrange',dr);
title('Noisy')

subplot(2,2,3);
framegram(F,xrecl,'dynrange',dr);
title('LASSO')

subplot(2,2,4); 
framegram(F,xrecgl,'dynrange',dr);
title('Group LASSO')


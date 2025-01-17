function [c,relres,iter]=franaiter(F,c,varargin)
%FRANAITER  Iterative analysis
%   Usage:  f=franaiter(F,c);
%
%   Input parameters:
%         F       : Frame   
%         c       : Array of coefficients.
%         Ls      : length of signal.
%   Output parameters:
%         f       : Signal.
%         relres  : Vector of residuals.
%         iter    : Number of iterations done.
%
%   c=FRANAITER(F,f) iteratively inverts the frame F using a
%   least-squares method.
%
%   [c,relres,iter]=FRANAITER(...) additionally returns the residuals in a
%   vector relres and the number of iteration steps iter.
%  
%   *Note:* If it is possible to explicitly calculate the canonical dual
%   frame then this is usually a much faster method than invoking
%   FRANAITER.
%
%   FRANAITER takes the following parameters at the end of the line of
%   input arguments:
%
%     'tol',t      Stop if relative residual error is less than the
%                  specified tolerance. Default is 1e-9 
%
%     'maxit',n    Do at most n iterations.
%
%     'pg'        Solve the problem using the Conjugate Gradient
%                  algorithm. This is the default.
%
%     'pcg'        Solve the problem using the Preconditioned Conjugate Gradient
%                  algorithm.
%
%     'print'      Display the progress.
%
%     'quiet'      Don't print anything, this is the default.
%
%   Examples
%   --------
%
%   The following example shows how to rectruct a signal without ever
%   using the dual frame:
%
%      f=greasy;
%      F=frame('dgtreal','gauss',40,60);
%      [c,relres,iter]=franaiter(F,f,'tol',1e-14);
%      r=frsyn(F,c);
%      norm(f-r)/norm(f)
%      semilogy(relres);
%      title('Conversion rate of the CG algorithm');
%      xlabel('No. of iterations');
%      ylabel('Relative residual');
%
%   See also: frame, frana, frsyn, frsyniter
%
%   Url: http://ltfat.sourceforge.net/doc/frames/franaiter.php

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
  
% AUTHORS: Peter L. Søndergaard
    
  if nargin<2
    error('%s: Too few input parameters.',upper(mfilename));
  end;
  
  definput.keyvals.Ls=[];
  definput.keyvals.tol=1e-9;
  definput.keyvals.maxit=100;
  definput.flags.alg={'cg','pcg'};
  definput.keyvals.printstep=10;
  definput.flags.print={'quiet','print'};

  [flags,kv,Ls]=ltfatarghelper({'Ls'},definput,varargin);
  
  % Determine L from the first vector, it must match for all of them.
  L=framelengthcoef(F,size(c,1));
    
  A=@(x) frsyn(F,frana(F,x));
           
      
  if flags.do_pcg
      d=framediag(F,L);
      M=spdiags(d,0,L,L);
      
      [fout,flag,dummytilde,iter,relres]=pcg(A,c,kv.tol,kv.maxit,M);
  else
      
      [fout,flag,dummytilde,iter,relres]=pcg(A,c,kv.tol,kv.maxit);          
  end;

  c=frana(F,fout);

  if nargout>1
      relres=relres/norm(fout(:));
  end;

end


    

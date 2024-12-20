function [mu,sigma] = PsyFcnFit(xdata,pdata)
% PsyFcnFit     Fit a psychometric function to the data
% 
% syntax: [mu,sigma] = PsyFcnFit(xdata,pdata)
% 
% Fits the psychometric function PsyFcn to the data given in the variables
% xdata and pdata. The parameters describing the fitted psychometric function (mu
% and sigma) are returned.
% 
% Note: The variables mu and sigma are not the mean value and the standard
%       deviation of the data. They are the parameters describing the
%       cumulative normal distribution underlying the psychometric function.
% 
% See also: PsyFcn

% (c) of, 2004 Jan 12
% Last Update: 2018 Feb 21
% Timestamp: <PsyFcnFit.m Tue 2005/02/15 09:37:04 OF@OFPC>
% Last revision: Borys Kowalewski 7/2/2019

x0 = [55,5];                           % start with some reasonable values

% create an inline function which has to be minimized:
f = inline('sum( (PsyFcn(xdata,x(1),x(2)) - pdata).^2)','x','xdata','pdata');

% the actual fitting is done by fminsearch:
[x, fval, exitflag] = fminsearch(f,x0,[],xdata,pdata); % find the minimum
if exitflag > 0,                        % function converged:
  mu = x(1);                            % return mu
  sigma = x(2);                         % and sigma
else                                    % function did not converge
  warning(sprintf('%s: No solution found!',mfilename));
  mu = [];                              % warning and return
  sigma = [];                           % emtpy vectors
end

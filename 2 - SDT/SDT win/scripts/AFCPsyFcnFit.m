function [mu,sigma] = AFCPsyFcnFit(xdata,pdata,n)
% AFCPsyFcnFit     Fit a psychometric function to the data
%
% syntax: [mu,sigma] = AFCPsyFcnFit(xdata,pdata,n)
%
% Fits the psychometric function AFCPsyFcn to the data given in the variables
% xdata, pdata and n. The parameters describing the fitted psychometric function (mu
% and sigma) are returned.
%
% Note: The variables mu and sigma are not the mean value and the standard
%       deviation of the data. They are the parameters describing the
%       cumulative normal distribution underlying the psychometric function.

% (c) of, 2014 Feb 25
% Timestamp: <AFCPsyFcnFit.m Tue 2014/02/14 09:55:03 OF@OFPC>
% Last revision: Borys Kowalewski 7/2/2019

x0 = [55,5];                           % start with some reasonable values

% create an inline function which has to be minimized:
f = inline('sum( (AFCPsyFcn(xdata,x(1),x(2),n) - pdata).^2)','x','xdata','pdata','n');

% the actual fitting is done by fminsearch:
[x, fval, exitflag] = fminsearch(f,x0,[],xdata,pdata,n); % find the minimum
if exitflag > 0,                        % function converged:
  mu = x(1);                            % return mu
  sigma = x(2);                         % and sigma
else                                    % function did not converge
  warning(sprintf('%s: No solution found!',mfilename));
  mu = [];                              % warning and return
  sigma = [];                           % emtpy vectors
end

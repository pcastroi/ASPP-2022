function p = AFCPsyFcn(x,mu,sigma,n)
% AFCPsyFcn Psychometric Function (according to n-AFC measurements)
%
% syntax: p = AFCPsyFcn(x,mu,sigma,n)
%
% Computes the psychometric function for an n-AFC measurement at point
% x. The psychometric function is calculated as a cumulative normal
% distribution described by its mean value mu and its standard
% deviation sigma.
% The inputs mu and sigma are obtained using the function AFCPsyFcnFit


p = PsyFcn(x,mu,sigma);
p = rescale(p,1/n,1); %Squeeze
end
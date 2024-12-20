function [res, resstd] = tuddata(expname, vp, group)
% tuddata reads in thresholds of a transformed up-down measurement
%
% syntax: [res, resstd] = csdata(expname, vp, group)
%
% input:  expname   name of the experiment
%         vp        initials of the subject
%         group     name of the subject group
%
% output: res       threshold of the experiment
%         resstd    standard deviation of the threshold
%
    
% 2015 Feb 10, Henrik Gert Hassager

if nargin < 3
    help(mfilename);
end

fname = sprintf('%s_%s_%s.dat',expname,vp,group);  % the filename to look for
if ~exist(fname,'file'),               % does it exist?
    error(sprintf('%s not found!',fname));
end

vals = load(fname);                    % load the data
if size(vals,2) < 3,                   % do we have a transformed up-down measurement?
    error('This is probably not the result file of a transformed up-down measurement');
end

res = vals(:,2);
resstd = vals(:,3);

% EOF

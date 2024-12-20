function data = csdata(expname, vp, group)
% csdata  reads in data of a constant stimuli measurement
%
% syntax: data = csdata(expname, vp, group)
%
% input:  expname           name of the experiment
%         vp                initials of the subject
%         group             name of the subject group
%
% output: data.level        the level of the pure tone
%         data.hit          the percent hit responses
%         data.falsealarm   the percent false alarm responses
%         data.pc           the percent correct responses
%
% note:   The function do not return the percent correct responses for 
%         yes/no measurement and do not return the percent hit and false
%         alarm responses for the AFC measurement.

% 2015 Feb 09, Henrik Gert Hassager

if nargin < 3
    help(mfilename);
end

fname = sprintf('%s_%s_%s.dat',expname,vp,group);  % the filename to look for
if ~exist(fname,'file'),               % does it exist?
    error(sprintf('%s not found!',fname));
end

vals = load(fname);                    % load the data
if size(vals,2) < 6,                   % do we have a constant stimuli measurement?
    error('This is probably not the result file of a constant stimuli measurement');
end
if size(vals,2) > 7,                   % do we have a constant stimuli measurement?
    error('This is probably not the result file of a constant stimuli measurement');
end

if size(vals,2) == 7,       % Yes/No experiment with catch trials
    x  = vals(1:2:end,4);                  % get the exppar2 only every second
    hi = vals(2:2:end,7)./vals(2:2:end,6); % the percent hit responses
    fa = vals(1:2:end,7)./vals(1:2:end,6); % the percent false alarm responses  
    [x,idx] = sort(x);                     % sort data according to level 
    hi = hi(idx);
    fa = fa(idx);
    data.level = x;
    data.hit = hi;
    data.falsealarm = fa;
end

if size(vals,2) == 6,       % AFC experiment with catch trials
    x  = vals(:,4);                        % get the expvar
    pc = vals(:,6)./vals(:,5);             % the percent correct responses
    data.level = x;
    data.pc = pc;
end


% EOF

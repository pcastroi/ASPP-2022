% membraneVoltageDiff.m - differential voltage equation for integrate and fire neuron
%
% Usage: U_next = membraneVoltageDiff(U, I, tau, R, fs, randI)
%
% U     = voltage
% I     = current
% tau   = time constant
% R     = leakage resistor
% fs    = sampling rate
% randI = random term mimicking the ion channels conductance probability
%
% U_next = next time step voltage
%
% See also: IFmodel

% Timestamp: 22-04-2004 09:17

function U_next = membraneVoltageDiff(U, I, tau, R, fs, randI)

if nargin < 6
    randI = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%
% insert equation here %
%%%%%%%%%%%%%%%%%%%%%%%%
U_next=(R*I-U)/(tau*fs)+U+randI.*R;

%Add the random term +randI.*R to the discrete time formulation of the
%differential equation



% eof
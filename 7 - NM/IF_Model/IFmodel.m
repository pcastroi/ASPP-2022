% IFModel.m - discrete time integrate-and-fire neuron model script
%
% Open the m-file for details
%
% See also: membraneVoltageDiff

% Timestamp: 23-04-2014

close all;clear all;clc

% general
fs = 50000;		% sampling rate


% parameters of the membrane
E_r = -0.0735;		% resting potential of the cell
C_m = 3.e-9;		% capacitance of the cell
R_l = 6.7114e+05;        % leakage resistor
tau_m = R_l*C_m;    % membrane time constant


% refractory term (threshold)
b = 5000.e-3;       % spike-induced change in threshold
tau_th = 1.e-3;     % time constant of threshold decay
th_r = 15.e-3;      % resting threshold above resting potential
perm_rand = 8.e-10;	% randomization of the ion channels permeability (e.g., 8e-10)

%%%%%%%%%%%%%% Input  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% insert input here

% 2-ms 15-nA current step input like in SIMULINK 
% I_m = [zeros(50,1); ones(round(fs*0.002),1)] * 15.e-9;

% make 4 steps out of it
% I_m = [repmat(I_m,4,1); zeros(500,1)];


% Apply a 100-ms 25-nA current step
I_m = [zeros(50,1); ones(round(fs*0.1),1)] * 25.e-9;


%%%%%%%%%%%%%% Iteration %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the number of iteration steps from input
Npts=size(I_m,1);

% Random vector
randI = perm_rand .* randn(1, Npts);

% initial values
U = zeros(Npts,1);
V_m = U + E_r;
s = U;
th = U;

for t=1:Npts-1
      
    % membrane potential without resting potential
    U(t+1) = membraneVoltageDiff(U(t), I_m(t), tau_m, R_l, fs, randI(t));
    
    % binary spiking variable
    if ( U(t+1) >= ( th(t) + th_r ) )
    	s(t+1) = 1;
    end
    
    % membrane potential
    V_m(t+1) = U(t+1) + E_r;
    
    % spike dependent threshold 'potential'
    th(t+1) = membraneVoltageDiff(th(t), s(t+1), tau_th, b, fs);
    
end


%%%%%%%%%%%%%%%% Plot %%%%%%%%%%%%%%%%%%%%%%%%%%

% derive time axis
time =(1:Npts)*1000/fs;

figure,
% Current subplot
h_current = axes('Position',[0.13 0.12 0.8 0.17]);
plot(h_current, time,I_m.*1.e9,'k');
set(h_current,'YLim',[0 40]);
set(get(h_current,'Ylabel'),'String','Current (nA)');
set(get(h_current,'Xlabel'),'String','Time (ms)');

% Membrane potential subplot
h_Vm = axes('Position',[0.13 0.33 0.8 0.45],'box','on');
hold(h_Vm,'on');
plot(h_Vm, time,(th+th_r+E_r)*1.e3,'b--');
plot(h_Vm, time,V_m*1.e3,'k')
set(h_Vm,'XTickLabel',[]);
set(get(h_Vm,'Ylabel'),'String','Depolarization (mV)');
%set(h_Vm,'YLim',[-100 50]);

% Spike generation subplot
h_spike = axes('Position',[0.13 0.82 0.8 0.17]);
plot(h_spike,time,s,'k')
set(h_spike,'XTickLabel',[])
set(h_spike,'YLim',[0 1.2])
set(h_spike,'YTick',[0 1])
set(h_spike,'YTickLabel',[0 1])
set(get(h_spike,'Ylabel'),'String','Spikes')

isiHist(s,fs)

% eof